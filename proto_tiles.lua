
local modpath="__spaceblock-improved__"
--[[ Space Tiles Now ]]--


local r={}
r.name="space-tile-1"
r.collision_mask={"ground-tile",
        "water-tile",
        "resource-layer",
        "floor-layer",
        "item-layer",
        "object-layer",
        "player-layer",
        "doodad-layer",}

r.type="tile"
r.layer=0
r.map_color={r=0,g=0,b=0}
r.pollution_absorption_per_second=0.01
r.tint={r=0.25,g=0.25,b=0.25,a=0.15}
r.variants={
	main={
		{
		picture = "__base__/graphics/terrain/concrete/concrete-dummy.png",
		count = 1,
		size = 1
		}
	},
	empty_transitions = true,
	material_background={
		picture = modpath.."/graphics/terrain/stars01.jpg",
		count = 1,
		scale = 256/402,
	},
}
r.can_be_part_of_blueprint=false
r.layer_group="zero"
data:extend{r}


local i=2
local x=table.deepcopy(r)
x.variants.material_background.picture=modpath.."/graphics/terrain/stars0"..i..".jpg"
x.variants.material_background.scale=(256/1024)
x.name="space-tile-"..i
data:extend{x}

local i=3
local x=table.deepcopy(r)
x.variants.material_background.picture=modpath.."/graphics/terrain/stars0"..i..".jpg"
x.variants.material_background.scale=(256/450)
x.name="space-tile-"..i
data:extend{x}

local i=4
local x=table.deepcopy(r)
x.variants.material_background.picture=modpath.."/graphics/terrain/stars0"..i..".jpg"
x.variants.material_background.scale=(256/554)
x.name="space-tile-"..i
data:extend{x}


local i=5
local x=table.deepcopy(r)
x.variants.material_background.picture=modpath.."/graphics/terrain/stars0"..i..".jpg"
x.variants.material_background.scale=(256/400)
x.name="space-tile-"..i
data:extend{x}


local i=6
local x=table.deepcopy(r)
x.variants.material_background.picture=modpath.."/graphics/terrain/stars0"..i..".jpg"
x.variants.material_background.scale=(256/554)
x.name="space-tile-"..i
x.tint={r=0.1,g=0.1,b=0.1,a=0.05}
data:extend{x}


local i=7
local x=table.deepcopy(r)
x.variants.material_background.picture=modpath.."/graphics/terrain/stars0"..i..".jpg"
x.variants.material_background.scale=(256/554)
x.name="space-tile-"..i
x.tint={r=0.1,g=0.1,b=0.1,a=0.05}
data:extend{x}


local i=8
local x=table.deepcopy(r)
x.variants.material_background.picture=modpath.."/graphics/terrain/stars0"..i..".jpg"
x.variants.material_background.scale=(256/400)
x.name="space-tile-"..i
x.tint={r=0.1,g=0.1,b=0.1,a=0.05}
data:extend{x}


--[[ Extend out of map tiles to space tiles transitions ]]--
function table.HasValue(t,x) for k,v in pairs(t)do if(v==x)then return true end end return false end

for k,v in pairs(data.raw.tile)do
	if(v.transitions)then for x,y in pairs(v.transitions)do
		if(y.to_tiles and type(y.to_tiles)=="table" and table.HasValue(y.to_tiles,"out-of-map"))then
			for i=1,8,1 do table.insert(y.to_tiles,"space-tile-"..i) end
		end
	end end
end


--[[ Purple Tile 

local t=table.deepcopy(data.raw.tile["tutorial-grid"])
t.name="space-concrete-purple"
t.tint={r=0.6,g=0.6,b=0.7,a=1}
t.decorative_removal_probability=1
t.walking_speed_modifier=2.5
t.map_color={r=0.2,g=0.1,b=0.25,a=1}
t.minable={mining_time=2,result=t.name}

data:extend{t}
]]--
--[[ Red Tile

local t=table.deepcopy(data.raw.tile["tutorial-grid"])
t.name="space-concrete-red"
t.tint={r=1,g=0.5,b=0,a=0.25}
t.decorative_removal_probability=1
t.walking_speed_modifier=1.6
t.map_color={r=0.2,g=0.1,b=0.25,a=1}
t.minable={mining_time=2,result=t.name}

data:extend{t}

]]
