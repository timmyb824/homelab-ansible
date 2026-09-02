# bin Role

Installs [bin](https://github.com/marcosnils/bin), a binary manager, and
(optionally) packages managed by it.

## Supported platforms

- macOS arm64 (`bin_*_darwin_arm64`)
- Linux x86_64 (`bin_*_linux_amd64`)
- Linux aarch64 (e.g. Vagrant VM, `bin_*_linux_arm64`)

## How it works

1. Downloads the pinned `bin` release asset (checksum-verified against the
   release `checksums.txt`).
2. Seeds `~/.config/bin/config.json` with `default_path` set to
   `bin_install_dir` (only if it doesn't already exist) so `bin`'s first-run
   "pick a default download dir" prompt is never triggered non-interactively.
3. Runs `bin install github.com/marcosnils/bin ~/.local/bin/` so `bin` is
   managed by itself, then verifies with `bin ls` and removes the bootstrap
   download.
4. If `bin_install_packages: true`, fetches the per-OS package list from the
   gist (`bin_darwin.list`, `bin_linux.list`) and runs `bin install <repo>`
   for each entry. Entries that are already installed exit non-zero
   ("file exists") and are skipped without failing the run.

## Role Variables

- `bin_state`: `present` or `absent` (default: `present`)
- `bin_version`: pinned bin release version, without the `v` prefix (default: `0.29.1`)
- `bin_install_dir`: install directory (default: `~/.local/bin`)
- `bin_packages_gist_url`: gist raw URL, templated with `bin_{{ ansible_system | lower }}.list`
- `bin_install_packages`: install packages from the gist list (default: `false`)
- `bin_github_token`: optional token exported as `GITHUB_AUTH_TOKEN` to avoid GitHub API rate limits

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: bin
      bin_state: present
      bin_install_packages: true
      tags: [bin, dev_tools]
```

## Notes

- Package list entries must be unambiguous for `bin`'s automatic asset
  scoring (single obvious asset per platform), otherwise `bin` prompts
  interactively. Prefer full release URLs for tricky packages.
- `bin_state: absent` removes the `bin` binary and `~/.config/bin/config.json`;
  binaries installed by `bin` are left in place.

## License

MIT
