---
name: sip
description: SIP and boot-args setup for yabai and corner injection
---

# SIP

This machine runs with partially disabled System Integrity Protection plus custom boot arguments. Two things need it: yabai's scripting-addition and the corner-fix library described in corners.md.

## Current state

Filesystem, debugging, NVRAM, boot-arg and Apple Internal protections are disabled, everything else stays on:

```console
$ csrutil status
System Integrity Protection status: unknown (Custom Configuration).
  Apple Internal: disabled
  Filesystem Protections: disabled
  Debugging Restrictions: disabled
  NVRAM Protections: disabled
  Boot-arg Restrictions: disabled
```

The boot arguments carry one flag for yabai and one that switches off AMFI for the corner fix:

```console
$ nvram boot-args=-arm64e_preview_abi
```

## Why each piece exists

Yabai needs filesystem and debugging protections off, and `-arm64e_preview_abi` present in the boot arguments, or `yabai --load-sa` refuses to inject into the Dock. The corner fix needs filesystem protections off so `libcornerfix.dylib` can live in `/usr/local/lib`, and `amfi_get_out_of_my_way=1` so hardened apps like Chromium, Safari and Finder accept the injected library instead of aborting on launch.

## Reapplying it

The SIP exemptions can only be changed from Recovery mode:

```sh
csrutil enable --without fs --without debug --without nvram
```

Boot arguments can be set from a normal terminal since NVRAM protection is off, but always keep the yabai flag when editing them:

```sh
sudo nvram boot-args="-arm64e_preview_abi amfi_get_out_of_my_way=1"
```

Reboot afterwards, then verify with `csrutil status` and `nvram boot-args`.
