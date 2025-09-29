{
  imports = [
    ../default.nix
    ../users.nix
    ../sshd.nix
  ];

  # Settings common to all hosts
  users.enable = true;
  sshd.enable = true;
}
