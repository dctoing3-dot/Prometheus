-- Complex Lua Test File
local module = {}

-- Private variables
local counter = 0
local config = {
    name = "Prometheus",
    version = "1.0",
    enabled = true
}

-- Private function
local function privateFunc(x, y)
    return x * y + counter
end

-- Public functions
function module.init(name)
    config.name = name
    print("Module initialized: " .. name)
end

function module.calculate(a, b, c)
    counter = counter + 1
    local result = privateFunc(a, b) + c
    return result
end

-- Table operations
local data = {10, 20, 30, 40, 50}
for i, v in ipairs(data) do
    print("Index " .. i .. ": " .. v)
end

-- String manipulation
local text = "Hello from Prometheus"
print(text:upper())
print(string.reverse(text))

return module
