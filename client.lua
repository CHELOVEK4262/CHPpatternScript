-- client.lua

local sirenMode = 0 -- 0 = выкл, 1 = wail, 2 = yelp
local taMode = 0    -- 0 = выкл, 1 = left, 2 = right, 3 = both

-- Таблица с допустимыми машинами и их extras
local vehicleExtras = {
	["chp15expedi"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
            right = {add={1,2,11}, remove={3,12}},
            both = {add={1,2,8}, remove={3,12}}
        }
    },
	["chp15f250"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
            right = {add={1,2,11}, remove={3,12}},
            both = {add={1,2,8}, remove={3,12}}
        }
    },
	["chp15f250st"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
            right = {add={1,2,11}, remove={3,12}},
            both = {add={1,2,8}, remove={3,12}}
        }
    },
	["chp15fpiuk9"] = {
        wail = {1,2,3,8,11},
        yelp = {2,12},
		park = {4,5,7},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
        }
    },
	["chp15fpiup"] = {
        wail = {1,2,3,8,11},
        yelp = {2,12},
		park = {4,5,7},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
        }
    },
	["chp15fpiu"] = {
        wail = {1,2,3,8,11},
        yelp = {2,12},
		park = {4,5,7},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
        }
    },
	["chp15fpiuw"] = {
        wail = {1,2,3,8,11},
        yelp = {2,12},
		park = {4,5,7},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
        },
    },
	["chp16fpiup"] = {
        wail = {1,2,3,8,11},
        yelp = {2,12},
		park = {4,5,7},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
        }
    },
	["chp16ram"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
            right = {add={1,2,11}, remove={3,12}},
            both = {add={1,2,8}, remove={3,12}}
        }
    },
	["chp18charg"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
            right = {add={1,2,11}, remove={3,12}},
            both = {add={1,2,8}, remove={3,12}}
        }
    },
	["chp18chargs"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
            right = {add={1,2,11}, remove={3,12}},
            both = {add={1,2,8}, remove={3,12}}
        }
    },
	["chp18chargn"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
            right = {add={1,2,11}, remove={3,12}},
            both = {add={1,2,8}, remove={3,12}}
        }
    },
	["chp18chargnp"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
            right = {add={1,2,11}, remove={3,12}},
            both = {add={1,2,8}, remove={3,12}}
        }
    },
	["chp19charg"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
            right = {add={1,2,11}, remove={3,12}},
            both = {add={1,2,8}, remove={3,12}}
        }
    },
	["chp19chargs"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
            right = {add={1,2,11}, remove={3,12}},
            both = {add={1,2,8}, remove={3,12}}
        }
    },
    ["chp18tahoe"] = {
        wail = {1,2,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,2,10}, remove={3,12}},
            right = {add={1,2,11}, remove={3,12}},
            both = {add={1,2,8}, remove={3,12}}
        }
    },
	["chp20charg"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5},
        ta = {
            left = {add={1,3,8,10}, remove={2,4,6}},
            right = {add={1,3,8,11}, remove={2,4,6}},
            both = {add={1,3,8,9}, remove={2,4,6}}
        }
    },
	["chp20fpiu"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5},
        ta = {
            left = {add={1,3,8,10}, remove={2,4,6}},
            right = {add={1,3,8,11}, remove={2,4,6}},
            both = {add={1,3,8,9}, remove={2,4,6}}
        }
    },
	["chp20fpiup"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5},
        ta = {
            left = {add={1,3,8,10}, remove={2,4,6}},
            right = {add={1,3,8,11}, remove={2,4,6}},
            both = {add={1,3,8,9}, remove={2,4,6}}
        }
    },
	["chp20tahoe"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5},
        ta = {
            left = {add={1,3,8,10}, remove={2,4,6}},
            right = {add={1,3,8,11}, remove={2,4,6}},
            both = {add={1,3,8,9}, remove={2,4,6}}
        }
    },
	["chp21tahoe"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5},
        ta = {
            left = {add={1,3,8,10}, remove={2,4,6}},
            right = {add={1,3,8,11}, remove={2,4,6}},
            both = {add={1,3,8,9}, remove={2,4,6}}
        }
    },
    ["chp23charg"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5},
        ta = {
            left = {add={1,3,8,10}, remove={2,4,6}},
            right = {add={1,3,8,11}, remove={2,4,6}},
            both = {add={1,3,8,9}, remove={2,4,6}}
        }
    },
	["chp23chargp"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5},
        ta = {
            left = {add={1,3,8,10}, remove={2,4,6}},
            right = {add={1,3,8,11}, remove={2,4,6}},
            both = {add={1,3,8,9}, remove={2,4,6}}
        }
    },
	["chp23durang"] = {
        wail = {1,2,3,6},
        yelp = {3,4},
		park = {5},
        ta = {
            left = {add={1,3,8,10}, remove={2,4,6}},
            right = {add={1,3,8,11}, remove={2,4,6}},
            both = {add={1,3,8,9}, remove={2,4,6}}
        }
    },
	["chpum15fpiu"] = {
        wail = {1,3},
        yelp = {2,12},
		park = {5},
        ta = {
            left = {add={1,10}, remove={2,3,12}},
        }
    }
}

