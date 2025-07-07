-- plugins/rust.lua
return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    dependencies = {
      "simrat39/rust-tools.nvim",
    },
    ---@type RustaceanvimPluginOpts
    opts = {
      server = {
        on_attach = function(client, bufnr)
          local key = vim.keymap.set

          key('n', '<leader>ca', function()
            vim.cmd.RustLsp('codeAction')
          end, { desc = 'Code Action', buffer = bufnr })
          key('n', '<leader>dr', function()
            vim.cmd.RustLsp('debuggables')
          end, { desc = 'Rust debuggables', buffer = bufnr })
        end,
        settings = {
          ["rust-analyzer"] = {
            assist = {
              emitMustUse = false,
              expressionFillDefault = "todo",
              preferSelf = false,
              termSearch = {
                borrowcheck = true,
                fuel = 1800,
              },
            },
            cachePriming = {
              enable = true,
              numThreads = "physical",
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
              allTargets = true,
              autoreload = true,
              buildScripts = {
                enable = true,
                invocationStrategy = "per_workspace",
                overrideCommand = nil,
                rebuildOnSave = true,
                useRustcWrapper = true,
              },
              cfgs = { "debug_assertions", "miri" },
--              extraArgs = {},
--              extraEnv = {},
--              features = {},
              noDefaultFeatures = false,
              noDeps = false,
              sysroot = "discover",
              sysrootSrc = nil,
              target = nil,
              targetDir = nil,
            },
            check = {
              allTargets = nil, -- Defaults to rust-analyzer.cargo.allTargets
              command = "check",
--              extraArgs = {},
--              extraEnv = {},
              features = nil, -- Defaults to rust-analyzer.cargo.features
--              ignore = {},
              invocationStrategy = "per_workspace",
              noDefaultFeatures = nil, -- Defaults to rust-analyzer.cargo.noDefaultFeatures
              overrideCommand = nil,
              targets = nil, -- Defaults to rust-analyzer.cargo.target
              workspace = true,
            },
            checkOnSave = true,
            completion = {
              addSemicolonToUnit = true,
              autoAwait = {
                enable = true,
              },
              autoIter = {
                enable = true,
              },
              autoimport = {
                enable = true,
                exclude = {
                  { path = "core::borrow::Borrow", type = "methods" },
                  { path = "core::borrow::BorrowMut", type = "methods" },
                },
              },
              autoself = {
                enable = true,
              },
              callable = {
                snippets = "fill_arguments",
              },
--              excludeTraits = {},
              fullFunctionSignatures = {
                enable = false,
              },
              hideDeprecated = false,
              limit = nil,
              postfix = {
                enable = true,
              },
              privateEditable = {
                enable = false,
              },
              snippets = {
                custom = {
                  ["Ok"] = {
                    postfix = "ok",
                    body = "Ok(${receiver})",
                    description = "Wrap the expression in a `Result::Ok`",
                    scope = "expr",
                  },
                  ["Box::pin"] = {
                    postfix = "pinbox",
                    body = "Box::pin(${receiver})",
                    requires = "std::boxed::Box",
                    description = "Put the expression into a pinned `Box`",
                    scope = "expr",
                  },
                  ["Arc::new"] = {
                    postfix = "arc",
                    body = "Arc::new(${receiver})",
                    requires = "std::sync::Arc",
                    description = "Put the expression into an `Arc`",
                    scope = "expr",
                  },
                  ["Some"] = {
                    postfix = "some",
                    body = "Some(${receiver})",
                    description = "Wrap the expression in an `Option::Some`",
                    scope = "expr",
                  },
                  ["Err"] = {
                    postfix = "err",
                    body = "Err(${receiver})",
                    description = "Wrap the expression in a `Result::Err`",
                    scope = "expr",
                  },
                  ["Rc::new"] = {
                    postfix = "rc",
                    body = "Rc::new(${receiver})",
                    requires = "std::rc::Rc",
                    description = "Put the expression into an `Rc`",
                    scope = "expr",
                  },
                },
              },
              termSearch = {
                enable = false,
                fuel = 1000,
              },
            },
            diagnostics = {
--              disabled = {},
              enable = true,
              experimental = {
                enable = false,
              },
--              remapPrefix = {},
              styleLints = {
                enable = false,
              },
--              warningsAsHint = {},
--              warningsAsInfo = {},
            },
            files = {
--              exclude = {},
              watcher = "client",
            },
            highlightRelated = {
              branchExitPoints = {
                enable = true,
              },
              breakPoints = {
                enable = true,
              },
              closureCaptures = {
                enable = true,
              },
              exitPoints = {
                enable = true,
              },
              references = {
                enable = true,
              },
              yieldPoints = {
                enable = true,
              },
            },
            hover = {
              actions = {
                debug = {
                  enable = true,
                },
                enable = true,
                gotoTypeDef = {
                  enable = true,
                },
                implementations = {
                  enable = true,
                },
                references = {
                  enable = false,
                },
                run = {
                  enable = true,
                },
                updateTest = {
                  enable = true,
                },
              },
              documentation = {
                enable = true,
                keywords = {
                  enable = true,
                },
              },
              dropGlue = {
                enable = true,
              },
              links = {
                enable = true,
              },
              maxSubstitutionLength = 20,
              memoryLayout = {
                alignment = "hexadecimal",
                enable = true,
                niches = false,
                offset = "hexadecimal",
                padding = nil,
                size = "both",
              },
              show = {
                enumVariants = 5,
                fields = 5,
                traitAssocItems = nil,
              },
            },
            imports = {
              granularity = {
                enforce = false,
                group = "crate",
              },
              group = {
                enable = true,
              },
              merge = {
                glob = true,
              },
              preferNoStd = false,
              preferPrelude = false,
              prefix = "crate",
              prefixExternPrelude = false,
            },
--            inlayHints = {
--              bindingModeHints = {
--                enable = false,
--              },
--              chainingHints = {
--                enable = true,
--              },
--              closingBraceHints = {
--                enable = true,
--                minLines = 25,
--              },
--              closureCaptureHints = {
--                enable = false,
--              },
--              closureReturnTypeHints = {
--                enable = 'never',
--              },
--              closureStyle = "impl_fn",
--              discriminantHints = {
--                enable = "never",
--              },
--              expressionAdjustmentHints = {
--                enable = "never",
--                hideOutsideUnsafe = false,
--                mode = "prefix",
--              },
--              genericParameterHints = {
--                ["const"] = {
--                  enable = true,
--                },
--                lifetime = {
--                  enable = false,
--                },
--                type = {
--                  enable = false,
--                },
--              },
--              implicitDrops = {
--                enable = false,
--              },
--              implicitSizedBoundHints = {
--                enable = false,
--              },
--              lifetimeElisionHints = {
--                enable = 'never',
--                useParameterNames = false,
--              },
--              maxLength = 25,
--              parameterHints = {
--                enable = true,
--              },
--              rangeExclusiveHints = {
--                enable = false,
--              },
--              reborrowHints = {
--                enable = 'never',
--              },
--              renderColons = true,
--              typeHints = {
--                enable = true,
--                hideClosureInitialization = false,
--                hideClosureParameter = false,
--                hideNamedConstructor = false,
--              },
--            },
            interpret = {
              tests = false,
            },
            joinLines = {
              joinAssignments = true,
              joinElseIf = true,
              removeTrailingComma = true,
              unwrapTrivialBlock = true,
            },
            lens = {
              debug = {
                enable = true,
              },
              enable = true,
              implementations = {
                enable = true,
              },
              location = "above_name",
              references = {
                adt = {
                  enable = false,
                },
                enumVariant = {
                  enable = false,
                },
                method = {
                  enable = false,
                },
                trait = {
                  enable = false,
                },
              },
              run = {
                enable = true,
              },
              updateTest = {
                enable = true,
              },
            },
--            linkedProjects = {},
            lru = {
              capacity = nil, -- Defaults to 128
              query = {
--                capacities = {},
              },
            },
            notifications = {
              cargoTomlNotFound = true,
            },
            numThreads = nil,
            procMacro = {
              attributes = {
                enable = true,
              },
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
              server = nil,
            },
            references = {
              excludeImports = false,
              excludeTests = false,
            },
            runnables = {
              command = nil,
--              extraArgs = {},
              extraTestBinaryArgs = { "--show-output" },
            },
            rustc = {
              source = nil,
            },
            rustfmt = {
--              extraArgs = {},
              overrideCommand = nil,
              rangeFormatting = {
                enable = false,
              },
            },
            semanticHighlighting = {
              doc = {
                comment = {
                  inject = {
                    enable = true,
                  },
                },
              },
              nonStandardTokens = true,
              operator = {
                enable = true,
                specialization = {
                  enable = false,
                },
              },
              punctuation = {
                enable = false,
                separate = {
                  macro = {
                    bang = false,
                  },
                },
                specialization = {
                  enable = false,
                },
              },
              strings = {
                enable = true,
              },
            },
            signatureInfo = {
              detail = "full",
              documentation = {
                enable = true,
              },
            },
            typing = {
              triggerChars = "=.",
            },
            vfs = {
--              extraIncludes = {},
            },
            workspace = {
              discoverConfig = nil,
              symbol = {
                search = {
                  excludeImports = false,
                  kind = "only_types",
                  limit = 128,
                  scope = "workspace",
                },
              },
            },
          }
        },
--        tools = { -- rust-tools options
--          autoSetHints = false,
--          inlay_hints = {
--            show_parameter_hints = true,
--            parameter_hints_prefix = "<- ",
--            right_padding_at_cursor = true,
--          },
--        },
      },
    },
 
    config = function(_, opts)
      vim.g.rustaceanvim = opts
    end,
  },
  {
    "saecki/crates.nvim",
    ft = {
      "rust",
      "toml"
    },
    opts = {},
  }
}

