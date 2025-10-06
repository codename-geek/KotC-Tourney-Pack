local world = 0
local room = 0
local battle = 0

local noBerserk = true
local noDoubleneg = true
local noSingleneg = true
local noPan = true

local usingGenie = true
local lastGenieForm = 0
local realForm = 0
local ignoreGenie = 1
local lastDriveMeter = 0

--Set Initial Values
function _OnInit()
	GameVersion = 0
end

function GetVersion() --Define anchor addresses
	if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
		OnPC = false
		print('GoA PS2 Version - Geek Anti-Cheese not loading')
	elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
		OnPC = true
		if ReadString(0x09A92F0,4) == 'KH2J' then --EGS
			GameVersion = 2
			Now = 0x0716DF8
			Save = 0x09A92F0
			BtlTyp = 0x2A10E44
			Slot1 = 0x2A22FD8
			IsLoaded = 0x09BA310
			print('GoA Epic Version - Geek Anti-Cheese')
		elseif ReadString(0x09A9830,4) == 'KH2J' then --Steam Global
			GameVersion = 3
			Now = 0x0717008
			Save = 0x09A9830
			BtlTyp = 0x2A11384
			Slot1 = 0x2A23518
			IsLoaded = 0x09BA850
			print('GoA Steam Global Version - Geek Anti-Cheese')
		elseif ReadString(0x09A8830,4) == 'KH2J' then --Steam JP
			GameVersion = 4
			Now = 0x0716008
			Save = 0x09A8830
			BtlTyp = 0x2A10384
			Slot1 = 0x2A22518
			IsLoaded = 0x09B9850
			print('GoA Steam JP Version - Geek Anti-Cheese')
		elseif ReadString(0x9A9330,4) == 'KH2J' then --EGS
			GameVersion = 2
			Now = 0x0716DF8
			Save = 0x09A9330
			BtlTyp = 0x2A10E84
			Slot1    = 0x2A23018
			IsLoaded = 0x9BA350
			print('GoA Epic Version (v.10) - Geek Anti-Cheese')
		elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam Global
			GameVersion = 3
			Now = 0x0717008
			Save = 0x09A98B0
			BtlTyp = 0x2A11404
			Slot1    = 0x2A23598
			IsLoaded = 0x9BA8D0
			print('GoA Steam Global Version (Updated) - Geek Anti-Cheese')
		elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam JP (same as Global for now)
			GameVersion = 4
			Now = 0x0717008
			Save = 0x09A98B0
			BtlTyp = 0x2A11404
			Slot1    = 0x2A23598
			IsLoaded = 0x9BA8D0
			print('GoA Steam JP Version (Updated) - Geek Anti-Cheese')
		end
	end
end

function BitOr(Address,Bit,Abs)
	WriteByte(Address,ReadByte(Address)|Bit,Abs and OnPC)
end
function BitNot(Address,Bit,Abs)
	WriteByte(Address,ReadByte(Address)&~Bit,Abs and OnPC)
end

function _OnFrame()
	--Get anchor addresses
	if GameVersion == 0 then
		GetVersion()
		return
	end

    RoomCheck()
	RemoveAbilities()
	RemovePan()
	GenieNerf()
end

