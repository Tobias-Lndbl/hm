#!/usr/bin/env python3
"""Export an existing Zen profile into Nix for programs/zen.nix.

Zen keeps spaces and pinned tabs in <profile>/zen-sessions.jsonlz4 (a mozlz4
container, not places.sqlite) and hand-changed prefs in <profile>/prefs.js.
This reads both and prints the corresponding `programs.zen-browser` snippet, so
a device that is already set up the way you like can be turned into config
instead of being re-clicked on the next machine.

Usage:
    zen-export-spaces.py --spaces     # spaces + pins block
    zen-export-spaces.py --prefs      # settings block (prefs you changed)
    zen-export-spaces.py --mods       # installed mod UUIDs
    zen-export-spaces.py --all

    # non-default profile / another machine's copied profile dir
    zen-export-spaces.py --spaces --profile "~/.config/zen/xxxx.Default Profile"

Close Zen first: it rewrites these files on exit.
"""

import argparse
import configparser
import json
import os
import re
import struct
import subprocess
import sys
import uuid

CONFIG_DIR = os.path.expanduser("~/.config/zen")

# Pin ids must be stable across runs, otherwise every export produces a new set
# of pins. Derive them from Zen's own zenSyncId instead of randomising.
PIN_NS = uuid.UUID("6f9619ff-8b86-d011-b42d-00c04fc964ff")


def find_default_profile():
    ini = os.path.join(CONFIG_DIR, "profiles.ini")
    if not os.path.exists(ini):
        sys.exit(f"no {ini} -- is Zen installed for this user?")
    cp = configparser.ConfigParser()
    cp.read(ini)
    profiles = [s for s in cp.sections() if s.startswith("Profile")]
    for s in profiles:
        if cp[s].get("Default") == "1":
            return os.path.join(CONFIG_DIR, cp[s]["Path"])
    if profiles:
        return os.path.join(CONFIG_DIR, cp[profiles[0]]["Path"])
    sys.exit(f"no profiles listed in {ini}")


def read_mozlz4(path):
    """Decode a mozLz40 container: 8-byte magic, LE u32 size, lz4 block."""
    with open(path, "rb") as fh:
        blob = fh.read()
    if not blob.startswith(b"mozLz40\0"):
        sys.exit(f"{path}: not a mozlz4 file")
    size = struct.unpack("<I", blob[8:12])[0]
    try:
        import lz4.block

        return json.loads(lz4.block.decompress(blob[12:], uncompressed_size=size))
    except ImportError:
        pass
    # No python-lz4 around: borrow mozlz4a from nixpkgs.
    out = subprocess.run(
        ["nix", "run", "nixpkgs#mozlz4a", "--", "-d", path, "/dev/stdout"],
        capture_output=True,
    )
    if out.returncode != 0:
        sys.exit(
            f"could not decode {path}: install python3Packages.lz4 or make "
            f"`nix run nixpkgs#mozlz4a` work.\n{out.stderr.decode(errors='replace')}"
        )
    return json.loads(out.stdout)


def nix_str(s):
    return '"' + str(s).replace("\\", "\\\\").replace('"', '\\"').replace("$", "\\$") + '"'


def nix_attr_name(s):
    return nix_str(s)


def tab_title(tab):
    entries = tab.get("entries") or []
    if entries:
        last = entries[-1]
        if last.get("title"):
            return last["title"]
        if last.get("url"):
            return last["url"]
    return tab.get("zenStaticLabel") or "Pin"


def tab_url(tab):
    entries = tab.get("entries") or []
    return entries[-1].get("url") if entries else None


