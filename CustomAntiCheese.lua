local CURRENT_LOCATION_ADDRESS = 0x0714DB8
local Save = 0x09A7070 - 0x56450E
local LUABACKEND_OFFSET = 0x56454E

local noBerserk = true
local noDoubleneg = true
local noPan = true
local usingGenie = true
local lastGenieForm = 0
local ignoreGenie = 2

--Set Initial Values for OnPC
function _OnInit()
	if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
		if ENGINE_VERSION < 3.0 then
			print('LuaEngine is Outdated. Things might not work properly.')
			return
		end
		OnPC = false
		Slot1    = 0x1C6C750 --Unit Slot 1
		BtlTyp 	 = 0x1C61958
	end
    if GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
        if ENGINE_VERSION < 5.0 then
            ConsolePrint('LuaBackend is outdated', 2)
			return
        end
		OnPC = true
		Slot1    = 0x2A20C58 - 0x56450E
		BtlTyp   = 0x2A0EAC4 - 0x56450E
		IsLoaded = 0x9B80D0 - 0x56454E
    end
end

local function read(address)
    return ReadByte(address - LUABACKEND_OFFSET)
end
local function BitOr(Address,Bit,Abs)
	WriteByte(Address,ReadByte(Address)|Bit,Abs and OnPC)
end
local function BitNot(Address,Bit,Abs)
	WriteByte(Address,ReadByte(Address)&~Bit,Abs and OnPC)
end

