{ config, pkgs, ... }:

{
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/01DA32DF94AE5600";
    fsType = "ntfs";
    options = [ "windows_names" "uid=1000" "gid=100" ];
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/06201E6D201E6449";
    fsType = "ntfs";
    options = [ "windows_names" "uid=1000" "gid=100" ];
  };
}

