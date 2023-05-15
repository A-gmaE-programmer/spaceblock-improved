--[[ Invisible beacon & modules for mining productivity research - Credit Fumelgo ]]--

local beacon={
	type="beacon",
	name="spaceblock-mining-prod-provider",
	energy_usage="10W",
	energy_source={type = "void",},
	flags = { "hide-alt-info", "not-blueprintable", "not-deconstructable", "not-on-map", "not-flammable", "not-repairable", "no-automated-item-removal", "no-automated-item-insertion" },
	animation={
		filename = modname.."/graphics/empty.png",
		width = 1,height = 1,line_length = 8,frame_count = 1,
	},
	animation_shadow={
		filename = modname.."/graphics/empty.png",
		width = 1,height = 1,line_length = 8,frame_count = 1,
	},
	base_picture={
		filename = modname.."/graphics/empty.png",
		width = 1,height = 1,
	},
	radius_visualisation_picture={
		filename = modname.."/graphics/empty.png",
		width = 1,height = 1
	},
	supply_area_distance = 0,
	distribution_effectivity = 1,
	module_specification = {module_slots = 65535,},
	allowed_effects = { "productivity" },
	selection_box=nil,
	collision_box=nil,
	collision_mask={},
}


local module={
	type = "module",
	name = "spaceblock-mining-prod-module",
	icon = modname.."/graphics/empty.png",
	icon_size = 1,
	flags = { "hidden", "hide-from-bonus-gui" },
	subgroup = "module",
	category = "productivity",
	tier = 0,
	stack_size = 1,
	effect = { productivity = {bonus = 0.10}},
	limitation = {},
	limitation_message_key="",
}
for k,v in pairs(spaceblock.recipes)do table.insert(module.limitation,v.name) end
for k,v in pairs(spaceblock.matter_recipes)do table.insert(module.limitation,v.name) end

data.raw["assembling-machine"]["assembling-machine-1"].allowed_effects={"productivity"}
data.raw["assembling-machine"]["assembling-machine-1"].module_specification={module_info_icon_shift = {0,0.8},module_slots = 0}

data:extend({beacon,module})