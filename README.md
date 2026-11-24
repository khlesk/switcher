<p align="center">
  <img src="package/contents/images/icon.svg" width="128" height="128" alt="Switcher">
</p>

<h1 align="center">Switcher</h1>

Switcher is a KDE Plasma widget for starting and stopping a shell command from your panel or desktop. Its icon shows the command's current state.

Use it for commands you run on demand, such as an SSH tunnel, a local development server, or a file watcher.

<img src="assets/screen.png" width="720" alt="Switcher screenshot">

## Features

- Stops the command and its child processes together.
- Supports custom state labels, icon themes, and SVG icons.
- Can show output from separate commands in the panel and tooltip.

## Install

Switcher requires Plasma 6 with Plasma 5 Support, Bash, and a systemd user session (version 254 or later).

The GitHub installer requires `tar`, `jq`, `kpackagetool6`, and either `curl` or `wget`.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/khlesk/switcher/master/scripts/install)
```

With `wget`:

```bash
bash <(wget -qO- https://raw.githubusercontent.com/khlesk/switcher/master/scripts/install)
```

For fish, use `psub`.

```fish
bash (curl -fsSL https://raw.githubusercontent.com/khlesk/switcher/master/scripts/install | psub)
```

For a `.plasmoid` file, use **Add Widgets → Get New Widgets → Install Widget From Local File**.

Add **Switcher** from the widget picker.

## Configure

Set a foreground command in **Configure Switcher → General**. For example, this serves files from a project directory on localhost.

```bash
python3 -m http.server 8000 --bind 127.0.0.1 --directory ~/projects/site
```

## Development

Clone the repository and enter the project directory:

```bash
git clone https://github.com/khlesk/switcher.git
cd switcher
```

Useful helper scripts:

- `./scripts/install`
- `./scripts/reinstall`
- `./scripts/uninstall`
- `./scripts/restart-plasmashell`
