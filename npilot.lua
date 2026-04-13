local out = vim.fn.system({ "echo", "hello" })
print(out)

function Main()
	local buffer = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local text = table.concat(buffer, "\n")

	-- print(text)
end

Main()
