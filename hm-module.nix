# hm-module.nix
{ wallpapers }:

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.wpaperd;
in
{
    options.wallpapers.mode = lib.mkOption {
      type = lib.types.str;
      default = "center";
      description = "The display mode for the wallpapers (e.g., 'center', 'fill', 'zoom', 'stretch').";
    };
  
    options.wallpapers.packs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of wallpaper packs to use from the wallpaper flake.";
    };
  
    config = lib.mkIf (cfg.enable && config.wallpapers.packs != []) {
      services.wpaperd.settings.any = {
        path =
          let
            selectedPacks = config.wallpapers.packs;
            availablePacks = builtins.attrNames wallpapers;
  
            # Ensure all selected packs exist
            validPacks = builtins.filter (p: builtins.hasAttr p wallpapers) selectedPacks;
            invalidPacks = builtins.filter (p: !(builtins.hasAttr p wallpapers)) selectedPacks;
  
          in
          # Throw an error if an invalid pack is selected
          if builtins.length invalidPacks > 0 then
            throw "The following wallpaper packs are not available: ${toString invalidPacks}. Available packs are: ${toString availablePacks}"
          else
            let
              mergedPath = pkgs.symlinkJoin {
                name = "merged-wallpapers";
                paths = map (pack: wallpapers.${pack}) validPacks;
              };
            in
            lib.mkForce mergedPath;
  
        mode = lib.mkForce config.wallpapers.mode;
      };
    };
  }
  
