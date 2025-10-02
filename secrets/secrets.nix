let
  systems = {
    mini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6M0/XCWHHLcCWzwvao+COZ5hDb9/gQp7Yp6jZRcCdu";
    sparkles = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIItEj1cbmZqIyGZgLfwIb3jmr7byFfTWrMf4FevPsxzn";
    sapphire = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyWx8Tkh7ORKbXPZ5oclwOxPdmAG39zujS0f7n4unQa";
    pure = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0hFkXxBFuXWhP8A7mI2ReXVCIjzdcBjLAnwYdNRkeg";
  };
  users = {
    dave_mini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL8vV4xFbHiAkqYOSgwT2hdTVtnXqH5yC2mZEsQUnuJ";
    dave_aurora = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8vKcWXqq+nA88NE2/mfCpu1bR1w8OJtJRTfTVqbbLR";
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in {
  "user_password.age".publicKeys = allUsers ++ allSystems;
  "acme_cloudflare_credentials.age".publicKeys = allUsers ++ [systems.pure systems.sparkles];
  "tailscale_auth_key.age".publicKeys = allUsers ++ allSystems;

  "sapphire_hc_ping_uuid.age".publicKeys = allUsers ++ [systems.sapphire];
  "sparkles_hc_ping_uuid.age".publicKeys = allUsers ++ [systems.sparkles];
  "sparkles_hc_restic_uuid.age".publicKeys = allUsers ++ [systems.sparkles];

  "restic/cloud/env.age".publicKeys = allUsers ++ [systems.sparkles];
  "restic/cloud/repo.age".publicKeys = allUsers ++ [systems.sparkles];
  "restic/cloud/password.age".publicKeys = allUsers ++ [systems.sparkles];
  "restic/local/repo.age".publicKeys = allUsers;
  "restic/local/password.age".publicKeys = allUsers;

  "linkding_password.age".publicKeys = allUsers ++ [systems.sparkles];
  "searxng_secret.age".publicKeys = allUsers ++ [systems.sparkles];
  "miniflux_admin.age".publicKeys = allUsers ++ [systems.sparkles];
  "mlbserver_env.age".publicKeys = allUsers ++ [systems.sapphire];
  "vaultwarden_admin_token.age".publicKeys = allUsers ++ [systems.pure];
}
