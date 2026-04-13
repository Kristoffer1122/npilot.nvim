local Popup = require("plenary.popup")
File = vim.api.nvim_buf_get_name(0)
Diff = vim.fn.system({ "git", "diff", File })

Out = {}
InHunk = false
Count = 0

for Line in Diff:gmatch("[^\n]+") do
	Count = Count + 1
	local pad = ""
	if Count < 10 then
		pad = "  "
	elseif Count < 100 then
		pad = " "
	elseif Count < 1000 then
		pad = ""
	else
		pad = ""
	end
	if Line:find("^@@") then
		InHunk = true
	elseif InHunk then
		table.insert(Out, ("%s %d %s"):format(pad, Count, Line))
	end
end

local function create_window()
	local width = 60
	local height = 10
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
	local bufnr = vim.api.nvim_create_buf(false, false)
	local npilot, win = Popup.create(bufnr, {
		title = "npilot",
		highlight = "npilotPopup",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
	})

	-- how do we set the input of the popup to the diff output?
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, Out)

	vim.api.nvim_win_set_option(win.border.win_id, "winhl", "Normal:npilotPopupBorder")
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"q",
		"<cmd>lua vim.api.nvim_win_close(" .. win.win_id .. ", true)<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<Esc>",
		"<cmd>lua vim.api.nvim_win_close(" .. win.win_id .. ", true)<CR>",
		{ noremap = true, silent = true }
	)

	return { bufnr = bufnr, win_id = win.win_id }
end
create_window()
