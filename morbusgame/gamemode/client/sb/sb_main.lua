
---- VGUI panel version of the scoreboard, based on TEAM GARRY's sandbox mode
---- scoreboard.s

local surface = surface
local draw = draw
local math = math
local string = string
local vgui = vgui

COLOR_WHITE = Color(255,255,255,175)
COLOR_GREEN = Color(0,255,0,175)
COLOR_YELLOW = Color(255,255,0,175)
COLOR_RED = Color(255,0,0,175)

EXPAND_SB = 28

local tex = surface.GetTextureID( "vgui/morbus/screen2" )

include("sb_team.lua")

surface.CreateFont("cool_small", {font = "coolvetica",
                       size = 20,
                       weight = 400})
surface.CreateFont("cool_large", {font = "coolvetica",
                       size = 24,
                       weight = 400})
surface.CreateFont("treb_small", {font = "Trebuchet18",
                       size = 14,
                       weight = 700})
local PANEL = {}

local max = math.max
local floor = math.floor
local function RoundsTMC()
  --local rounds_left = max(0, GetGlobalInt("morbus_rounds_left", 6))
  return max(0, GetGlobalInt("morbus_rounds_left", 6))
end

local function MinutesTMC()
	return max(0, GetGlobalInt("morbus_minutes_left", 45))
end


GROUP_GAME = 1
GROUP_SWARM = 2
GROUP_SPEC = 3

GROUP_COUNT = 3

function ScoreGroup(p)
  if not IsValid(p) then return -1 end -- will not match any group panel

  if true then
    if p:IsSpec() then
      return GROUP_SPEC
    elseif p:IsSwarm() then
      return GROUP_SWARM
    else
      return GROUP_GAME
    end
  end

  return p:IsGame() and GROUP_GAME or GROUP_SPEC
end

function PANEL:Init()

  self.Status = false
  self.Trans = 200

  self.hostdesc = vgui.Create("DLabel", self)
  self.hostdesc:SetText(GAMEMODE.Name)
  self.hostdesc:SetContentAlignment(9)

  self.hostname = vgui.Create( "DLabel", self )
  self.hostname:SetText( "XenoGamers.com" )
  self.hostname:SetContentAlignment(9)

  self.devname = vgui.Create( "DLabel", self )
  self.devname:SetText( "Version 1.5.8.4xG" )
  self.devname:SetContentAlignment(9)

  self.devname2 = vgui.Create( "DLabel", self )
  self.devname2:SetText( "" )
  self.devname2:SetContentAlignment(9)

  self.mapchange = vgui.Create("DLabel", self)
  self.mapchange:SetText("Map changes in 00 rounds")
  self.mapchange:SetContentAlignment(9)

  self.mapchange.Think = function (sf)
                    --local r = UntilMapChange()

                    sf:SetText("Map changes in "..RoundsTMC().." rounds or "..MinutesTMC().." minutes")
                    sf:SizeToContents()
                  end

				  
				  

  self.ply_frame = vgui.Create( "MPlayerFrame", self )

  self.ply_groups = {}
  
  local t = vgui.Create("MScoreGroup", self.ply_frame:GetCanvas())
  t:SetGroupInfo("Humans", Color(0,180,0,50), GROUP_GAME)
  self.ply_groups[GROUP_GAME] = t

  t = vgui.Create("MScoreGroup", self.ply_frame:GetCanvas())  
  t:SetGroupInfo("Spectators", Color(240, 240, 0, 50), GROUP_SPEC)
  self.ply_groups[GROUP_SPEC] = t

  if true then
    t = vgui.Create("MScoreGroup", self.ply_frame:GetCanvas())
    t:SetGroupInfo("Swarm Aliens", Color(255, 90, 0, 100), GROUP_SWARM)
    self.ply_groups[GROUP_SWARM] = t
  end

  -- the various score column headers
  self.cols = {}
  self.cols[1] = vgui.Create( "DLabel", self )
  self.cols[1]:SetText( "Ping" )
  

  //self.cols[2] = vgui.Create( "DLabel", self )
  //self.cols[2]:SetText( "Score" )
  -- self.cols[3] = vgui.Create( "DLabel", self )
  -- self.cols[3]:SetText("Rank")

  if true then
    self.cols[2] = vgui.Create("DLabel", self)
    self.cols[2]:SetText("Sanity")    
  end

  self:UpdateScoreboard()
  self:StartUpdateTimer()
