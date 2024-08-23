-- Creates a directory if it does not already exist.
--
-- Parameters:
--   - path: A string representing the path of the directory to be created.
--
-- Throws an error if the directory cannot be created.
local function createDirectoryIfNotExists(path)
    local command
    if package.config:sub(1, 1) == '\\' then
        -- Windows
        command = 'mkdir "' .. path .. '"'
    else
        -- Unix-based (Linux, macOS)
        command = 'mkdir -p "' .. path .. '"'
    end

    local success = os.execute(command)
    if not success then
        error("Error creating directory '" .. path .. "'.")
    end
end

-- Writes data to a file.
--
-- Parameters:
--   - path: A string representing the path of the file to be written.
--   - data: A string representing the data to be written to the file.
--
-- Throws an error if the file cannot be written.
local function writeToFile(path, data)
    local file = io.open(path, "w")
    if file then
        file:write(data)
        file:close()
    else
        error("Error writing to file: " .. path)
    end
end

-- Reads data from a file.
--
-- Parameters:
--   - path: A string representing the path of the file to be read.
--
-- Returns:
--   - A string representing the data read from the file.
--
-- Throws an error if the file cannot be read.
local function readFromFile(path)
    local file = io.open(path, "r")
    if file then
        local data = file:read("*all")
        file:close()
        return data
    else
        error("Error reading from file: " .. path)
    end
end

return {
    createDirectoryIfNotExists = createDirectoryIfNotExists,
    writeToFile = writeToFile,
    readFromFile = readFromFile,
}
