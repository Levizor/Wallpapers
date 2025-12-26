{
  description = "Wallpaper packs flake";

  outputs =
    { self, ... }:
    let
      # Automatically detect all directories in the repo
      packs = builtins.filter (d: builtins.pathExists d && builtins.isDirectory d) (
        builtins.attrNames (builtins.readDir ./.)
      );

      # Map each pack name to its path
      packPaths = builtins.listToAttrs (
        map (d: {
          name = d;
          value = ./${d};
        }) packs
      );

    in
    {
      # Each wallpaper pack accessible individually
      wallpapers = packPaths;

      # Optional: merged pack (symlink farm)
      mergedPack = builtins.fromJSON (builtins.toJSON packs); # placeholder
    };
}
