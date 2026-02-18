{
  config,
  pkgs,
  inputs,
  ...
}: {
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
      termguicolors = true;
      signcolumn = "yes";
      updatetime = 300;
    };

    # All external tools for all languages
    extraPackages = with pkgs; [
      # General
      ripgrep
      fd

      # LSP servers
      lua-language-server
      nixd
      rust-analyzer
      nodePackages.typescript-language-server
      nodePackages.eslint
      python3Packages.python-lsp-server

      # Formatters
      alejandra
      rustfmt
      nodePackages.prettier
      python3Packages.black
      python3Packages.ruff
    ];

    plugins = {
      # ---------- Core UI ----------
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
            follow_current_file.enabled = true;
            filtered_items = {
              visible = true;
              hide_dotfiles = false;
            };
          };
        };
      };

      web-devicons.enable = true;
      gitsigns.enable = true;
      lualine.enable = true;
      which-key.enable = true;
      indent-blankline.enable = true;
      flash.enable = true;
      comment.enable = true;
      vim-surround.enable = true;

      # ---------- LSP ----------
      lsp = {
        enable = true;
        servers = {
          # Nix
          nixd.enable = true;

          # Rust
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };

          # TS/JS
          ts_ls.enable = true;

          # Python
          pylsp.enable = true;

          # Lua (optional, for Neovim config)
          lua_ls.enable = true;
        };
      };

      # ---------- Treesitter ----------
      treesitter = {
        enable = true;
        nixGrammars = true;
      };

      # ---------- Completion ----------
      cmp = {
        enable = true;
        autoEnableSources = true;
      };

      # ---------- Formatting ----------
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            javascript = ["prettier"];
            typescript = ["prettier"];
            rust = ["rustfmt"];
            nix = ["alejandra"];
            python = ["black"];
          };
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
        };
      };

      # ---------- Linting ----------
      lint = {
        enable = true;
        lintersByFt = {
          javascript = ["eslint"];
          typescript = ["eslint"];
          python = ["ruff"];
        };
      };

      # ---------- Copilot ----------
      /*
        copilot-lua = {
        enable = true;
        settings = {
          suggestion = {
            enabled = true;
            auto_trigger = false;
            debounce = 75;
            keymap = {
              accept  = "<C-y>";
              next    = "<M-]>";
              prev    = "<M-[>";
              dismiss = "<C-e>";
            };
          };
          panel = { enabled = false; };
          filetypes = {
            markdown   = false;
            text       = false;
            gitcommit  = false;
            gitrebase  = false;
            yaml       = false;
          };
        };
      };

      copilot-chat = {
        enable = true;
        settings = {
          window = {
            layout = "vertical";
            width = 0.3;
          };

          prompts = {
            Explain = {
              prompt = "/COPILOT_EXPLAIN Explain this code in 3-4 sentences. Focus on key concepts only.";
            };
            Review = {
              prompt = "Review this code for issues. List problems but do NOT provide fixed code.";
            };
            Fix = {
              prompt = "Identify the bug and suggest a fix approach. Provide only the minimal changed lines, not the full code.";
            };
            Optimize = {
              prompt = "Suggest optimization approaches. Explain the strategy, don't rewrite everything.";
            };
            Docs = {
              prompt = "Add concise documentation comments. Follow language conventions.";
            };
            Tests = {
              prompt = "Suggest test cases to write. List scenarios, not full test code.";
            };
            Approach = {
              prompt = "Describe the algorithm or approach to solve this in pseudocode or plain English. Do not write actual code.";
            };
            Implement = {
              prompt = "Write the complete, production-ready implementation.";
            };
          };

          question_header = "## User ";
          answer_header   = "## Copilot ";
          error_header    = "## Error ";

          auto_follow_cursor = false;
          show_help          = false;
          auto_insert_mode   = false;
        };
      };
      */
    };

    keymaps = [
      # Explorer
      {
        mode = "n";
        key = "<C-n>";
        action = ":Neotree toggle<CR>";
        options.desc = "Toggle Explorer";
      }

      # Copilot Chat
      /*
        {
        mode = "n";
        key = "<leader>aa";
        action = ":CopilotChatToggle<CR>";
        options.desc = "Toggle Copilot Chat";
      }
      {
        mode = "v";
        key = "<leader>aa";
        action = ":CopilotChatToggle<CR>";
        options.desc = "Toggle Copilot Chat";
      }
      {
        mode = "n";
        key = "<leader>ar";
        action = ":CopilotChatReset<CR>";
        options.desc = "Reset Chat";
      }
      {
        mode = "n";
        key = "<leader>at";
        action = ":CopilotChatToggle<CR>";
        options.desc = "Toggle Chat";
      }

      {
        mode = "n";
        key = "<leader>ae";
        action = ":CopilotChatExplain<CR>";
        options.desc = "Explain Code";
      }
      {
        mode = "v";
        key = "<leader>ae";
        action = ":CopilotChatExplain<CR>";
        options.desc = "Explain Code";
      }
      {
        mode = "n";
        key = "<leader>ap";
        action = ":CopilotChatApproach<CR>";
        options.desc = "Get Approach";
      }
      {
        mode = "v";
        key = "<leader>ap";
        action = ":CopilotChatApproach<CR>";
        options.desc = "Get Approach";
      }

      {
        mode = "n";
        key = "<leader>ai";
        action = ":CopilotChatImplement<CR>";
        options.desc = "Implement (Full Code)";
      }
      {
        mode = "v";
        key = "<leader>ai";
        action = ":CopilotChatImplement<CR>";
        options.desc = "Implement (Full Code)";
      }

      {
        mode = "n";
        key = "<leader>uc";
        action = ":ToggleCopilot<CR>";
        options.desc = "Toggle Copilot Autocomplete";
      }
      */

      # Window nav
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
      }

      # Save/quit
      {
        mode = "n";
        key = "<leader>w";
        action = ":w<CR>";
        options.desc = "Save";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = ":q<CR>";
        options.desc = "Quit";
      }
    ];

    colorschemes.catppuccin.enable = true;

    extraConfigLua = ''
      -- Minimalist diagnostic icons
      local signs = { Error = "", Warn = "", Hint = "󰛩", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        severity_sort = true,
        float = {
          source = "always",
          border = "rounded",
          header = "",
          prefix = "",
        },
      })

      -- Diagnostic keymaps
      vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { desc = "Show diagnostic" })
      vim.keymap.set('n', '<leader>d[', vim.diagnostic.goto_prev,  { desc = "Prev diagnostic" })
      vim.keymap.set('n', '<leader>d]', vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
      vim.keymap.set('n', '<leader>dd', "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })

      -- Toggle Copilot Autocomplete
      vim.api.nvim_create_user_command('ToggleCopilot', function()
        local ok, copilot_suggestion = pcall(require, "copilot.suggestion")
        if not ok then
          print("Copilot plugin not available")
          return
        end

        if copilot_suggestion.is_visible() then
          copilot_suggestion.dismiss()
        end

        local current = vim.g.copilot_auto_trigger
        if current == nil then current = false end

        vim.g.copilot_auto_trigger = not current

        if vim.g.copilot_auto_trigger then
          vim.fn['copilot#Suggest']()
          print("Copilot autocomplete: ENABLED")
        else
          print("Copilot autocomplete: DISABLED (use <M-]> to trigger manually)")
        end
      end, {})
    '';
  };
}
