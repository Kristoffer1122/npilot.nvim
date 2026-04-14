local Popup = require("plenary.popup")
local Chat = require("CopilotChat")
local Select = require("CopilotChat.select")

local Ok, Chat = pcall(require, "CopilotChat")
if not Ok then
	vim.notify("npilot: CopilotChat.nvim is required. Install CopilotC-Nvim/CopilotChat.nvim", vim.log.levels.ERROR)
	return
end

local function GetVisualSelection()
	local Start = vim.fn.getpos("'<")
	local End = vim.fn.getpos("'>")
	local Lines = vim.api.nvim_buf_get_lines(0, Start[2] - 1, End[2], false)
	return Lines, Start[2] - 1, End[2]
end

local function Npilot()
	local OrigBufnr = vim.api.nvim_get_current_buf()
	local Lines, StartLine, EndLine = GetVisualSelection()
	local Code = table.concat(Lines, "\n")

	local Width = math.floor(vim.o.columns / 2)
	local Height = math.floor(vim.o.lines / 2)
	local Borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
	local PopupBufnr = vim.api.nvim_create_buf(false, true)
	local WinId, Win = Popup.create(PopupBufnr, {
		title = "npilot",
		highlight = "npilotPopup",
		line = math.floor(((vim.o.lines - Height) / 2) - 1),
		col = math.floor((vim.o.columns - Width) / 2),
		minwidth = Width,
		minheight = Height,
		borderchars = Borderchars,
	})

	vim.api.nvim_buf_set_lines(PopupBufnr, 0, -1, false, { "Waiting for Copilot..." })

	local Filetype = vim.bo[OrigBufnr].filetype
	Chat.ask("Improve this code. Return only the improved code, no explanation.", {
		selection = function()
			return {
				content = Code,
				filetype = Filetype,
				start_row = StartLine + 1,
				end_row = EndLine,
			}
		end,
		headless = true,
		callback = function(Response)
			vim.schedule(function()
				local ResponseText = type(Response) == "table" and Response.content or Response
				local ResponseLines = vim.split(ResponseText, "\n")

				-- Strip markdown code fences if present
				if ResponseLines[1] and ResponseLines[1]:match("^```") then
					table.remove(ResponseLines, 1)
				end
				if ResponseLines[#ResponseLines] and ResponseLines[#ResponseLines]:match("^```") then
					table.remove(ResponseLines, #ResponseLines)
				end

				vim.api.nvim_buf_set_lines(PopupBufnr, 0, -1, false, ResponseLines)

				-- y to accept, n/q to discard
				vim.api.nvim_buf_set_keymap(PopupBufnr, "n", "y", "", {
					noremap = true,
					silent = true,
					callback = function()
						vim.api.nvim_buf_set_lines(OrigBufnr, StartLine, EndLine, false, ResponseLines)
						vim.api.nvim_win_close(WinId, true)
					end,
				})

				vim.api.nvim_buf_set_keymap(PopupBufnr, "n", "n", "", {
					noremap = true,
					silent = true,
					callback = function()
						vim.api.nvim_win_close(WinId, true)
					end,
				})
			end)
		end,
	})

	vim.api.nvim_buf_set_keymap(PopupBufnr, "n", "q", "", {
		noremap = true,
		silent = true,
		callback = function()
			vim.api.nvim_win_close(WinId, true)
		end,
	})
end

vim.keymap.set("v", "<leader>np", Npilot, { noremap = true, silent = true })
