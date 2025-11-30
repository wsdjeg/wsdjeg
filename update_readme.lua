local M = {}

M.begin = "^<!-- nvim-plugins start -->$"
M._end = "^<!-- nvim-plugins end -->$"
M.content_func = ""
M.autoformat = 0

function M._find_position()
	local start = vim.fn.search(M.begin, "bwnc")
	local _end = vim.fn.search(M._end, "bnwc")
	return unpack(vim.fn.sort({ start, _end }, "n"))
end

function M.update(...)
	local start, _end = M._find_position()
	if start ~= 0 and _end ~= 0 then
		if _end - start > 1 then
			vim.cmd((start + 1) .. "," .. (_end - 1) .. "delete")
		end
		vim.fn.append(start, M.content_func())
	end
end

local function generate_content()
	local lines = { "| name | release | luarocks | description |", "| --- | --- | --- | --- |" }
	local plugs = require("plug").get()
	local names = vim.tbl_keys(plugs)
	table.sort(names)
	for _, name in ipairs(names) do
		local v = plugs[name]
		if vim.startswith(v[1], "wsdjeg") and vim.regex('nvim'):match_str(v[1]) then
			table.insert(
				lines,
				"["
					.. v.name
					.. "](https://github.com/"
					.. v[1]
					.. ") | "
					.. "[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/"
					.. v.name
					.. ")](https://github.com/wsdjeg/"
					.. v.name
					.. "/releases)"
					.. " | "
					.. "[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/"
					.. v.name
					.. ")](https://luarocks.org/modules/wsdjeg/"
					.. v.name
					.. ")"
					.. " | "
					.. (v.desc or "")
			)
		end
	end
	return lines
end

M.content_func = generate_content

M.update()
vim.cmd("Format")