function _OnFrame()
    --------Checks for Current room
    local world = read(CURRENT_LOCATION_ADDRESS + 0x00)
    local room = read(CURRENT_LOCATION_ADDRESS + 0x01)
	local battle = read(CURRENT_LOCATION_ADDRESS + 0x08)

	--------Pan Check
	--if Pan is in Inventory and the custom flag isn't set, set it
	if ReadByte(Save+0x36C4)&0x20 == 0x20 and ReadByte(Save+0x3608) == 0 then
		WriteByte(Save+0x3608,ReadByte(Save+0x3608)+1)
		--ConsolePrint("Pan in inventory")
	end

	--------Superboss Room Check
	----Simulated Twilight Town
	--Data Roxas
    if world == 0x12 and room == 0x15 and battle == 0x63 then
		noBerserk = true
        noDoubleneg = true
		noPan = false
	----Twilight Town
	--Data Axel
	elseif world == 0x02 and room == 0x14 and battle == 0xD5 then
		noBerserk = true
        noDoubleneg = true
		noPan = false
	--Hollow Bastion
	--Sephiroth
	elseif world == 0x04 and room == 0x01 and battle == 0x4B then
		noBerserk = true
        noDoubleneg = false
		noPan = false
	--Data Demyx
	elseif world == 0x04 and room == 0x04 and battle == 0x72 then
		noBerserk = true
        noDoubleneg = false
		noPan = false
	----Land of Dragons
	--Data Xigbar
	elseif world == 0x12 and room == 0x0A and battle == 0x64 then
		noBerserk = true
        noDoubleneg = false
		noPan = false
	----Beast's Castle
	--Data Xaldin
	elseif world == 0x05 and room == 0x0F and battle == 0x61 then
		noBerserk = true
        noDoubleneg = false
		noPan = false
	--Olympus Coliseum
	--AS Zexion
	elseif world == 0x04 and room == 0x22 and battle == 0x97 then
		noBerserk = true
        noDoubleneg = false
		noPan = false
	--Data Zexion
	elseif world == 0x04 and room == 0x22 and battle == 0x98 then
		noBerserk = true
        noDoubleneg = false
		noPan = false
	----Disney Castle
	--AS Marluxia
	elseif world == 0x04 and room == 0x26 and battle == 0x91 then
		noBerserk = true
        noDoubleneg = true
		noPan = true
	--Data Marluxia
	elseif world == 0x04 and room == 0x26 and battle == 0x96 then
		noBerserk = true
        noDoubleneg = true
		noPan = true
	--Terra
	elseif world == 0x0C and room == 0x07 and battle == 0x43 then
		noBerserk = true
        noDoubleneg = true
		noPan = true
	--Terra Refight
	elseif world == 0x0C and room == 0x07 and battle == 0x49 then
		noBerserk = true
        noDoubleneg = true
		noPan = true
	----Port Royal
	--Data Luxord
	elseif world == 0x12 and room == 0x0E and battle == 0x65 then
		noBerserk = true
        noDoubleneg = false
		noPan = false
	----Agrabah
	--AS Lexaeus
	elseif world == 0x04 and room == 0x21 and battle == 0x8E then
		noBerserk = true
        noDoubleneg = true
		noPan = true
	--Data Lexaeus
	elseif world == 0x04 and room == 0x21 and battle == 0x93 then
		noBerserk = true
        noDoubleneg = true
		noPan = true
	----Halloween Town
	--AS Vexen
	elseif world == 0x04 and room == 0x20 and battle == 0x73 then
		noBerserk = true
        noDoubleneg = false
		noPan = false
	--Data Vexen
	elseif world == 0x04 and room == 0x20 and battle == 0x92 then
		noBerserk = true
        noDoubleneg = false
		noPan = false
	----Pride Lands
	--Data Saix
	elseif world == 0x12 and room == 0x0F and battle == 0x66 then
		noBerserk = true
        noDoubleneg = true
		noPan = true
	----Space Paranoids
	--AS Larxene
	elseif world == 0x04 and room == 0x21 and battle == 0x8F then
		noBerserk = true
        noDoubleneg = true
		noPan = true
	--Data Larxene
	elseif world == 0x04 and room == 0x21 and battle == 0x94 then
		noBerserk = true
        noDoubleneg = true
		noPan = true
	----The World That Never Was
	--Data Xemnas 1
	elseif world == 0x12 and room == 0x13 and battle == 0x61 then
		noBerserk = false
        noDoubleneg = false
		noPan = false
	--Data Final Xemnas
	elseif world == 0x12 and room == 0x14 and battle == 0x62 then
		noBerserk = false
        noDoubleneg = false
		noPan = false
    --Base Case
    else
        noBerserk = false
        noDoubleneg = false
		noPan = false
    end

    --------Force unequip All Berserk and Both negative combos if 2 are equipped
    local NegativeComboCount = 0
    for Slot = 0,68 do
        local Current = Save + 0x2544 + 2*Slot
        local Ability = ReadShort(Current) & 0x0FFF
        local Initial = ReadShort(Current) & 0xF000
		--Negative Combo Check
        if Ability == 0x018A and noDoubleneg then
            if Initial > 0 then --Initially equipped
                NegativeComboCount = NegativeComboCount + 1
            end
            if NegativeComboCount > 1 then --Unequip all Negative Combo except one
				ConsolePrint("Removing One Negative Combo")
                WriteShort(Current,Ability)
            end
		--Berserk Charge Check
        elseif Ability == 0x018B and noBerserk and Initial > 0 then
            WriteShort(Current,Ability)
			ConsolePrint("Removing Berserk Charge")
		--Hori Slash w/ Genie Check
		elseif Ability == 0x010F and noBerserk and false then
			--if genie is ever summoned, remove hori
			if ReadByte(Save+0x3525) == 2 then
				WriteShort(Current,Ability)
			else
				--Restore hori immediately
				if ReadByte(Save+0x35C8) == 1 then
					WriteShort(Current,Ability+0x8000)
				end

				--track hori equipped state
				if Initial > 0 then
					WriteByte(Save+0x35C8,1) -- hori initially equipped
				else
					WriteByte(Save+0x35C8,0)
				end
			end
        end
    end

	--------Force Remove Pan from Summon Menu if noPan
	if noPan then
		BitNot(Save+0x36C4,0x020)
	--Give Pan back if the player should have pan outside a boss
	elseif ReadByte(Save+0x35C7) > 0 and not noPan then
		BitOr(Save+0x36C4,0x020)
	end

	--------Genie Hori "Nerf"
	--When genie is summoned for the first time, record initial form and run once
	if ReadByte(Save+0x3525) == 2 and not usingGenie then
		usingGenie = true
		lastGenieForm = ReadByte(Save+0x3527)
		ConsolePrint("Summoned Genie!")
	end
	--If genie is out and the form changes,
	--Remove 1 full drive meter
	if ReadByte(Save+0x3527) ~= lastGenieForm and ReadByte(Save+0x3525) == 2 then
		lastGenieForm = ReadByte(Save+0x3527)
		if ReadByte(Save+0x3527) ~= 0 then
			--ignore first 2 genie swaps
			--first genie swap is technically cause of the code
			if ignoreGenie > 1 then
				ignoreGenie = ignoreGenie - 1
				return
			--the second swap is the manual swap
			--only in combat
			elseif ignoreGenie > 0 and ReadByte(BtlTyp) ~= 0 then
				ignoreGenie = ignoreGenie - 1
				return
			end
			--only subtract drive when in Combat
			if ReadByte(BtlTyp) ~= 0 then
				WriteFloat(Slot1+0x1B4,ReadFloat(Slot1+0x1B4)-600)
			end
			--ConsolePrint("Changed forms!")
		end
	end
	--Always rewrite to the address of the current form 0
	--The form still behaves as normal since the game overwrites this every frame
	if ReadByte(Save+0x3525) == 2 and usingGenie and ReadByte(IsLoaded) ~= 0x00 then
		WriteByte(Save+0x3527,0)
	--When in a load and Genie is out, give back the freebies
	elseif ReadByte(Save+0x3525) == 2 and usingGenie then
		ignoreGenie = 2
	else
		usingGenie = false
		ignoreGenie = 2
		--ConsolePrint("Dismissed Genie!")
	end
end