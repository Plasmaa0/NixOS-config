{
  buildDotnetModule,
  dotnetCorePackages,
  fetchzip,
}:
buildDotnetModule {
  name = "yuckls";
  pname = "yuckls";
  src = fetchzip {
    url = "https://github.com/Eugenenoble2005/YuckLS/archive/ab4c0315cd6c77ef0ed3c620bde0ece48e4a5949.zip";
    hash = "sha256-HhxFVX9BHNydguGFZMd5FNZB06KxF34A9CqTzwJijes=";
  };

  projectFile = "YuckLS.sln";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  executables = ["YuckLS"];
}
