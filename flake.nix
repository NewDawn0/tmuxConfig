{
  description = "NewDawn0's tmux config";

  inputs.utils.url = "github:NewDawn0/nixUtils";

  outputs = { self, utils, ... }: {
    overlays.default = final: prev: {
      ndtmux = self.packages.${prev.system}.default;
    };
    packages = utils.lib.eachSystem { } (pkgs:
      let
        plugins = with builtins; readDir ./plugins |> attrNames;
        tmuxPlugins = pkgs.stdenvNoCC.mkDerivation {
          name = "tmux-plugins";
          src = ./.;
          dontBuild = true;
          dontConfigure = true;
          installPhase = ''
            mkdir -p $out/share
            cp -R plugins $out/share/
          '';
        };
        tmuxCfg = pkgs.writeTextFile {
          name = "tmux-cfg";
          text = with builtins;
            readFile ./tmux.conf + concatStringsSep "\n"
            (map (p: "source-file ${tmuxPlugins}/share/plugins/${p}") plugins);
          destination = "/share/tmux.conf";
        };
      in {
        default = pkgs.writeShellApplication {
          name = "tmux";
          text = "${pkgs.tmux}/bin/tmux -f ${tmuxCfg}/share/tmux.conf";
          meta = {
            description = "Fully setup runnable tmux configuration";
            homepage = "https://github.com/NewDawn0/tmuxConfig";
            license = pkgs.lib.licenses.mit;
            maintainers = with pkgs.lib.maintainers; [ NewDawn0 ];
            platforms = pkgs.lib.platforms.all;
          };
        };
      });
  };
}
