-- Anti-Debug Injection Code
local antiDebugCode = [[
-- Luraph-style Anti-Debug
(function()
    local function check()
        if debug then
            local h = debug.gethook()
            if h then 
                while true do end 
            end
        end
        if os and os.clock then
            local t = os.clock()
            for i = 1, 50 do end
            if os.clock() - t > 0.005 then
                error("Debugger detected")
            end
        end
    end
    if math.random() < 0.1 then check() end
end)()
]]
