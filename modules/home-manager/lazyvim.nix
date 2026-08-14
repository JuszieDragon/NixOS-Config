{ inputs, pkgs, ... }: {
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;

    extras.lang = {
      nix.enable = true;
      python = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
      rust = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
      typescript = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };
    extraPackages = with pkgs; [
      fd
      fzf
      gcc
      nixd
      ripgrep
      pkg-config
      openssl
    ];
    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      caddy
      vrl
    ];
    config = {
      options = /*lua*/ ''
        vim.opt.relativenumber = false

        -- Fix terminal errors when in a nix develop shell
        vim.opt.shell = "zsh"
        vim.opt.shellcmdflag = "-l -i -c"

        -- Force Neovim to use the system clipboard for yanks and deletes
        vim.opt.clipboard = "unnamedplus"

        -- Configure the built-in OSC 52 clipboard provider
        vim.g.clipboard = {
          name = 'OSC 52',
          copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy,
            ['*'] = require('vim.ui.clipboard.osc52').copy,
          },
          paste = {
            ['+'] = require('vim.ui.clipboard.osc52').paste,
            ['*'] = require('vim.ui.clipboard.osc52').paste,
          },
        }
      '';

      keymaps = /*lua*/ ''
        vim.keymap.set('n', '<leader>th', ':split | terminal<CR>', { desc = 'Terminal split horizontal' })
        vim.keymap.set('n', '<leader>tv', ':vsplit | terminal<CR>', { desc = 'Terminal split vertical' })
      '';

      autocmds = /*lua*/ ''
      -- Automatically enter insert mode when opening a new terminal
        local term_group = vim.api.nvim_create_augroup("TerminalSettings", { clear = true })

        vim.api.nvim_create_autocmd("TermOpen", {
          group = term_group,
          pattern = "*",
          command = "startinsert",
        })
      '';
    };
    plugins = {
      colorscheme = /*lua*/ ''
        return {
          { "ellisonleao/gruvbox.nvim" },
          {
            "LazyVim/LazyVim",
            opts = {
              colorscheme = "gruvbox",
            },
          }
        }
      '';
    };
  };
}