def export_spaces(profile):
    sessions = os.path.join(profile, "zen-sessions.jsonlz4")
    if not os.path.exists(sessions):
        sys.exit(f"{sessions} not found -- open Zen once, then close it.")
    data = read_mozlz4(sessions)
    spaces = data.get("spaces") or []
    tabs = data.get("tabs") or []
    if not spaces:
        sys.exit("this profile has no spaces yet")

    # Pins are tabs flagged pinned/essential and tied to a space uuid.
    by_space = {}
    for tab in tabs:
        if not (tab.get("pinned") or tab.get("zenEssential")):
            continue
        if tab.get("zenIsEmpty"):
            continue
        by_space.setdefault(tab.get("zenWorkspace"), []).append(tab)

    out = ["      spaces = {"]
    seen_names = {}
    for idx, sp in enumerate(spaces):
        raw_uuid = sp.get("uuid", "")
        bare = raw_uuid.strip("{}")
        name = sp.get("name") or f"Space{idx + 1}"
        # Attribute names must be unique even if two spaces share a label.
        seen_names[name] = seen_names.get(name, 0) + 1
        attr = name if seen_names[name] == 1 else f"{name} {seen_names[name]}"

        out.append(f"        {nix_attr_name(attr)} = {{")
        out.append(f"          id = {nix_str(bare)};")
        out.append(f"          position = {(idx + 1) * 1000};")
        if sp.get("icon"):
            out.append(f"          icon = {nix_str(sp['icon'])};")
        if sp.get("containerTabId"):
            out.append(f"          container = {sp['containerTabId']};")

        theme = sp.get("theme") or {}
        colors = theme.get("gradientColors") or []
        if colors:
            out.append("          theme = {")
            out.append(f"            type = {nix_str(theme.get('type', 'gradient'))};")
            out.append("            colors = [")
            for c in colors:
                out.append("              {")
                for key in ("red", "green", "blue", "lightness"):
                    if c.get(key) is not None:
                        out.append(f"                {key} = {c[key]};")
                for key in ("algorithm", "type"):
                    if c.get(key):
                        out.append(f"                {key} = {nix_str(c[key])};")
                if isinstance(c.get("position"), dict):
                    pos = c["position"]
                    if pos.get("x") is not None:
                        out.append(f"                position.x = {pos['x']};")
                    if pos.get("y") is not None:
                        out.append(f"                position.y = {pos['y']};")
                if c.get("primary") is not None:
                    out.append(f"                primary = {str(c['primary']).lower()};")
                out.append("              }")
            out.append("            ];")
            if theme.get("opacity") is not None:
                out.append(f"            opacity = {theme['opacity']};")
            if theme.get("texture") is not None:
                out.append(f"            texture = {theme['texture']};")
            if theme.get("rotation") is not None:
                out.append(f"            rotation = {theme['rotation']};")
            out.append("          };")

        pins = by_space.get(raw_uuid) or by_space.get(bare) or []
        if pins:
            out.append("          pins = {")
            seen_pins = {}
            for pidx, tab in enumerate(sorted(pins, key=lambda t: t.get("index", 0))):
                title = tab_title(tab)
                seen_pins[title] = seen_pins.get(title, 0) + 1
                pattr = title if seen_pins[title] == 1 else f"{title} {seen_pins[title]}"
                sync_id = tab.get("zenSyncId") or f"{bare}-{pidx}"
                pin_id = uuid.uuid5(PIN_NS, sync_id)
                out.append(f"            {nix_attr_name(pattr)} = {{")
                out.append(f"              id = {nix_str(pin_id)};")
                url = tab_url(tab)
                if url:
                    out.append(f"              url = {nix_str(url)};")
                out.append(f"              position = {(pidx + 1) * 100};")
                if tab.get("zenEssential"):
                    out.append("              isEssential = true;")
                if tab.get("userContextId"):
                    out.append(f"              container = {tab['userContextId']};")
                out.append("            };")
            out.append("          };")
        out.append("        };")
    out.append("      };")
    return "\n".join(out)


# prefs.js is overwhelmingly machine state -- per-install UUIDs, timestamps,
# migration counters -- and only a thin layer of it is an actual setting worth
# syncing. Both filters below are deliberately aggressive: a pref wrongly
# dropped just has to be re-added by hand, whereas a wrongly kept one pins
# another device to this machine's identity. Treat the output as a starting
# point and prune it.
PREF_NOISE = (
    "app.normandy.",
    "app.update.",
    "browser.bookmarks.addedImportButton",
    "browser.contentblocking.cfr-milestone.",
    "browser.download.viewableInternally.typeWasRegistered.",
    "browser.laterrun.",
    "browser.migration.",
    "browser.newtabpage.activity-stream.impressionId",
    "browser.newtabpage.storageVersion",
    "browser.pagethumbnails.storage_version",
    "browser.proton.toolbar.version",
    "browser.region.",
    "browser.safebrowsing.provider.",
    "browser.search.region",
    "browser.startup.couldRestoreSession.",
    "browser.startup.homepage_override.",
    "browser.startup.lastColdStartupCheck",
    "browser.termsofuse.",
    "browser.urlbar.quicksuggest.",
    "browser.urlbar.recentsearches.",
    "captchadetection.",
    "datareporting.dau.",
    "datareporting.policy.firstRunTime",
    "distribution.",
    "doh-rollout.",
    "dom.push.",
    "extensions.blocklist.",
    "extensions.colorway-",
    "extensions.databaseSchema",
    "extensions.lastApp",
    "extensions.lastPlatformVersion",
    "extensions.pendingOperations",
    "extensions.quarantinedDomains.",
    "extensions.signatureCheckpoint",
    "extensions.systemAddonSet",
    "extensions.webextensions.uuids",
    "gecko.handlerService.",
    "idle.lastDailyNotification",
    "media.gmp",
    "network.cookie.CHIPS.",
    "network.cookie.validation.",
    "nimbus.",
    "pdfjs.enabledCache.",
    "pdfjs.migrationVersion",
    "places.database.",
    "pref.privacy.disable_button.",
    "privacy.purge_trackers.",
    "privacy.sanitize.pending",
    "privacy.trackingprotection.allow_list.",
    "services.sync.engine.",
    "sidebar.backupState",
    "toolkit.profiles.",
    "security.sandbox.content.tempDirSuffix",
    "services.settings.",
    "storage.vacuum.last.",
    "toolkit.startup.last_success",
    "toolkit.telemetry.cachedClientID",
    "toolkit.telemetry.previousBuildID",
    "toolkit.telemetry.reportingpolicy.firstRun",
    "zen.keyboard.shortcuts.version",
    "zen.mods.last-update",
    "zen.mods.milestone",
    "zen.mods.updated-value-observer",
    "zen.session-store.last-build-id",
    "zen.ui.migration.",
    "zen.updates.",
    "zen.welcome-screen.seen",
    "zen.workspaces.active",
)

