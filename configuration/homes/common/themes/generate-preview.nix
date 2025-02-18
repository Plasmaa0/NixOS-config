{config, ...}: {
  home.file."theme-preview.html".text = let
    c = config.lib.stylix.colors;
  in ''
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                margin: 0;
                display: flex;
                flex-wrap: wrap;
                height: 100vh;
                font-family: '${config.stylix.fonts.monospace.name}', monospace;
            }
            .color-box {
                flex: 1 0 12.5%;
                height: 50vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 2em;
                color: #${c.base07};
                -webkit-text-stroke: 1px #${c.base00};
            }
        </style>
    </head>
    <body>
        <div class="color-box" style="background-color: #${c.base00};">----</div>
        <div class="color-box" style="background-color: #${c.base01};">---</div>
        <div class="color-box" style="background-color: #${c.base02};">--</div>
        <div class="color-box" style="background-color: #${c.base03};">-</div>
        <div class="color-box" style="background-color: #${c.base04};">+</div>
        <div class="color-box" style="background-color: #${c.base05};">++</div>
        <div class="color-box" style="background-color: #${c.base06};">+++</div>
        <div class="color-box" style="background-color: #${c.base07};">++++</div>

        <div class="color-box" style="background-color: #${c.base08};">red</div>
        <div class="color-box" style="background-color: #${c.base09};">orange</div>
        <div class="color-box" style="background-color: #${c.base0A};">yellow</div>
        <div class="color-box" style="background-color: #${c.base0B};">green</div>
        <div class="color-box" style="background-color: #${c.base0C};">cyan</div>
        <div class="color-box" style="background-color: #${c.base0D};">blue</div>
        <div class="color-box" style="background-color: #${c.base0E};">purple</div>
        <div class="color-box" style="background-color: #${c.base0F};">brown</div>
    </body>
    </html>
  '';
}
