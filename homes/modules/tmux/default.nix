{
  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    keyMode = "vi";
    extraConfig = ''
      setw -g mouse on

      setw -g mode-style "fg=black,bg=white"

      set -g status-left-length 32
      set -g status-right "#(whoami)@#H %H:%M"
      set -g status-style "fg=black,bg=white"

      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  };
}
