{ config, lib, pkgs, ... }:
let
  shellAliases = {
    k = "kubectl";
  };

in
{
  home.shellAliases = shellAliases;

  home.packages = [ pkgs.pure-prompt ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellOptions = [ "autocd" "histappend" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        fpath+=("${pkgs.pure-prompt}/share/zsh/site-functions")
      '')
      ''
        setopt autocd

        export PURE_PROMPT_SYMBOL=">"
        export PURE_PROMPT_VICMD_SYMBOL="<"
        export PURE_GIT_UP_ARROW="^"
        export PURE_GIT_DOWN_ARROW="v"
        export PURE_GIT_STASH_SYMBOL="="
        export PURE_CMD_MAX_EXEC_TIME=5
        export PURE_GIT_PULL=0
        export PURE_GIT_UNTRACKED_DIRTY=1

        autoload -Uz promptinit && promptinit

        zstyle ':prompt:pure:path' color cyan
        zstyle ':prompt:pure:git:branch' color magenta
        zstyle ':prompt:pure:git:dirty' color red
        zstyle ':prompt:pure:git:arrow' color red
        zstyle ':prompt:pure:git:stash' show yes
        zstyle ':prompt:pure:git:action' color yellow
        zstyle ':prompt:pure:execution_time' color yellow
        zstyle ':prompt:pure:prompt:success' color green
        zstyle ':prompt:pure:prompt:error' color red

        prompt pure
      ''
    ];
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
    git = true;
  };

  programs.ripgrep = {
    enable = true;
    package = pkgs.ripgrep.override { withPCRE2 = true; };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