-- Проверка, допустим ли транспорт
local function isAllowedVehicle(vehicle)
    if vehicle == 0 then return false end
    local model = GetEntityModel(vehicle)
    local name = GetDisplayNameFromVehicleModel(model):lower()
    return vehicleExtras[name] ~= nil
end

-- Копия таблицы
local function copyTable(tbl)
    local t = {}
    for _, v in ipairs(tbl) do
        table.insert(t, v)
    end
    return t
end

-- Получение extras для текущего режима сирен
local function getExtrasForMode(vehicle, mode)
    local model = GetEntityModel(vehicle)
    local name = GetDisplayNameFromVehicleModel(model):lower()
    local data = vehicleExtras[name]
    if not data then return {} end

    local extras = {}

    if mode == 0 then
        -- OFF = мигалки по wail, но без звука
        extras = copyTable(data.wail or {})
    elseif mode == 1 then
        extras = copyTable(data.wail or {})
    elseif mode == 2 then
        extras = copyTable(data.yelp or {})
    end

    -- park mode (если сирена включена и скорость почти 0)
    if IsVehicleSirenOn(vehicle) and GetEntitySpeed(vehicle) < 0.5 and data.park then
        for _, v in ipairs(data.park) do
            table.insert(extras, v)
        end
    end

    return extras
end


-- Получение extras для TA
local function getTAExtras(vehicle, mode)
    local model = GetEntityModel(vehicle)
    local name = GetDisplayNameFromVehicleModel(model):lower()
    local data = vehicleExtras[name]
    if not data or not data.ta then return {add={}, remove={}} end

    if mode == 1 then return data.ta.left or {add={}, remove={}} end
    if mode == 2 then return data.ta.right or {add={}, remove={}} end
    if mode == 3 then return data.ta.both or {add={}, remove={}} end
    return {add={}, remove={}}
end

-- Управление extras
local function setVehicleExtras(vehicle, mode, taMode)
    if vehicle == 0 or not isAllowedVehicle(vehicle) then return end

    SetVehicleAutoRepairDisabled(vehicle, true)

    local extrasSet = {} -- таблица-множество

    -- добавляем extras для сирен
    for _, v in ipairs(getExtrasForMode(vehicle, mode)) do
        extrasSet[v] = true
    end

    -- TA extras
    local taExtras = getTAExtras(vehicle, taMode)
    for _, v in ipairs(taExtras.add or {}) do
        extrasSet[v] = true
    end
    for _, v in ipairs(taExtras.remove or {}) do
        extrasSet[v] = nil
    end

    -- применяем к машине
    for i = 1, 20 do
        if extrasSet[i] then
            SetVehicleExtra(vehicle, i, 0) -- вкл
        else
            SetVehicleExtra(vehicle, i, 1) -- выкл
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

        -- Q (OFF)
        if IsControlJustPressed(0, 44) then
            sirenMode = 0
            setVehicleExtras(vehicle, sirenMode, taMode)
        end

        -- ALT (переключатель Wail/Off)
        if IsControlJustPressed(0, 19) then
            if sirenMode ~= 0 then
                sirenMode = 0
            else
                sirenMode = 1
            end
            setVehicleExtras(vehicle, sirenMode, taMode)
        end

        -- R (Wail <-> Yelp)
        local canToggle, _ = canToggleSiren()
        if IsControlJustPressed(0, 45) and canToggle then
            if sirenMode == 1 then
                sirenMode = 2
            elseif sirenMode == 2 then
                sirenMode = 1
            end
            setVehicleExtras(vehicle, sirenMode, taMode)
        end

        -- 1 (Wail toggle)
        if IsControlJustPressed(0, 157) then
            if sirenMode == 1 then
                sirenMode = 0
            else
                sirenMode = 1
            end
            setVehicleExtras(vehicle, sirenMode, taMode)
        end

        -- 2 (Yelp toggle)
        if IsControlJustPressed(0, 158) then
            if sirenMode == 2 then
                sirenMode = 0
            else
                sirenMode = 2
            end
            setVehicleExtras(vehicle, sirenMode, taMode)
        end

        -- TA работает только если мигалки включены
        if IsVehicleSirenOn(vehicle) then
            if IsControlJustPressed(0, 159) then -- 6
                if taMode == 1 then taMode = 0 else taMode = 1 end
                setVehicleExtras(vehicle, sirenMode, taMode)
            end

            if IsControlJustPressed(0, 162) then -- 8
                if taMode == 2 then taMode = 0 else taMode = 2 end
                setVehicleExtras(vehicle, sirenMode, taMode)
            end

            if IsControlJustPressed(0, 161) then -- 7
                if taMode == 3 then taMode = 0 else taMode = 3 end
                setVehicleExtras(vehicle, sirenMode, taMode)
            end
        else
            -- если мигалки выключены — TA сбрасывается
            if taMode ~= 0 then
                taMode = 0
                setVehicleExtras(vehicle, sirenMode, taMode)
            end
        end

        -- Обновляем extras постоянно (динамический park и ta)
        if canControl then
            setVehicleExtras(vehicle, sirenMode, taMode)
        end
    end
end)
