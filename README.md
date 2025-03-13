# Conf🍚

**Shell app configs**

## Install🤢

Nix home-manager solution

```nix
let
  conf = builtins.fetchGit {
    url = "https://github.com/mart-mihkel/conf.git";
    rev = "<commit-hash-sri>";
    ref = "tty";
  };
in {
  home = {
    file.".config/nvim".source = conf.outPath + "/.config/nvim";
    file.".config/tmux".source = conf.outPath + "/.config/tmux";

    file.".bash_profile".text = "[[ -f ~/.bashrc ]] && . ~/.bashrc";
    file.".bashrc".source = conf.outPath + "/.bashrc";
  };
}
```

You can get the sri hash from git log with

```bash
nix hash convert --hash-algo sha1 <commit-hash> --to sri
```
