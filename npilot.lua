Diff = vim.fn.system({ "git", "diff" })
File = vim.api.nvim_buf_get_name(0)
print(File)

Start_diff = nil

print("\n")

for line in Diff:gmatch("[^\n]+") do
	-- find start of diff.
	if line:find("[@@]") then
		Start_diff = (debug.getinfo(1).currentline + 1)
		print("DIFF:", Start_diff)
	end
	print(line)
end
