---
name: ssh
description: ssh config templates
---

# SSH

## Cloudflared

```sshconfig
Host <alias>
    User <user>
    HostName <host>
    ProxyCommand cloudflared access ssh --hostname %h
```

## Alias

```sshconfig
Host <alias>
    User <user>
    HostName <host>
    IdentityFile <path>
```