# Catches the same class of thing under names the prefix list doesn't know.
PREF_NOISE_RE = re.compile(
    r"(?i)("
    r"migration|checkpoint|firstrun|lastapp|buildid|"
    r"profileid|profilegroupid|clientid|useragentid|impressionid|"
    r"lastupdate|lastdefaultchanged|lastsubmission|lastepoch|lastmigrate|"
    r"storageversion|storage_version|databaseschema|"
    r"was_ever_enabled|hasmigrated|donefirstrun|didskip"
    r")"
)

PREF_RE = re.compile(r'^user_pref\("([^"]+)",\s*(.*)\);\s*$')


def export_prefs(profile):
    path = os.path.join(profile, "prefs.js")
    if not os.path.exists(path):
        sys.exit(f"{path} not found")
    out = ["      settings = {"]
    kept = 0
    with open(path, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            m = PREF_RE.match(line.strip())
            if not m:
                continue
            key, raw = m.group(1), m.group(2).strip()
            if key.startswith(PREF_NOISE) or PREF_NOISE_RE.search(key):
                continue
            if raw in ("true", "false"):
                val = raw
            elif re.fullmatch(r"-?\d+", raw):
                val = raw
            elif raw.startswith('"'):
                # prefs.js stores JSON blobs as escaped strings; keep verbatim.
                try:
                    val = nix_str(json.loads(raw))
                except json.JSONDecodeError:
                    continue
            else:
                continue
            out.append(f"        {nix_str(key)} = {val};")
            kept += 1
    out.append("      };")
    if not kept:
        return "      # no non-default prefs found"
    return "\n".join(out)


def export_mods(profile):
    path = os.path.join(profile, "zen-themes.json")
    if not os.path.exists(path):
        return "      mods = [ ];"
    with open(path, encoding="utf-8") as fh:
        try:
            data = json.load(fh)
        except json.JSONDecodeError:
            return "      mods = [ ];"
    if not data:
        return "      mods = [ ];"
    lines = ["      mods = ["]
    for mod_id, mod in data.items():
        name = mod.get("name") if isinstance(mod, dict) else None
        comment = f" # {name}" if name else ""
        lines.append(f"        {nix_str(mod_id)}{comment}")
    lines.append("      ];")
    return "\n".join(lines)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--profile", help="profile directory (default: the default profile)")
    ap.add_argument("--spaces", action="store_true")
    ap.add_argument("--prefs", action="store_true")
    ap.add_argument("--mods", action="store_true")
    ap.add_argument("--all", action="store_true")
    args = ap.parse_args()

    if not (args.spaces or args.prefs or args.mods or args.all):
        ap.error("pick at least one of --spaces / --prefs / --mods / --all")

    profile = os.path.expanduser(args.profile) if args.profile else find_default_profile()
    if not os.path.isdir(profile):
        sys.exit(f"{profile} is not a directory")
    print(f"# exported from {profile}", file=sys.stderr)

    if args.spaces or args.all:
        print(export_spaces(profile))
    if args.prefs or args.all:
        print(export_prefs(profile))
    if args.mods or args.all:
        print(export_mods(profile))


if __name__ == "__main__":
    main()
