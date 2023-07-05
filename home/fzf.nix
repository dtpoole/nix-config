{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [ "--layout=reverse" "--info=inline" "--height=60%" "--multi" ];

    colors = {
      fg = "#e5e9f0";
      bg = "#3b4252";
      hl = "#81a1c1";
      "fg+" = "#e5e9f0";
      "bg+" = "#3b4252";
      "hl+" = "#81a1c1";
      info = "#eacb8a";
      prompt = "#bf6069";
      pointer = "#b48dac";
      marker = "#a3be8b";
      spinner = "#b48dac";
      header = "#a3be8b";
    };
  };
}
