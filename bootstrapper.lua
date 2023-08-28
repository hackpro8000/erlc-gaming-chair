local core
local interface

function src(str)
	return "https://raw.githubusercontent.com/hackpro8000/erlc-gaming-chair/main/"..str
end

local success, err = pcall(function()
	local bypass = loadstring(game:HttpGet(src "bypass.lua"))()
	core = loadstring(game:HttpGet(src "core.lua"))()
	interface = loadstring(game:HttpGet(src "interface.lua"))()

	bypass()
end)

if success then
	core.start()
	interface.start()
else
	rconsoleprint(err.."\n")
end