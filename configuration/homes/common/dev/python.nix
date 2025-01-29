{pkgs, ...}: {
  home.packages = with pkgs; [
    ((python3.override {
        enableOptimizations = true;
        reproducibleBuild = false;
      })
      .withPackages (ppkgs:
        with ppkgs; [
          numpy
          matplotlib
          tabulate
          sympy
          scipy
        ]))
  ];
}