end

function PANEL:Think()
  local status = self.Status
  local maxtrans = self.MaxTrans
  local trans = self.Trans


  local ftrans = 0
  local mul = math.sin(RealTime()*4)/8
  if trans > 0 then
   ftrans = math.Clamp(trans + (trans*(mul)),trans-30,trans+30)
  end

  self.FTrans = ftrans
end

function PANEL:StartUpdateTimer()
  if not timer.Exists("MScoreboardUpdater") then
    timer.Create( "MScoreboardUpdater", 0.3, 0,
              function()
                local pnl = GAMEMODE:GetScoreboardPanel()
                if IsValid(pnl) then
                  pnl:UpdateScoreboard()
                end
              end)
  end
end

local colors = {
  bg = Color(30,30,30, 235),
  bar = Color(220,180,0,255)
};

local ConVarYpos = GetConVar("morbus_scoreboard_ypos")
local y_logo_off = ConVarYpos:GetInt()

function PANEL:Paint()

  y_logo_off = ConVarYpos:GetInt()  
  
  surface.SetTexture( tex )
  
  -- Server name is outlined by orange/gold area
  draw.RoundedBox( 0, 300, y_logo_off + 37, self:GetWide() - 300, 24, Color(60,60,60,self.FTrans))
end

function PANEL:PerformLayout()
  -- position groups and find their total size
  local gy = 0
  
  -- can't just use pairs (undefined ordering) or ipairs (group 2 and 3 might not exist)
  for i=1, GROUP_COUNT do
    local group = self.ply_groups[i]
    if ValidPanel(group) then
      if group:HasRows() then
        group:SetVisible(true)
        group:SetPos(0, gy)		
        group:SetSize(self.ply_frame:GetWide(), group:GetTall())
        group:InvalidateLayout()
        gy = gy + group:GetTall() + 5
      else
        group:SetVisible(false)
      end
    end
  end

  self.ply_frame:GetCanvas():SetSize(self.ply_frame:GetCanvas():GetWide(), gy)

  local h = y_logo_off + 110 + self.ply_frame:GetCanvas():GetTall()

  -- if we will have to clamp our height, enable the mouse so player can scroll
  local scrolling = h > ScrH() * 0.95
--   gui.EnableScreenClicker(scrolling)
  self.ply_frame:SetScroll(scrolling)

  h = math.Clamp(h, 110 + y_logo_off, ScrH() * 0.95)

  local targetWidth = 780
  
  if #player.GetAll() >= EXPAND_SB then
	targetWidth = 1350
  end
  
  local maxSize = ScrW() * 0.95
  
  local w = 0
  
  if maxSize < targetWidth then
	w = maxSize
  else
	w = targetWidth
  end

  self:SetSize(w, h)
  self:SetPos( (ScrW() - w) / 2, math.min(72, (ScrH() - h) / 4))

  self.ply_frame:SetPos(8, y_logo_off + 75)
  self.ply_frame:SetSize(self:GetWide() - 16, self:GetTall() - 95 - y_logo_off - 5)

  -- server stuff
  self.hostdesc:SizeToContents()
  self.hostdesc:SetColor(Color(255,255,255,175))
  self.hostdesc:SetPos(8, y_logo_off)

  local hw = w - 180 - 8
  self.hostname:SizeToContents()
  self.hostname:SetPos(310 , y_logo_off + 37)

  self.devname:SizeToContents()
  self.devname:SetPos(w - 260 - 8, y_logo_off - 20 + self.hostname:GetTall())
  if GetGlobalBool("Morbus_Outdated",0) then
    self.devname:SetColor(Color(200,0,0,175))
    self.devname2:SetColor(Color(255,255,255,175))
  else
    self.devname2:SetColor(Color(255,255,255,0))
  end

  self.devname2:SizeToContents()
  self.devname2:SetPos(w - 210 - 8 + self.devname:GetWide()/2, y_logo_off + self.hostname:GetTall() + self.devname:GetTall() - 8)

  surface.SetFont("cool_large")
  local hname = self.hostname:GetValue()
  local tw, _ = surface.GetTextSize(hname)
  while tw > hw do
    hname = string.sub(hname, 1, -6) .. "..."
    tw, th = surface.GetTextSize(hname)
  end

  self.hostname:SetText(hname)

  self.mapchange:SizeToContents()
  self.mapchange:SetPos(w - self.mapchange:GetWide() - 8, y_logo_off + 40)

  -- score columns
  local cy = y_logo_off + 78
  for k,v in ipairs(self.cols) do
    v:SizeToContents()
    v:SetPos( w - (49*k) - v:GetWide()/2 - 8, cy)
  end
