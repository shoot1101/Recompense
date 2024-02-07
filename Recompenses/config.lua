Config = {}

-- PARAMÈTRES DES COMMANDES --
Config.Command = 'daily-reward'
Config.UseCommand = true

-- TYPES DE RÉCOMPENSES --
Config.MoneyReward = true
Config.ItemReward = false

-- PARAMÈTRES DES RÉCOMPENSES EN ARGENT --
Config.RandomAmount = true -- true sélectionnera un montant aléatoire dans le tableau des récompenses | false utilisera le montant prédéfini
Config.PresetAmount = 1000
Config.MoneyRewards = {
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    1000
}

-- PARAMÈTRES DES RÉCOMPENSES EN ITEM --
Config.RandomItems = false -- true sélectionnera un item aléatoire dans le tableau des récompenses | false utilisera l'item prédéfini avec le montant prédéfini
Config.PresetAmount = 1 
Config.PresetItem = 'fixkit'
Config.ItemRewards = {
    {
        item = 'water',
        amount = 2
    },
    {
        item = 'bread',
        amount = 2
    }
}

-- DEBUG OPTIONS --
Config.EnableDebug = true

-- WEBHOOK --
Config.logs = {
    -------------------------	
    NameLogs = "Logs - Récompense journalière",
    -------------------------
    recj = "webhook discord",

}