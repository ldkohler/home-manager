{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    git-trim
  ];

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {

      user = {
        name = "TODO";  # TODO: Set your work Git username
        email = "TODO";  # TODO: Set your work email address
      };

      alias = {
        a = "add";
        b = "branch";
        c = "commit";
        acp = "!acp() { git add . && git commit -m \"$*\" && git push; }; acp";
        cane = "commit --amend --no-edit";
        cf = "config";
        ch = "checkout";
        cl = "clone";
        cp = "cherry-pick";
        d = "diff";
        dt = "difftool";
        f = "fetch";
        i = "init";
        lg = "log --oneline --graph --decorate";
        m = "merge";
        p = "pull";
        pu = "push";
        r = "remote";
        rb = "rebase";
        rs = "restore";
        rt = "reset";
        s = "status";
        sm = "submodule";
        st = "stash";
        sw = "switch";
        t = "tag";
        wt = "worktree";
      };

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };
  };

}
