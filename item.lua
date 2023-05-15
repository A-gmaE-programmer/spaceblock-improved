local modname = "__spaceblock-improved__"
local spaceblock={}

-- Space matter item made from all basic resources
-- Planned: use in more complex machines
local matter = {
    type = "item",
    name = "spaceblock-matter",
    icons = {{
        icon = modname.."/graphics/icons/bootstrap.png"
    }}
}

spaceblock.temp = {}

function spaceblock.extend()
    if(table_size(spaceblock.temp)>0) then
		local t = {}
		for k,v in pairs(spaceblock.temp) do
			table.insert(t,v)
		end
        data:extend(t)
        spaceblock.temp = {}
	end
end

-- check if resource is mineable and whether it generates in a normal factorio world
-- also checks if there are results of mining
function can_dupe(e)
    local rz=proto.Results(e.minable)
    if (not rz or not rz[1]) then return end --If mining gives no products skip
    if (not proto.IsAutoplaceControl(e)) then return end --Check if resource generates
    if (not e.minable) then return end --Check if mineable
    return true
end

function simple_recipe(e)
    local is_fluid = false
    local result = proto.Result(proto.Results(e.minable)[1]).name
    local category = e.category or "basic-solid"
    local temperature

    for k,v in pairs(proto.Results(e.minable)) do
        if (v.type=="fluid") then 
            cat="basic-fluid" temperature=v.temperature 
            break 
        end
    end
    
    local dupe_recipe = {
        name = "spaceblock-dupe-"..e.name,
        type = "recipe",
        icons = e.icons or {{icon = e.icon}},
        icon_size = e.icon_size,
        enabled = true,
        allow_decomposition = false,
        order = (e.order and "a3" .. e.order or "a3"),
        localised_name = e.localised_name or {"entity-name."..e.name}
    }


end