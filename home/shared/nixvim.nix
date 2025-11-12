{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      clipboard = "unnamedplus";
    };

    plugins = {
      # File navigation
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          window = {
            width = 30;
            position = "left";
            mappings = {
              "<space>" = "none";
            };
          };
          filesystem = {
            follow_current_file = {
              enabled = true;
            };
            filtered_items = {
              visible = true;
              hide_dotfiles = false;
            };
          };
        };
      };

      web-devicons.enable = true;

      # LSP
      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          nixd.enable = true;
        };
      };

      # Treesitter
      treesitter = {
        enable = true;
        nixGrammars = true;
      };

      # Completion
      cmp = {
        enable = true;
        autoEnableSources = true;
      };

      # Git integration
      gitsigns.enable = true;

      # UI improvements
      lualine.enable = true;
      which-key.enable = true;
      indent-blankline.enable = true;

      # Navigation
      flash.enable = true;

      # Formatting
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            javascript = ["prettier"];
            typescript = ["prettier"];
            rust = ["rustfmt"];
            nix = ["alejandra"];
          };
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
        };
      };

      # Linting
      lint = {
        enable = true;
        lintersByFt = {
          javascript = ["eslint"];
          typescript = ["eslint"];
        };
      };

      # Utilities
      comment.enable = true;
      vim-surround.enable = true;
    };

    keymaps = [
      # Neo-tree
      { mode = "n"; key = "<C-n>"; action = ":Neotree toggle<CR>"; options.desc = "Toggle Explorer"; }

      # Gen.nvim AI
      { mode = "n"; key = "<leader>ai"; action = ":Gen<CR>"; options.desc = "AI Sidebar"; }
      { mode = "v"; key = "<leader>ai"; action = ":Gen<CR>"; options.desc = "AI Generate"; }
      { mode = "n"; key = "<leader>ag"; action = ":Gen<CR>"; options.desc = "AI Prompt"; }
      
      # Window navigation
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; }
      
      # Save and quit
      { mode = "n"; key = "<leader>w"; action = ":w<CR>"; options.desc = "Save"; }
      { mode = "n"; key = "<leader>q"; action = ":q<CR>"; options.desc = "Quit"; }
    ];

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "gen.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "David-Kunz";
          repo = "gen.nvim";
          rev = "main";
          sha256 = "sha256-s12r8dvva0O2VvEPjOQvpjVpEehxsa4AWoGHXFYxQlI=";
        };
      })
    ];

    extraConfigLua = ''
      require('gen').setup({
        model = "qwen3:4b",
        host = "localhost",
        port = "11434",
        display_mode = "float",
        show_model = true,
      })
    '';

    colorschemes.catppuccin.enable = true;
  };
}

