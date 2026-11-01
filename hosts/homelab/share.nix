# The T7 share, as both sides see it. Plain data: `import` it, it is not a module.
# The Mac's lima.yaml mounts it, and the guest declares it by Lima's tag, which
# is computed from these two strings, so they must come from one place.
{
  location = "/Volumes/T7/homelab";
  mountPoint = "/mnt/t7";
}
