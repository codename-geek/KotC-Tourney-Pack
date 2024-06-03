--ROM Version
--Last Update: Objective rando compatibility
--Todo: Maybe item-based progress flags

LUAGUI_NAME = 'GoA ROM Randomizer Build'
LUAGUI_AUTH = 'SonicShadowSilver2 (Ported by Num)'
LUAGUI_DESC = 'A GoA build for use with the Randomizer. Requires ROM patching.'

function _OnInit()
print('GoA v1.54 - Codename_Geek GoA Edit')
GoAOffset = 0x7C
if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
	if ENGINE_VERSION < 3.0 then
		print('LuaEngine is Outdated. Things might not work properly.')
	end
	OnPC = false
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
	BtlEnd = 0x1D490C0 --Something about end-of-battle camera
	TxtBox = 0x1D48D54 --Last Displayed Textbox
	DemCln = 0x1D48DEC --Demyx Clone Status
	Slot1    = 0x1C6C750 --Unit Slot 1
	NextSlot = 0x268
	Point1   = 0x1D48EFC
	NxtPoint = 0x38
	Gauge1   = 0x1D48FA4
	NxtGauge = 0x34
	Menu1    = 0x1C5FF18 --Menu 1 (main command menu)
	NextMenu = 0x4
elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
	if ENGINE_VERSION < 5.0 then
		ConsolePrint('LuaBackend is Outdated. Things might not work properly.',2)
	end
	OnPC = true
	Now = 0x0714DB8 - 0x56454E
	Sve = 0x2A09C00 - 0x56450E
	Save = 0x09A7070 - 0x56450E
	Obj0Pointer = 0x2A22730 - 0x56454E
	Sys3Pointer = 0x2AE3550 - 0x56454E
	Btl0Pointer = 0x2AE3558 - 0x56454E
	ARDPointer = 0x2A0CF28 - 0x56454E
	Music = 0x0AB8504 - 0x56450E
	Pause = 0x0AB9038 - 0x56450E
	React = 0x2A0E822 - 0x56450E
	Cntrl = 0x2A148A8 - 0x56450E
	Timer = 0x0AB9010 - 0x56450E
	Songs = 0x0B63534 - 0x56450E
	GScre = 0x0728E90 - 0x56454E
	GMdal = 0x0729024 - 0x56454E
	GKill = 0x0AF4906 - 0x56450E
	CamTyp = 0x0716A58 - 0x56454E
	GamSpd = 0x07151D4 - 0x56454E
	CutNow = 0x0B62758 - 0x56450E
	CutLen = 0x0B62774 - 0x56450E
	CutSkp = 0x0B6275C - 0x56450E
	BtlTyp = 0x2A0EAC4 - 0x56450E
	BtlEnd = 0x2A0D3A0 - 0x56450E
	TxtBox = 0x074BC70 - 0x56454E
	DemCln = 0x2A0CF74 - 0x56450E
	Slot1    = 0x2A20C58 - 0x56450E
	NextSlot = 0x278
	Point1   = 0x2A0D108 - 0x56450E
	NxtPoint = 0x50
	Gauge1   = 0x2A0D1F8 - 0x56450E
	NxtGauge = 0x48
	Menu1    = 0x2A0E7D0 - 0x56450E
	NextMenu = 0x8
end
SeedCleared = false
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

function Warp(W,R,D,M,B,E) --Warp into the appropriate World, Room, Door, Map, Btl, Evt
M = M or ReadShort(Save + 0x10 + 0x180*W + 0x6*R)
B = B or ReadShort(Save + 0x10 + 0x180*W + 0x6*R + 2)
E = E or ReadShort(Save + 0x10 + 0x180*W + 0x6*R + 4)
WriteByte(Now+0x00,W)
WriteByte(Now+0x01,R)
WriteShort(Now+0x02,D)
WriteShort(Now+0x04,M)
WriteShort(Now+0x06,B)
WriteShort(Now+0x08,E)
--Record Location in Save File
WriteByte(Save+0x000C,W)
WriteByte(Save+0x000D,R)
WriteShort(Save+0x000E,D)
end

function Events(M,B,E) --Check for Map, Btl, and Evt
return ((Map == M or not M) and (Btl == B or not B) and (Evt == E or not E))
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

function BitOr(Address,Bit,Abs)
WriteByte(Address, ReadByte(Address, Abs and OnPC)|Bit, Abs and OnPC)
end

function BitNot(Address,Bit,Abs)
WriteByte(Address, ReadByte(Address, Abs and OnPC)&~Bit, Abs and OnPC)
end

function Faster(Toggle)
if Toggle then
	WriteFloat(GamSpd,2) --Faster Speed
elseif ReadFloat(GamSpd) > 1 then
	WriteFloat(GamSpd,1) --Normal Speed
end
end

function RemoveTTBlocks() --Remove All TT & STT Blocks
WriteShort(Save+0x207C,0) --Sunset Station
WriteShort(Save+0x2080,0) --Central Station
WriteShort(Save+0x20E4,0) --Underground Concourse
WriteShort(Save+0x20E8,0) --The Woods
WriteShort(Save+0x20EC,0) --Sandlot
WriteShort(Save+0x20F0,0) --Tram Commons
WriteShort(Save+0x20F4,0) --The Mysterious Tower
WriteShort(Save+0x20F8,0) --Tower Wardrobe
WriteShort(Save+0x20FC,0) --Basement Corridor
WriteShort(Save+0x2100,0) --Mansion Library
WriteShort(Save+0x2110,0) --Tunnelway
WriteShort(Save+0x2114,0) --Station Plaza
WriteShort(Save+0x211C,0) --The Old Mansion
WriteShort(Save+0x2120,0) --Mansion Foyer
end

function VisitLock(ItemAddress, RequiredCount, Address, Bit)
	local ItemCount = ReadByte(ItemAddress)
	if ItemCount < RequiredCount then
		BitNot(Address, Bit)
	elseif ReadByte(Address) & Bit == 0 then
		BitOr(Address, Bit)
	end
end

function _OnFrame()
if true then --Define current values for common addresses
	World  = ReadByte(Now+0x00)
	Room   = ReadByte(Now+0x01)
	Place  = ReadShort(Now+0x00)
	Door   = ReadShort(Now+0x02)
	Map    = ReadShort(Now+0x04)
	Btl    = ReadShort(Now+0x06)
	Evt    = ReadShort(Now+0x08)
	PrevPlace = ReadShort(Now+0x30)
	if Place == 0xFFFF or not MSN then
		if not OnPC then
			Obj0 = ReadInt(Obj0Pointer)
			Sys3 = ReadInt(Sys3Pointer)
			Btl0 = ReadInt(Btl0Pointer)
			MSN = 0x04FA440
		else
			Obj0 = ReadLong(Obj0Pointer)
			Sys3 = ReadLong(Sys3Pointer)
			Btl0 = ReadLong(Btl0Pointer)
			MSN = 0x0BF08C0 - 0x56450E
		end
	end
	if not OnPC then
		ARD = ReadInt(ARDPointer)
	else
		ARD = ReadLong(ARDPointer)
	end
end
GoA()
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