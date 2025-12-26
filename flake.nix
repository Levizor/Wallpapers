{
  description = "A collection of wallpapers.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      lib = nixpkgs.lib;

      # List of directories to exclude from wallpaper packs
      excludedDirs = [ ".git" ".github" "lib" ];

      # Get all entries in the root directory
      entries = builtins.readDir ./.;

      # Filter for directories that are wallpaper packs
      isWallpaperPack = name: type: type == "directory" && !(lib.elem name excludedDirs);

      # Get the names of the wallpaper pack directories
      wallpaperPacks = lib.attrNames (lib.filterAttrs isWallpaperPack entries);

      # Create an attribute set of wallpapers, where each key is a pack name
      # and the value is a path to the directory in the Nix store.
      wallpapers = lib.genAttrs wallpaperPacks (packName: ./. + "/${packName}");

    in
    {
      # The primary output, providing access to individual wallpaper packs
      inherit wallpapers;

      # Home Manager module for configuring wpaperd with the selected wallpaper packs
      homeManagerModules.default = import ./hm-module.nix { inherit wallpapers; };
    };
}
