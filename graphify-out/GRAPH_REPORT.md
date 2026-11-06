# Graph Report - .dotfiles  (2026-11-06)

## Corpus Check
- 18 files · ~32,920 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 8 file(s) not represented in the graph (top: (none) 6, .lock 1, .bak 1)

## Summary
- 323 nodes · 528 edges · 19 communities (17 shown, 2 thin omitted)
- Extraction: 90% EXTRACTED · 9% INFERRED · 1% AMBIGUOUS · INFERRED: 49 edges (avg confidence: 0.79)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `abf76435`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- AwesomeWM Bar & Keys
- Claude Code & Craft Apps
- Flake Inputs & Overlays
- Shell & Terminal Tools
- AppMenu DBus Widget
- Revelation & Error Handling
- Browser Hardening
- Boot, Fonts & Services
- System Daemons & Bluetooth
- Hardware, Power & GPU
- Desktop Session & Packages
- AwesomeWM Themes
- Audio, Display & Security
- Root System Config
- User & Groups
- Networking
- Git & SSH
- Gaming & Graphics
- modules/nixos/nginx.nix

## God Nodes (most connected - your core abstractions)
1. `programs.claude-code` - 25 edges
2. `User clotilde` - 8 edges
3. `numtide/llm-agents.nix` - 8 edges
4. `globalkeys` - 7 edges
5. `home.packages (user apps)` - 7 edges
6. `programs.firefox` - 7 edges
7. `to_awful_items()` - 6 edges
8. `programs.craftapps (all Craft apps, skill + MCP enabled)` - 6 edges
9. `nixpkgs (nixos-unstable) flake input` - 6 edges
10. `bar.setup()` - 5 edges

## Surprising Connections (you probably didn't know these)
- `services.zerotierone (joins one network)` --semantically_similar_to--> `programs.localsend (open firewall)`  [AMBIGUOUS] [semantically similar]
  modules/nixos/zerotier.nix → modules/nixos/localsend.nix
- `hardware.nvidia (legacy_580, PRIME offload)` --conceptually_related_to--> `Intel CPU (kvm-intel, microcode updates)`  [INFERRED]
  modules/nixos/nvidia.nix → hardware-configuration.nix
- `windowManager.awesome (default session)` --conceptually_related_to--> `~/.config/awesome out-of-store symlink`  [INFERRED]
  modules/nixos/X11.nix → home.nix
- `virtualisation.docker (disabled; rootless enabled, btrfs storage)` --conceptually_related_to--> `User clotilde`  [AMBIGUOUS]
  modules/nixos/docker.nix → modules/nixos/user.nix
- `/usr/share/fonts tmpfiles symlink` --conceptually_related_to--> `nix-craftapps flake input`  [INFERRED]
  modules/nixos/fonts.nix → flake.nix

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Selectable themes via beautiful.init** — awesome_variables_chosen_theme, awesome_themes_default_theme, awesome_themes_sky_theme, awesome_themes_zenburn_theme [EXTRACTED 1.00]
- **rc.lua startup sequence** — awesome_rc, awesome_error_handler, awesome_autostart, awesome_hotkeys_keyboard, awesome_variables, awesome_rules, awesome_hotkeys_mouse, awesome_signals, awesome_menu [EXTRACTED 1.00]
- **Per-screen wibar composition** — awesome_bar_setup, awesome_widgets_appmenu_new, awesome_widgets_tasklist_new, awesome_bar_shared_widgets [EXTRACTED 1.00]
- **Claude Code MCP servers incl. Craft apps** — modules_home_manager_claude_code_token_savior, modules_home_manager_claude_code_rea_mcp, modules_home_manager_claude_code_nixos_mcp, modules_home_manager_artcraft_programs_craftapps, modules_home_manager_claude_code_enable_mcp_integration [EXTRACTED 1.00]
- **Flake -> configuration -> modules/nixos composition** — flake, flake_nixosconfigurations_nixos, configuration, hardware_configuration, modules_nixos_default [EXTRACTED 1.00]
- **terminal-browser split via kitty remote control** — modules_home_manager_claude_code_terminal_browser, modules_home_manager_kitty_remote_control, modules_home_manager_kitty_programs_kitty, modules_home_manager_claude_code_programs_claude_code [EXTRACTED 1.00]
- **Browser stack (default handler + alternatives)** — modules_home_manager_firefox_programs_firefox, modules_home_manager_librewolf_programs_librewolf, modules_home_manager_chromium_programs_chromium, modules_home_manager_xdg_mime_apps [INFERRED 0.85]
- **User group-gated capabilities** — modules_nixos_user_clotilde, modules_nixos_user_group_wireshark, modules_nixos_wireshark_wireshark, modules_nixos_user_group_networkmanager, modules_nixos_network_networkmanager [INFERRED 0.85]
- **X11 desktop session (sddm, awesome, nvidia, keyring/polkit)** — modules_nixos_x11_sddm, modules_nixos_x11_awesome, modules_nixos_x11_xserver, modules_nixos_nvidia_nvidia, modules_nixos_security_gnome_keyring, modules_nixos_security_polkit [INFERRED 0.85]

