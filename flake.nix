{
  description = "NewDawn0's tmux config";

  inputs.utils.url = "github:NewDawn0/nixUtils";
  outputs = { utils, ... }: {
    packages = utils.lib.eachSystem { } (pkgs:
      let
        tmuxPlugins = pkgs.symlinkJoin {
          name = "tmux-plugins";
          paths = with pkgs.tmuxPlugins; [ vim-tmux-navigator yank ];
        };
        tmuxCfg = pkgs.stdenvNoCC.mkDerivation {
          name = "tmux-cfg";
          src = ./.;
          dontBuild = true;
          installPhase = "install -D tmux.conf $out/lib/tmux.conf";
        };
        tmuxBin = pkgs.writeShellScriptBin "tmux" ''
          ${pkgs.tmux}/bin/tmux
        '';
        tmuxFinal = pkgs.symlinkJoin {
          name = "tmux-final";
          paths = [ tmuxBin tmuxCfg ];
        };
        # tmuxBin = pkgs.writeShellApplication {
        #   name = "tmux";
        #   text = "${pkgs.tmux}/bin/tmux -f ${tmuxCfg}/lib/tmux.conf";
        #   meta = {
        #     description = "Fully setup runnable tmux configuration";
        #     homepage = "https://github.com/NewDawn0/tmuxConfig";
        #     license = pkgs.lib.licenses.mit;
        #     maintainers = with pkgs.lib.maintainers; [ NewDawn0 ];
        #     platforms = pkgs.lib.platforms.all;
        #   };
        # };
      in { default = tmuxFinal; });

  };
}
