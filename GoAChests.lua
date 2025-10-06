function _OnInit()
	GameVersion = 0
end
function GetVersion() --Define anchor addresses
if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
	GameVersion = 1
	Now = 0x032BAE0 --Current Location
	Save = 0x032BB30 --Save File
	Sys3Pointer = 0x1C61AF8 --03system.bin Pointer Address
	Sys3 = ReadInt(Sys3Pointer)
	print('GoA PS2 Version - Custom Modified GoA Chests')
elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
	OnPC = true
	if ReadString(0x9A9330,4) == 'KH2J' then --EGS
		GameVersion = 2
		Now = 0x0716DF8
		Save = 0x09A9330
		inputAddr = 0x29FAD70
		Cntrl = 0x2A16C68
		BtlTyp = 0x2A10E84
		Slot1 = 0x2A23018
		Sys3Pointer = 0x2AE58D0
		Sys3 = ReadLong(Sys3Pointer)
		IsLoaded = 0x09BA310
		print('GoA Epic Version (v.10) - Custom Modified GoA Chests')
	elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam Global
		GameVersion = 3
		Now = 0x0717008
		Save = 0x09A98B0
		inputAddr = 0xBF31A0
		Cntrl = 0x2A171E8
		BtlTyp = 0x2A11404
		Slot1 = 0x2A23598
		Sys3Pointer = 0x2AE5E50
		Sys3 = ReadLong(Sys3Pointer)
		print('GoA Steam Global Version (v.2) - Custom Modified GoA Chests')
		IsLoaded = 0x09BA850
	elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam JP (same as Global for now)
		GameVersion = 4
		Now = 0x0717008
		Save = 0x09A98B0
		inputAddr = 0xBF31A0
		Sys3Pointer = 0x2AE5E50
		Cntrl = 0x2A171E8
		BtlTyp = 0x2A11404
		Slot1 = 0x2A23598
		Sys3 = ReadLong(Sys3Pointer)
		IsLoaded = 0x09B9850
		print('GoA Steam JP Version (v.2) - Custom Modified GoA Chests')
	end
end
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

OpenedChest = false
GoA_Warning = false
GoA_Locked = true
infoBoxTick = 0
doInfoBox = false
function _OnFrame()
	if GameVersion == 0 then --Get anchor addresses
		GetVersion()
		return
	end
	local ObjectiveCount = ReadShort(BAR(Sys3,0x6,0x4F4),OnPC)

	World  = ReadByte(Now+0x00)
	Room   = ReadByte(Now+0x01)
	Place  = ReadShort(Now+0x00)
	Map    = ReadShort(Now+0x04)
	Btl    = ReadShort(Now+0x06)
	Evt    = ReadShort(Now+0x08)

	Check()
	--print(CheckCount)
	if CheckCount >= 13 and not GoA_Warning and not OpenedChest then
		WriteInfoBox('GoA Bonuses are now open!')
		GoA_Warning = true
		GoA_Locked = false
	end

	if CheckCount <= 12 then
		GoA_Warning = false
		GoA_Locked = true
	end

	if GoA_Locked then --under 13 unlocks, junk chests
		WriteShort(BAR(Sys3, 0x7, 0xECA), 0x0148, OnPC)
		WriteShort(BAR(Sys3, 0x7, 0xED6), 0x0169, OnPC)
		WriteShort(BAR(Sys3, 0x7, 0xEBE), 0x0148, OnPC)
	end
	if ReadByte(Save + 0x23DF) & 0x4 ~= 0x4 and
	  ReadByte(Save + 0x23DF) & 0x8 ~= 0x8 and
	  ReadByte(Save + 0x23DF) & 0x2 ~= 0x2 and
	  not GoA_Locked then --if the chests are unopened and 13 unlocks
		WriteShort(BAR(Sys3, 0x7, 0xECA), 0x0191, OnPC)
		WriteShort(BAR(Sys3, 0x7, 0xED6), 0x021B, OnPC)
		WriteShort(BAR(Sys3, 0x7, 0xEBE), 0x006B, OnPC)
		OpenedChest = false
	end

	if ReadByte(Save + 0x23DF) & 0x4 == 0x4 and not OpenedChest then
		--print("Opened Left Chest")
		WriteShort(BAR(Sys3, 0x7, 0xECA), 0x0191, OnPC) --Experience Boost
		WriteShort(BAR(Sys3, 0x7, 0xED6), 0x0003, OnPC)
		if ObjectiveCount == 40 then
			WriteShort(BAR(Sys3, 0x7, 0xEBE), 0x016B, OnPC) --Lucky Emblem
		else
			WriteShort(BAR(Sys3, 0x7, 0xEBE), 0x0003, OnPC) --Ether
		end
		WriteByte(Save+0x24FE, 2)
	end
	if ReadByte(Save + 0x23DF) & 0x8 == 0x8 and not OpenedChest then
		--print("Opened Middle Chest")
		WriteShort(BAR(Sys3, 0x7, 0xECA), 0x0187, OnPC) --Air Combo Boost
		WriteShort(BAR(Sys3, 0x7, 0xED6), 0x021B, OnPC) --Combo Master
		WriteShort(BAR(Sys3, 0x7, 0xEBE), 0x0186, OnPC) --Combo Boost
		if ObjectiveCount ~= 40 then
			WriteByte(Save+0x24F9,ReadByte(Save+0x24F9) + 3) --Power Boost
			WriteByte(Save+0x24FA,ReadByte(Save+0x24FA) + 3) --Magic Boost
		end
		WriteByte(Save+0x24FE, 0)
	end
	if ReadByte(Save + 0x23DF) & 0x2 == 0x2 and not OpenedChest then
		--print("Opened Right Chest")
		WriteShort(BAR(Sys3, 0x7, 0xED6), 0x0003, OnPC)
		WriteShort(BAR(Sys3, 0x7, 0xECA), 0x0003, OnPC)
		WriteShort(BAR(Sys3, 0x7, 0xEBE), 0x006B, OnPC) --Glide 2
		WriteByte(Save+0x24FE, 1)
	end
	
	if (ReadByte(Save + 0x23DF) & 0x4 == 0x4 or
	   ReadByte(Save + 0x23DF) & 0x8 == 0x8 or
	   ReadByte(Save + 0x23DF) & 0x2 == 0x2) then
		--print("Opened Chest")
		OpenedChest = true
	else
		OpenedChest = false
	end

	DisplayInfoBox()
