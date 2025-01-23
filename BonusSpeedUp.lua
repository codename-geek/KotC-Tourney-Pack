function _OnInit()
	GameVersion = 0
end

function GetVersion() --Define anchor addresses
	if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
		OnPC = false
		GameVersion = 1
		print('GoA PS2 Version - Boss Bonus Speed Up')
		GamSpd = 0x0349E0C --Game Speed
		BtlTyp = 0x1C61958 --Battle Status (Out-of-Battle, Regular, Forced)
		BtlEnd = 0x1D490C0 --End-of-Battle camera & signal
	elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
		OnPC = true
		if ReadString(0x09A92F0,4) == 'KH2J' then --EGS
			GameVersion = 2
			print('GoA Epic Version (v.9) - Boss Bonus Speed Up')
			GamSpd = 0x0717214
			BtlTyp = 0x2A10E44
			BtlEnd = 0x2A0F720
		elseif ReadString(0x09A9830,4) == 'KH2J' then --Steam Global
			GameVersion = 3
			print('GoA Steam Global Version (Downpatch) - Boss Bonus Speed Up')
			GamSpd = 0x0717424
			BtlTyp = 0x2A11384
			BtlEnd = 0x2A0FC60
		elseif ReadString(0x09A8830,4) == 'KH2J' then --Steam JP
			GameVersion = 4
			print('GoA Steam JP Version (Downpatch) - Boss Bonus Speed Up')
			GamSpd = 0x0716424
			BtlTyp = 0x2A10384
			BtlEnd = 0x2A0EC60
		elseif ReadString(0x9A9330,4) == 'KH2J' then --EGS
			GameVersion = 2
			print('GoA Epic Version (v.10) - Boss Bonus Speed Up')
			GamSpd = 0x0717214
			BtlTyp = 0x2A10E84
			BtlEnd = 0x2A0F760
		elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam Global
			GameVersion = 3
			print('GoA Steam Global Version (Updated) - Boss Bonus Speed Up')
			GamSpd = 0x0717424
			BtlTyp = 0x2A11404
			BtlEnd = 0x2A0FCE0
		elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam JP (same as Global for now)
			GameVersion = 4
			print('GoA Steam JP Version (Updated) - Boss Bonus Speed Up')
			GamSpd = 0x0717424
			BtlTyp = 0x2A11404
			BtlEnd = 0x2A0FCE0
		end
	end
end

prevBtlEnd = 0
speedingUp = false
function _OnFrame()
	if GameVersion == 0 then --Get anchor addresses
		GetVersion()
		return
	end

	if (ReadByte(BtlEnd) == 4 and prevBtlEnd ~= 4 and ReadByte(BtlTyp) == 2)
	or (ReadByte(BtlEnd) == 3 and prevBtlEnd ~= 3 and ReadByte(BtlTyp) == 2) then
		--print("woot")
		speedingUp = true
		WriteFloat(GamSpd,2)
	end
	prevBtlEnd = ReadByte(BtlEnd)
	if (ReadByte(BtlTyp) ~= 2 or ReadByte(BtlEnd) == 0) and speedingUp then
		--print("no woot")
		speedingUp = false
		WriteFloat(GamSpd,1)
	end
end