{ lib }:
/*
  Recursively imports Nix files and directories containing `default.nix` from a specified path,
  creating a nested attribute set structure that mirrors the directory layout.

  Arguments:
    - path: The directory path to scan (can be string or path type)

  Returns:
    Attribute set where:
    - `.nix` files become attributes with their basename (without extension)
    - Directories become nested attribute sets
    - Directories containing `default.nix` get a special `default` attribute
    - Values are the result of importing the corresponding Nix file

  Example Directory Structure:
    /path
    ├── file1.nix
    ├── dir1
    │   ├── default.nix
    │   ├── file2.nix
    │   └── subdir
    │       └── default.nix
    └── dir2
        └── file3.nix

  Example Return Value:
    {
      file1 = <content of file1.nix>;
      dir1 = {
        default = <content of dir1/default.nix>;
        file2 = <content of dir1/file2.nix>;
        subdir = {
          default = <content of dir1/subdir/default.nix>;
        };
      };
      dir2 = {
        file3 = <content of dir2/file3.nix>;
      };
    }

  Note:
    - All imported files should return valid Nix values (typically attribute sets)
    - Directory names take precedence over filenames in case of conflicts
    - Designed for use with Nix's module system and `imports` declarations
*/
let
  discoverModules = path: let
    collect = dir: let
      entries = builtins.readDir dir;
      nixFiles = lib.filterAttrs (n: v: v == "regular" && lib.hasSuffix ".nix" n) entries;
      directories = lib.filterAttrs (n: v: v == "directory") entries;
      filesSet = lib.mapAttrs' (n: _:
        let name = lib.removeSuffix ".nix" n;
        in lib.nameValuePair name (import "${dir}/${n}")
      ) nixFiles;
      dirsSet = lib.mapAttrs' (n: _:
        lib.nameValuePair n (collect "${dir}/${n}")
      ) directories;
      defaultFile = if entries ? "default.nix" then { default = import "${dir}/default.nix"; } else {};
    in defaultFile // filesSet // dirsSet;
  in collect path;
in
discoverModules