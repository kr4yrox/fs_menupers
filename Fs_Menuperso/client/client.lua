ESX  = nil
local open = false
local FilterItem, FilterWeapon =  true, true
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function RefreshPlayerData()
    Citizen.CreateThread(function()
        ESX.PlayerData = ESX.GetPlayerData()
    end)
end

local F5Menu = RageUI.CreateMenu("", "Menu personnel")
local InventoryMenu = RageUI.CreateSubMenu(F5Menu, "", "Menu personnel")
local RacMenu = RageUI.CreateSubMenu(F5Menu, "", "Menu personnel")
local ActionsItemMenu = RageUI.CreateSubMenu(InventoryMenu, "", "Menu personnel")
local ActionsWeaponMenu = RageUI.CreateSubMenu(InventoryMenu, "", "Menu personnel")
local WalletMenu = RageUI.CreateSubMenu(F5Menu, "", "Menu personnel")
local BillingMenu = RageUI.CreateSubMenu(WalletMenu, "Factures", "Menu personnel")
local CardMenu = RageUI.CreateSubMenu(WalletMenu, "Vos cartes", "Menu personnel")
local GestionSocietyMenu = RageUI.CreateSubMenu(WalletMenu, "Gestion societé", "Menu personnel")
local GestionOrganisationMenu = RageUI.CreateSubMenu(WalletMenu, "Gestion organisation", "Menu personnel")
local DiversMenu = RageUI.CreateSubMenu(F5Menu, "Divers", "Menu personnel")
local ClotheMenu = RageUI.CreateSubMenu(DiversMenu, "Vêtements", "Menu personnel")
local HealthMenu = RageUI.CreateSubMenu(DiversMenu, "Santé", "Menu personnel")
local OptionMenu = RageUI.CreateSubMenu(DiversMenu, "Options", "Menu personnel")
local GestionVehMenu = RageUI.CreateSubMenu(F5Menu, "Véhicule", "Menu personnel")


F5Menu.Closed = function()   
    RageUI.Visible(F5Menu, false)
    open = false
end 

DiversMenu.Closed = function()
    RageUI.Visible(DiversMenu, false)
end

local CurrentItem = {}
local CurrentWeapon = {}


