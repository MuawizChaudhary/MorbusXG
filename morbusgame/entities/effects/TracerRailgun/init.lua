EFFECT.LaserMat = Material("trails/plasma")
EFFECT.EndSprMat = Material("effects/yellowflare")

/*-------------------------------------------------------------------
	[ Init ]
	When the entity is first initialised.
-------------------------------------------------------------------*/
function EFFECT:Init(data)
	self.Position = data:GetStart()
	self.Weapon = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.StartPos = self:GetTracerShootPos(self.Position,self.Weapon,self.Attachment)
	self.EndPos = data:GetOrigin()
	self.Length = (self.StartPos - self.EndPos):Length()
	
	if not IsValid(self.Weapon) then return false end

		if LocalPlayer() == self.Weapon.Owner and LocalPlayer():GetFOV() < 75 then
		self.StartPos = LocalPlayer():GetShootPos() + Vector(0,0,-10)
		
	end	
	self.Alpha = 255
	self.Width = 5
	self.Entity:SetRenderBoundsWS(self.StartPos,self.EndPos)
end

/*-------------------------------------------------------------------
	[ Think ]
	Think cycle; gradually reduces alpha until we end drawing (return false).
-------------------------------------------------------------------*/
function EFFECT:Think()
	if not self.Alpha then return false end
	self.Alpha = self.Alpha - FrameTime() * 2000
	
	if self.Alpha < 0 then return false end
	return true
end

/*-------------------------------------------------------------------
	[ Render ]
	The visible aspect of the effect.
-------------------------------------------------------------------*/
function EFFECT:Render()
	if self.Alpha < 1 then return end
	
	// Complicated alpha equation (its not).
	local alpha = self.Alpha + ((self.Alpha/2) * math.sin(CurTime()*((255-self.Alpha)*0.08))) 
   
	// Laser beams:
	render.SetMaterial(self.LaserMat)
	
	// Colored beam
	render.DrawBeam(self.StartPos, 						// Startpos
					self.EndPos,						// Endpos
					self.Width,							// Width
					CurTime()*15 + (self.Length*0.01),	// Start tex coord
					CurTime()*15,						// End tex coord
					Color(255, 115, 0, 255)) // Color
	

	
	// End sprite.
	render.SetMaterial(self.EndSprMat)
	
	// Colored sprites
	render.DrawSprite(self.StartPos, self.Width*2, self.Width*1, 255, 155, 0, 255)
	render.DrawSprite(self.EndPos, self.Width*2, self.Width*1, 255, 155, 0, 255)
end
