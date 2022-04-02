--[[
    #####################################################################
    #                _____           __          _                      #
    #               |  __ \         / _|        | |                     #
    #               | |__) | __ ___| |_ ___  ___| |__                   #
    #               |  ___/ '__/ _ \  _/ _ \/ __| '_ \                  #
    #               | |   | | |  __/ ||  __/ (__| | | |                 #
    #               |_|   |_|  \___|_| \___|\___|_| |_|                 #
    #                                                                   #
    #                       JD_Perms By Prefech                         #
    #                         www.prefech.com                           #
    #                                                                   #
    #####################################################################
]]

RegisterCommand("perms", function(source, args, rawCommand)
	if args[1] ~= nil then
		if source == 0 then
			if args[1]:find("^steam:" ) ~= nil then
				steam = args[1]
			else
				steam = ExtractIdentifiers(args[1])
			end
			id = args[1]
			staff = checkPerms(steam)
			donator = checkDonator(steam)
			print(([[^1^*================== Permissions Check ====================")
PlayerID:^1^* %s ^0| ^rPlayerName:^1^* %s
Staff Role:^1^* %s
Donator:^1^* %s
^1^*=====================================================^0^r]]):format(id, GetPlayerName(id), staff, steam))
		end
		if args[1]:find("^steam:" ) ~= nil then
			steam = args[1]
		else
			steam = ExtractIdentifiers(args[1])
		end
		id = args[1]
		staff = checkPerms(steam)
		donator = checkDonator(steam)
		ChatAddMessage(source, "^1^*================== Permissions Check ====================")
		ChatAddMessage(source, "PlayerID: ^1^*"..id.."^0 | ^rPlayerName: ^1^*"..GetPlayerName(id))
		ChatAddMessage(source, "Staff Role: ^1^*"..staff)
		ChatAddMessage(source, "Donator: ^1^*"..donator)
		ChatAddMessage(source, "^1^*=====================================================")
	else
		InvalidArgs(source, rawCommand)
	end
end)

RegisterCommand("addperms", function(source, args, rawCommand)
	if args[3] ~= nil then
		if source == 0 then
			if args[1]:find("^steam:" ) ~= nil then
				steam = args[1]
			else
				steam = ExtractIdentifiers(args[1])
			end
			AddToFile(steam, args[2], args[3])
			creatLog("Console just added "..steam.. " to the group "..args[2].."\nNotes: "..args[3], 0)
			print("^5[JD_Perms] Permissions updated!")
		else
			if IsPlayerAceAllowed(source, Config.AdminPerm) then
				if args[1]:find("^steam:" ) ~= nil then
					steam = args[1]
				else
					steam = ExtractIdentifiers(args[1])
				end
				AddToFile(steam, args[2], args[3])
				creatLog(GetPlayerName(source).." just added "..steam.. " to the group "..args[2].."\nNotes: "..args[3], source)
				ChatAddMessage(source, "Permissions updated!")
			else
				ChatAddMessage(source, "^1Insuficient Premissions!")
			end
		end
	else
		InvalidArgs(source, rawCommand)
	end
end)

RegisterCommand("delperms", function(source, args, rawCommand)
	if args[2] ~= nil then
		if source == 0 then
			if args[1]:find("^steam:" ) ~= nil then
				steam = args[1]
			else
				steam = ExtractIdentifiers(args[1])
			end
			RemoveFromFile(steam, args[2])
			creatLog("Console just removed "..steam.." from the group "..args[2], 0)
			print("^5[JD_Perms] Permissions updated!")
		else
			if IsPlayerAceAllowed(source, Config.AdminPerm) then
				if args[1]:find("^steam:" ) ~= nil then
					steam = args[1]
				end
				RemoveFromFile(steam, args[2])
				creatLog(GetPlayerName(source).." just removed "..steam.." from the group "..args[2], source)
				ChatAddMessage(source, "Updated permissions!")
			else
				ChatAddMessage(source, "^1Insuficient Premissions!")
			end
		end
	else
		InvalidArgs(source, rawCommand)
	end
end)

