let
  shellAliases = {
    tm = "tmux";
  };
in
{
  programs.tmux = {
    enable = true;
  };

  # only works in bash/zsh, not nushell
  # home.shellAliases = shellAliases;
}