function RoomCheck()
	world = ReadByte(Now + 0x00)
	room = ReadByte(Now + 0x01)
	battle = ReadByte(Now + 0x08)
	--------Superboss Room Check
	----Simulated Twilight Town
	--Data Roxas
	if world == 0x12 and room == 0x15 and battle == 0x63 then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = true
		noPan = false
	----Twilight Town
	--Data Axel
	elseif world == 0x02 and room == 0x14 and battle == 0xD5 then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = false
		noPan = false
	--Hollow Bastion
	--Sephiroth
	elseif world == 0x04 and room == 0x01 and battle == 0x4B then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Data Demyx
	elseif world == 0x04 and room == 0x04 and battle == 0x72 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = true
	----Land of Dragons
	--Data Xigbar
	elseif world == 0x12 and room == 0x0A and battle == 0x64 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	----Beast's Castle
	--Xaldin
	elseif world == 0x05 and room == 0x0F and battle == 0x52 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Data Xaldin
	elseif world == 0x05 and room == 0x0F and battle == 0x61 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Olympus Coliseum
	--Hades
	elseif world == 0x06 and room == 0x13 and battle == 0xCA then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = true
	--AS Zexion
	elseif world == 0x04 and room == 0x22 and battle == 0x97 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Data Zexion
	elseif world == 0x04 and room == 0x22 and battle == 0x98 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	----Disney Castle
	--AS Marluxia
	elseif world == 0x04 and room == 0x26 and battle == 0x91 then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = false
		noPan = true
	--Data Marluxia
	elseif world == 0x04 and room == 0x26 and battle == 0x96 then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = false
		noPan = true
	--Terra
	elseif world == 0x0C and room == 0x07 and battle == 0x43 then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = true
		noPan = true
	----Port Royal
	--Grim Reaper 1
	elseif world == 0x10 and room == 0x12 and battle == 0x55 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Grim Reaper 2
	elseif world == 0x10 and room == 0x01 and battle == 0x36 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Data Luxord
	elseif world == 0x12 and room == 0x0E and battle == 0x65 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	----Agrabah
	--AS Lexaeus
	elseif world == 0x04 and room == 0x21 and battle == 0x8E then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = false
		noPan = true
	--Data Lexaeus
	elseif world == 0x04 and room == 0x21 and battle == 0x93 then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = false
		noPan = true
	----Halloween Town
	--AS Vexen
	elseif world == 0x04 and room == 0x20 and battle == 0x73 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Data Vexen
	elseif world == 0x04 and room == 0x20 and battle == 0x92 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	----Pride Lands
	--Data Saix
	elseif world == 0x12 and room == 0x0F and battle == 0x66 then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = true
		noPan = true
	----Space Paranoids
	--AS Larxene
	elseif world == 0x04 and room == 0x21 and battle == 0x8F then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = false
		noPan = true
	--Data Larxene
	elseif world == 0x04 and room == 0x21 and battle == 0x94 then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = false
		noPan = true
	----The World That Never Was
	--Roxas
	elseif world == 0x12 and room == 0x15 and battle == 0x41 then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = true
		noPan = false
	--Xigbar
	elseif world == 0x12 and room == 0x0A and battle == 0x39 then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Luxord
	elseif world == 0x12 and room == 0x0E and battle == 0x3A then
		noBerserk = true
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Saix
	elseif world == 0x12 and room == 0x0F and battle == 0x38 then
		noBerserk = true
		noDoubleneg = true
		noSingleneg = true
		noPan = true
	--Xemnas 1
	elseif world == 0x12 and room == 0x13 and battle == 0x3B then
		noBerserk = false
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Data Xemnas 1
	elseif world == 0x12 and room == 0x13 and battle == 0x61 then
		noBerserk = false
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Data Final Xemnas
	elseif world == 0x12 and room == 0x14 and battle == 0x62 then
		noBerserk = false
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	--Base Case
	else
		noBerserk = false
		noDoubleneg = false
		noSingleneg = false
		noPan = false
	end
end

function RemoveAbilities()
	local NegativeComboCount = 0
	for Slot = 0,68 do
		local Current = Save + 0x2544 + 2*Slot
		local Ability = ReadShort(Current) & 0x0FFF
		local Initial = ReadShort(Current) & 0xF000
		--Negative Combo Check
		if Ability == 0x018A then
			if Initial > 0 then --Initially equipped
				NegativeComboCount = NegativeComboCount + 1
			end
			if NegativeComboCount > 1 and noDoubleneg then --Unequip one Negative Combo
				print("Removing One Negative Combo")
				WriteShort(Current,Ability)
			end
			if NegativeComboCount > 0 and noSingleneg then --Unequip one Negative Combo
				print("Removing Both Negative Combos")
				WriteShort(Current,Ability)
			end 
		--Berserk Charge Check
		elseif Ability == 0x018B and noBerserk and Initial > 0 then
			WriteShort(Current,Ability)
			print("Removing Berserk Charge")
		end
	end