end

--Get Progression Item Count (Pages + Drives + Unlocks)
function Check()
	--Torn Pages
	local truePageCount = 0
	--Used first page
	if ReadByte(Save+0x1DB1) > 1 then
		truePageCount = 1
	end
	--Used second page
	if ReadByte(Save+0x1DB2) > 1 then
		truePageCount = 2
	end
	--Used third page
	if ReadByte(Save+0x1DB3) > 1 then
		truePageCount = 3
	end
	--Used fourth page
	if ReadByte(Save+0x1DB4) > 1 then
		truePageCount = 4
	end
	--Used fifth page
	if ReadByte(Save+0x1DB5) > 0 then
		truePageCount = 5
	end
	truePageCount = truePageCount + ReadByte(Save+0x3598)

	--Forms
	local formCount = 0
	--Valor
	if ReadByte(Save+0x36C0)&0x80 == 0x80 then
		formCount = formCount + 1
	end
	--Wisdom
	if ReadByte(Save+0x36C0)&0x4 == 0x4 then
		formCount = formCount + 1
	end
	--Limit
	if ReadByte(Save+0x36CA)&0x8 == 0x8 then
		formCount = formCount + 1
	end
	--Master
	if ReadByte(Save+0x36C0)&0x40 == 0x40 then
		formCount = formCount + 1
	end
	--Final
	if ReadByte(Save+0x36C2)&0x02 == 0x02 then
		formCount = formCount + 1
	end

	--Visit Unlocks
	local unlockCount = 0
	--Namine's Sketches
	unlockCount = unlockCount + ReadByte(Save+0x3642)
	--Ice Cream
	unlockCount = unlockCount + ReadByte(Save+0x3649)
	--Membership Card
	unlockCount = unlockCount + ReadByte(Save+0x3643)
	--Beast's Claw
	unlockCount = unlockCount + ReadByte(Save+0x35B3)
	--Battlefields of War
	unlockCount = unlockCount + ReadByte(Save+0x35AE)
	--Scimitar
	unlockCount = unlockCount + ReadByte(Save+0x35C0)
	--Sword of the Ancestors
	unlockCount = unlockCount + ReadByte(Save+0x35AF)
	--Proud Fang
	unlockCount = unlockCount + ReadByte(Save+0x35B5)
	--Royal Summons (DUMMY 13)
	unlockCount = unlockCount + ReadByte(Save+0x365D)
	--Bone Fist
	unlockCount = unlockCount + ReadByte(Save+0x35B4)
	--Skill and Crossbones
	unlockCount = unlockCount + ReadByte(Save+0x35B6)
	--Identity Disk
	unlockCount = unlockCount + ReadByte(Save+0x35C2)
	--Way to the Dawn
	unlockCount = unlockCount + ReadByte(Save+0x35C1)

	CheckCount = truePageCount + formCount + unlockCount
