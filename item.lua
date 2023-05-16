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
spaceblock.recipes = {}

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
    local item_drop=proto.Results(e.minable)
    if (not item_drop or not item_drop[1]) then return end --If mining gives no products skip
    if (not proto.IsAutoplaceControl(e)) then return end --Check if resource generates
    if (not e.minable) then return end --Check if mineable
    return true
end

-- Function to abstract away the ingredient and result creation from recipe for more readable code
function setup_ingredients(dupe_recipe, type, result, temperature)
    dupe_recipe.energy_required = settings.startup["spaceblock_"..type.."_speed"]
    dupe_recipe.ingredients = {{
        type = type,
        name = result,
        amount = settings.startup["spaceblock_"..type.."_needed"].value,
    }}
    dupe_recipe.results = {{
        type = type,
        name = result,
        amount = settings.startup["spaceblock_"..type.."_needed"].value + settings.startup["spaceblock_"..type.."_count"].value,
    }}
    if (type == "fluid") then
        dupe_recipe.results[1].temperature = temperature
    end
end

-- set up simple duplication recipe based on resource
function simple_recipe(e)
    -- Figure out if resource is item or fluid and what the result of mining is
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

    -- Setup the ingredients & results for recipe
    if (category == "basic-fluid") then
        dupe_recipe.category = "oil-processing"
        dupe_recipe.subgroup = "spaceblock-dupe-fluid"
        dupe_recipe.order = "z"
        setup_ingredients(dupe_recipe, "fluid", result, temperature)
    else
        dupe_recipe.category = "crafting"
        dupe_recipe.subgroup = "spaceblock-dupe-raw"
        setup_ingredients(dupe_recipe, "item", result, temperature)
    end

    -- If an input fluid is required to mine the resource then include it in the recipe
    if (e.mineable.required_fluid) then
        dupe_recipe.category = "chemistry"
		dupe_recipe.subgroup = "spaceblock-dupe-chem"
		table.insert(dupe_recipe.ingredients, {
            type = "fluid",
            name = e.minable.required_fluid,
            amount = e.minable.fluid_amount
        })
	end

    -- Add resource to list for generating bootstrap block hole
    spaceblock.recipes[e.name] = dupe_recipe
end

function spaceblock.RecipeFromTree(e,result_id)
    -- Check if it generates
    if(not e.minable or not proto.IsAutoplaceControl(e, result_id)) then return end
    -- Get a list of results from mining the tree
	local tree_drops_list = proto.Results(e.minable)
    -- Recursively get the result(s) from tree
    if(not result_id) then
        for i,x in pairs(tree_drops_list) do
            spaceblock.RecipeFromTree(e,i)
        end 
        return 
    end
    -- Get the item droped from tree
	local item_drop=proto.Result(tree_drops_list[result_id])
    -- Ignore fluid drops as players can't harvest them anyways
    if(item_drop.type == "fluid") then return end
	local rname=item_drop.name -- Get the name of the dropped item
	if(not rname or spaceblock.recipes[rname]) then return end
	local raw = proto.RawItem(rname)
    if(not raw) then
        error("A tree possibly giving a fluid? How?: " .. serpent.block(e))
    end
    -- start setting up the recipe
	local dupe = {
        name = "spaceblock-dupe-"..rname,
        enabled = true,
        type = "recipe",
        icons = proto.Icons(raw),
        enabled = true,
		allow_decomposition = false,
		order = (raw.order and "a3"..raw.order..result_id or "a3"..result_id),
		localised_name = raw.localised_name or {"item-name."..rname},
	}

	dupe.category = "crafting"
	dupe.subgroup = "spaceblock-dupe-tree"
	dupe.energy_required = settings.startup["spaceblock_item_speed"].value
	local input_amount = settings.startup["spaceblock_item_needed"].value
	local duped_result = settings.startup["spaceblock_item_count"].value
	dupe.ingredients = {{type="item",name=rname,amount=input_amount}}
	dupe.results = {{type="item",name=rname,amount=input_amount+duped_result}}
	spaceblock.recipes[rname] = dupe
	spaceblock.temp[rname] = dupe
	spaceblock.resources.tree[rname] = e
end

-- TODO: function to link 2 resources (chain recipes)

-- TODO: maybe 2 ingredients to one recipe?


-- Scan the resources
for k,v in pairs(data.raw.resource) do
    -- Verfiy that resource can the used
    
    
end

-- Create simple recipe

-- Link chain recipes

-- TODO: maybe 2 ingredients to one recipe?


-- TODO: scan trees





-- The bootstrap recipe & space matter

function spaceblock.MakeBootstrapRecipe()

    local recipe = {
        name = "spaceblock_bootstrap",
        type = "recipe",
        icon_size = 32,
        icon = modname.."/graphics/icons/bootstrap.png",
        order = "a1aaa",
        category = "crafting",
        subgroup = "spaceblock-dupe-bootstrap",
        energy_required = settings.startup["spaceblock_bootstrap_speed"].value * 3,
        ingredients = {},
        results = {},
        enabled = true,
    }

    local space_matter = {
        name = "spaceblock_matter",
        type = "recipe",
        icons={{
            icon = "__spaceblock__/graphics/icons/bootstrap.png",
            tint = {r=0.25,g=0,b=1,a=1},
            icon_size = 32
        }},
        order = "a1ddd",
        category = "crafting",
        subgroup = "spaceblock-dupe-bootstrap",
        energy_required = settings.startup["spaceblock_bootstrap_speed"].value*3,
        ingredients = {},
        results = {{
            name = "spaceblock-matter",
            amount = 1
        },{
            name = "spaceblock-matter",
            amount = 1,
            probability = 0.1
        }},
        enabled = true,
        localised_description = {"recipe-description.spaceblock_matter"},
    }
    
    -- TODO: Add the resources to the recipes

end