function ChatAddMessage(id, msg)
	TriggerClientEvent('chat:addMessage', id, { args = {"^5[JD_Perms]", msg }})
end

local commands = {
	["perms"] = "Please use /perms [id]",
	["addperms"] = "Please use /addperms [id] [group] [Name/Comments]",
	["delperms"] = "Please use /delperms [id] [group]"
}

function InvalidArgs(id, rawCommand)
	for k,v in pairs(commands) do
		if string.find(rawCommand ,k) then
			if id == 0 then
				print(v)
				return
			else
				TriggerClientEvent('chat:addMessage', id, { args = {"^5[JD_Perms]", v }})
				return
			end
		end
	end
end

function AddToFile(steam, group, notes)
	file = io.open(Config.Path..'/JD_Perms.cfg', 'a')
	io.output(file)
	local data = "\nadd_principal identifier."..steam.." group."..group.. "  #".. notes
	io.write(data)
	io.close(file)
	ExecuteCommand("add_principal identifier."..steam.." group."..group.."")
end

function RemoveFromFile(steam, group)
	inFile = io.open(Config.Path..'/JD_Perms.cfg', 'r')
	fileText = inFile:read('*a')
	inFile:close()
	outText = fileText:gsub('\nadd_principal identifier.'..steam..' group.'..group..'[^\n]*', '')
	outFile = io.open(Config.Path..'/JD_Perms.cfg', 'w+')
	outFile:write(outText)
	outFile:close()
	ExecuteCommand("remove_principal identifier."..steam.." group."..group.."")
end

function creatLog(message, id)
	if GetResourceState('JD_logs') == "started" and Config.JD_logs then
		args = {
			EmbedMessage = message,
			color = Config.JD_logsColor,
			channel = Config.JD_logsChannel
		}
		if id ~= 0 then
			args['player_id'] = id
		end
		exports.JD_logs:createLog(args)
	end
end

function ExtractIdentifiers(src)
    local identifiers = { steam = "", ip = "", discord = "", license = "", xbl = "", live = "" }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam:") then
            identifiers.steam = id
        end
    end
    return identifiers.steam
end

function checkPerms(steam)
	local group = '0'
	for i = 1, #Config.StaffGroups do
		file = io.open(Config.Path..'/JD_Perms.cfg', 'r')
		fileText = file:read('*a')
		for line in fileText:gmatch('\nadd_principal identifier.'..steam..' group.'..Config.StaffGroups[i]:lower()..'[^\n]*', '[^\r\n]+') do
			if group == '0' then
				group = Config.StaffGroups[i]
			end
		end
		file:close()
  	end
	  if group ~= '0' then
		return group
	  else
		return "N/A"
	  end
end

function checkDonator(steam)
	local group = '0'
	for i = 1, #Config.DonatorGroups do
		file = io.open(Config.Path..'/JD_Perms.cfg', 'r')
		fileText = file:read('*a')
		for line in fileText:gmatch('\nadd_principal identifier.'..steam..' group.'..Config.DonatorGroups[i]:lower()..'[^\n]*', '[^\r\n]+') do
			if group == '0' then
			group = Config.DonatorGroups[i]
		end
		end
		file:close()
	end
	if group ~= '0' then
		return group
	else
		return "N/A"
	end
end

-- version check
Citizen.CreateThread(function()
	local vRaw = LoadResourceFile(GetCurrentResourceName(), 'version.json')
	if vRaw and Config.versionCheck then
		local v = json.decode(vRaw)
		PerformHttpRequest('https://raw.githubusercontent.com/JokeDevil/JD_Perms/master/version.json', function(code, res, headers)
			if code == 200 then
				local rv = json.decode(res)
				if rv.version ~= v.version then
					print(([[^1-------------------------------------------------------
JD_Perms
UPDATE: %s AVAILABLE
CHANGELOG: %s
-------------------------------------------------------^0]]):format(rv.version,rv.changelog))
				end
			else
				print('JD_Perms unable to check version')
			end
		end,'GET')
	end
end)