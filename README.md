# tmuxConfig - Easily Deployable tmux Configuration with Nix

## Overview

**tmuxConfig** is a Nix package that provides an easily deployable `tmux` configuration. It does not rely on Home Manager and can be installed like any other package by applying the `overlays.default` overlay.

## Features

- 🌐 Vim-splits integration
- 📄✏️Sensible defaults for better usability.
- ✨ UI theme
- 📦 Easily deployable via Nix overlays.

## Try it out

```bash
nix run github:NewDawn0/tmuxConfig
```

## Installation

1. Add the input to your system flake

```nix
{ inputs.tmuxConfig.url = "github:NewDawn0/tmuxConfig"; }
```

2. Apply the overlay

```nix
pkgs = import nixpkgs {
    # ...
    overlays = [ inputs.tmuxConfig.overlays.default ]
};
```

1. Install the ndtmux package

```nix
environment.systemPackages = [
    # ...
    pkgs.ndtmux
];
```

## Usage

After installation, `tmuxConfig` provides a pre-configured `tmux` setup. Start `tmux` normally:

```bash
tmux
```
