
data:extend(
{

	{type="int-setting",name="spaceblock_landfill",order="1g5fa", -- +1 landfill
	setting_type="startup",default_value=1,
	minimum_value=1,maximum_value=50},

	{type="int-setting",name="spaceblock_landfill_cost",order="1g5fb", -- science pack cost
	setting_type="startup",default_value=2,
	minimum_value=1,maximum_value=50},

	{type="int-setting",name="spaceblock_landfill_speed",order="1g5fc",
	setting_type="startup",default_value=5,
	minimum_value=1,maximum_value=50},


	{type="double-setting",name="spaceblock_bootstrap_speed",order="21a",
	setting_type="startup",default_value=5,
	minimum_value=5,maximum_value=50},

	{type="double-setting",name="spaceblock_bootstrap_chance",order="21b",
	setting_type="startup",default_value=0.5,
	minimum_value=0.001,maximum_value=1},


	{type="double-setting",name="spaceblock_item_speed",order="22a",
	setting_type="startup",default_value=5,
	minimum_value=1,maximum_value=60},

	{type="int-setting",name="spaceblock_item_needed",order="22b",
	setting_type="startup",default_value=5,
	minimum_value=1,maximum_value=50},

	{type="int-setting",name="spaceblock_item_count",order="22c",
	setting_type="startup",default_value=1,
	minimum_value=1,maximum_value=50},

	{type="double-setting",name="spaceblock_fluid_speed",order="23a",
	setting_type="startup",default_value=5,
	minimum_value=1,maximum_value=50},

	{type="int-setting",name="spaceblock_fluid_needed",order="23b",
	setting_type="startup",default_value=500,
	minimum_value=1,maximum_value=2000},

	{type="int-setting",name="spaceblock_fluid_count",order="23c",
	setting_type="startup",default_value=250,
	minimum_value=1,maximum_value=1000},

	{
		type="double-setting",
		name="spaceblock_convert_item_speed",
		order="24a",
		setting_type="startup",
		default_value=5,
		minimum_value=1,
		maximum_value=60
	},
	{
		type = "int-setting",
		name = "spaceblock_convert_item_needed",
		order = "24b",
		setting_type = "startup",
		default_value = 5,
		minimum_value = 1,
		maximum_value = 250
	},
	{
		type="int-setting",
		name="spaceblock_convert_item_count",
		order="24c",
		setting_type="startup",
		default_value=5,
		minimum_value=1,
		maximum_value=250
	},


})