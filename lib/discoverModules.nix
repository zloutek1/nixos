{ lib }:

# Returns a set of nix files in a directory
# Arguments:
#   - path: The nix path of a directory with modules
{ path }: 

let
    allFiles = builtins.readDir path;
    nixFiles = lib.filterAttrs (fileName: fileType: fileType == "regular" && lib.hasSuffix ".nix" fileName) allFiles;
in 
    lib.attrsets.mapAttrs' 
        (fileName: pathType: {
            name = lib.strings.removeSuffix ".nix" fileName;
            value = import "${path}/${fileName}";
        })
        nixFiles
