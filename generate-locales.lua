#!/usr/bin/env lua
-- Locale Generation Script for Resource Biters
-- Run this script to generate locale files for all supported languages
-- Usage: lua generate-locales.lua

-- Load the biter data to get resource_list
package.path = package.path .. ";./prototypes/?.lua"

-- We need to mock some Factorio globals
data = { extend = function() end }
settings = { startup = {} }

-- Load biter-data which defines resource_list
dofile("prototypes/biter-data.lua")

-- Load the locale generator
local locale_generator = dofile("locale-generator.lua")

-- Create directory if it doesn't exist (platform-agnostic)
local function ensure_directory(path)
    -- Try mkdir for both Windows and Unix
    os.execute('mkdir "' .. path .. '" 2>nul')
    os.execute('mkdir -p "' .. path .. '" 2>/dev/null')
end

-- Write content to file
local function write_file(path, content)
    local file = io.open(path, "w")
    if file then
        file:write(content)
        file:close()
        return true
    end
    return false
end

-- Main generation function
local function generate_all_locales()
    local languages = locale_generator.get_supported_languages()

    print("Generating locale files for Resource Biters...")
    print("Found " .. (function()
        local count = 0
        for _ in pairs(resource_list) do count = count + 1 end
        return count
    end)() .. " resources in resource_list")
    print("")

    for _, lang in ipairs(languages) do
        local locale_dir = "locale/" .. lang
        local locale_file = locale_dir .. "/resource-biters.cfg"

        -- Ensure the directory exists
        ensure_directory(locale_dir)

        -- Generate the content
        local content = locale_generator.generate_locale_content(lang, resource_list)

        -- Write the file
        if write_file(locale_file, content) then
            print("Generated: " .. locale_file)
        else
            print("ERROR: Failed to write " .. locale_file)
        end
    end

    print("")
    print("Locale generation complete!")
end

-- Run the generator
generate_all_locales()
