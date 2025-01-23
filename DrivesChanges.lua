function _OnInit()
	GameVersion = 0
	lastDriveVal = 0
end

function GetVersion()
	if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
		OnPC = false
		GameVersion = 1
		Save = 0x032BB30
		Pause = 0x0347E08
		Slot1    = 0x1C6C750
		print('GoA PS2 Version - Drive Changes')
	elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
        if ReadString(0x09A92F0,4) == 'KH2J' then --EGS
			GameVersion = 2
			Save = 0x09A92F0
			Pause = 0x0ABB2B8
			Slot1    = 0x2A22FD8
			print('GoA Epic Version (v.9) - Drive Changes')
		elseif ReadString(0x09A9830,4) == 'KH2J' then --Steam Global
			GameVersion = 3
			Save = 0x09A9830
			Pause = 0x0ABB7F8
			Slot1    = 0x2A23518
			print('GoA Steam Global Version (Downpatch) - Drive Changes')
		elseif ReadString(0x09A8830,4) == 'KH2J' then --Steam JP
			GameVersion = 4
			Save = 0x09A8830
			Pause = 0x0ABA7F8
			Slot1    = 0x2A22518
			print('GoA Steam JP Version (Downpatch) - Drive Changes')
		elseif ReadString(0x9A9330,4) == 'KH2J' then --EGS
			GameVersion = 2
			Save = 0x09A9330
			Pause = 0x0ABB2F8
			Slot1    = 0x2A23018
			print('GoA Epic Version (v.10) - Drive Changes')
		elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam Global
			GameVersion = 3
			Save = 0x09A98B0
			Pause = 0x0ABB878
			Slot1    = 0x2A23598
			print('GoA Steam Global Version (Updated) - Drive Changes')
		elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam JP (same as Global for now)
			GameVersion = 4
			Save = 0x09A98B0
			Pause = 0x0ABB878
			Slot1    = 0x2A23598
			print('GoA Steam JP Version (Updated) - Drive Changes')
		end
    end
end

function _OnFrame()
	if GameVersion == 0 then --Get anchor addresses
		GetVersion()
		return
	end

	--Check if Drive is decreasing
	if ReadFloat(Slot1+0x1B4) ~= lastDriveVal then
		--ConsolePrint("Decreasing")
		--Limit
		if ReadByte(Save+0x3524) == 3 and ReadByte(Pause) ~= 3 then
			WriteFloat(Slot1+0x1B4,ReadFloat(Slot1+0x1B4)-0.20)
		--Final
		elseif ReadByte(Save+0x3524) == 5 and ReadByte(Pause) ~= 3 then
			WriteFloat(Slot1+0x1B4,ReadFloat(Slot1+0x1B4)-0.20)
		--Valor
		elseif ReadByte(Save+0x3524) == 1 and ReadByte(Pause) ~= 3 then
			WriteFloat(Slot1+0x1B4,ReadFloat(Slot1+0x1B4)+0.1)
		end
	end

	lastDriveVal = ReadFloat(Slot1+0x1B4)
end