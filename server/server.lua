RegisterCommand("perms", function(source, args, rawCommand)
	if source == 0 then
		print("^1Error: This command can't be used in console.^0")
		return
	end
	if args[1] ~= nil then
		if args[1]:find("^steam:" ) ~= nil then
			steam = args[1]
		else
			steam = ExtractIdentifiers(args[1])
		end
		id = args[1]
	else
		steam = ExtractIdentifiers(source)
		id = source
	end
	staff = checkPerms(steam)
	donator = checkDonator(steam)
	TriggerClientEvent('chat:addMessage', source, { args = {"^2[JD_Perms]", "^1^*================== Permissions Check ===================="} })
	TriggerClientEvent('chat:addMessage', source, { args = {"^3[JD_Perms]", "PlayerID: ^1^*"..id.."^0 | ^rPlayerName: ^1^*"..GetPlayerName(id)} })
	TriggerClientEvent('chat:addMessage', source, { args = {"^4[JD_Perms]", "Staff Role: ^1^*"..staff} })
	TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Donator: ^1^*"..donator} })
	TriggerClientEvent('chat:addMessage', source, { args = {"^6[JD_Perms]", "^1^*====================================================="} })
end)

RegisterCommand("addperms", function(source, args, rawCommand)
	if source == 0 then
		if args[1] == nil then
			print("^1Error: Please use addperms [id] [group] [Name/Comments].^0")
			return
		end
		if args[3] == nil then
			print("^1Error: Please use addperms [id] [group] [Name/Comments].^0")
			return
		end
		if args[3] == nil then
			print("^1Error: Please use addperms [id] [group] [Name/Comments].^0")
			return
		end
		if args[1] ~= nil then
			if args[1]:find("^steam:" ) ~= nil then
				steam = args[1]
			else
				steam = ExtractIdentifiers(args[1])
			end
		end
		file = io.open(Config.Path..'/JD_Perms.cfg', 'a')
		io.output(file)
		local data = "\nadd_principal identifier."..steam.." group."..args[2].. "  #".. args[3]
		io.write(data)
  		io.close(file)
		ExecuteCommand("add_principal identifier."..steam.." group."..args[2].."")
		print("^5[JD_Perms] Permissions updated!")
		return
	else
		if IsPlayerAceAllowed(source, Config.AdminPerm) then	
			if args[1] ~= nil then
				if args[1]:find("^steam:" ) ~= nil then
					steam = args[1]
				else
					steam = ExtractIdentifiers(args[1])
				end
			end
			if args[1] ~= nil then
				if args[2] ~= nil then
					if args[3] ~= nil then
						file = io.open(Config.Path..'/JD_Perms.cfg', 'a')
						io.output(file)
						local data = "\nadd_principal identifier."..steam.." group."..args[2].. "  #".. args[3]
						io.write(data)
						  io.close(file)
						ExecuteCommand("add_principal identifier."..steam.." group."..args[2].."")
						if Config.JD_logs then
							exports.JD_logs:discord(GetPlayerName(source).." just added "..steam.. " to the group "..args[2].."\nNotes: "..args[3], source, 0, Config.JD_logsColor, Config.JD_logsChannel)
						end
						TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Permissions updated!"} })
					else
						TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Please use /addperms [id] [group] [Name/Comments]"} })		
					end
				else
					TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Please use /addperms [id] [group] [Name/Comments]"} })
				end
			else
				TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Please use /addperms [id] [group] [Name/Comments]"} })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "^1Insuficient Premissions!"} })
		end
	end
end)

RegisterCommand("delperms", function(source, args, rawCommand)
	if source == 0 then
		if args[1] == nil then
			print("^1Error: Please use delperms [id] [group].^0")
			return
		end
		if args[3] == nil then
			print("^1Error: Please use delperms [id] [group].^0")
			return
		end
		if args[1] ~= nil then
			if args[1]:find("^steam:" ) ~= nil then
				steam = args[1]
			else
				steam = ExtractIdentifiers(args[1])
			end
		end
		inFile = io.open(Config.Path..'/JD_Perms.cfg', 'r')
		fileText = inFile:read('*a')
		inFile:close()
		outText = fileText:gsub('\nadd_principal identifier.'..steam..' group.'..args[2]..'[^\n]*', '')
		outFile = io.open(Config.Path..'/JD_Perms.cfg', 'w+')
		outFile:write(outText)
		outFile:close()
		ExecuteCommand("remove_principal identifier."..steam.." group."..args[2].."")
		if Config.JD_logs then
			exports.JD_logs:discord(GetPlayerName(source).." just removed "..steam.. " from the group "..args[2], source, 0, Config.JD_logsColor, Config.JD_logsChannel)
		end
		print("^5[JD_Perms] Permissions updated!")
		return
	else
		if IsPlayerAceAllowed(source, Config.AdminPerm) then
	
			if args[1] ~= nil then
				if args[1]:find("^steam:" ) ~= nil then
					steam = args[1]
				else
					steam = ExtractIdentifiers(args[1])
				end
			end
			if args[1] ~= nil then
				if args[2] ~= nil then
					inFile = io.open(Config.Path..'/JD_Perms.cfg', 'r')
					fileText = inFile:read('*a')
					inFile:close()
					outText = fileText:gsub('\nadd_principal identifier.'..steam..' group.'..args[2]..'[^\n]*', '')
					outFile = io.open(Config.Path..'/JD_Perms.cfg', 'w+')
					outFile:write(outText)
					outFile:close()
					ExecuteCommand("remove_principal identifier."..steam.." group."..args[2].."")
					TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Updated permissions!"} })
					return
				else
					TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Please use /delperms [id] [group]"} })
					return
				end
			else
				TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Please use /delperms [id] [group]"} })
				return
			end
			TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Please use /delperms [id] [group]"} })
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "^1Insuficient Premissions!"} })
		end
	end
end)

function ExtractIdentifiers(src)
    local identifiers = { steam = "", ip = "", discord = "", license = "", xbl = "", live = "" }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        end
    end
    return identifiers.steam
end

function checkPerms(steam)
	------------------------------------------- Loop trough Staff Groups
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
	------------------------------------------- Loop trough Donator Groups
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
Citizen.CreateThread(
	function()
		local vRaw = LoadResourceFile(GetCurrentResourceName(), 'version.json')
		if vRaw and Config.versionCheck then
			local v = json.decode(vRaw)
			PerformHttpRequest(
				'https://raw.githubusercontent.com/JokeDevil/JD_Perms/master/version.json',
				function(code, res, headers)
					if code == 200 then
						local rv = json.decode(res)
						if rv.version ~= v.version then
							print(
								([[^1
-------------------------------------------------------
JD_Perms
UPDATE: %s AVAILABLE
CHANGELOG: %s
-------------------------------------------------------
^0]]):format(
									rv.version,
									rv.changelog
								)
							)
						end
					else
						print('JD_Perms unable to check version')
					end
				end,
				'GET'
			)
		end
	end
)
