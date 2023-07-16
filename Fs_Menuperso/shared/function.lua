ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
		blockinput = false
        return result
    else
        Wait(500)
		blockinput = false
        return nil
    end
end

function startAnimAction(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
		RemoveAnimDict(lib)
	end)
end

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

function Cinematic()
    Config.Cinematic = not Config.Cinematic
    if Config.Cinematic then    
        CreateThread(function()
            while Config.Cinematic do 
                Wait(1)
                DrawRect(1.0, 1.0, 2.0, 0.23, 0, 0, 0, 255)
                DrawRect(1.0, 0.0, 2.0, 0.23, 0, 0, 0, 255)
            end
        end)
    end
end

function setUniform(value)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == 1 then
                playAnim('clothingtie', 'try_tie_negative_a', 1000)
                Wait(1000)
                ClearPedTasks(PlayerPedId())
			    if skin.torso_1 ~= skina.torso_1 then -- torse
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['arms'] = skin.arms})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['arms'] = 15})
				end
			elseif value == 2 then -- tshirt

                playAnim('clothingtie', 'try_tie_negative_a', 1000)
				Wait(1000)
				ClearPedTasks(PlayerPedId())

				if skin.tshirt_1 ~= skina.tshirt_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['tshirt_1'] = 15, ['tshirt_2'] = 0})
				end
			elseif value == 3 then -- pants
				playAnim('re@construction', 'out_of_breath', 1300)
				Wait(1000)
				ClearPedTasks(PlayerPedId())
				if skin.pants_1 ~= skina.pants_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 61, ['pants_2'] = 1})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
					end
				end
			elseif value == 4 then -- shoes
				playAnim('random@domestic', 'pickup_low', 1000)
                Wait(1000)
				ClearPedTasks(PlayerPedId())
				
				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})
					end
				end
			elseif value == 5 then -- bags
				playAnim('anim@heists@ornate_bank@grab_cash', 'intro', 1600)
                Wait(1000)
				ClearPedTasks(PlayerPedId())

				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == 6 then -- watches
				playAnim('nmt_3_rcm-10', 'cs_nigel_dual-10', 1200)
                Wait(1000)
				ClearPedTasks(PlayerPedId())
				if skin.watches_1 ~= skina.watches_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['watches_1'] = skin.watches_1, ['watches_2'] = skin.watches_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['watches_1'] = -1, ['watches_2'] = 0})
				end
			elseif value == 7 then -- bracelets
				playAnim('nmt_3_rcm-10', 'cs_nigel_dual-10', 1200)
                Wait(1000)
				ClearPedTasks(PlayerPedId())
				if skin.bracelets_1 ~= skina.bracelets_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bracelets_1'] = skin.bracelets_1, ['bracelets_2'] = skin.bracelets_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bracelets_1'] = -1, ['bracelets_2'] = 0})
				end
			elseif value == 8 then -- mask
				playAnim('mp_masks@standard_car@ds@', 'put_on_mask', 800)
                Wait(1000)
				ClearPedTasks(PlayerPedId())
				if skin.mask_1 ~= skina.mask_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['mask_1'] = skin.mask_1, ['mask_2'] = skin.mask_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['mask_1'] = 0, ['mask_2'] = 0})
				end
			elseif value == 9 then -- helmet
				playAnim('clothingtie', 'check_out_a', 2000)
                Wait(1000)
				ClearPedTasks(PlayerPedId())
				if skin.helmet_1 ~= skina.helmet_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['helmet_1'] = skin.helmet_1, ['helmet_2'] = skin.helmet_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['helmet_1'] = -1, ['helmet_2'] = 0})
				end
			elseif value == 10 then -- glasses
				playAnim('clothingspecs', 'take_off', 1400)
                Wait(1000)
				ClearPedTasks(PlayerPedId())
				if skin.glasses_1 ~= skina.glasses_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['glasses_1'] = skin.glasses_1, ['glasses_2'] = skin.glasses_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['glasses_1'] = 0, ['glasses_2'] = 0})
				end
			elseif value == 11 then -- ears
				playAnim('mini@ears_defenders', 'takeoff_earsdefenders_idle', 800)
                Wait(1000)
				ClearPedTasks(PlayerPedId())
				if skin.ears_1 ~= skina.ears_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['ears_1'] = skin.ears_1, ['ears_2'] = skin.ears_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['ears_1'] = 0, ['ears_2'] = 0})
				end
            end
            TriggerServerEvent('esx_skin:save', skina)                                    
		end)
	end)
end


ShowCard = function(Type, Actions)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if Type == 1 then 
        if Actions == 1 then 
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId())) 
        elseif Actions == 2 then 
            if closestPlayer ~= -1 and closestDistance <= 3 then 
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer)) 
            else
                ESX.ShowNotification("~o~Aucun joueur a proximité ") 
            end
        end
    elseif Type == 2 then 
        if Actions == 1 then 
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver') 
        elseif Actions == 2 then 
            if closestPlayer ~= -1 and closestDistance <= 3 then 
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver') 
            else
                ESX.ShowNotification("~o~Aucun joueur a proximité ") 
            end
        end
    elseif Type == 3 then 
        if Actions == 1 then 
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon') 
        elseif Actions == 2 then 
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon') 
        end
    end
