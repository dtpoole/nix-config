let
  systems = {
    mini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6M0/XCWHHLcCWzwvao+COZ5hDb9/gQp7Yp6jZRcCdu";
    crunch = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAG0mzjqkPiIaqwvnPbmnxWI3rXkS8141yP5eBUk8rhE";
  };
  users = {
    dave_mini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL8vV4xFbHiAkqYOSgwT2hdTVtnXqH5yC2mZEsQUnuJ dave@mini.local";
    dave_air = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8HIreGLHjE8f2kpfd49WRCfXXk2oMRApuIW78BWYVi";
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in
{
  "test.age".publicKeys = allUsers ++ [ systems.mini ];
  "crunch_hc_ping_uuid.age".publicKeys = allUsers ++ [ systems.crunch ];
  "acme_cloudflare_credentials.age".publicKeys = allUsers ++ [ systems.crunch ];
  "restic_repository.age".publicKeys = allUsers ++ allSystems;
  "restic_repository_password.age".publicKeys = allUsers ++ allSystems;
}
