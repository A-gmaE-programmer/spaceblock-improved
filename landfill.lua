lib={DATA_LOGIC=true}
require("lib/lib")

local modname = "__spaceblock-improved__"
local hand=logic.hand
local spaceblock={}

-- Find the most basic science pack
spaceblock.initial_packs={}
logic.InitScanResourceCats()
logic.InitScanCraftCats()
logic.InitScanRecipes()
logic.InitScanTechnologies()
logic.ScanRecipes(true)
for k,v in pairs(hand.items) do 
	if(proto.LabPack(k)) then
		spaceblock.initial_packs[k] = proto.RawItem(k)
	end
end

-- Increase stack size of vanilla landfill and allow it to replace everything
data.raw.item.landfill.place_as_tile.condition = {}
data.raw.item.landfill.stack_size = math.max(data.raw.item.landfill.stack_size, 200)
data.raw.recipe.landfill.enabled = true

-- New recipe for crafting landfill

function spaceblock.ExtendLandfill()
	if(table_size(spaceblock.initial_packs) == 0) then return end
	local orig = data.raw.recipe.landfill
	local rs = table.deepcopy(proto.Results(orig))
	local amt=settings.startup.spaceblock_landfill.value or 1

	for k=#rs,1,-1 do local v=rs[k]
		if((v[1] or v.name):find("landfill"))then rs[k].name=(v[1] or v.name) rs[k][1]=nil rs[k][2]=nil rs[k].amount=amt+5 rs[k].catalyst_amount=5
		elseif((v[1] or v.name):find("powerblock"))then rs[k]=nil
		end
	end

	local recipe={type="recipe",name="spaceblock-landfill",icon_size=32,enabled=true, localised_name={"item-name."..orig.name},localised_description={"item-description."..orig.name},
		icon_size=32,icons={{icon=modname.."/graphics/icons/bootstrap.png",tint={r=0,g=1,b=0.25,a=1}}},
		category="crafting",subgroup="spaceblock-dupe-bootstrap",order="a1cc",ingredients={},energy_required=settings.startup.spaceblock_landfill_speed.value or 5,	}

	for k,v in pairs(spaceblock.initial_packs)do table.insert(recipe.ingredients,{type="item",name=k,amount=settings.startup.spaceblock_landfill_cost.value or 2}) end
	recipe.results=rs

	table.insert(recipe.ingredients,{type="item",name="landfill",amount=5})
	data:extend{recipe}
end

spaceblock.ExtendLandfill()

-- Waterfill recipe & tile

local water = data.raw.tile["water"]
local waterfill = table.deepcopy(data.raw.recipe["concrete"])
-- In game name & description of waterfill recipe
waterfill.name = "spaceblock-water"
waterfill.localised_name = water.localised_name or {"tile-name."..t.name}
waterfill.localised_description = water.localised_description
-- Actual recipe
waterfill.ingredients = {{
	type="fluid",
	name="water",
	amount=10000
}}
waterfill.result = "spaceblock-water"
waterfill.result_count = 1
waterfill.results = nil
-- Icon stuff
waterfill.icons ={{
	icon = "__base__/graphics/terrain/water/water1.png",
	icon_size=32
}}
waterfill.icon=nil
waterfill.icon_size=32
waterfill.main_product = nil
waterfill.enabled = true

-- Waterfill item/tile
local waterfill_tile = table.deepcopy(data.raw.item["concrete"])
waterfill_tile.name = "spaceblock-water"
waterfill_tile.place_as_tile = {
	condition = {"water-tile"},
	condition_size = 1,
	result = "water"
}
waterfill_tile.subgroup = "terrain"
waterfill_tile.icon = nil
waterfill_tile.icons = {{
	icon = "__base__/graphics/terrain/water/water1.png",
	icon_size = 32
}}
waterfill_tile.icon_size=32
-- Add it
data:extend{
	waterfill,
	waterfill_tile
}