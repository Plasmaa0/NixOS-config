{
  buildDotnetModule,
  dotnetCorePackages,
  fetchzip,
}:
buildDotnetModule {
  name = "yuckls";
  pname = "yuckls";
  src = fetchzip {
    url = "https://github.com/Eugenenoble2005/YuckLS/archive/refs/heads/main.zip";
    hash = "sha256-HhxFVX9BHNydguGFZMd5FNZB06KxF34A9CqTzwJijes=";
  };

  projectFile = "YuckLS.sln";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  executables = ["YuckLS"];
}