end

function PANEL:ApplySchemeSettings()
  self.hostdesc:SetFont("DSMass")
  self.hostname:SetFont("cool_large")
  self.devname:SetFont("DSLarge")
  self.devname2:SetFont("treb_small")
  self.mapchange:SetFont("treb_small")

  self.hostdesc:SetTextColor(COLOR_WHITE)
  self.hostname:SetTextColor(COLOR_BLACK)
  self.mapchange:SetTextColor(COLOR_WHITE)

  for k,v in pairs(self.cols) do
    v:SetFont("treb_small")
    v:SetTextColor(COLOR_WHITE)
  end
end

function PANEL:UpdateScoreboard( force )
  if not force and not self:IsVisible() then return end

  local layout = false

  -- Put players where they belong. Groups will dump them as soon as they don't
  -- anymore.
  for k, p in pairs(player.GetAll()) do
    if IsValid(p) then
      --local group = ScoreGroup(p)
	  local selfPlyGroup = self.ply_groups[ScoreGroup(p)]
      if selfPlyGroup and not selfPlyGroup:HasPlayerRow(p) then
        selfPlyGroup:AddPlayerRow(p)
        layout = true
      end
    end
  end

  for k, group in pairs(self.ply_groups) do
    if ValidPanel(group) then
      group:SetVisible( group:HasRows() )
      group:UpdatePlayerData()
    end
  end

  if layout then
    self:PerformLayout()
  else
    self:InvalidateLayout()
  end
end

vgui.Register( "MScoreboard", PANEL, "Panel" )

---- PlayerFrame is defined in sandbox and is basically a little scrolling
---- hack. Just putting it here (slightly modified) because it's tiny.

local PANEL = {}
function PANEL:Init()
  self.pnlCanvas  = vgui.Create( "Panel", self )
  self.YOffset = 0

  self.scroll = vgui.Create("DVScrollBar", self)
end

function PANEL:GetCanvas() return self.pnlCanvas end

function PANEL:OnMouseWheeled( dlta )
  self.scroll:AddScroll(dlta * -2)

  self:InvalidateLayout()
end

function PANEL:SetScroll(st)
  self.scroll:SetEnabled(st)
end

function PANEL:PerformLayout()
  self.pnlCanvas:SetVisible(self:IsVisible())
  
  local wide = self:GetWide()

  -- scrollbar
  self.scroll:SetPos(wide - 16, 0)
  self.scroll:SetSize(16, self:GetTall())

  local was_on = self.scroll.Enabled
  self.scroll:SetUp(self:GetTall(), self.pnlCanvas:GetTall())
  self.scroll:SetEnabled(was_on) -- setup mangles enabled state

  self.YOffset = self.scroll:GetOffset()
  self.pnlCanvas:SetPos( 0, self.YOffset )  
  self.pnlCanvas:SetSize( wide - (self.scroll.Enabled and 16 or 0), self.pnlCanvas:GetTall() )
end
vgui.Register( "MPlayerFrame", PANEL, "Panel" )

