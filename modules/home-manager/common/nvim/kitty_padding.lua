local kitty_padding_group = vim.api.nvim_create_augroup("KittyPaddingGroup", { clear = true })

local target_socket = vim.env.KITTY_LISTEN_ON
if target_socket then
  vim.api.nvim_create_autocmd("VimEnter", {
    group = kitty_padding_group,
    desc = "Remove Kitty padding on Vim start",
    callback = function()
      vim.fn.system({ "kitty", "@", "--to", target_socket, "set-spacing", "padding=0" })
    end,
  })

  vim.api.nvim_create_autocmd("VimLeave", {
    group = kitty_padding_group,
    desc = "Restore Kitty padding on Vim exit",
    callback = function()
      vim.fn.system({ "kitty", "@", "--to", target_socket, "set-spacing", "padding=default" })
    end,
  })
end

return {}