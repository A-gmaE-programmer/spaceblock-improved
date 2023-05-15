require("lib/lib")

spaceblock=spaceblock or {}
spaceblock.initial_size={8,8}

events.on_init(function() events.raise_migrate() end)
events.on_config(function() end)
events.on_load(function() end)

spaceblock.ship_prototypes={"crash-site-spaceship"}
for k,v in pairs{"small","medium","big"}do
	table.insert(spaceblock.ship_prototypes,"crash-site-spaceship-wreck-"..v)
	for i=1,6,1 do table.insert(spaceblock.ship_prototypes,"crash-site-spaceship-wreck-"..v.."-"..i) end
end

script.on_event(defines.events.on_chunk_generated,function(ev)
	local f=ev.surface
	if(not (f.name=="nauvis" or f.name:sub(1,11)~="spaceblock_"))then return end
	local a=ev.area
	local tv={}
	local t={}
	local tx
	local base_tile=1
	for x=a.left_top.x,a.right_bottom.x do
		for y=a.left_top.y,a.right_bottom.y do

			if((x>=spaceblock.initial_size[1]*-1 and x<spaceblock.initial_size[1]) and (y>=spaceblock.initial_size[2]*-1 and y<spaceblock.initial_size[2]))then
				--table.insert(t,{name="concrete",position={x,y}})
				tx=tx or {} table.insert(tx,{name="landfill",position={x,y}})
			else
				local tile="space-tile-"..base_tile --"out-of-map"
				local rg=false
				if(math.random(1,5)==1)then rg=true tile="space-tile-"..math.random(1,8) end
				if(rg)then
					local zx,zy=x,y
					tv[zx]=tv[zx] or {}
					if(not tv[zx][zy])then table.insert(t,{name=tile,position={zx,zy}}) end
					for i=1,math.random(4,12) do
						local xy=math.random(1,4)-2
						zx=zx+(xy==-1 and -1 or (xy==2 and 1 or 0))
						zy=zy+(xy==0 and -1 or (xy==1 and 1 or 0))
						tv[zx]=tv[zx] or {}
						if(math.abs(zx)>spaceblock.initial_size[1] and math.abs(zy)>spaceblock.initial_size[2] and not tv[zx][zy])then
							tv[zx][zy]=true table.insert(t,{name=tile,position={zx,zy}})
						end
					end
				elseif(not tv[x] or not tv[x][y])then
					table.insert(t,{name=tile,position={x,y}}) tv[x]=tv[x] or {} tv[x][y]=true
				end
			end
		end
	end

	f.destroy_decoratives{area=a}
	if(tx)then f.set_tiles(tx) end
	f.set_tiles(t)
	
	for k,v in pairs(f.find_entities_filtered{type="character",invert=true,area=a})do v.destroy{raise_destroy=true} end

end)

function table.HasValue(t,x) for k,v in pairs(t)do if(v==x)then return true end end return false end

local BadStarterEnts={"mining-drill","furnace"}
local function StarterInventory(ev)
	local p=game.players[ev.player_index]
	local inv=p.get_main_inventory()
	if(not inv)then return end
	if(not global.first)then global.first=true else return end

	p.get_main_inventory().insert{name="assembling-machine-2",count=1}
	p.get_main_inventory().insert{name="assembling-machine-1",count=4}
	p.get_main_inventory().insert{name="chemical-plant",count=2}
	p.get_main_inventory().insert{name="solar-panel",count=20}
	p.get_main_inventory().insert{name="small-electric-pole",count=5}
	p.get_main_inventory().insert{name="landfill",count=800}
	p.get_main_inventory().insert{name="spaceblock-water",count=50}
	p.get_main_inventory().insert{name="offshore-pump",count=1}
	p.get_main_inventory().insert{name="accumulator",count=10}

	local inv=p.get_main_inventory()
	for k,v in pairs(inv.get_contents())do
		local item=game.item_prototypes[k]
		local ent if(item)then ent=game.entity_prototypes[item.name] end
		if(ent and table.HasValue(BadStarterEnts,ent.type))then --ent.type=="mining-drill")then
			inv.remove{name=k,count=v}
		end
	end
end
script.on_event(defines.events.on_cutscene_cancelled, StarterInventory)
script.on_event(defines.events.on_player_created, StarterInventory)

--[[ Do the thing for mining productivity to be applied to duplicator assemblers with invisible beacons, credit Fumelgo for the references ]]--

function spaceblock.GetMiningBonus(fc) return math.floor(fc.mining_drill_productivity_bonus * 10 + 0.5) end
function spaceblock.RecipeIsDupe(rcp) return rcp.name:sub(1,15)=="spaceblock-dupe" end

function spaceblock.RemoveAssembler(e) local obj=cache.get_entity(e) if(obj)then if(isvalid(obj.beacon))then obj.beacon.destroy() end cache.destroy_entity(obj) end end
function spaceblock.RefreshAssemblers(fc) for idx,obj in pairs(global._lib.ents)do local h=obj.host if(isvalid(h) and (h.name=="spaceblock-matter-furnace" or h.type=="assembling-machine") and h.force==fc)then spaceblock.CheckAssembler(h) end end end
function spaceblock.CheckAssembler(e) local r,obj=e.get_recipe(),cache.force_entity(e)
	if(e.name=="spaceblock-matter-furnace" or (r and spaceblock.RecipeIsDupe(r)))then
		if(not isvalid(obj.beacon))then obj.beacon=e.surface.create_entity({name="spaceblock-mining-prod-provider",position=e.position,force=e.force}) end
		local mods=obj.beacon.get_module_inventory() local modc=mods.get_item_count("spaceblock-mining-prod-module") local dif=spaceblock.GetMiningBonus(e.force)-modc
		if(dif>0)then mods.insert({name="spaceblock-mining-prod-module",count=dif}) elseif(dif<0)then mods.remove({name="spaceblock-mining-prod-module",count=dif}) end
	elseif(isvalid(obj.beacon))then
		obj.beacon.destroy()
	end
end

cache.type("assembling-machine",{
	gui_closed=spaceblock.CheckAssembler,
	settings_pasted=spaceblock.CheckAssembler,
	create=spaceblock.CheckAssembler,
	destroy=spaceblock.RemoveAssembler,
})
cache.ent("spaceblock-matter-furnace",{
	create=spaceblock.CheckAssembler,
	destroy=spaceblock.RemoveAssembler,
})

events.on_event(defines.events.on_research_finished,function(ev)
	for _,fx in pairs(ev.research.effects) do if(fx.type=="mining-drill-productivity-bonus")then spaceblock.RefreshAssemblers(ev.research.force) return end end
end)


lib.lua()