end

GestionMoney = function(Type, Actions)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if Type == 1 then 
        if Actions == 1 then 
            local amount = KeyboardInput("GiveMoneyToPlayer", "Montant à donner au joueur", "", 5)
            if amount ~= nil then 
                amount = tonumber(amount)
                if type(amount) == 'number' then
                    if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                        if closestPlayer ~= -1 and closestDistance <= 3 then 
                            TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', ESX.PlayerData.money, amount)
                        else
                            ESX.ShowNotification("~o~Aucun joueur a proximité ")
                        end
                    else
                        ESX.ShowNotification("~o~Vous ne pouvez pas donner en étant dans un véhicule.")
                    end
                end
            end
        elseif Actions == 2 then 
            local amount = KeyboardInput("DropMoney", "Montant à jeter", "", 5)
            if amount ~= nil then 
                amount = tonumber(amount)
                if type(amount) == 'number' then
                    TriggerServerEvent('esx:removeInventoryItem', 'item_money', ESX.PlayerData.money, amount)
                end
            end
        end
    elseif Type == 2 then
        if Actions == 1 then 
            local amount = KeyboardInput("GiveBlackMoneyToPlayer", "Montant à donner au joueur", "", 5)
            if amount ~= nil then 
                amount = tonumber(amount)
                if type(amount) == 'number' then
                    if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                        if closestPlayer ~= -1 and closestDistance <= 3 then 
                            TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', 'black_money', amount)
                        else
                            ESX.ShowNotification("~o~Aucun joueur a proximité ")
                        end
                    else
                        ESX.ShowNotification("~o~Vous ne pouvez pas donner en étant dans un véhicule.")
                    end
                end
            end
        elseif Actions == 2 then 
            local amount = KeyboardInput("DropBlackMoney", "Montant à jeter", "", 5)
            if amount ~= nil then 
                amount = tonumber(amount)
                if type(amount) == 'number' then
                    TriggerServerEvent('esx:removeInventoryItem', 'item_account', 'black_money', amount)
                end
            end
        end
    end
end

GestionSociety = function(job, type)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if not IsPedSittingInAnyVehicle(PlayerPedId()) then
        if closestPlayer ~= -1 and closestDistance <= 3 then 
            TriggerServerEvent("cxF5:GestionSociety", GetPlayerServerId(closestPlayer), job, type)
        else
            ESX.ShowNotification("~o~Aucun joueur a proximité ")
        end
    else
        ESX.ShowNotification("~o~Vous ne pouvez pas faire cela en étant dans un véhicule")
    end
end

ActionItem = {
    Use = function(item)
        if item.usable then 
            TriggerServerEvent('esx:useItem', item.name)
        else
            ESX.ShowNotification("L'item ~b~"..item.label.." ~s~n'est pas utilisable")
        end
    end,
    Give = function(item)
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        local amount = KeyboardInput("GiveItemToPlayer", "Montant à donner au joueur", "", 5)
        if amount ~= nil then 
            amount = tonumber(amount)
            if type(amount) == 'number' then
                if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    if closestPlayer ~= -1 and closestDistance <= 3 then 
                        if item.count >= amount then
                            TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer),'item_standard', item.name, amount)
                        else
                            ESX.ShowNotification("~r~Vous n'avez pas autant de "..item.label.." sur vous !")
                        end
                    else
                        ESX.ShowNotification("~o~Aucun joueur a proximité ")
                    end
                else
                    ESX.ShowNotification("~o~Vous ne pouvez pas donner en étant dans un véhicule.")
                end
            end
        end
    end,
    Drop = function(item)
        if item.canRemove then
            local amount = KeyboardInput("DropItem", "Montant à jeter", "", 5)
            if amount ~= nil then 
                amount = tonumber(amount)
                if type(amount) == 'number' then
                    if not IsPedSittingInAnyVehicle(PlayerPedId()) then 
                        if item.count >= amount then 
                            TriggerServerEvent('esx:removeInventoryItem', 'item_standard', item.name, amount)
                        else
                            ESX.ShowNotification("~r~Vous n'avez pas autant de "..item.label.." sur vous !")
                        end
                    else
                        ESX.ShowNotification("~o~Vous ne pouvez pas jeter en étant dans un véhicule.")
                    end
                end
            end
        end
    end
}

ActionWeapon = {
    Give = function(weapon)
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
            if closestPlayer ~= -1 and closestDistance <= 3 then 
                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_weapon', weapon.name, GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(weapon.name)))                        
            else
                ESX.ShowNotification("~o~Aucun joueur a proximité ")
            end
        else
            ESX.ShowNotification("~o~Vous ne pouvez pas donner en étant dans un véhicule.")
        end
    end,
    Drop = function(weapon)
        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
            TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', weapon.name)
        else
            ESX.ShowNotification("~o~Vous ne pouvez pas jeter en étant dans un véhicule.")
        end
    end
}

function LoadHUDHealth()
    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        Config.Thirst = status.val*0.0001
    end)
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
        Config.Hunger = status.val*0.0001
    end)
end

Billing = {}

function RefreshFacture() 
    ESX.TriggerServerCallback('cxF5:getBills', function(bills)
        Billing = bills 
    end)    
end