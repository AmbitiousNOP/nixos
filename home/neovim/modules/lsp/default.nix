{
  pkgs,
  config,
  lib,
  ...
}:

let
  lspServers = with pkgs; [
    lua-language-server
    vim-language-server
    nixd
    #nil
  ];
in
{

  home.packages = lspServers ++ [
    pkgs.stylua
    pkgs.nixfmt-rfc-style
  ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      cmp_luasnip
      luasnip
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
    ];

    extraLuaConfig = lib.mkAfter ''
                                    		require('fidget').setup{}

                                    		vim.api.nvim_create_autocmd('LspAttach', {
                                    		  group = vim.api.nvim_create_augroup('lsp-attach', {clear = true}),
                                    		  callback = function(event)
                                    			local map = function(keys, func, desc, mode)
                                    			  mode = mode or 'n'
                                    			  vim.keymap.set(mode,keys,func, { buffer = event.buf, desc = 'LSP' .. desc})
                                    			end
                                    			-- Rename the variable under your cursor.
                                    			--  Most Language Servers support renaming across files, etc.
                                    			map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

                                    			-- Execute a code action, usually your cursor needs to be on top of an error
                                    			-- or a suggestion from your LSP for this to activate.
                                    			map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

                                    			-- Find references for the word under your cursor.
                                    			map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                                    			-- Jump to the implementation of the word under your cursor.
                                    			--  Useful when your language has ways of declaring types without an actual implementation.
                                    			map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                                    			-- Jump to the definition of the word under your cursor.
                                    			--  This is where a variable was first declared, or where a function is defined, etc.
                                    			--  To jump back, press <C-t>.
                                    			map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                                    			-- WARN: This is not Goto Definition, this is Goto Declaration.
                                    			--  For example, in C this would take you to the header.
                                    			map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                                    			-- Fuzzy find all the symbols in your current document.
                                    			--  Symbols are things like variables, functions, types, etc.
                                    			map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

                                    			-- Fuzzy find all the symbols in your current workspace.
                                    			--  Similar to document symbols, except searches over your entire project.
                                    			map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

                                    			-- Jump to the type of the word under your cursor.
                                    			--  Useful when you're not sure what type a variable is and you want to see
                                    			--  the definition of its *type*, not where it was *defined*.
                                    			map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

                                    			local function client_supports_method(client,method, bufnr)
                                    			  if vim.fn.has 'nvim-0.11' == 1 then
                                    			return client:supports_method(method, bufnr)
                                    			  else
                                    			return client.supports_method(method, {bufnr = bufnr})
                                    			  end
                                    			end

                                    			-- The following two autocommands are used to highlight references of the
                                    			-- word under your cursor when your cursor rests there for a little while.
                                    			--    See `:help CursorHold` for information about when this is executed
                                    			--
                                    			-- When you move your cursor, the highlights will be cleared (the second autocommand).
                                    			local client = vim.lsp.get_client_by_id(event.data.client_id)
                                    			if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                                    			  local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
                                    			  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                                    			buffer = event.buf,
                                    			group = highlight_augroup,
                                    			callback = vim.lsp.buf.document_highlight,
                                    			  })

                                    			  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                                    			buffer = event.buf,
                                    			group = highlight_augroup,
                                    			callback = vim.lsp.buf.clear_references,
                                    			  })

                                    			  vim.api.nvim_create_autocmd('LspDetach', {
                                    			group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                                    			callback = function(event2)
                                    			  vim.lsp.buf.clear_references()
                                    			  vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
                                    			end,
                                    			  })
                                    			end

                                    			-- The following code creates a keymap to toggle inlay hints in your
                                    			-- code, if the language server you are using supports them
                                    			--
                                    			-- This may be unwanted, since they displace some of your code
                                    			if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                                    			  map('<leader>th', function()
                                    			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                                    			  end, '[T]oggle Inlay [H]ints')
                                    			end

                                    			-- The following code enalbes auto-formating on save 
                                    			if not client_supports_method(client, vim.lsp.protocol.Methods.textDocument_willSaveWaitUntil, event.buf) and client_supports_method(client,vim.lsp.protocol.Methods.textDocument_formatting, event.buf) then
                                    			  vim.api.nvim_create_autocmd('BufWritePre', {
                                    			group = vim.api.nvim_create_augroup('lsp-fmt', {clear = false}),
                                    			buffer = event.buf,
                                    			callback = function()
                                    			  vim.lsp.buf.format({bufnr = event.buf, id = client.id, timeout_ms = 1000})
                                    			end,
                                    			  })
                                    			end
                                    		  end,
                                    		})

                                    		vim.diagnostic.config {
                                    		  severity_sort = true,
                                    		  float = { border = 'rounded', source = 'if_many'},
                                    		  underline = { severity = vim.diagnostic.severity.ERROR},
                                    		  signs = vim.g.have_nerd_font and {
                                    			text = {
                                    			  [vim.diagnostic.severity.ERROR] = '󰅚 ',
                                    			  [vim.diagnostic.severity.WARN] = '󰀪 ',
                                    			  [vim.diagnostic.severity.INFO] = '󰋽 ',
                                    			  [vim.diagnostic.severity.HINT] = '󰌶 ',
                                    			},
                                    		  }
                                    		}

                                    		local cmp = require('cmp')
                                    		cmp.setup({
                                    		  snippet = {
                                    			expand = function(args)
                                    			  require('luasnip').lsp_expand(args.body)
                                    			end,
                                    		  },
                                    		  window = {
                                    			completion = cmp.config.window.bordered(),
                                    			documentation = cmp.config.window.bordered(),
                                    		  },
                                    		  mapping = cmp.mapping.preset.insert({
                                    			['<C-b>'] = cmp.mapping.scroll_docs(-4),
                                    			['<C-f>'] = cmp.mapping.scroll_docs(4),
                                    			['<C-Space>'] = cmp.mapping.complete(),
                                    			['<C-e>'] = cmp.mapping.abort(),
                                    			['<CR>'] = cmp.mapping.confirm({select = true}),
                                    		  }),

                                    		  sources = cmp.config.sources({
                                    			{name = 'nvim_lsp'},
                                    			{name = 'luasnip'},
                                    			{name = 'buffer'},
                                    			{name = 'path'},
                                    		  })
                                    		})

                                    		local capabilities = require('cmp_nvim_lsp').default_capabilities()
                                    		local servers = {
                                    		  lua_ls = {
                                    			cmd = {'lua-language-server'},
                                    			settings = {
                                    			  Lua = {
                                    			completion = {
                                    			  callSnippet = 'Replace',
                                    			},
                                    			  },
                                    			},
                                    		  },
                                    		  nix = {
                                    			cmd = {'nixd'},
                                    			filetypes = {'nix'},
                                    			root_markers = {'.git', 'flake.nix'},
                                    			settings = {
                                    			  nixd = {
                                    			nixpkgs = {
                                    			  expr = "import <nixpkgs> { }",
                                    			},
                                    			formatting = {
                                    			  command = { "nixfmt" },
                                    			},
                                    			options = {
                                    			  nixos = {
                                    				expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.laptop.options",
                                    			  },
                                    			  home_manager = {
                                    				expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.laptop.options.home-manager.users.type.getSubOptions []",
                                    			  },
                                    			},
                                    			  }
                                    			},
                                    		  },
                                    		  vimls = {
                                    			cmd = {'vim-language-server'},
                                    		  },
                                    		  gopls = {
                              			  	cmd = {'gopls'},
                                    			filetypes = {'go'},
                                    			root_markers = {'go.work', 'go.mod', '.git'},
                              				settings = {
                              					analyses = {
                              						unusedparams = true,
                              					},
                              					staticcheck = true,
                              					gofumpt = true,
                              				},
                                    		  },
                                    		  helm_ls={
            								  	settings = {
            										yamlls = {
            											path = 'yaml-language-server',
            										},
            									},
            								  },
                  						  yamlls={
      									  	cmd = {'yaml-language-server', '--stdio'},
      									  },
                                    		  pylsp = {},
                                    		}

                                    		local function lsp_cmd_exists(cmd)
                                    		  return vim.fn.executable(cmd) == 1
                                    		end

                                    		for server_name, server_opts in pairs(servers) do 
                                    		  local cmd = (server_opts and server_opts.cmd and server_opts.cmd[1]) or server_name
                                    		  vim.lsp.config[server_name] = server_opts
                                    		  if lsp_cmd_exists(cmd) then 
                                    			vim.lsp.enable(server_name)
                                    		  end 
                                    		end 
    '';
  };

}
