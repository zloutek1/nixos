{ lib, ... }:

# Function to create a type consisting of available options and one default.
# One can either specify
# ```nix
# options = [ "zsh" "bash" ];
# ```
# where the first element gets selected
# or specify the object directly
# ```nix
# options = {
#   available = [ "zsh" "bash" ];
#   default = "zsh";
# };
# ```nix
# Arguments:
#   - name: the name of the selector
#   - type: the possible values
#   - description: the description of the selector
{
  name,
  type,
  description ? "",
}:

lib.types.coercedTo (lib.types.listOf type)
  (list: {
    available = list;
    default = lib.lists.head list;
  })
  (
    lib.types.submodule (
      { config, ... }:
      {
        options = {
          available = lib.mkOption {
            type = lib.types.listOf type;
            description = "Available ${name} options";
          };

          default = lib.mkOption {
            type = type;
            description = "Default ${name} selection";
          };
        };
      }
    )
  )
