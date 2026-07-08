{ pkgs, ... }: {
  home.packages = with pkgs; [
    slumber
  ];

  programs.lazyvim.plugins.slumber = /*lua*/ ''
    return {
      {
        "folke/which-key.nvim",
        opts = function(_, opts)
          local wk = require("which-key")
          wk.add({
            {
              "<leader>vs",
              function()
                Snacks.terminal.open("slumber", {
                  win = {
                    position = "float",
                    border = "none",
                    width = 0,
                    height = 0,
                  },
                })
              end,
              desc = "Open in Slumber",
            },
          })
        end,
      },
    }
  '';
}
