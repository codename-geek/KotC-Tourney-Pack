function _OnInit()
GameVersion = 0
print('GoA v1.54 - Codename_Geek Final Fights Unlocker')
GoAOffset = 0x7C
SeedCleared = false
end

function GetVersion() --Define anchor addresses
if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
	OnPC = false
	GameVersion = 1
	print('GoA PS2 Version')
	Now = 0x032BAE0 --Current Location
	Sve = 0x1D5A970 --Saved Location
	Save = 0x032BB30 --Save File
	Obj0Pointer = 0x1D5BA10 --00objentry.bin Pointer Address
	Sys3Pointer = 0x1C61AF8 --03system.bin Pointer Address
	Btl0Pointer = 0x1C61AFC --00battle.bin Pointer Address
	ARDPointer  = 0x034ECF4 --ARD Pointer Address
	Music = 0x0347D34 --Background Music
	Pause = 0x0347E08 --Ability to Pause
	React = 0x1C5FF4E --Reaction Command
	Cntrl = 0x1D48DB8 --Sora Controllable
	Timer = 0x0349DE8
	Songs = 0x035DAC4 --Atlantica Stuff
	GScre = 0x1F8039C --Gummi Score
	GMdal = 0x1F803C0 --Gummi Medal
	GKill = 0x1F80856 --Gummi Kills
	CamTyp = 0x0348750 --Camera Type
	GamSpd = 0x0349E0C --Game Speed
	CutNow = 0x035DE20 --Cutscene Timer
	CutLen = 0x035DE28 --Cutscene Length
	CutSkp = 0x035DE08 --Cutscene Skip
	BtlTyp = 0x1C61958 --Battle Status (Out-of-Battle, Regular, Forced)
	BtlEnd = 0x1D490C0 --End-of-Battle camera & signal
	TxtBox = 0x1D48D54 --Last Displayed Textbox
	DemCln = 0x1D48DEC --Demyx Clone Status (might have to do with other mission status/signal?)
	Slot1    = 0x1C6C750 --Unit Slot 1
	NextSlot = 0x268
	Point1   = 0x1D48EFC
	NxtPoint = 0x38
	Gauge1   = 0x1D48FA4
	NxtGauge = 0x34
	Menu1    = 0x1C5FF18 --Menu 1 (main command menu)
	NextMenu = 0x4
	Obj0 = ReadInt(Obj0Pointer)
	Sys3 = ReadInt(Sys3Pointer)
	Btl0 = ReadInt(Btl0Pointer)
	MSN = 0x04FA440
elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
	OnPC = true
	if ReadString(0x09A92F0,4) == 'KH2J' then --EGS
		GameVersion = 2
		print('GoA Epic Version')
		Now = 0x0716DF8
		Sve = 0x2A0BF80
		Save = 0x09A92F0
		Obj0Pointer = 0x2A24A70
		Sys3Pointer = 0x2AE5890
		Btl0Pointer = 0x2AE5898
		ARDPointer = 0x2A0F268
		Music = 0x0ABA784
		Pause = 0x0ABB2B8
		React = 0x2A10BA2
		Cntrl = 0x2A16C28
		Timer = 0x0ABB290
		Songs = 0x0B657B4
		GScre = 0x072AEB0
		GMdal = 0x072B044
		GKill = 0x0AF6B86
		CamTyp = 0x0718A98
		GamSpd = 0x0717214
		CutNow = 0x0B649D8
		CutLen = 0x0B649F4
		CutSkp = 0x0B649DC
		BtlTyp = 0x2A10E44
		BtlEnd = 0x2A0F720
		TxtBox = 0x074DCB0
		DemCln = 0x2A0F2F4
		Slot1    = 0x2A22FD8
		NextSlot = 0x278
		Point1   = 0x2A0F488
		NxtPoint = 0x50
		Gauge1   = 0x2A0F578
		NxtGauge = 0x48
		Menu1    = 0x2A10B50
		NextMenu = 0x8
		Obj0 = ReadLong(Obj0Pointer)
		Sys3 = ReadLong(Sys3Pointer)
		Btl0 = ReadLong(Btl0Pointer)
		MSN = 0x0BF2C40
	elseif ReadString(0x09A9830,4) == 'KH2J' then --Steam Global
		GameVersion = 3
		print('GoA Steam Global Version')
		Now = 0x0717008
		Sve = 0x2A0C4C0
		Save = 0x09A9830
		Obj0Pointer = 0x2A24FB0
		Sys3Pointer = 0x2AE5DD0
		Btl0Pointer = 0x2AE5DD8
		ARDPointer = 0x2A0F7A8
		Music = 0x0ABACC4
		Pause = 0x0ABB7F8
		React = 0x2A110E2
		Cntrl = 0x2A17168
		Timer = 0x0ABB7D0
		Songs = 0x0B65CF4
		GScre = 0x072B130
		GMdal = 0x072B2C4
		GKill = 0x0AF70C6
		CamTyp = 0x0718CA8
		GamSpd = 0x0717424
		CutNow = 0x0B64F18
		CutLen = 0x0B64F34
		CutSkp = 0x0B64F1C
		BtlTyp = 0x2A11384
		BtlEnd = 0x2A0FC60
		TxtBox = 0x074DF20
		DemCln = 0x2A0F834
		Slot1    = 0x2A23518
		NextSlot = 0x278
		Point1   = 0x2A0F9C8
		NxtPoint = 0x50
		Gauge1   = 0x2A0FAB8
		NxtGauge = 0x48
		Menu1    = 0x2A11090
		NextMenu = 0x8
		Obj0 = ReadLong(Obj0Pointer)
		Sys3 = ReadLong(Sys3Pointer)
		Btl0 = ReadLong(Btl0Pointer)
		MSN = 0x0BF3340
	elseif ReadString(0x09A8830,4) == 'KH2J' then --Steam JP
		GameVersion = 4
		print('GoA Steam JP Version')
		Now = 0x0716008
		Sve = 0x2A0B4C0
		Save = 0x09A8830
		Obj0Pointer = 0x2A23FB0
		Sys3Pointer = 0x2AE4DD0
		Btl0Pointer = 0x2AE4DD8
		ARDPointer = 0x2A0E7A8
		Music = 0x0AB9CC4
		Pause = 0x0ABA7F8
		React = 0x2A100E2
		Cntrl = 0x2A16168
		Timer = 0x0ABA7D0
		Songs = 0x0B64CF4
		GScre = 0x072A130
		GMdal = 0x072A2C4
		GKill = 0x0AF60C6
		CamTyp = 0x0717CA8
		GamSpd = 0x0716424
		CutNow = 0x0B63F18
		CutLen = 0x0B63F34
		CutSkp = 0x0B63F1C
		BtlTyp = 0x2A10384
		BtlEnd = 0x2A0EC60
		TxtBox = 0x074CF20
		DemCln = 0x2A0E834
		Slot1    = 0x2A22518
		NextSlot = 0x278
		Point1   = 0x2A0E9C8
		NxtPoint = 0x50
		Gauge1   = 0x2A0EAB8
		NxtGauge = 0x48
		Menu1    = 0x2A10090
		NextMenu = 0x8
		Obj0 = ReadLong(Obj0Pointer)
		Sys3 = ReadLong(Sys3Pointer)
		Btl0 = ReadLong(Btl0Pointer)
		MSN = 0x0BF2340
	end
