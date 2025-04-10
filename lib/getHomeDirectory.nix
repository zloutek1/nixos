# Returns the conventional home directory path for a user based on the OS.
# Arguments:
#   - pkgs: The Nix package set for the target system (to access stdenv).
#   - username: The name of the user.
{ pkgs, username }:

if pkgs.stdenv.isDarwin then
  "/Users/${username}"
else if pkgs.stdenv.isLinux then
  "/home/${username}"
else
  throw "Unsupported system type: Cannot determine home directory for user ${username}."
