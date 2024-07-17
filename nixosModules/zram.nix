{ lib, config, ... }: {

  options = {
    zram.enable = lib.mkEnableOption "enables zram";
  };

  config = lib.mkIf config.zram.enable {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 75;
    };

    boot.kernel.sysctl = { "vm.swappiness" = 25; };

  };

}
