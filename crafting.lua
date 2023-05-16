local modname = "__spaceblock-improved__"
local spaceblock={}

data:extend{ -- Add new crafting tab for spaceblock duplications
    {name="spaceblock-duplications",type="item-group",order="q",order_in_recipe="0",enabled=true,
        icons={{icon=modname.."/graphics/icons/blackhole.png",icon_size=128}},
    },
    {
        name = "spaceblock-dupe-bootstrap",
        type = "item-subgroup",
        group = "spaceblock-duplications",
        order = "7"
    },
	{
        name="spaceblock-dupe-tree",
        type="item-subgroup",
        group="spaceblock-duplications",
        order="a"
    },
	{
        name="spaceblock-dupe-raw",
        type="item-subgroup",
        group="spaceblock-duplications",
        order="b"},
	{
        name="spaceblock-dupe-fluid",
        type="item-subgroup",
        group="spaceblock-duplications",
        order="c"
    },
	{
        name="spaceblock-dupe-chem",
        type="item-subgroup",
        group="spaceblock-duplications",
        order="d"
    },
    {
        name="spaceblock-dupe-convert",
        type="item-subgroup",
        group="spaceblock-duplications",
        order="e"
    },
}