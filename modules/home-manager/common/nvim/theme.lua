local M = {}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {
  white = '#dee3e5',
  black = '#0e1415',
  darker_black = lighten('#0e1415', -3),
  black2 = lighten('#0e1415', 6),
  one_bg = lighten('#0e1415', 10),
  one_bg2 = lighten('#0e1415', 16),
  one_bg3 = lighten('#0e1415', 22),
  grey = '#3f484a',
  grey_fg = lighten('#3f484a', -10),
  grey_fg2 = lighten('#3f484a', -20),
  light_grey = '#899294',
  red = '#ffb4ab',
  baby_pink = lighten('#ffb4ab', 10),
  pink = '#bac6ea',
  line = '#899294',
  green = '#b1cbd0',
  vibrant_green = lighten('#b1cbd0', 10),
  blue = '#82d3e0',
  nord_blue = lighten('#82d3e0', 10),
  yellow = lighten('#bac6ea', 10),
  sun = lighten('#bac6ea', 20),
  purple = '#bac6ea',
  dark_purple = lighten('#bac6ea', -10),
  teal = '#334b4f',
  orange = '#ffb4ab',
  cyan = '#b1cbd0',
  statusline_bg = lighten('#0e1415', 6),
  pmenu_bg = '#3f484a',
  folder_bg = lighten('#82d3e0', 0),
  lightbg = lighten('#0e1415', 10),
}

M.base_16 = {
  base00 = '#0e1415',
  base01 = lighten('#3f484a', 0),
  base02 = '#b1cbd0',
  base03 = lighten('#899294', 0),
  base04 = lighten('#bfc8ca', 0),
  base05 = '#dee3e5',
  base06 = lighten('#dee3e5', 0),
  base07 = '#0e1415',
  base08 = lighten('#ffb4ab', -10),
  base09 = '#bac6ea',
  base0A = '#82d3e0',
  base0B = '#dae2ff',
  base0C = '#82d3e0',
  base0D = lighten('#004f58', 20),
  base0E = '#9eeffd',
  base0F = '#dee3e5',
}

M.type = "dark"  -- or "light" depending on your theme

M.polish_hl = {
  defaults = {
    Comment = {
      italic = true,
      fg = M.base_16.base03,
    },
  },
  Syntax = {
    String = {
      fg = '#bac6ea'
    }
  },
  treesitter = {
    ["@comment"] = {
      fg = M.base_16.base03,
    },
    ["@string"] = {
      fg = '#bac6ea'
    },
  }
}

return M