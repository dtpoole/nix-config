{
  imports = [
    ../default.nix
    ../users.nix
    ../sshd.nix
    ../hm.nix
  ];

  # Settings common to all hosts
  users.enable = true;
  sshd.enable = true;
  hm.enable = true;
}