## Communities (19 total, 2 thin omitted)

### Community 0 - "AwesomeWM Bar & Keys"
Cohesion: 0.06
Nodes (36): Dual monitor xrandr layout (eDP-1 + HDMI-1 primary), EasyEffects equalizer service, Wacom stylus mapped to HDMI-1 (xinput/xsetwacom), bar.setup(), separator(), bar.setup, shared_widgets(), clientbuttons (+28 more)

### Community 1 - "Claude Code & Craft Apps"
Cohesion: 0.07
Nodes (50): apps.json (Craft app name list), inputs.nix-craftapps (flake input), onNvidia PRIME offload wrapper, programs.craftapps (all Craft apps, skill + MCP enabled), agent-browser skill, andrej-karpathy-skills plugin, ccstatusline (status line), check-nix slash command (+42 more)

### Community 2 - "Flake Inputs & Overlays"
Cohesion: 0.08
Nodes (35): agent-browser flake input, andrej-karpathy-skills flake input, ccstatusline flake input, claude-code (sadjow/claude-code-nix) flake input, claude-code overlay, compose2nix flake input, firefox-addons (rycee NUR) flake input, git-surgeon flake input (+27 more)

### Community 3 - "Shell & Terminal Tools"
Cohesion: 0.07
Nodes (25): pokeget random Pokemon greeting, programs.bash, Rebuild aliases (bshm, bsnix, bbnix, btnix), systemd user service caffeine (caffeine-ng), services.copyq, programs.kitty, kitty remote control (socket-only, unix:/tmp/kitty), programs.mpv (ytdl-format avc1 <=1080p) (+17 more)

### Community 4 - "AppMenu DBus Widget"
Cohesion: 0.20
Nodes (14): below(), clean_label(), dbusmenu_call(), get_client_menu(), get_layout(), is_visible(), make_button(), on_registrar_call() (+6 more)

### Community 5 - "Revelation & Error Handling"
Cohesion: 0.21
Nodes (10): debug::error notification handler, current_tag_clients(), debuginfo(), hintbox_display_toggle(), hintbox_pos(), match_clients(), revelation.expose(), revelation.expose_callback() (+2 more)

### Community 6 - "Browser Hardening"
Cohesion: 0.27
Nodes (9): programs.chromium (ungoogled-chromium), inputs.firefox-addons (flake input), inputs.nixpkgs-firefox (flake input), Kreyren nixos-config (upstream reference), Firefox hardening policies (telemetry off, tracking protection, extensions locked), programs.firefox, uBlock Origin managed settings, LibreWolf privacy settings (resistFingerprinting, DoH mode 3) (+1 more)

### Community 7 - "Boot, Fonts & Services"
Cohesion: 0.18
Nodes (5): fonts.packages (noto, fira-code, font-awesome, material-icons), boot.loader.grub (EFI, os-prober), services.keyd (pageup -> enter), services.stirling-pdf (port 3000), services.zerotierone (joins one network)

### Community 8 - "System Daemons & Bluetooth"
Cohesion: 0.18
Nodes (9): hardware.bluetooth, services.acpid, services.blueman, services.fstrim, services.gvfs, services.libinput, services.tumbler, services.udisks2 (+1 more)

