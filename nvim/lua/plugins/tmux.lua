return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<F1>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate Left" },
      { "<F2>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate Down" },
      { "<F3>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate Up" },
      { "<F4>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate Right" },
    },
  },
}
