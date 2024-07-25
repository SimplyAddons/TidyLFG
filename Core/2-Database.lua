local E = select(2, ...):unpack()

function E:GetConfig(key)
	return self.DB and self.DB.global[key]
end

function E:SaveConfig(key, value)
	if self.DB then
		self.DB.global[key] = value
	end
end