end

--still missing icon support and special things like color/size/ect.
CharSet = {['０'] = 0x21, ['１'] = 0x22, ['２'] = 0x23, ['３'] = 0x24, ['４'] = 0x25, ['５'] = 0x26, ['６'] = 0x27, 
['７'] = 0x28, ['８'] = 0x29, ['９'] = 0x2a, ['+'] = 0x2b, ['−'] = 0x2c, ['ₓ'] = 0x2d, ['A'] = 0x2e, ['B'] = 0x2f, 
['C'] = 0x30, ['D'] = 0x31, ['E'] = 0x32, ['F'] = 0x33, ['G'] = 0x34, ['H'] = 0x35, ['I'] = 0x36, ['J'] = 0x37, 
['K'] = 0x38, ['L'] = 0x39, ['M'] = 0x3a, ['N'] = 0x3b, ['O'] = 0x3c, ['P'] = 0x3d, ['Q'] = 0x3e, ['R'] = 0x3f, 
['S'] = 0x40, ['T'] = 0x41, ['U'] = 0x42, ['V'] = 0x43, ['W'] = 0x44, ['X'] = 0x45, ['Y'] = 0x46, ['Z'] = 0x47, 
['!'] = 0x48, ['?'] = 0x49, ['%'] = 0x4a, ['/'] = 0x4b, ['※'] = 0x4c, ['、'] = 0x4d, ['。'] = 0x4e, ['.'] = 0x4f, 
[','] = 0x50, [';'] = 0x51, [':'] = 0x52, ['…'] = 0x53, ["-"] = 0x54, ['–'] = 0x55, ['〜'] = 0x56, ["'"] = 0x57, 
['('] = 0x5a, [')'] = 0x5b, ['「'] = 0x5c, ['」'] = 0x5d, ['『'] = 0x5e, ['』'] = 0x5f, ['“'] = 0x60, ['”'] = 0x61, 
['['] = 0x62, [']'] = 0x63, ['<'] = 0x64, ['>'] = 0x65, ['-'] = 0x66, ["–"] = 0x67, ['◯'] = 0x6c, ['✕'] = 0x6d, 
--these kinda don't exactly work as single character searches, huh?
--["I"] = 0x74, ["II"] = 0x75, ["III"] = 0x76, ["IV"] = 0x77, ["V"] = 0x78, ["VI"] = 0x79, ["VII"] = 0x7a, ["VIII"] = 0x7b, 
--["IX"] = 0x7c, ["X"] = 0x7d, ["XIII"] = 0x7e, ["XI"] = 0x84, ["XII"] = 0x85,
['α'] = 0x7f,['β'] = 0x80, ['γ'] = 0x81, 
['&'] = 0x86, ['#'] = 0x87, ['®'] = 0x88, ['▴'] = 0x89, ['▾'] = 0x8a, ['▸'] = 0x8b, ['◂'] = 0x8c, ['°'] = 0x8d, 
["♪"] = 0x8e, ['0'] = 0x90, ['1'] = 0x91, ['2'] = 0x92, ['3'] = 0x93, ['4'] = 0x94, ['5'] = 0x95, ['6'] = 0x96, 
['7'] = 0x97, ['8'] = 0x98, ['9'] = 0x99, ['a'] = 0x9a, ['b'] = 0x9b, ['c'] = 0x9c, ['d'] = 0x9d, ['e'] = 0x9e, 
['f'] = 0x9f, ['g'] = 0xa0, ['h'] = 0xa1, ['i'] = 0xa2, ['j'] = 0xa3, ['k'] = 0xa4, ['l'] = 0xa5, ['m'] = 0xa6, 
['n'] = 0xa7, ['o'] = 0xa8, ['p'] = 0xa9, ['q'] = 0xaa, ['r'] = 0xab, ['s'] = 0xac, ['t'] = 0xad, ['u'] = 0xae, 
['v'] = 0xaf, ['w'] = 0xb0, ['x'] = 0xb1, ['y'] = 0xb2, ['z'] = 0xb3, ['Æ'] = 0xb4, ['æ'] = 0xb5, ['ß'] = 0xb6, 
['à'] = 0xb7, ['á'] = 0xb8, ['â'] = 0xb9, ['ä'] = 0xba, ['è'] = 0xbb, ['é'] = 0xbc, ['ê'] = 0xbd, ['ë'] = 0xbe, 
['ì'] = 0xbf, ['í'] = 0xc0, ['î'] = 0xc1, ['ï'] = 0xc2, ['ñ'] = 0xc3, ['ò'] = 0xc4, ['ó'] = 0xc5, ['ô'] = 0xc6, 
['ö'] = 0xc7, ['ù'] = 0xc8, ['ú'] = 0xc9, ['û'] = 0xca, ['ü'] = 0xcb, ['º'] = 0xcc, ['—'] = 0xcd, ['»'] = 0xce, 
['«'] = 0xcf, ['À'] = 0xd0, ['Á'] = 0xd1, ['Â'] = 0xd2, ['Ä'] = 0xd3, ['È'] = 0xd4, ['É'] = 0xd5, ['Ê'] = 0xd6, 
['Ë'] = 0xd7, ['Ì'] = 0xd8, ['Í'] = 0xd9, ['Î'] = 0xda, ['Ï'] = 0xdb, ['Ñ'] = 0xdc, ['Ò'] = 0xdd, ['Ó'] = 0xde, 
['Ô'] = 0xdf, ['Ö'] = 0xe0, ['Ù'] = 0xe1, ['Ú'] = 0xe2, ['Û'] = 0xe3, ['Ü'] = 0xe4, ['¡'] = 0xe5, ['¿'] = 0xe6, 
['Ç'] = 0xe7, ['ç'] = 0xe8, ['‛'] = 0xe9, ['’'] = 0xea, ['`'] = 0xeb, ['´'] = 0xec, ['"'] = 0xed, ['★'] = 0xef, 
['☆'] = 0xf0, ['■'] = 0xf1, ['□'] = 0xf2, ['▲'] = 0xf3, ['△'] = 0xf4, ['●'] = 0xf5, ['○'] = 0xf6, ['♪'] = 0xf7, 
['♫'] = 0xf8, ['→'] = 0xf9, ['←'] = 0xfa, ['↑'] = 0xfb, ['↓'] = 0xfc, ['・'] = 0xfd, ['❤'] = 0xfe}

