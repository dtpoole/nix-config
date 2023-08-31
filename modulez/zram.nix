{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 75;
  };

  boot.kernel.sysctl = { "vm.swappiness" = 25; };

}
