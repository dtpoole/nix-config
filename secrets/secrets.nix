let
  systems = {
    mini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6M0/XCWHHLcCWzwvao+COZ5hDb9/gQp7Yp6jZRcCdu";
    slug = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAYeKyjR9GlfevtfOIqox7zAwla5y1cONc3lIkXcLD+g";
    supernaut = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICngfzwaBuOLv8QUeK7vvTbffdSQlLoOVEzyo7kHM9d0";
    hope = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9h+cgPBruVyOiuBz0sblAghDg9g9B1ecGUhbWP+FkZ";
    sparkles = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIItEj1cbmZqIyGZgLfwIb3jmr7byFfTWrMf4FevPsxzn";
  };
  users = {
    dave_mini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL8vV4xFbHiAkqYOSgwT2hdTVtnXqH5yC2mZEsQUnuJ";
    dave_air = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8HIreGLHjE8f2kpfd49WRCfXXk2oMRApuIW78BWYVi";
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in
{
  "user_password.age".publicKeys = allUsers ++ allSystems;
  "acme_cloudflare_credentials.age".publicKeys = allUsers ++ [ systems.supernaut systems.sparkles systems.hope ];
  "restic_repository.age".publicKeys = allUsers ++ allSystems;
  "restic_cloud_repository.age".publicKeys = allUsers ++ [ systems.sparkles systems.hope ];
  "restic_cloud_environment.age".publicKeys = allUsers ++ [ systems.sparkles systems.hope ];
  "restic_cloud_password.age".publicKeys = allUsers ++ [ systems.sparkles systems.hope ];
  "restic_repository_password.age".publicKeys = allUsers ++ allSystems;
  "supernaut_hc_ping_uuid.age".publicKeys = allUsers ++ [ systems.supernaut ];
  "supernaut_hc_backup_uuid.age".publicKeys = allUsers ++ [ systems.supernaut ];
  "supernaut_vaultwarden_admin_token.age".publicKeys = allUsers ++ [ systems.supernaut ];
  "linkding_password.age".publicKeys = allUsers ++ [ systems.sparkles ];
  "tailscale_auth_key.age".publicKeys = allUsers ++ allSystems;
  "hope_hc_ping_uuid.age".publicKeys = allUsers ++ [ systems.hope ];
  "sparkles_hc_ping_uuid.age".publicKeys = allUsers ++ [ systems.sparkles ];
}
