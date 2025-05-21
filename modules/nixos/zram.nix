{
  lib,
  config,
  ...
}: {
  options = {
    zram.enable = lib.mkEnableOption "enables zram";
  };

  config = lib.mkIf config.zram.enable {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
      priority = 5;
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.page_cluster" = 0;
      "vm.dirty_ratio" = 5;
    };
  };
}
