Config = {
    Map = nil,
    Items = {
        "nanskip.conv_ore_coal", "nanskip.dril"
    }
}

function Client.OnStart()
    _DEBUG = true
    _HASH = "b0e5e93"

    _LATEST_LINK = "https://raw.githubusercontent.com/Nanskip/cubzh-thewaydown/" .. _HASH .. "/"
    _LOADALL()
end

_LOAD_LIST = {
    modules = {
        worldgen = "modules/worldgen.lua",
        player = "modules/player.lua",
        swipe = "modules/swipe.lua",
        game = "game.lua",
    },
    images = {

    },
    sounds = {
        -- sounds
    },
    other = {
        -- other
    }
}

function _LOADALL()
    log("Starting up...")
    _LOAD_MODULES()
end

function _FINISH()
    log("Downloading finished.")

    game.start()
end

function _LOAD_MODULES()
    log("Need to download " .. tableLength(_LOAD_LIST.modules) .. " module files.")
    local downloaded = 0
    
    for k, v in pairs(_LOAD_LIST.modules) do    
        HTTP:Get(_LATEST_LINK .. v, function(response)
            if response.StatusCode ~= 200 then
                log("Error downloading [" .. k .. ".lua]. Code: " .. response.StatusCode, "ERROR")

                return
            end

            _ENV[k] = load(response.Body:ToString(), nil, "bt", _ENV)()
            log("Module [".. k.. ".lua] downloaded.")

            downloaded = downloaded + 1
            if downloaded == tableLength(_LOAD_LIST.modules) then
                log("Downloaded all required module files.")
                _LOAD_IMAGES()
            end
        end)
    end
end

function _INIT_MODULES()
    log("Initializing modules...")
    for k, v in pairs(_LOAD_LIST.modules) do
        if _ENV[k].INIT ~= nil then
            local initialized = _ENV[k]:INIT()
            if initialized then
                log(k, "INIT")
            else
                log("Module [" .. k .. ".lua] initialization error.", "ERROR")
            end
        else
            log("Module [" .. k .. ".lua] has no initialization function.", "WARNING")
        end
    end

    log("All modules have been initialized.")
    _FINISH()
end

function _LOAD_IMAGES()
    log("Need to download " .. tableLength(_LOAD_LIST.images) .. " image files.")
    _IMAGES = {}
    local downloaded = 0

    for k, v in pairs(_LOAD_LIST.images) do
        HTTP:Get(_LATEST_LINK .. v, function(response)
            if response.StatusCode ~= 200 then
                log("Error downloading [" .. k .. "] image. Code: " .. response.StatusCode, "ERROR")

                return
            end

            _IMAGES[k] = response.Body
            log("Image [".. k.. "] downloaded.")

            downloaded = downloaded + 1
            if downloaded == tableLength(_LOAD_LIST.images) then
                log("Downloaded all required image files.")
                _INIT_MODULES()
            end
        end)
    end
    if tableLength(_LOAD_LIST.images) == 0 then
        log("No images to download.")
        _INIT_MODULES()
    end
end

function log(text, type)
    if _LOGS == nil then _LOGS = {} end
    if type == nil then
        type = "INFO"
    end
    local timeStamp = os.date("[%H:%M:%S]")
    local log_text = timeStamp .. " " .. "EMPTY LOG."
    if type == "INFO" then
        log_text = timeStamp .. " " .. "[INFO]: " .. text
    elseif type == "INIT" then
        log_text = timeStamp .. " " .. "[INIT]: Module [" .. text .. ".lua] initialized."
    elseif type == "ERROR" then
        log_text = timeStamp .. " " .. "[ERROR]: ".. text
    elseif type == "WARNING" or type == "WARN" then
        log_text = timeStamp .. " " .. "[WARN]: " .. text
    end

    _LOGS[#_LOGS+1] = log_text
    if _DEBUG == true then
        print(log_text)
    end
end

function tableLength(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

math.round = function(num)
    return math.floor(num + 0.5)
end