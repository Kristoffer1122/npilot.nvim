local Ok, Chat = pcall(require, "CopilotChat")
if not Ok then
	vim.notify("npilot: CopilotChat.nvim is required. Install CopilotC-Nvim/CopilotChat.nvim", vim.log.levels.ERROR)
	return {}
end

local Config = {
	model = "gpt-4.1",
}

local function Npilot()
	local OrigBufnr = vim.api.nvim_get_current_buf()
	local Start = vim.fn.getpos("'<")
	local End = vim.fn.getpos("'>")
	local Lines = vim.api.nvim_buf_get_lines(OrigBufnr, Start[2] - 1, End[2], false)
	local StartLine = Start[2] - 1
	local EndLine = End[2]
	local Code = table.concat(Lines, "\n")

	if Code == "" then
		vim.notify("No code selected")
		return
	end

	local Width = math.floor(vim.o.columns / 2)
	local Height = math.floor(vim.o.lines / 2)
	local PopupBufnr = vim.api.nvim_create_buf(false, true)
	local WinId = vim.api.nvim_open_win(PopupBufnr, true, {
		relative = "editor",
		row = math.floor((vim.o.lines - Height) / 2),
		col = math.floor((vim.o.columns - Width) / 2),
		width = Width,
		height = Height,
		style = "minimal",
		border = "rounded",
		title = " npilot ",
		title_pos = "center",
	})

	vim.api.nvim_buf_set_lines(PopupBufnr, 0, -1, false, { "Waiting for Copilot..." })

	local Prompt = "Improve this code. Return only the improved code, no explanation.\n\n```\n" .. Code .. "\n```"

	Chat.ask(Prompt, {
		headless = true,
		model = Config.model,
		callback = function(Response)
			vim.schedule(function()
				local ResponseText = Response.content or ""
				local ResponseLines = vim.split(ResponseText, "\n")

				if ResponseLines[1] and ResponseLines[1]:match("^```") then
					table.remove(ResponseLines, 1)
				end
				if ResponseLines[#ResponseLines] and ResponseLines[#ResponseLines]:match("^```") then
					table.remove(ResponseLines, #ResponseLines)
				end

				vim.api.nvim_buf_set_lines(PopupBufnr, 0, -1, false, ResponseLines)
				vim.api.nvim_win_set_config(WinId, { title = " npilot [y/N] " })

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

local function Setup(Opts)
	Config = vim.tbl_extend("force", Config, Opts or {})
end

vim.keymap.set("v", "<leader>np", "<Esc><cmd>lua require('npilot').run()<CR>", { noremap = true, silent = true })

return { run = Npilot, setup = Setup }
