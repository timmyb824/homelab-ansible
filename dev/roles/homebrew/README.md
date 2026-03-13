# Homebrew Role

This Ansible role installs and configures Homebrew and manages packages on macOS systems.

## Requirements

- Ansible 2.9 or higher
- macOS operating system

## Role Variables

```yaml
# Default state for Homebrew installation and packages
homebrew_state: present # Can be 'present' or 'absent'

# Installation mode: 'brewfile', 'targeted', or 'both'
# - brewfile: Install packages from Brewfile in gist
# - targeted: Install only the targeted package list below
# - both: Install from both Brewfile and targeted list
homebrew_install_mode: "brewfile"

# Mac App Store configuration
install_mas: false # Whether to install Mac App Store CLI
install_slack: false # Whether to install Slack from Mac App Store

# Gist base URL for package lists
gist_base_url: "https://gist.githubusercontent.com/timmyb824/807597f33b14eceeb26e4e6f81d45962/raw"

# Taps to add before installing targeted packages
homebrew_taps:
  - homebrew/core
  - homebrew/cask

# Targeted packages to install (used when install_mode is 'targeted' or 'both')
homebrew_packages:
  - chezmoi
  - sops
  - age
  - atuin
  - cloudflared
  - fzf
  - ghq
  - gh
  - go
  - helix
  - helm
  - k9s
  - fnm
  - mas
  - rbenv
  - tfenv
  - trufflehog
  - zellij
```

## Usage

### Install from Brewfile only (default)

```yaml
- hosts: all
  roles:
    - role: homebrew
      homebrew_state: present
      homebrew_install_mode: "brewfile"
```

### Install targeted packages only

```yaml
- hosts: all
  roles:
    - role: homebrew
      homebrew_state: present
      homebrew_install_mode: "targeted"
```

### Install both Brewfile and targeted packages

```yaml
- hosts: all
  roles:
    - role: homebrew
      homebrew_state: present
      homebrew_install_mode: "both"
```

### Customize targeted packages

```yaml
- hosts: all
  roles:
    - role: homebrew
      homebrew_state: present
      homebrew_install_mode: "targeted"
      homebrew_taps:
        - homebrew/core
        - custom/tap
      homebrew_packages:
        - git
        - vim
        - custom-package
```

## Features

1. Installs Homebrew if not present
2. Configures PATH for both Intel and Apple Silicon Macs
3. Supports three installation modes:
   - **Brewfile mode**: Manages packages via Brewfile from gist
   - **Targeted mode**: Installs a specific list of packages
   - **Both mode**: Combines Brewfile and targeted package installation
4. Manages Homebrew taps
5. Supports Mac App Store installations via mas
6. Idempotent operations

## Package List

### Brewfile Mode

Packages are managed via a `Brewfile` in your gist. The format is:

```ruby
package1
package2
# Comments are supported
package3
```

### Targeted Mode

Packages are defined in the `homebrew_packages` variable as a list. You can customize this list in your playbook or inventory.

## Notes

- The role automatically detects the Mac architecture and sets up the appropriate PATH
- Mac App Store installations require being signed into the App Store
- Package installations are idempotent and will only install missing packages
