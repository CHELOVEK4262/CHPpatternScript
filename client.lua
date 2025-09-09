-- client.lua

local sirenMode = 0 -- 0 = выкл, 1 = wail, 2 = yelp

-- Таблица с допустимыми машинами и их extras
local vehicleExtras = {
	["chp15expedi"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5}
    },
	["chp15f250"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5}
    },
	["chp15f250st"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5}
    },
	["chp15fpiuk9"] = {
        wail = {1,2,3,8,11},
        yelp = {2,12},
		park = {4,5,7}
    },
	["chp15fpiup"] = {
        wail = {1,2,3,8,11},
        yelp = {2,12},
		park = {4,5,7}
    },
	["chp15fpiu"] = {
        wail = {1,2,3,8,11},
        yelp = {2,12},
		park = {4,5,7}
    },
	["chp15fpiuw"] = {
        wail = {1,2,3,8,11},
        yelp = {2,12},
		park = {4,5,7}
    },
	["chp16fpiup"] = {
        wail = {1,2,3,8,11},
        yelp = {2,12},
		park = {4,5,7}
    },
	["chp16ram"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5}
    },
	["chp18charg"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5}
    },
	["chp18chargs"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5}
    },
	["chp18chargn"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5}
    },
	["chp18chargnp"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5}
    },
	["chp19charg"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5}
    },
	["chp19chargs"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5}
    },
    ["chp18tahoe"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5}
    },
	["chp20charg"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5}
    },
	["chp20fpiu"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5}
    },
	["chp20fpiup"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5}
    },
	["chp20tahoe"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5}
    },
	["chp21tahoe"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5}
    },
    ["chp23charg"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5}
    },
	["chp23chargp"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5}
    },
	["chp23durang"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5}
    },
	["chpum15fpiu"] = {
        wail = {1,3},
        yelp = {2,12},
		park = {5}
    }
}

-- Проверка, допустим ли транспорт
local function isAllowedVehicle(vehicle)
    if vehicle == 0 then return false end
    local model = GetEntityModel(vehicle)
    local name = GetDisplayNameFromVehicleModel(model):lower()
    return vehicleExtras[name] ~= nil
end

-- Вспомогательная функция для поиска значения в таблице
local function tableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

-- Копия таблицы (чтобы не портить оригинал)
local function copyTable(tbl)
    local t = {}
    for _, v in ipairs(tbl) do
        table.insert(t, v)
    end
    return t
end

-- Получение extras для текущего режима
local function getExtrasForMode(vehicle, mode)
    local model = GetEntityModel(vehicle)
    local name = GetDisplayNameFromVehicleModel(model):lower()
    local data = vehicleExtras[name]
    if not data then return {} end

    local extras = {}

    if mode == 0 then
        extras = copyTable(data.wail or {}) -- OFF = Wail style (мигалки без звука)
    elseif mode == 1 then
        extras = copyTable(data.wail or {})
    elseif mode == 2 then
        extras = copyTable(data.yelp or {})
    end

    -- Park режим: включается при ВКЛЮЧЁННЫХ мигалках и скорости < 0.5
    if IsVehicleSirenOn(vehicle) and GetEntitySpeed(vehicle) < 0.5 and data.park then
        for _, v in ipairs(data.park) do
            table.insert(extras, v)
        end
    end

    return extras
end

-- Управление extras
local function setVehicleExtras(vehicle, mode)
    if vehicle == 0 or not isAllowedVehicle(vehicle) then return end

    SetVehicleAutoRepairDisabled(vehicle, true)

    local extrasOn = getExtrasForMode(vehicle, mode)

    for i = 1, 20 do
        if tableContains(extrasOn, i) then
            SetVehicleExtra(vehicle, i, 0) -- включаем
        else
            SetVehicleExtra(vehicle, i, 1) -- выключаем
        end
    end
end

-- Проверка возможности переключения режима R
local function canToggleSiren()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 or not isAllowedVehicle(vehicle) then return false, vehicle end
    if not IsVehicleSirenOn(vehicle) then return false, vehicle end
    if sirenMode == 0 then return false, vehicle end
    return true, vehicle
end

-- Проверка, может ли игрок управлять сиренами
local function canControlSiren()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 or not isAllowedVehicle(vehicle) then return false, vehicle end
    return true, vehicle
end

-- Отслеживание клавиш
CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local canControl, _ = canControlSiren()

        -- Q (OFF → ставит extras как Wail без siren)
        if IsControlJustPressed(0, 44) then
            sirenMode = 0
            setVehicleExtras(vehicle, sirenMode)
        end

        -- ALT (переключатель Wail/Off)
        if IsControlJustPressed(0, 19) then
            if sirenMode ~= 0 then
                sirenMode = 0
            else
                sirenMode = 1
            end
            setVehicleExtras(vehicle, sirenMode)
        end

        -- R (переключатель Wail/Yelp)
        local canToggle, _ = canToggleSiren()
        if IsControlJustPressed(0, 45) and canToggle then
            if sirenMode == 1 then
                sirenMode = 2
            elseif sirenMode == 2 then
                sirenMode = 1
            end
            setVehicleExtras(vehicle, sirenMode)
        end

        -- 1 (Wail toggle)
        if IsControlJustPressed(0, 157) then
            if sirenMode == 1 then
                sirenMode = 0
            else
                sirenMode = 1
            end
            setVehicleExtras(vehicle, sirenMode)
        end

        -- 2 (Yelp toggle)
        if IsControlJustPressed(0, 158) then
            if sirenMode == 2 then
                sirenMode = 0
            else
                sirenMode = 2
            end
            setVehicleExtras(vehicle, sirenMode)
        end

        -- Обновляем extras постоянно (динамический park)
        if canControl then
            setVehicleExtras(vehicle, sirenMode)
        end
    end
end)
