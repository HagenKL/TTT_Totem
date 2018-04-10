-- Simple animated image extension by saibotk
local PANEL = {}

AccessorFunc( PANEL, "m_iFrames",         "Frames" )

function PANEL:Init()
	self.frame = 0
	self.m_iFrames = 1
	self.anim = Derma_Anim( "AnimateImage", self, self.Animate )
	return self.BaseClass.Init(self)
end

function PANEL:SetMaterial(mat)
	if mat then
		mat:SetInt("$frame", 0 )
		mat:Recompute()
	end
	return self.BaseClass.SetMaterial(self, mat)
end

function PANEL:StartAnim( length )
	self.anim:Start( length )
end

function PANEL:Think()
	if self.anim:Active() then
		self.anim:Run()
	end
end

function PANEL:Animate( anim, delta, data )
   local mat = self:GetMaterial()

   local newframe = math.Truncate( self.m_iFrames * delta, 0 )
   if (delta == 1) then newframe = self.m_iFrames - 1 end
   if mat and self.frame < newframe then
	   self.frame = newframe
	   mat:SetInt("$frame", newframe )
	   mat:Recompute()
	   self.BaseClass.SetMaterial(self, mat)
   end
end

vgui.Register( "DAnimatedImage", PANEL, "DImage" )