end
if GameVersion ~= 0 then
	--[[Slot2  = Slot1 - NextSlot
	Slot3  = Slot2 - NextSlot
	Slot4  = Slot3 - NextSlot
	Slot5  = Slot4 - NextSlot
	Slot6  = Slot5 - NextSlot
	Slot7  = Slot6 - NextSlot
	Slot8  = Slot7 - NextSlot
	Slot9  = Slot8 - NextSlot
	Slot10 = Slot9 - NextSlot
	Slot11 = Slot10 - NextSlot
	Slot12 = Slot11 - NextSlot
	Point2 = Point1 + NxtPoint
	Point3 = Point2 + NxtPoint
	Gauge2 = Gauge1 + NxtGauge
	Gauge3 = Gauge2 + NxtGauge--]]
	Menu2  = Menu1 + NextMenu
	--Menu3  = Menu2 + NextMenu
end
end

function BAR(File,Subfile,Offset) --Get address within a BAR file
	local Subpoint = File + 0x08 + 0x10*Subfile
	local Address
	--Detect errors
	if ReadInt(File,OnPC) ~= 0x01524142 then --Header mismatch
		return
	elseif Subfile > ReadInt(File+4,OnPC) then --Subfile over count
		return
	elseif Offset >= ReadInt(Subpoint+4,OnPC) then --Offset exceed subfile length
		return
	end
	--Get address
	Address = File + (ReadInt(Subpoint,OnPC) - ReadInt(File+8,OnPC)) + Offset
	return Address
end

function _OnFrame()
	if GameVersion == 0 then --Get anchor addresses
		GetVersion()
		return
	end

	if true then --Define current values for common addresses
		World  = ReadByte(Now+0x00)
		Room   = ReadByte(Now+0x01)
		Place  = ReadShort(Now+0x00)
		Door   = ReadShort(Now+0x02)
		Map    = ReadShort(Now+0x04)
		Btl    = ReadShort(Now+0x06)
		Evt    = ReadShort(Now+0x08)
		PrevPlace = ReadShort(Now+0x30)
		if not OnPC then
			ARD = ReadInt(ARDPointer)
		else
			ARD = ReadLong(ARDPointer)
		end
	end
	GoA()
	TWtNW()
end

function GoA()
	--Clear Conditions
	if not SeedCleared then
		local ObjectiveCount = ReadShort(BAR(Sys3,0x6,0x4F4),OnPC)
		if ReadByte(Save+0x36B2) > 0 and ReadByte(Save+0x36B3) > 0 and ReadByte(Save+0x36B4) > 0 then --All Proofs Obtained
			SeedCleared = true
		elseif ReadByte(Save+0x363D) >= ObjectiveCount then --Requisite Objective Count Achieved
			SeedCleared = true
		end
	end
	--Garden of Assemblage Rearrangement
	if Place == 0x1A04 then
		--Open Promise Charm Path
		if SeedCleared and ReadByte(Save+0x3694) > 0 then --Seed Cleared & Promise Charm
			WriteShort(BAR(ARD,0x06,0x05C),0x77A,OnPC) --Text
		end
		--Demyx's Portal Text
		if ReadByte(Save+0x1D2E) > 0 then --Hollow Bastion Cleared
			WriteShort(BAR(ARD,0x05,0x25C),0x779,OnPC) --Radiant Garden
		end
	end
end

function TWtNW()
	--Final Door Requirements
	if ReadShort(Save+0x1B7C) == 0x04 and SeedCleared then
		WriteShort(Save+0x1B7C, 0x0D) --The Altar of Naught MAP (Door RC Available)
	end
end