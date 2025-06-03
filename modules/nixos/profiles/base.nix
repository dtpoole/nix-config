{ inputs, ... }: {
  imports = [
    ../default.nix
    ../users.nix
    ../sshd.nix
    ../hm.nix
    inputs.agenix.nixosModules.default
  ];

  # Settings common to all hosts
  users.enable = true;
  sshd.enable = true;
  hm.enable = true;
}