### Community 9 - "Hardware, Power & GPU"
Cohesion: 0.33
Nodes (4): Intel CPU (kvm-intel, microcode updates), LUKS-encrypted btrfs root (samsungcrypt, lzo compression), virtualisation.docker (disabled; rootless enabled, btrfs storage), docker-compose / docker-buildx packages

### Community 10 - "Desktop Session & Packages"
Cohesion: 0.25
Nodes (7): ~/.config/awesome out-of-store symlink, programs.nix-ld, services.picom, polkit_gnome package, environment.systemPackages, programs.thunar, windowManager.awesome (default session)

### Community 12 - "Audio, Display & Security"
Cohesion: 0.28
Nodes (6): services.gnome.gnome-keyring + seahorse, security.rtkit, xdg.portal (gtk, keyring secret portal), services.pipewire (pulse, alsa), services.displayManager.sddm, services.xserver (wacom)

### Community 13 - "Root System Config"
Cohesion: 0.29
Nodes (6): nixpkgs allowUnfree, Nix flakes + nix-command experimental features, Weekly automatic nix garbage collection (7d), system.stateVersion 26.11, modules/home-manager, home.stateVersion 26.11

### Community 14 - "User & Groups"
Cohesion: 0.25
Nodes (6): security.polkit (reboot/poweroff rule for users group), User clotilde, group dialout, group wheel, group wireshark, programs.wireshark (dumpcap, usbmon)

### Community 15 - "Networking"
Cohesion: 0.29
Nodes (5): programs.localsend (open firewall), Cloudflare DNS nameservers (1.1.1.1), networking.firewall, networking.networkmanager, group networkmanager

### Community 16 - "Git & SSH"
Cohesion: 0.60
Nodes (4): Global git ignores (claude settings.local, graphify-out state), programs.gh (ssh protocol), programs.git, programs.ssh (github.com identity)

### Community 17 - "Gaming & Graphics"
Cohesion: 0.25
Nodes (6): services.tlp (performance governor, charge thresholds 40-80), hardware.graphics (32-bit, intel-media-driver VA-API), hardware.nvidia (legacy_580, PRIME offload), zenith-nvidia, programs.gamescope, programs.steam (proton-ge, gamescope session)

## Ambiguous Edges - Review These
- `error_handler.lua` → `init.lua`  [AMBIGUOUS]
  awesome/revelation/init.lua · relation: conceptually_related_to
- `User clotilde` → `virtualisation.docker (disabled; rootless enabled, btrfs storage)`  [AMBIGUOUS]
  modules/nixos/docker.nix · relation: conceptually_related_to
- `programs.localsend (open firewall)` → `services.zerotierone (joins one network)`  [AMBIGUOUS]
  modules/nixos/zerotier.nix · relation: semantically_similar_to
- `modules/nixos/nginx.nix` → `nixos/default.nix`  [AMBIGUOUS]
  modules/nixos/default.nix · relation: references

## Knowledge Gaps
- **69 isolated node(s):** `EasyEffects equalizer service`, `Media keys (playerctl, wpctl volume)`, `Rofi keys (rofi-screenshot, rofimoji)`, `Super+D show desktop / restore`, `myawesomemenu` (+64 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 78 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `compose2nix flake input` connect `Flake Inputs & Overlays` to `Desktop Session & Packages`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `User clotilde` (e.g. with `security.polkit (reboot/poweroff rule for users group)` and `home.nix`) actually correct?**
  _`User clotilde` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `EasyEffects equalizer service`, `Media keys (playerctl, wpctl volume)`, `Rofi keys (rofi-screenshot, rofimoji)` to the rest of the system?**
  _69 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `AwesomeWM Bar & Keys` be split into smaller, more focused modules?**
  _Cohesion score 0.06453634085213032 - nodes in this community are weakly interconnected._
- **Why does `nixosConfigurations.nixos` connect `Flake Inputs & Overlays` to `Root System Config`?**
  _High betweenness centrality (0.018) - this node is a cross-community bridge._

### Low-confidence Hints
_AMBIGUOUS edges — the extractor was unsure. Verify before acting on these._

- **What is the exact relationship between `error_handler.lua` and `init.lua`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `User clotilde` and `virtualisation.docker (disabled; rootless enabled, btrfs storage)`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._