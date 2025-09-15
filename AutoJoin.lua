-- AutoJoin для Steal a Brainrot: Поиск серверов с богатыми игроками (>= 10M)
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local jobId = game.JobId

local MIN_MONEY = 10000000  -- Минимум 10 миллионов
local CHECK_INTERVAL = 60   -- Проверка каждую минуту
local HOP_DELAY = 10        -- Задержка после хопа

-- Получение списка серверов
local function getServers()
    local servers = {}
    local cursor = ""
    repeat
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
        local success, result = pcall(function() return game:HttpGet(url) end)
        if success then
            local response = HttpService:JSONDecode(result)
            for _, server in ipairs(response.data) do
                if server.playing < server.maxPlayers * 0.8 and server.id ~= jobId and server.playing > 1 then
                    table.insert(servers, server.id)
                end
            end
            cursor = response.nextPageCursor or ""
        else

