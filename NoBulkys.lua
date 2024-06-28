--Set Initial Values
function _OnInit()
	GameVersion = 0
end

function GetVersion() --Define anchor addresses
	if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
		OnPC = false
		GameVersion = 1
		Now = 0x032BAE0 --Current Location
		Save = 0x032BB30 --Save File
		BtlTyp = 0x1C61958 --Battle Status (Out-of-Battle, Regular, Forced)
		Slot1    = 0x1C6C750 --Unit Slot 1
	elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
		OnPC = true
		if ReadString(0x09A92F0,4) == 'KH2J' then --EGS
			GameVersion = 2
			Now = 0x0716DF8
			Save = 0x09A92F0
			BtlTyp = 0x2A10E44
			Slot1    = 0x2A22FD8
		elseif ReadString(0x09A9830,4) == 'KH2J' then --Steam Global
			GameVersion = 3
			Now = 0x0717008
			Save = 0x09A9830
			BtlTyp = 0x2A11384
			Slot1    = 0x2A23518
		elseif ReadString(0x09A8830,4) == 'KH2J' then --Steam JP
			GameVersion = 4
			Now = 0x0716008
			Save = 0x09A8830
			BtlTyp = 0x2A10384
			Slot1    = 0x2A22518
		end
	end
end

local function BitOr(Address,Bit,Abs)
	WriteByte(Address,ReadByte(Address)|Bit,Abs and OnPC)
end
local function BitNot(Address,Bit,Abs)
	WriteByte(Address,ReadByte(Address)&~Bit,Abs and OnPC)
end

local world = 0x00
local room = 0x00
local prev_World = 0x00
local prev_Room = 0x00
local hadNoExpOn = false
local equip = false
local forceEquipped = false
function _OnFrame()
	if GameVersion == 0 then --Get anchor addresses
		GetVersion()
		return
	end

    --------Checks for Current room
	--if going to a new room
    if world ~= ReadByte(Now + 0x00) or room ~= ReadByte(Now + 0x01) then
		prev_World = world
		prev_Room = room
	end
	world = ReadByte(Now + 0x00)
	room = ReadByte(Now + 0x01)

	equip = false
	if world == 0x02 and room == 0x21 and --in Station of Calling
	    ((prev_World == 0x04 and prev_Room == 0x1A) or --GoA
	    (prev_World == 0x12 and prev_Room == 0x1B) or --Buildings
		(prev_World == 0x12 and prev_Room == 0x1C)) then --Other Buildings
		--print("In promise charm room")
		equip = true
	end


    --------Force equip no exp
    local NoExpCount = 0 --no exps equipped
    for Slot = 0,68 do
        local Current = Save + 0x2544 + 2*Slot
        local Ability = ReadShort(Current) & 0x0FFF
        local Initial = ReadShort(Current) & 0xF000 --initial increases when equipped
		--No Exp Check
        if Ability == 0x0194 then
			--if not equipped and supposed to equip
			if Initial == 0 and equip then
                WriteShort(Current,Ability+0x8000)
				--print("equipping")
				forceEquipped = true
            end
			--if already equipped not by code, do nothing
			if Initial > 0 and forceEquipped and
				prev_World == 0x02 and prev_Room == 0x21 and
				((world == 0x12 and room == 0x1B) or (world == 0x04 and room == 0x1A)) then
				WriteShort(Current,Ability)
				--print("Unequipping")
				forceEquipped = false
			end
		end
    end
	--------Force equip no exp
end