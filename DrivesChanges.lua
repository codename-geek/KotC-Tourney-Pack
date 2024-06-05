local canExecute = false

function _OnInit()
    if GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
        if ENGINE_VERSION < 5.0 then
            ConsolePrint('LuaBackend is outdated', 2)
			return
        end
		Slot1    = 0x2A20C58 - 0x56450E
		Pause 	 = 0xBEBD28 - 0x56454E

		canExecute = true
    end
end

function _OnFrame()
	if canExecute == false then
		return
	end

	--Limit
	if ReadByte(Save+0x3524) == 3 and ReadByte(Pause) ~= 3 then
		WriteFloat(Slot1+0x1B4,ReadFloat(Slot1+0x1B4)-0.25)
	--Final
	elseif ReadByte(Save+0x3524) == 5 and ReadByte(Pause) ~= 3 then
		WriteFloat(Slot1+0x1B4,ReadFloat(Slot1+0x1B4)-0.25)
	--Valor
	elseif ReadByte(Save+0x3524) == 1 and ReadByte(Pause) ~= 3 then
		WriteFloat(Slot1+0x1B4,ReadFloat(Slot1+0x1B4)+0.1)
	end
end