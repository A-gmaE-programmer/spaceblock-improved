lib={DATA_LOGIC=true}
require("lib/lib")

-- Find the most basic science pack
spaceblock.initial_packs={}
logic.InitScanResourceCats()
logic.InitScanCraftCats()
logic.InitScanRecipes()
logic.InitScanTechnologies()
logic.ScanRecipes(true)
for k,v in pairs(hand.items)do if(proto.LabPack(k))then local raw=proto.RawItem(k) spaceblock.initial_packs[k]=raw end end

-- Increase stack size of vanilla landfill and allow it to replace everything
data.raw.item.landfill.place_as_tile.condition={}
data.raw.item.landfill.stack_size=math.max(data.raw.item.landfill.stack_size,200)
data.raw.recipe.landfill.enabled=true

-- New recipe for crafting landfill