end

function RemovePan()
	--if Pan is in Inventory and the custom flag isn't set, set it
	if ReadByte(Save+0x36C4)&0x20 == 0x20 and ReadByte(Save+0x3609) == 0 then
		WriteByte(Save+0x3609,ReadByte(Save+0x3609)+1)
		--print("Pan in inventory")
	end
	--Remove Pan from Inventory if noPan Cheese
	if noPan and ReadByte(Save+0x36C4)&0x20 == 0x20 then
		--print("Removing Pan")
		BitNot(Save+0x36C4,0x020)
	--Give Pan back if the player had Pan outside of the boss
	elseif ReadByte(Save+0x3609) > 0 and not noPan and ReadByte(Save+0x36C4)&0x20 == 0 then
		--print("Adding Back Pan")
		BitOr(Save+0x36C4,0x020)
	end
end

function GenieNerf()
	--When Genie is dismissed, reset
	if usingGenie and ReadByte(Save+0x3525) ~= 2 then
		usingGenie = false
		lastGenieForm = 0
		ignoreGenie = 1
		realForm = 0
		WriteByte(Save+0x3527,0)
		--print("Dismissed Genie!")
	end
	if ReadByte(Save+0x3525) ~= 2 then
		return
	end
	--Record every Genie Form Change here
	if usingGenie and lastGenieForm == 0 and ReadByte(Save+0x3527) ~= 0 then
		realForm = ReadByte(Save+0x3527)
		--print(realForm)
	end
	--if genie is summoned for the first time, record initial form
	if ReadByte(Save+0x3525) == 2 and not usingGenie then
		usingGenie = true
		ignoreGenie = 1
		realForm = ReadByte(Save+0x3527)
		lastGenieForm = ReadByte(Save+0x3527)
		lastDriveMeter = ReadFloat(Slot1+0x1B4)
		--print("Summoned Genie!")
	end
	--if genie is out and the form changed, do something
	if usingGenie and ReadByte(Save+0x3527) ~= lastGenieForm then
		lastGenieForm = ReadByte(Save+0x3527)
		if ReadByte(Save+0x3527) ~= 0 then
			--ignore first swap
			if ignoreGenie > 0 and ReadByte(BtlTyp) ~= 0 then
				ignoreGenie = ignoreGenie - 1
				return
			end
			--only subtract drive when in Combat
			if ignoreGenie == 0 and ReadByte(BtlTyp) ~= 0 then
				WriteFloat(Slot1+0x1B4,ReadFloat(Slot1+0x1B4)-600)
			end
			--print("Changed forms!")
		end
	end
	--Overwrite the address the form is stored in (doesn't break game)
	if ReadByte(IsLoaded) ~= 0x00 then
		WriteByte(Save+0x3527,0)
	elseif ReadByte(IsLoaded) == 0x00 then
		WriteByte(Save+0x3527,realForm)
		ignoreGenie = 1
	end
	--Reset Freebie Swaps when not in combat
	if usingGenie and ReadByte(BtlTyp) == 0 then
		ignoreGenie = 1
	end
	--if genie is out and the drive meter has not gone down, you know genie is loading
	if ReadByte(Save+0x3525) == 2 and lastDriveMeter == ReadFloat(Slot1+0x1B4) then
		--print(ReadFloat(Slot1+0x1B4))
		lastDriveMeter = ReadFloat(Slot1+0x1B4)
		WriteByte(Save+0x3527,realForm)
		--print("Genie loading")
	end
end