{
  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];

    shellAliases = {
      wake-jaam = "wol --port=9 9C:6B:00:13:EE:B0";
      neofetch = "fastfetch --config neofetch";
    };

    initExtra = ''
      PS1="\[\033[01;34m\]\W\[\033[00m\] "

      bind 'set completion-ignore-case on'
      bind 'set show-all-if-ambiguous on'
      bind 'TAB:menu-complete'
    '';
  };
}
