let
  systems = {
    mini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6M0/XCWHHLcCWzwvao+COZ5hDb9/gQp7Yp6jZRcCdu";
    slug = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAYeKyjR9GlfevtfOIqox7zAwla5y1cONc3lIkXcLD+g";
    supernaut = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICngfzwaBuOLv8QUeK7vvTbffdSQlLoOVEzyo7kHM9d0";
    sparkles = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIItEj1cbmZqIyGZgLfwIb3jmr7byFfTWrMf4FevPsxzn";
    jumbo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+jRGsr5gDvuAZVInvp6IuLeV7lRD5u8GTbGNmDRa5j";
    vm1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlsETz033DfRhx3oWV8smITgaEh2wf5euhlVyPNUd0W";
  };
  users = {
    dave_mini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL8vV4xFbHiAkqYOSgwT2hdTVtnXqH5yC2mZEsQUnuJ";
    dave_aurora = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8vKcWXqq+nA88NE2/mfCpu1bR1w8OJtJRTfTVqbbLR";
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in {
  "user_password.age".publicKeys = allUsers ++ allSystems;
  "acme_cloudflare_credentials.age".publicKeys = allUsers ++ [systems.supernaut systems.sparkles];
  "supernaut_hc_ping_uuid.age".publicKeys = allUsers ++ [systems.supernaut];
  "supernaut_hc_restic_uuid".publicKeys = allUsers ++ [systems.supernaut];
  "supernaut_vaultwarden_admin_token.age".publicKeys = allUsers ++ [systems.supernaut];
  "linkding_password.age".publicKeys = allUsers ++ [systems.sparkles];
  "tailscale_auth_key.age".publicKeys = allUsers ++ allSystems;
  "jumbo_hc_ping_uuid.age".publicKeys = allUsers ++ [systems.jumbo];
  "sparkles_hc_ping_uuid.age".publicKeys = allUsers ++ [systems.sparkles];
  "sparkles_hc_restic_uuid.age".publicKeys = allUsers ++ [systems.sparkles];

  "restic/cloud/env.age".publicKeys = allUsers ++ [systems.sparkles];
  "restic/cloud/repo.age".publicKeys = allUsers ++ [systems.sparkles];
  "restic/cloud/password.age".publicKeys = allUsers ++ [systems.sparkles];

  "restic/local/repo.age".publicKeys = allUsers ++ [systems.supernaut];
  "restic/local/password.age".publicKeys = allUsers ++ [systems.supernaut];

  "eplustv_env.age".publicKeys = allUsers ++ [systems.jumbo];
  "searxng_secret.age".publicKeys = allUsers ++ [systems.sparkles];
  "miniflux_admin.age".publicKeys = allUsers ++ [systems.sparkles];
}
