local E = select(2, ...):unpack()

function E:GetConfig(key)
    --return Config[key]
    return self.DB.global[key]
end

function E:SaveConfig(key, value)
    --Config[key] = value
    self.DB.global[key] = value
end