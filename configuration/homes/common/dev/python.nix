{pkgs, ...}:{
  home.packages = (with pkgs; [
    ((pkgs.python3.override { enableOptimizations = true; reproducibleBuild = false;}).withPackages (ppkgs: [
      ppkgs.numpy
      ppkgs.matplotlib
      ppkgs.tabulate
      ppkgs.sympy
      ppkgs.scipy
    ]))
  ]);
}
