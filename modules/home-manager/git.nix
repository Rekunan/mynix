{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Rekunan";
    userEmail = "Mangsn05@protonmail.com";
    extraConfig = {
      core = {
        editor = "vim";
      };
      push = {
        default = "current";
      };
    };
  };
}

