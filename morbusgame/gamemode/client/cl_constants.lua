// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team


/*------------------------------------------------
MISSION TEXT
-------------------------------------------------*/

Mission = {}
Mission = {
{
	"None",
	"You have nothing to do right now"
},
{
	"Sleep",
	"If you don't sleep your going to passout",
	"Sleep is vital to your survival",
	"You need to sleep"
},
{
	"Eat",
	"If you don't eat your going to starve",
	"Your stromach is rumbling",
	"Your getting pretty hungry"
},
{
	"Clean",
	"Clean this shit off",
	"Your covered in shit",
	"You look like a mud monster"
},
{
	"Piss",
	"Your bowels yearn for a toilet",
	"The dam needs to be broken",
	"Brown bomb ready!"
},
{
	"Kill",
	"Hunt down the humans and infect or kill them"
}
}

function GetMissionTitle(number)
	return Mission[number+1][1]
end

function GetMissionText(number)
	return Mission[number][math.random(2,table.Count(Mission))]
end

/*------------------------------------------------
VGUI ELEMENTS
-------------------------------------------------*/




ICON_WEIGHT = surface.GetTextureID("vgui/poids")
RING = surface.GetTextureID( "redring" )
VEINS = surface.GetTextureID( "veins" )
ICON_KILL = surface.GetTextureID("vgui/killneed")
ICON_WASH = surface.GetTextureID("vgui/wash")
ICON_PISS = surface.GetTextureID("vgui/wc")
ICON_EAT = surface.GetTextureID("vgui/eat")
ICON_SLEEP = surface.GetTextureID("vgui/sleep")
ICON_WAIT = surface.GetTextureID("vgui/waitneed")
ICON_NEED = surface.GetTextureID("vgui/need_target")

MissionIcon = {
	ICON_WAIT, ICON_SLEEP, ICON_EAT, ICON_WASH, ICON_PISS, ICON_KILL
}

surface.CreateFont( "DSMass", {
	font 		= "DeadSpaceTitleFont",
	size 		= 64,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 64, 100, true, false, "DSMass")

surface.CreateFont( "DSHuge", {
	font 		= "DeadSpaceTitleFont",
	size 		= 42,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 42, 100, true, false, "DSHuge")

surface.CreateFont( "DSLarge", {
	font 		= "DeadSpaceTitleFont",
	size 		= 28,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 30, 100, true, false, "DSLarge")

surface.CreateFont( "DSSmall", {
	font 		= "DeadSpaceTitleFont",
	size 		= 18,
	weight 		= 100,
	antialias	= true
})

surface.CreateFont( "DSTiny2", {
	font 		= "DeadSpaceTitleFont",
	size 		= 16,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 18, 100, true, false, "DSSmall")

surface.CreateFont( "DSTiny", {
	font 		= "DeadSpaceTitleFont",
	size 		= 12,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 12, 100, true, false, "DSTiny")

surface.CreateFont( "DSMedium", {
	font 		= "DeadSpaceTitleFont",
	size 		= 22,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 22, 100, true, false, "DSMedium")

// 1:00 = 60
// 2:00 = 120
// 3:00 = 180
// 4:00 = 240
// 5:00 = 300

/*
1- 100
2- 130
3- 230
4- 180
5- 190
6- 270
7- 310
8- 195
9- 220
10- 210
11- 240
12- 240
*/
MUSIC_TIME = {100,130,230,180,190,270,310,195,220,210,240,240}

MUSIC = {}
for i=1,12 do
	MUSIC[i] = {"mor_song"..i..".mp3",MUSIC_TIME[i]}
	util.PrecacheSound("music/mor_song"..i..".mp3")
end



MUSIC_ALIEN_WIN = "morbus_alien_victory.mp3"
MUSIC_HUMAN_WIN = "morbus_human_victory.mp3"



