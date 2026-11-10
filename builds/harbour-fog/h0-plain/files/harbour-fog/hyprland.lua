-- Harbour Fog: teal fading into grey-blue on the active window,
-- a dim slate on inactive ones.
local active_border_color = { colors = { "rgba(6f9e9aee)", "rgba(7f97adee)" }, angle = 45 }
local inactive_border_color = "rgba(36414baa)"

hl.config({
  general = {
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
  },
})
