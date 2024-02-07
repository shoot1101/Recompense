local redeemedIdents = {}

if Config.UseCommand then
	RegisterCommand(Config.Command, function(source, args)
		ClaimReward(source)
	end, false)
end

RegisterCommand('viewRedeemed', function(source, args)
    for k,v in pairs(redeemedIdents) do
        print(v)
    end
end, false)

function ClaimReward(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayerName = xPlayer.getName()
    local xPlayerIdentifier = xPlayer.getIdentifier()

    -- Print that the player is trying to redeem their reward
    if Config.EnableDebug then
        print(xPlayerName .. ' (' .. xPlayerIdentifier .. ') tente d échanger sa récompense quotidienne')
    end

    -- Check to see if the player's identifier exist in the table
    if #redeemedIdents == 0 then
        -- Debug Message
        if Config.EnableDebug then
            print('Les identifiants utilisés sont vides')
        end

        -- Add the player to the reward list
        table.insert(redeemedIdents, xPlayerIdentifier)
        if Config.EnableDebug then
            print('Ajouté ' .. xPlayerIdentifier .. ' aux identifiants échangés.')
        end

        --- MONEY ---
        if Config.MoneyReward then
            if Config.RandomAmount then
                local crateAmount = Config.MoneyRewards[math.random(#Config.MoneyRewards)]
                xPlayer.addAccountMoney('bank', crateAmount)
                xPlayer.showNotification('$' .. crateAmount .. ' a été ajouté à votre banque!')
                eLogsDiscord("[Récompense] **"..xPlayer.getName().."** a reçu : "..crateAmount.. '$', Config.logs.recj)

                if Config.EnableDebug then
                    print('A donné à ' .. xPlayerIdentifier .. ' leur récompense quotidienne')
                end
            else
                local crateAmount = Config.PresetAmount
                xPlayer.addAccountMoney('bank', crateAmount)
                xPlayer.showNotification('$' .. crateAmount .. ' a été ajouté à votre banque!')
                eLogsDiscord("[Récompense] **"..xPlayer.getName().."** a reçu : "..crateAmount.. '$', Config.logs.recj)

                if Config.EnableDebug then
                    print('A donné à ' .. xPlayerIdentifier .. ' leur récompense quotidienne')
                end
            end
        end

        -- WAIT
        Citizen.Wait(3 * 1000)

        --- ITEM ---
        if Config.ItemReward then
            if Config.RandomItems then
                local randomItem = Config.ItemRewards[math.random(#Config.ItemRewards)]
                local selectedItem = randomItem.item
                local selectedItemCount = randomItem.amount
                xPlayer.addInventoryItem(selectedItem, selectedItemCount)
                local itemLabel = ESX.GetItemLabel(selectedItem)
                xPlayer.showNotification('' .. selectedItemCount .. ' ' .. itemLabel .. ' a été ajouté à votre inventaire!')
                eLogsDiscord("[Récompense] **"..xPlayer.getName().."** a reçu :**"..selectedItemCount.. '' .. itemLabel, Config.logs.deco)

                if Config.EnableDebug then
                    print('A donné à ' .. xPlayerIdentifier .. ' leur récompense quotidienne')
                end
            else
                xPlayer.addInventoryItem(Config.PresetItem, Config.PresetAmount)
                local itemLabel = ESX.GetItemLabel(Config.PresetItem)
                xPlayer.showNotification('' .. Config.PresetAmount .. ' ' .. itemLabel .. ' a été ajouté à votre inventaire!')
                eLogsDiscord("[Récompense] **"..xPlayer.getName().."** a reçu :**"..Config.PresetAmount.. '' .. itemLabel, Config.logs.deco)

                if Config.EnableDebug then
                    print('A donné à ' .. xPlayerIdentifier .. ' leur récompense quotidienne')
                end
            end
        end
    else
        if has_redeemed(redeemedIdents, xPlayerIdentifier) then
            xPlayer.showNotification('[ERREUR] Vous avez déjà utilisé votre récompense quotidienne!')
            if Config.EnableDebug then
                print('Joueur: ' .. xPlayerIdentifier .. ' ont essayé à nouveau d échanger leur récompense quotidienne')
            end
        else
            -- Add the player to the reward list
            table.insert(redeemedIdents, xPlayerIdentifier)
            if Config.EnableDebug then
                print('Ajouté ' .. xPlayerIdentifier .. ' aux identifiants échangés.')
            end

            --- MONEY ---
            if Config.MoneyReward then
                if Config.RandomAmount then
                    local crateAmount = Config.MoneyRewards[math.random(#Config.MoneyRewards)]
                    xPlayer.addAccountMoney('bank', crateAmount)
                    xPlayer.showNotification('$' .. crateAmount .. ' a été ajouté à votre banque!')
                    eLogsDiscord("[Récompense] **"..xPlayer.getName().."** a reçu :**"..crateAmount, Config.logs.recj)

                    if Config.EnableDebug then
                        print('A donné à ' .. xPlayerIdentifier .. ' leur récompense quotidienne')
                    end
                else
                    local crateAmount = Config.PresetAmount
                    xPlayer.addAccountMoney('bank', crateAmount)
                    xPlayer.showNotification('$' .. crateAmount .. ' a été ajouté à votre banque!')
                    eLogsDiscord("[Récompense] **"..xPlayer.getName().."** a reçu :**"..crateAmount, Config.logs.recj)

                    if Config.EnableDebug then
                        print('A donné à ' .. xPlayerIdentifier .. ' leur récompense quotidienne')
                    end
                end
            end

            --- ITEMM ---
            if Config.ItemReward then
                if Config.RandomItems then
                    local randomItem = Config.ItemRewards[math.random(#Config.ItemRewards)]
                    local selectedItem = randomItem.item
                    local selectedItemCount = randomItem.amount
                    xPlayer.addInventoryItem(selectedItem, selectedItemCount)
                    local itemLabel = ESX.GetItemLabel(selectedItem)
                    xPlayer.showNotification('' .. selectedItemCount .. ' ' .. itemLabel .. ' a été ajouté à votre inventaire!')
                    if Config.EnableDebug then
                        print('A donné à ' .. xPlayerIdentifier .. ' leur récompense quotidienne')
                    end
                else
                    xPlayer.addInventoryItem(Config.PresetItem, Config.PresetAmount)
                    local itemLabel = ESX.GetItemLabel(Config.PresetItem)
                    xPlayer.showNotification('' .. Config.PresetAmount .. ' ' .. itemLabel .. ' a été ajouté à votre inventaire!')
                    if Config.EnableDebug then
                        print('A donné à ' .. xPlayerIdentifier .. ' leur récompense quotidienne')
                    end
                end
            end
        end
    end
end

function has_redeemed(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

---------------- LOGS
function eLogsDiscord(message,url)
    local DiscordWebHook = url
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({username = Config.logs.NameLogs, content = message}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('reward:logsEvent')
AddEventHandler('reward:logsEvent', function(message, url)
	eLogsDiscord(message,url)
end)