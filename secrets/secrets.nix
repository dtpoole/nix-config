let
  systems = {
    mini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6M0/XCWHHLcCWzwvao+COZ5hDb9/gQp7Yp6jZRcCdu";
    crunch = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAG0mzjqkPiIaqwvnPbmnxWI3rXkS8141yP5eBUk8rhE";
    slug = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAYeKyjR9GlfevtfOIqox7zAwla5y1cONc3lIkXcLD+g";
    supernaut = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICngfzwaBuOLv8QUeK7vvTbffdSQlLoOVEzyo7kHM9d0";
    vm1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMe0y88ln1b5palqJLalarm+KeQ9Y18ErYcXoGhmnopo";
    bombs = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcNrOGJNj5PrQgBmOvA3hef15/ZKmKrik5keay2mg46";
    hope = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9h+cgPBruVyOiuBz0sblAghDg9g9B1ecGUhbWP+FkZ";
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
  "crunch_hc_ping_uuid.age".publicKeys = allUsers ++ [ systems.crunch ];
  "acme_cloudflare_credentials.age".publicKeys = allUsers ++ [ systems.crunch systems.supernaut ];
  "restic_repository.age".publicKeys = allUsers ++ allSystems;
  "restic_repository_password.age".publicKeys = allUsers ++ allSystems;
  "crunch_hc_backup_uuid.age".publicKeys = allUsers ++ [ systems.crunch ];
  "supernaut_hc_ping_uuid.age".publicKeys = allUsers ++ [ systems.supernaut ];
  "supernaut_hc_backup_uuid.age".publicKeys = allUsers ++ [ systems.supernaut ];
  "supernaut_vaultwarden_admin_token.age".publicKeys = allUsers ++ [ systems.supernaut ];
  "linkding_password.age".publicKeys = allUsers ++ [ systems.bombs ];
  "bombs_hc_backup_uuid.age".publicKeys = allUsers ++ [ systems.bombs ];
}
