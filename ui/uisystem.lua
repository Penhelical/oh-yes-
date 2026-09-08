local module = {}
module.renderGroups = {}


module.AddObject = function(obj,group)
	if not module[group] then table.insert(module.renderGroups,group) module[group] = {} end
	if module[group][obj.z] == nil then module[group][obj.z] = {} end
	if obj.range then module[group][obj.z][obj.range] = obj return obj.z, obj.range end
	table.insert(module[group][obj.z],obj)
	return obj.z, #module[group][obj.z]
end

module.affectAll = function(group,func)
	local t = {}
	for i,d in pairs(module[group] or {}) do
		if type(d) == "table" then
			for i,v in pairs(d) do
				func(v)
			end
		end
	end
end

module.Destroy = function(group,z,n)
	module[group][z][n] = nil
end

return module