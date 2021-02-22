RegisterCommand("perms", function(source, args, rawCommand)
	if args[1] ~= nil then
		if args[1]:find("^steam:" ) ~= nil then
			steam = args[1]
		else
			steam = ExtractIdentifiers(args[1])
		end
	else
		steam = ExtractIdentifiers(source)
	end
	staff = checkPerms(steam)
	donator = checkDonator(steam)
	TriggerClientEvent('chat:addMessage', source, { args = {"^2[JD_Perms]", "^1^*================== Permissions Check ===================="} })
	TriggerClientEvent('chat:addMessage', source, { args = {"^3[JD_Perms]", "PlayerID: ^1^*"..args[1].."^0 | ^rPlayerName: ^1^*"..GetPlayerName(args[1])} })
	TriggerClientEvent('chat:addMessage', source, { args = {"^4[JD_Perms]", "Staff Role: ^1^*"..staff} })
	TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Donator: ^1^*"..donator} })
	TriggerClientEvent('chat:addMessage', source, { args = {"^6[JD_Perms]", "^1^*====================================================="} })
end)

RegisterCommand("addperms", function(source, args, rawCommand)
	if source == 0 then
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
			exports.JD_logs:discord(GetPlayerName(source).." just removed "..steam.. " to the group "..args[2], source, 0, Config.JD_logsColor, Config.JD_logsChannel)
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
	------------------------------------------- admin
	admin = io.open(Config.Path..'/JD_Perms.cfg', 'r')
	fileText = admin:read('*a')
	for line in fileText:gmatch('\nadd_principal identifier.'..steam..' group.admin[^\n]*', '[^\r\n]+') do
		return "Admin"
	end
	admin:close()

	--                 This is how you can add more staff roles.
	--                 Keep in mind it will always display the highest one in this list.

	-- moderator = io.open(Config.Path..'/JD_Perms.cfg', 'r')
	-- fileText = moderator:read('*a')
	-- for line in fileText:gmatch('\nadd_principal identifier.'..steam..' group.moderator[^\n]*', '[^\r\n]+') do
	--	return "Moderator"
	-- end
	-- moderator:close()


	return "None"
end

function checkDonator(steam)	
	------------------------------------------- VIP Plus
	vipplus = io.open(Config.Path..'/JD_Perms.cfg', 'r')
	fileText = vipplus:read('*a')
	for line in fileText:gmatch('\nadd_principal identifier.'..steam..' group.vipplus[^\n]*', '[^\r\n]+') do
		return "VIP Plus"
	end
	vipplus:close()
	
	------------------------------------------- VIP
	vip = io.open(Config.Path..'/JD_Perms.cfg', 'r')
	fileText = vip:read('*a')
	for line in fileText:gmatch('\nadd_principal identifier.'..steam..' group.vip[^\n]*', '[^\r\n]+') do
		return "VIP"
	end
	vip:close()

	--                 This is how you can add more staff roles.
	--                 Keep in mind it will always display the highest one in this list.

	--anotherdonatorgroup = io.open(Config.Path..'/JD_Perms.cfg', 'r')
	--fileText = anotherdonatorgroup:read('*a')
	--for line in fileText:gmatch('\nadd_principal identifier.'..steam..' group.anotherdonatorgroup[^\n]*', '[^\r\n]+') do
	--	return "anotherdonatorgroup"
	--end
	--anotherdonatorgroup:close()

	return "N/A"
end