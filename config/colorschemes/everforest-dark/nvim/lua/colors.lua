require("everforest").setup({
    background = "hard",
    transparent_background_level = 1,
    italics = true,
    disable_italic_comments = false,
    inlay_hints_background = "dimmed",
    on_highlights = function(hl, palette)
      hl["@string.special.symbol.ruby"] = { link = "@field" }
      hl["DiagnosticUnderlineWarn"] = { undercurl = true, sp = palette.yellow }
    end,
  })
require("everforest").load()
