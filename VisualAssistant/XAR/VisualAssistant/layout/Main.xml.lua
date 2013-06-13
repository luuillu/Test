function OnInitControl(self)
	self:SetObjPos2(0,0,"father.width","father.height")
end

function OnDestroy(self)
	AsynCall(function() 
		os.exit()
	end)
end