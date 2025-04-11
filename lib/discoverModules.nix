{ lib }:

# Returns an attribute set importing .nix files and directories containing default.nix
# from the specified path.
#
# Arguments:
#   - path: The nix path (can be a string or path type) of a directory to scan.
#
# Returns:
#   An attribute set where:
#   - Keys derived from `.nix` files are the filenames without the `.nix` suffix.
#   - Keys derived from directories are the directory names themselves.
#   - Values are the imported contents of the corresponding `.nix` or `default.nix` file.
{ path }:

let
  allEntries = builtins.readDir path;

  # Process each entry, creating a list of { name = ..., value = ... } attribute sets
  # or null for entries that should be ignored.
  processedEntries = lib.attrsets.mapAttrsToList (name: type:
    if type == "regular" && lib.hasSuffix ".nix" name then
      {
        name = lib.strings.removeSuffix ".nix" name;
        value = import "${path}/${name}";
      }
    else if type == "directory" && builtins.pathExists "${path}/${name}/default.nix" then
      {
        name = name;
        value = import "${path}/${name}/default.nix";
      }
    else
      null
  ) allEntries;

  validEntries = lib.filter (entry: entry != null) processedEntries;

  resultAttrs = lib.listToAttrs validEntries;

in
resultAttrs