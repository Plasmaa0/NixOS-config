{...}: {
  flake.nixosModules.ollama = {pkgs, ...}: {
    # https://opencode.ai/
    # https://github.com/ggozad/oterm
    # https://github.com/NPC-Worldwide/npcsh
    # nix-shell -p aider-chat
    # https://github.com/SilasMarvin/lsp-ai https://www.reddit.com/r/HelixEditor/comments/1icazgu/how_did_you_configure_it_for_ai/
    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "262144";
      };
      # Optional: preload models, see https://ollama.com/library
      loadModels = [
      ];
      home = "/persist/data/ollama";
    };
    services.open-webui = {
      enable = false;
      openFirewall = true;
      environment = {
        WEBUI_AUTH = "False";
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
      };
    };
  };
}