function OpenF5Menu()
    if open then 
        open = false 
        RageUI.Visible(F5Menu,false)
        return
    else
        open = true 
        RageUI.Visible(F5Menu, true)
        RefreshPlayerData()
        RefreshFacture() 
        LoadHUDHealth()
        CreateThread(function ()
            while open do 
                RageUI.IsVisible(F5Menu, function()
                    RageUI.Button("Inventaire", false , {RightLabel = "→"}, true , {}, InventoryMenu)
                    RageUI.Button("Portefeuille", false , {RightLabel = "→"}, true , {}, WalletMenu)
                    RageUI.Button("Raccourcis", false , {RightLabel = "→"}, true , {}, RacMenu)
                    RageUI.Button("Divers", false , {RightLabel = "→"}, true , {}, DiversMenu)
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
                        RageUI.Button("Gestion du véhicule", false , {RightLabel = "→"}, true , {}, GestionVehMenu)
                    else
                        RageUI.Button("Gestion du véhicule", false , {RightLabel = "→"}, false , {}, GestionVehMenu)
                    end

                end)
                RageUI.IsVisible(InventoryMenu, function()
                    RageUI.List("Filtres : ", Config.Filters, (Config.Filters.FiltersIndex or 1), false, {}, true, {
                        onListChange = function(Index)
                            Config.Filters.FiltersIndex = Index
                            if Index == 1 then
                                FilterItem, FilterWeapon =  true, true
                            elseif Index == 2 then
                                FilterItem, FilterWeapon =  true, false
                            elseif Index == 3 then
                                FilterItem, FilterWeapon =  false, true
                            end
                        end
                    })
                    if FilterItem then
                        RageUI.Separator("↓ ~y~Items~s~ ↓")
                        for k,v in pairs(ESX.PlayerData.inventory) do
                            if v.count > 0 then
                                RageUI.Button(v.label.." - ["..v.count.."]", false , {RightLabel = "→"}, true , {
                                    onSelected = function()
                                        CurrentItem = v
                                    end
                                }, ActionsItemMenu)
                            end
                        end
                    end
                    if FilterWeapon then
                        RageUI.Separator("↓ ~y~Armes~s~ ↓")
                        for k,v in pairs (ESX.GetWeaponList()) do
                            if HasPedGotWeapon(PlayerPedId(), GetHashKey(v.name), false) and v.name ~= 'WEAPON_UNARMED' then
                                RageUI.Button(v.label.." - [~b~Munitions:~s~ "..GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(v.name)).."]", false, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        CurrentWeapon = v
                                    end
                                }, ActionsWeaponMenu)
                            end
                        end
                    end
                end)
                RageUI.IsVisible(ActionsItemMenu, function()
                    for k,v in pairs(ESX.PlayerData.inventory) do
                        if CurrentItem.name == v.name then
                            RageUI.Separator("Item : ~b~"..v.label.."~s~ - [Quantité(s): ~r~"..v.count.."~s~]")
                            RageUI.Button("Utiliser", false , {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ActionItem.Use(v)
                                    Wait(180)
                                    RefreshPlayerData()
                                end
                            })
                            RageUI.Button("Donner", false , {RightLabel = "→"}, true , {
                                onSelected = function()
                                    ActionItem.Give(v)
                                    Wait(180)
                                    RefreshPlayerData()
                                end
                            })
                            -- RageUI.Button("Jeter", false , {RightLabel = "→"}, true , {
                            --     onSelected = function()
                            --         ActionItem.Drop(v)
                            --         Wait(180)
                            --         RefreshPlayerData() 
                            --     end
                            -- })
                        end
                    end
                end)
                RageUI.IsVisible(ActionsWeaponMenu, function()
                    for k,v in pairs(ESX.GetWeaponList()) do
                        if CurrentWeapon.name == v.name then
                            RageUI.Separator("Armes : ~b~"..v.label.."~s~ - [Munition(s): ~r~"..GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(v.name)).."~s~]")
                            RageUI.Button("Donner", false , {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ActionWeapon.Give(v)
                                    Wait(180)
                                    RageUI.GoBack()
                                    RefreshPlayerData()
                                end
                            })

                            RageUI.Button("Jeter", false , {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ActionWeapon.Drop(v)
                                    Wait(180)
                                    RageUI.GoBack()
                                    RefreshPlayerData()
                                end
                            })
                        end
                    end
                end)

                RageUI.IsVisible(RacMenu, function()

                    RageUI.Button("Menu Armes", nil , {RightLabel = "→"}, true , {
                        onSelected = function()
                        ExecuteCommand("menuarme")
                        -- RageUI.CloseAll()
                    end
                })

                RageUI.Button("Menu Vip", nil , {RightLabel = "→"}, true , {
                    onSelected = function()
                    ExecuteCommand("vip")
                    RageUI.CloseAll()
                end
            })
             
            RageUI.Button("Menu Clefs", nil , {RightLabel = "→"}, true , {
                onSelected = function()
                ExecuteCommand("+KeyMenu")
                RageUI.CloseAll()
            end
        })

                end)
                RageUI.IsVisible(WalletMenu, function()
                    RageUI.Separator("Métier : ~b~"..ESX.PlayerData.job.label.. " - " ..ESX.PlayerData.job.grade_label)
                    RageUI.Separator("Organisation : ~b~"..ESX.PlayerData.job2.label.. " - " ..ESX.PlayerData.job2.grade_label)
                    RageUI.List("Liquide: ~g~" ..ESX.PlayerData.money.."€", Config.MoneyList, Config.MoneyList.MoneyIndex, nil, {}, true, {
                        onListChange = function(Index)
                            Config.MoneyList.MoneyIndex = Index;
                        end,
                        onSelected = function (Index)
                            GestionMoney(1,Index)
                            Wait(180)
                            RefreshPlayerData()
                        end
                    })
                    RageUI.List("Argent sale: ~r~" ..ESX.PlayerData.accounts[2].money.."€", Config.MoneyList, Config.MoneyList.BlackMoneyIndex, nil, {}, true, {
                        onListChange = function(Index)
                            Config.MoneyList.BlackMoneyIndex = Index;
                        end,
                        onSelected = function (Index)
                            GestionMoney(2,Index)
                            Wait(180)
                            RefreshPlayerData()
                        end
                    })
                    RageUI.Button("Vos factures", false, {RightLabel = "→"}, true, {
                        onSelected = function()
                            RefreshFacture()
                        end
                    },BillingMenu)
                    RageUI.Button("Porte-Cartes", false, {RightLabel = "→"}, true, {},CardMenu)
                    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.Button("Gestion société", false , {RightLabel = "→"}, true , {}, GestionSocietyMenu)
                    else
                        RageUI.Button("Gestion société", false , {RightLabel = "→"}, false , {})
                    end
                    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
                        RageUI.Button("Gestion organisation", false , {RightLabel = "→"}, true , {}, GestionOrganisationMenu)
                    else
                        RageUI.Button("Gestion organisation", false , {RightLabel = "→"}, false , {})
                    end
                end)
                RageUI.IsVisible(BillingMenu, function()
                    for i=1, #Billing do
                        RageUI.Button(Billing[i].label, false, {RightLabel = "~g~"..Billing[i].amount.."€"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback('esx_billing:payBill', function()
                                end, Billing[i].id)
                                Wait(180)
                                RefreshFacture()
                            end
                        })
                    end
                end)
                RageUI.IsVisible(CardMenu, function()
                    RageUI.List("Pièce d'identité : ", Config.Card, (Config.Card.IdentityIndex or 1), false, {}, true, {
                        onListChange = function(Index)
                            Config.Card.IdentityIndex = Index
                        end,
                        onSelected = function(Index)
                            ShowCard(1, Index)
                        end
                    })
                    RageUI.List("Permis de conduire : ", Config.Card, (Config.Card.LicenseIndex or 1), false, {}, true, {
                        onListChange = function(Index)
                            Config.Card.LicenseIndex = Index
                        end,
                        onSelected = function(Index)
                            ShowCard(2, Index)
                        end
                    })
                end)

                RageUI.IsVisible(GestionSocietyMenu, function()
                    for k,v in pairs (Config.GestionSociety) do
                        RageUI.Button(v, false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                GestionSociety(1, k)
                            end
                        })
                    end
                end)

                RageUI.IsVisible(GestionOrganisationMenu, function()
                    for k,v in pairs (Config.GestionSociety) do
                        RageUI.Button(v, false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                GestionSociety(2, k)
                            end
                        })
                    end
                end)

                RageUI.IsVisible(DiversMenu, function()
                    RageUI.Button("Animations", false , {RightLabel = "→" }, true , {
                        onSelected = function()
                            F5Menu.Closed()
                            DiversMenu.Closed()
                            TriggerEvent("dp:RecieveMenu")
                        end
                    })
                    RageUI.Button("Gestion vêtements", false, {RightLabel = "→"}, true, {}, ClotheMenu)
                    RageUI.Button("Santé", false, {RightLabel = "→"}, true, {}, HealthMenu)
                    RageUI.Button("Options", false, {RightLabel = "→"}, true, {}, OptionMenu)
                end)

                RageUI.IsVisible(ClotheMenu, function()
                    for k,v in pairs (Config.ClotheList) do
                        RageUI.Button(v, false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                setUniform(k)
                            end
                        })
                    end
                end)

                RageUI.IsVisible(HealthMenu, function()
                    RageUI.SliderProgress('Faim: '..Round(Config.Hunger).."%", Config.Hunger, 100, false, {
                        ProgressBackgroundColor = { R = 255, G = 255, B = 255, A = 255 },
                        ProgressColor = { R = 218, G = 137, B = 12, A = 255 },
                    }, true, {})

                    RageUI.SliderProgress('Soif: '..Round(Config.Thirst).."%", Config.Thirst, 100, false, {
                        ProgressBackgroundColor = { R = 255, G = 255, B = 255, A = 255 },
                        ProgressColor = { R = 74, G = 165, B = 178, A = 255 },
                    }, true, {})
                end)

                RageUI.IsVisible(OptionMenu, function()
                    RageUI.Separator("[Mon ID : ~b~"..GetPlayerServerId(PlayerId()).."]")
                    RageUI.Checkbox('Enlever le GPS', false, Config.CheckboxGPS, {}, {
                        onChecked = function()
                            DisplayRadar(false)
                        end,
                        onUnChecked = function()
                            DisplayRadar(true)
                        end,
                        onSelected = function(Index)
                            Config.CheckboxGPS = Index
                        end
                    })
                    
                    RageUI.Checkbox("Hud faim / soif", false, Config.CheckboxHUD, {}, {
                        onChecked = function()
                            TriggerEvent('esx_status:setDisplay', 0.0)
                        end,
                        onUnChecked = function()
                            TriggerEvent('esx_status:setDisplay', 1.0)
                        end,
                        onSelected = function(Index)
                            Config.CheckboxHUD = Index
                        end
                    }) 
                    RageUI.Checkbox("Mode cinématique", false, Config.CheckboxCinematic, {}, {
                        onChecked = function()
                            TriggerEvent('esx_status:setDisplay', 0.0)
                            DisplayRadar(false)
                            Cinematic()
                        end,
                        onUnChecked = function()
                            TriggerEvent('esx_status:setDisplay', 1.0)
                            DisplayRadar(true)
                            Cinematic()
                        end,
                        onSelected = function(Index)
                            Config.CheckboxCinematic = Index
                        end
                    }) 
                    RageUI.Button('Se déconnecter', false, { RightLabel = "→", Color = {HightLightColor = {235, 18, 15, 150}, BackgroundColor = {38, 85, 150, 160 }}}, true, {
                        onSelected = function()
                            TriggerServerEvent("cxF5:Deconnection")
                        end
                    })
                end)
                RageUI.IsVisible(GestionVehMenu, function()
                    RageUI.Separator("Etat du moteur: ~y~".. math.floor(0.11*GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(), false))-10).."/100")
                    RageUI.List("Limitateur de vitesse : ", Config.LimitateurList, (Config.LimitateurList.LimitateurIndex or 1), false, {}, true, {
                        onListChange = function(Index)
                            Config.LimitateurList.LimitateurIndex = Index
                        end,
                        onSelected = function(Index)
                            if Index ~= 5 then
                                SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), math.floor(Config.LimitateurList[Index] / 3.6) * 1.01)
                                -- ESX.ShowNotification("Votre régulateur est réglé sur ~b~"..Config.LimitateurList[Index].." km/h")
                                exports['okokNotify']:Alert("Limitateur", "Votre régulateur est réglé sur "..Config.LimitateurList[Index].." km/h", 5000, 'info')
                            else
                                SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 1000.0/3.6)
                                -- ESX.ShowNotification("Votre régulateur c'est ~r~réinitialiser")
                                exports['okokNotify']:Alert("Limitateur", "Reset", 5000, 'info')
                            end
                        end
                    })
                    RageUI.List("Gestion des portes : ", Config.PorteList, (Config.PorteList.PorteListIndex or 1), false, {}, true, {
                        onListChange = function(Index)
                            Config.PorteList.PorteListIndex = Index
                        end,
                        onSelected = function(Index)
                            if GetVehicleDoorAngleRatio(GetVehiclePedIsIn(PlayerPedId()), Index - 1) > 0.0 then 
                                SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), Index - 1, false)
                            else
                                SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), Index - 1, false)
                            end
                        end
                    })
                end)
                Wait(0)
            end
        end)
    end
end 

Keys.Register('F5','F5', ' ', function()
    OpenF5Menu()
end)