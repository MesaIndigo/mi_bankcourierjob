-- local variables
local taskA = nil
local taskAped = {
    spawned = false,
    ped = nil
}

local taskB = nil
local taskBped = {
    spawned = false,
    ped = nil
}

local working = false
local job = Config.job.name
local time = Job.pacific.cooldown
local timer = false

local function cooldown()
    timer = true
    SetTimeout(time * 60000, function()
        timer = false
    end)
end

---------- Job Events ----------
RegisterNetEvent('g6s:pacific:start', function()
    taskA = Job.fleeca
    if working or timer then 
        lib.notify({
            id = 'pacific1',
            title = 'G6 Security: Request denied',
            description = 'Return later for this assignment',
            position = 'top-right',
            style = {
                backgroundColor = '#F4F6F7',
                color = '#252525',
                ['.description'] = {
                  color = '#4B4B4B'
                }
            },
            icon = '6',
            iconColor = '#28B463'
        })
    else
        local pedA = taskA[math.random(1, #taskA)]
        taskA = pedA
        working = true
        local model = lib.requestmodel(joaat(taskA.model))
        local coords = taskA.loc
        local anim = taskA.anim
        if taskAped.spawned then return
        else
            local ped = CreatePed(1, model, coords.x, coords.y, coords.z-1, coords.w, false, false)
            Util.g6sped_utils(ped, anim)
            taskAped.ped = ped
        end
        local blipA = nil
        local sprite = Job.blip.sprite
        local color = Job.blip.color
        local route = true
        local routecolor = Job.blip.routecolor
        local scale = Job.blip.scale
        local name = Job.blip.name
        if blipA ~= nil then
            Util.g6sremove_blip(blipA)
            blipA = nil
        end
        
        blipA = AddBlipForCoord(coords.x, coords.y, coords.z)
        Util.g6sroute(sprite, color, route, routecolor, scale, name)

        local ped_options = {
            {
                name = 'pacific1',
                label = 'Take money',
                groups = job,
                icon = 'fa-solid fa-sack-dollar',
                canInteract = function(_, distance)
                    return distance < 2.5 and working
                end,
                onSelect = function()
                    exports.ox_target:removeLocalEntity(taskBped.ped, { 'pacific1' })
                    TriggerEvent('g6s:fleeca:end')
                    Util.g6sremove_blip(blipA)
                    Util.g6sremove_ped(taskAped.ped)
                    taskAped.spawned = false
                    
                end
            }
        }
    
        exports.ox_target:addLocalEntity(taskAped.ped, ped_options)
        taskAped.spawned = true

        lib.notify({
            id = 'pacific2',
            title = 'Pacific: Business Deposit',
            description = 'Drive to the designated business for pickup',
            position = 'top-right',
            style = {
                backgroundColor = '#F4F6F7',
                color = '#252525',
                ['.description'] = {
                  color = '#4B4B4B'
                }
            },
            icon = '6',
            iconColor = '#28B463'
        })
    end
end)

RegisterNetEvent('g6s:pacific:end', function()
    local pedB = nil
    repeat
        taskB = Job.fleeca
        pedB = taskB[math.random(1, #taskB)]
        
    until(pedB ~= taskA)
    taskB = pedB
    working = true
    local model = lib.requestmodel(joaat(taskB.model))
    local coords = taskB.loc
    local anim = taskB.anim
    if taskBped.spawned then 
    else
        local ped = CreatePed(1, model, coords.x, coords.y, coords.z-1, coords.w, false, false)
        Util.g6sped_utils(ped, anim)
        taskBped.ped = ped
    end
    local blipB = nil
        local sprite = Job.blip.sprite
        local color = Job.blip.color
        local route = true
        local routecolor = Job.blip.routecolor
        local scale = Job.blip.scale
        local name = Job.blip.name
        if blipB ~= nil then
            Util.g6sremove_blip(blipB)
            blipB = nil
        end
        
        blipB = AddBlipForCoord(coords.x, coords.y, coords.z)
        Util.g6sroute(sprite, color, route, routecolor, scale, name)

    local ped_options = {
        {
            name = 'pacific2',
            label = 'Deliver money',
            groups = job,
            icon = 'fa-solid fa-sack-dollar',
            canInteract = function(_, distance)
                return distance < 2.5 and working
            end,
            onSelect = function()
                TriggerEvent('g6s:fleeca:final')
                exports.ox_target:removeLocalEntity(taskBped.ped, { 'fleecabank2' })
                Util.g6sremove_blip(blipB)
                Util.g6sremove_ped(taskBped.ped)
            end
        }
    }

    exports.ox_target:addLocalEntity(taskBped.ped, ped_options)
    taskBped.spawned = true

    lib.notify({
        id = 'pacific3',
        title = 'Pacific: Business Deposit',
        description = 'Deliver the money to the the Pacific Standard Bank',
        position = 'top-right',
        style = {
            backgroundColor = '#F4F6F7',
            color = '#252525',
            ['.description'] = {
                color = '#4B4B4B'
            }
        },
        icon = '6',
        iconColor = '#28B463'
    })
end)

RegisterNetEvent('g6s:pacific:final', function()
    lib.callback('payout:pacific')
    working = false
    cooldown()
    lib.notify({
        id = 'pacific',
        title = 'Pacific: Business Deposit Comlete',
        description = 'Money delivered. Payment deposited to account',
        position = 'top-right',
        style = {
            backgroundColor = '#F4F6F7',
            color = '#252525',
            ['.description'] = {
                color = '#4B4B4B'
            }
        },
        icon = '6',
        iconColor = '#28B463'
    })
end)