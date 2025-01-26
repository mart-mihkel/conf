{
  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];

    shellAliases = {
      headset = "bluetoothctl connect 14:3F:A6:DA:AA:00";
      wake-jaam = "wol --port=9 9C:6B:00:13:EE:B0";
      neofetch = "fastfetch --config neofetch";
      activate = ". .venv/bin/activate";
    };

    initExtra = ''
      PS1="\[\033[01;34m\]\W\[\033[00m\] "

      bind 'set completion-ignore-case on'
      bind 'set show-all-if-ambiguous on'
      bind 'TAB:menu-complete'
    '';
  };
}
