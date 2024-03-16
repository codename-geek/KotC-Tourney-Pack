local CURRENT_LOCATION_ADDRESS = 0x0714DB8
local Save = 0x09A7070 - 0x56450E

local noBerserk = true
local noDoubleneg = true

function _OnFrame()
    ------------------------------------------------------------------------
	--Checks for Current room
    local world = read(CURRENT_LOCATION_ADDRESS + 0x00)
    local room = read(CURRENT_LOCATION_ADDRESS + 0x01)
	local battle = read(CURRENT_LOCATION_ADDRESS + 0x08)

	--Simulated Twilight Town
	--Data Roxas
    if world == 0x12 and room == 0x15 and battle == 0x63 then
		noBerserk = true
        noDoubleneg = true

	--Twilight Town
	--Data Axel
	elseif world == 0x02 and room == 0x14 and battle == 0xD5 then
		noBerserk = true
        noDoubleneg = true

	--Hollow Bastion
	--Sephiroth
	elseif world == 0x04 and room == 0x01 and battle == 0x4B then
		noBerserk = true
        noDoubleneg = false
	--Data Demyx
	elseif world == 0x04 and room == 0x04 and battle == 0x72 then
		noBerserk = true
        noDoubleneg = false
	
	--Land of Dragons
	--Data Xigbar
	elseif world == 0x12 and room == 0x0A and battle == 0x64 then
		noBerserk = true
        noDoubleneg = false

	--Beast's Castle
	--Data Xaldin
	elseif world == 0x05 and room == 0x0F and battle == 0x61 then
		noBerserk = true
        noDoubleneg = false
	
	--Olympus Coliseum
	--AS Zexion
	elseif world == 0x04 and room == 0x22 and battle == 0x97 then
		noBerserk = true
        noDoubleneg = false
	--Data Zexion
	elseif world == 0x04 and room == 0x22 and battle == 0x98 then
		noBerserk = true
        noDoubleneg = false
	
	--Disney Castle
	--AS Marluxia
	elseif world == 0x04 and room == 0x26 and battle == 0x91 then
		noBerserk = true
        noDoubleneg = true
	--Data Marluxia
	elseif world == 0x04 and room == 0x26 and battle == 0x96 then
		noBerserk = true
        noDoubleneg = true
	--Terra
	elseif world == 0x0C and room == 0x07 and battle == 0x43 then
		noBerserk = true
        noDoubleneg = true
	--Terra Refight
	elseif world == 0x0C and room == 0x07 and battle == 0x49 then
		noBerserk = true
        noDoubleneg = true
	
	--Port Royal
	--Data Luxord
	elseif world == 0x12 and room == 0x0E and battle == 0x65 then
		noBerserk = true
        noDoubleneg = false

	--Agrabah
	--AS Lexaeus
	elseif world == 0x04 and room == 0x21 and battle == 0x8E then
		noBerserk = true
        noDoubleneg = true
	--Data Lexaeus
	elseif world == 0x04 and room == 0x21 and battle == 0x93 then
		noBerserk = true
        noDoubleneg = true

	--Halloween Town
	--AS Vexen
	elseif world == 0x04 and room == 0x20 and battle == 0x73 then
		noBerserk = true
        noDoubleneg = false
	--Data Vexen
	elseif world == 0x04 and room == 0x20 and battle == 0x92 then
		noBerserk = true
        noDoubleneg = false

	--Pride Lands
	--Data Saix
	elseif world == 0x12 and room == 0x0F and battle == 0x66 then
		noBerserk = true
        noDoubleneg = true

	--Space Paranoids
	--AS Larxene
	elseif world == 0x04 and room == 0x21 and battle == 0x8F then
		noBerserk = true
        noDoubleneg = true
	--Data Larxene
	elseif world == 0x04 and room == 0x21 and battle == 0x94 then
		noBerserk = true
        noDoubleneg = true

    --Base Case
    else
        noBerserk = false
        noDoubleneg = false
    end

    --Force unequip All Berserk and Both negative combos if 2 are equipped
    local NegativeComboCount = 0
    for Slot = 0,68 do
        local Current = Save + 0x2544 + 2*Slot
        local Ability = ReadShort(Current) & 0x0FFF
        local Initial = ReadShort(Current) & 0xF000
        if Ability == 0x018A and noDoubleneg then --Negative Combo
            if Initial > 0 then --Initially equipped
                NegativeComboCount = NegativeComboCount + 1
            end
            if NegativeComboCount > 1 then --Unequip all Negative Combo except one
                WriteShort(Current,Ability)
            end
        elseif Ability == 0x018B and canBerserk then --Berserk Charge
            WriteShort(Current,Ability)
        end
    end
end