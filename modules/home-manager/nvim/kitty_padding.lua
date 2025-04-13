-- Define an autocommand group to manage our autocommands.
-- Using { clear = true } ensures idempotency on reloads.
local kitty_padding_group = vim.api.nvim_create_augroup("KittyPaddingGroup", { clear = true })

-- Autocommand for VimEnter: Remove Kitty padding
vim.api.nvim_create_autocmd("VimEnter", {
  group = kitty_padding_group,
  desc = "Remove Kitty padding on Vim start",
  -- Use a Lua callback function for the action
  callback = function()
    -- Execute the shell command synchronously using vim.fn.system.
    -- Passing arguments as a table avoids shell interpolation.
    vim.fn.system({ "kitty", "@", "set-spacing", "padding-left=0" })
    vim.fn.system({ "kitty", "@", "set-spacing", "padding-top=0" })

    -- Optional: Add basic error checking using pcall
    -- local ok1, err1 = pcall(vim.fn.system, { "kitty", "@", "set-spacing", "padding-left=0" })
    -- local ok2, err2 = pcall(vim.fn.system, { "kitty", "@", "set-spacing", "padding-top=0" })
    -- if not ok1 or not ok2 then
    --   vim.notify("Failed to set Kitty padding on VimEnter. Error(s): ".. tostring(err1).. ", ".. tostring(err2), vim.log.levels.ERROR)
    -- end
  end,
})

-- Autocommand for VimLeave: Restore Kitty padding to default
vim.api.nvim_create_autocmd("VimLeave", {
  group = kitty_padding_group,
  desc = "Restore Kitty padding on Vim exit",
  -- Use a Lua callback function for the action
  callback = function()
    -- Execute the shell command synchronously using vim.fn.system.
    vim.fn.system({ "kitty", "@", "set-spacing", "padding-left=default" })
    vim.fn.system({ "kitty", "@", "set-spacing", "padding-top=default" })

    -- Optional: Add basic error checking using pcall
    -- local ok1, err1 = pcall(vim.fn.system, { "kitty", "@", "set-spacing", "padding-left=default" })
    -- local ok2, err2 = pcall(vim.fn.system, { "kitty", "@", "set-spacing", "padding-top=default" })
    -- if not ok1 or not ok2 then
    --   vim.notify("Failed to restore Kitty padding on VimLeave. Error(s): ".. tostring(err1).. ", ".. tostring(err2), vim.log.levels.ERROR)
    -- end
  end,
})

-- Lua modules loaded via require() can optionally return a value.
-- It's not strictly necessary here as the module's purpose is the side effect
-- of creating autocommands, but returning an empty table is common practice.
return {}