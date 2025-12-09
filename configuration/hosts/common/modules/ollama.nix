{pkgs, ...}: {
  # https://opencode.ai/
  # https://github.com/ggozad/oterm
  # https://github.com/NPC-Worldwide/npcsh
  # nix-shell -p aider-chat
  # https://github.com/SilasMarvin/lsp-ai https://www.reddit.com/r/HelixEditor/comments/1icazgu/how_did_you_configure_it_for_ai/
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    # Optional: preload models, see https://ollama.com/library
    loadModels = [
      # big boys
      "deepseek-coder:6.7b"
      "deepseek-r1"
      "qwen3-coder"

      # small
      "granite4:350m"
      "granite4:3b"

      # visual
      "gemma3:12b"
      "llama3.2-vision:11b"
      "llava:latest"

      # specific
      #    maths
      "mathstral"
      "falcon3:7b-instruct-q8_0"
      #    code
      "codellama"
      "codegemma:7b"
      "codegemma:2b"
      "codegemma:instruct"
      "codegemma:code"
      "stable-code"
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
}