function Text2khscii(item_name)
	out_list = {}
	char_count = 0
	

	--Throughout the text, do:
	while char_count < utf8.len(item_name) do
		--get character
		char = utf8.sub(item_name, char_count+1, char_count+1)
		--check if exists in dict, then grab khscii value if it does
		if CharSet[char] ~= nil then
			table.insert(out_list, CharSet[char])
		else --can't find, so use 0x01 (a blank space)
			table.insert(out_list, 0x01)
		end
		
		--incrament char count num for next
		char_count = char_count + 1
	end
	
	--null terminator at end
	table.insert(out_list, 0x00)
	
    return out_list
end

--I HATE UTF8 ALL MY HOMIES HATE LUA TOO
--thank ouy mr ihf from stackoverflow. my hero
function utf8.sub(s,i,j)
    i=utf8.offset(s,i)
    j=utf8.offset(s,j+1)-1
    return string.sub(s,i,j)
end

function WriteInfoBox(text)
	if GameVersion > 1 then
		infoBoxText = text
		txt = Text2khscii(text)
		WriteArray(0x800004, txt)
		doInfoBox = true
	end
end
function ShowInfoBox()
	if GameVersion > 1 then
		WriteByte(0x800000, 0x01)
	end
end

function DisplayInfoBox() --Used to check when the wincon is achieved at when to display it
	if ReadByte(Cntrl) == 0 and (ReadByte(BtlTyp) >= 0 and ReadByte(BtlTyp) <= 2)
	   and doInfoBox and ReadByte(IsLoaded) == 0 then
		infoBoxTick = infoBoxTick + 1
		if infoBoxTick > 15 then --after 15 frames?
			print(infoBoxText)
			ShowInfoBox()
			doInfoBox = false
			infoBoxTick = 0
		end
	end
end