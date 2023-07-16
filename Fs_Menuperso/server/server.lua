ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterServerEvent("cxF5:GestionSociety")
AddEventHandler("cxF5:GestionSociety", function(target, job, type)
    local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
    if job == 1 then
        if type == 1 then
            xTarget.setJob(xPlayer.job.name, 0)
            -- TriggerClientEvent('esx:showNotification', source, "Vous avez ~r~recruté " .. xTarget.name)
            -- TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~recruté par " .. xPlayer.name)
        elseif type == 2 then
            if xPlayer.job.name == xTarget.job.name then
                xTarget.setJob(xTarget.job.name, tonumber(xTarget.job.grade) + 1)
                -- TriggerClientEvent('esx:showNotification', source, "Vous avez ~g~promu " .. xTarget.name)
                -- TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~promu par "..xPlayer.name)
            else
                -- TriggerClientEvent('esx:showNotification', source, "~o~Vous n'avez pas l'autorisation")
            end
        elseif type == 3 then
            if xTarget.job.grade == 0 then
                -- TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas plus ~r~rétrograder~w~ davantage.')
            else
                if xPlayer.job.name == xTarget.job.name then
                    xTarget.setJob(xTarget.job.name, tonumber(xTarget.job.grade) - 1)
                    -- TriggerClientEvent('esx:showNotification', source, "Vous avez ~r~rétrogradé " .. xTarget.name)
                    -- TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~rétrogradé par " .. xPlayer.name)
                else
                    -- TriggerClientEvent('esx:showNotification', source, "~o~Vous n'avez pas l'autorisation")
                end
            end

        elseif type == 4 then
            if xPlayer.job.name == xTarget.job.name then
                xTarget.setJob('unemployed', 0)
                -- TriggerClientEvent('esx:showNotification', source, "Vous avez ~r~viré " .. xTarget.name)
                -- TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~viré par " .. xPlayer.name)
            else
                -- TriggerClientEvent('esx:showNotification', source, "~o~Vous n'avez pas l'autorisation")
            end
        end
    else
        if type == 1 then
            xTarget.setJob2(xPlayer.job2.name, 0)
            -- TriggerClientEvent('esx:showNotification', source, "Vous avez ~r~recruté " .. xTarget.name)
            -- TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~recruté par " .. xPlayer.name)
        elseif type == 2 then
            if xPlayer.job2.name == xTarget.job2.name then
                xTarget.setJob2(xTarget.job2.name, tonumber(xTarget.job2.grade) + 1)
                -- TriggerClientEvent('esx:showNotification', source, "Vous avez ~g~promu " .. xTarget.name)
                -- TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~promu par "..xPlayer.name)
            else
                -- TriggerClientEvent('esx:showNotification', source, "~o~Vous n'avez pas l'autorisation")
            end
        elseif type == 3 then
            if xTarget.job2.grade == 0 then
                -- TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas plus ~r~rétrograder~w~ davantage.')
            else
                if xPlayer.job2.name == xTarget.job2.name then
                    xTarget.setJob2(xTarget.job2.name, tonumber(xTarget.job2.grade) - 1)
                    -- TriggerClientEvent('esx:showNotification', source, "Vous avez ~r~rétrogradé " .. xTarget.name)
                    -- TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~rétrogradé par " .. xPlayer.name)
                else
                    -- TriggerClientEvent('esx:showNotification', source, "~o~Vous n'avez pas l'autorisation")
                end
            end

        elseif type == 4 then
            if xPlayer.job2.name == xTarget.job2.name then
                xTarget.setJob2('unemployed2', 0)
                -- TriggerClientEvent('esx:showNotification', source, "Vous avez ~r~viré " .. xTarget.name)
                -- TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~viré par " .. xPlayer.name)
            else
                TriggerClientEvent('esx:showNotification', source, "~o~Vous n'avez pas l'autorisation")
            end
        end
    end
end)

RegisterServerEvent("cxF5:Deconnection")
AddEventHandler("cxF5:Deconnection", function()
    DropPlayer(source, "Déconnexion effectuée avec succès. \nVos données et votre position ont étés sauvegardées. \nMerci d'avoir joué sur notre serveur")
end)

ESX.RegisterServerCallback('cxF5:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}

		for i = 1, #result do
			bills[#bills + 1] = {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			}
		end

		cb(bills)
	end)
end)