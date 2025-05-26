{
  description = "NewDawn0's tmux config";

  inputs.utils.url = "github:NewDawn0/nixUtils";

  outputs = { self, utils, ... }: {
    overlays.default = final: prev: {
      ndtmux = self.packages.${prev.system}.default;
    };
    packages = utils.lib.eachSystem { } (pkgs:
      let
        plugins = with builtins; attrNames (readDir ./plugins);
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
          runtimeInputs = [ pkgs.tmux ];
          text = ''
            CONF="${tmuxCfg}/share/tmux.conf"
            case "$1" in
              # Only inject options conditonally
              "" | attach* | new* | switch* | kill* | has* | run*)
                ${pkgs.tmux}/bin/tmux -f "$CONF" "$@"
                ;;
              *)
                ${pkgs.tmux}/bin/tmux "$@"
                ;;
            esac
          '';
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
