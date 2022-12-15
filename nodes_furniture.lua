---------------------------------------------------------------------------------------
-- furniture
---------------------------------------------------------------------------------------
-- contains:
--  * bench - if you don't have 3dforniture:chair, then this is the next best thing
--  * table - very simple one
--  * shelf - for stroring things; this one is 3d
--  * stovepipe - so that the smoke from the furnace can get away
--  * washing place - put it over a water source and you can 'wash' yourshelf
---------------------------------------------------------------------------------------
-- TODO: change the textures of the bed (make the clothing white, foot path not entirely covered with cloth)

local S = cottages.S




-- furniture; possible replacement: 3dforniture:chair
minetest.register_node("cottages:bench", {
	drawtype = "nodebox",
	description = S("simple wooden bench"),
	tiles = {"cottages_minimal_wood.png", "cottages_minimal_wood.png",  "cottages_minimal_wood.png",  "cottages_minimal_wood.png",  "cottages_minimal_wood.png",  "cottages_minimal_wood.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
	sounds = cottages.sounds.wood,
	node_box = {
		type = "fixed",
		fixed = {
					-- sitting area
					{-0.5, -0.15, 0.1,  0.5,  -0.05, 0.5},
					
					-- stützen
					{-0.4, -0.5,  0.2, -0.3, -0.15, 0.4},
					{ 0.3, -0.5,  0.2,  0.4, -0.15, 0.4},
				}
	},
	selection_box = {
		type = "fixed",
		fixed = {
					{-0.5, -0.5, 0, 0.5, 0, 0.5},
				}
	},
	is_ground_content = false,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				return cottages.sit_on_bench( pos, node, clicker, itemstack, pointed_thing );
			end,
})


-- a simple table; possible replacement: 3dforniture:table
local cottages_table_def = {
		description = S("table"),
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {"cottages_minimal_wood.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.1, -0.5, -0.1,  0.1, 0.3,  0.1},
				{ -0.5,  0.48, -0.5,  0.5, 0.4,  0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.4,  0.5},
			},
		},
		is_ground_content = false,
}


-- search for the workbench in AdventureTest
local workbench = minetest.registered_nodes[ "workbench:3x3"];
if( workbench ) then
	cottages_table_def.tiles        = {workbench.tiles[1], cottages_table_def.tiles[1]};
	cottages_table_def.on_rightclick = workbench.on_rightclick;
end
-- search for the workbench from RealTEst
workbench = minetest.registered_nodes[ "workbench:work_bench_birch"];
if( workbench ) then
	cottages_table_def.tiles	= {workbench.tiles[1], cottages_table_def.tiles[1]};
	cottages_table_def.on_construct = workbench.on_construct;
	cottages_table_def.can_dig      = workbench.can_dig;
	cottages_table_def.on_metadata_inventory_take = workbench.on_metadata_inventory_take;
	cottages_table_def.on_metadata_inventory_move = workbench.on_metadata_inventory_move;
	cottages_table_def.on_metadata_inventory_put  = workbench.on_metadata_inventory_put;
end

minetest.register_node("cottages:table", cottages_table_def );

-- looks better than two slabs impersonating a shelf; also more 3d than a bookshelf 
-- the infotext shows if it's empty or not
minetest.register_node("cottages:shelf", {
		description = S("open storage shelf"),
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {"cottages_minimal_wood.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		node_box = {
			type = "fixed",
			fixed = {

 				{ -0.5, -0.5, -0.3, -0.4,  0.5,  0.5},
 				{  0.4, -0.5, -0.3,  0.5,  0.5,  0.5},

				{ -0.5, -0.2, -0.3,  0.5, -0.1,  0.5},
				{ -0.5,  0.3, -0.3,  0.5,  0.4,  0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.5,  0.5},
			},
		},

		on_construct = function(pos)

                	local meta = minetest.get_meta(pos);

			local spos = pos.x .. "," .. pos.y .. "," .. pos.z
	                meta:set_string("formspec",
                                "size[8,8]"..
                                "list[current_name;main;0,0;8,3;]"..
                                "list[current_player;main;0,4;8,4;]"..
				"listring[nodemeta:" .. spos .. ";main]" ..
				"listring[current_player;main]")
                	meta:set_string("infotext", S("open storage shelf"))
                	local inv = meta:get_inventory();
                	inv:set_size("main", 24);
        	end,

	        can_dig = function( pos,player )
	                local  meta = minetest.get_meta( pos );
	                local  inv = meta:get_inventory();
	                return inv:is_empty("main");
	        end,

                on_metadata_inventory_put  = function(pos, listname, index, stack, player)
	                local  meta = minetest.get_meta( pos );
                        meta:set_string('infotext', S('open storage shelf (in use)'));
                end,
                on_metadata_inventory_take = function(pos, listname, index, stack, player)
	                local  meta = minetest.get_meta( pos );
	                local  inv = meta:get_inventory();
	                if( inv:is_empty("main")) then
                           meta:set_string('infotext', S('open storage shelf (empty)'));
                        end
                end,
		is_ground_content = false,


})

-- so that the smoke from a furnace can get out of a building
minetest.register_node("cottages:stovepipe", {
		description = S("stovepipe"),
		drawtype = "nodebox",
		tiles = {"cottages_steel_block.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		node_box = {
			type = "fixed",
			fixed = {
				{  0.20, -0.5, 0.20,  0.45, 0.5,  0.45},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{  0.20, -0.5, 0.20,  0.45, 0.5,  0.45},
			},
		},
		is_ground_content = false,
})


-- this washing place can be put over a water source (it is open at the bottom)
minetest.register_node("cottages:washing", {
		description = S("washing place"),
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {"cottages_clay.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, -0.2, -0.2},

				{ -0.5, -0.5, -0.2, -0.4, 0.2,  0.5},
				{  0.4, -0.5, -0.2,  0.5, 0.2,  0.5},

				{ -0.4, -0.5,  0.4,  0.4, 0.2,  0.5},
				{ -0.4, -0.5, -0.2,  0.4, 0.2, -0.1},

			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.2,  0.5},
			},
		},
                on_rightclick = function(pos, node, player)
                   -- works only with water beneath
                   local node_under = minetest.get_node( {x=pos.x, y=(pos.y-1), z=pos.z} );
		   if( not( node_under ) or node_under.name == "ignore" or (node_under.name ~= 'default:water_source' and node_under.name ~= 'default:water_flowing')) then
                      minetest.chat_send_player( player:get_player_name(), S("Sorry. This washing place is out of water. Please place it above water!"));
		   else
                      minetest.chat_send_player( player:get_player_name(), S("You feel much cleaner after some washing."));
		   end
                end,
		is_ground_content = false,

})


---------------------------------------------------------------------------------------
-- functions for sitting or sleeping
---------------------------------------------------------------------------------------

cottages.allow_sit = function( player )
	-- no check possible
	if( not( player.get_player_velocity )) then
		return true;
	end
	local velo = player:get_player_velocity();
	if( not( velo )) then
		return false;
	end
	local max_velo = 0.0001;
	if(   math.abs(velo.x) < max_velo
	  and math.abs(velo.y) < max_velo
	  and math.abs(velo.z) < max_velo ) then
		return true;
	end
	return false;
end

cottages.sit_on_bench = function( pos, node, clicker, itemstack, pointed_thing )
	if( not( clicker ) or not( default.player_get_animation ) or not( cottages.allow_sit( clicker ))) then
		return;
	end

	local animation = default.player_get_animation( clicker );
	local pname = clicker:get_player_name();

	if( animation and animation.animation=="sit") then
		default.player_attached[pname] = false
		clicker:set_pos({x=pos.x,y=pos.y-0.5,z=pos.z})
		clicker:set_eye_offset({x=0,y=0,z=0}, {x=0,y=0,z=0})
		clicker:set_physics_override(1, 1, 1)
		default.player_set_animation(clicker, "stand", 30)
	else
		-- the bench is not centered; prevent the player from sitting on air
		local p2 = {x=pos.x, y=pos.y, z=pos.z};
		if not( node ) or node.param2 == 0 then
			p2.z = p2.z+0.3;
		elseif node.param2 == 1 then
			p2.x = p2.x+0.3;
		elseif node.param2 == 2 then
			p2.z = p2.z-0.3;
		elseif node.param2 == 3 then
			p2.x = p2.x-0.3;
		end

		clicker:set_eye_offset({x=0,y=-7,z=2}, {x=0,y=0,z=0})
		clicker:set_pos( p2 )
		default.player_set_animation(clicker, "sit", 30)
		clicker:set_physics_override(0, 0, 0)
		default.player_attached[pname] = true
	end
end


---------------------------------------------------------------------------------------
-- crafting receipes
---------------------------------------------------------------------------------------
minetest.register_craft({
	output = "cottages:table",
	recipe = {
		{"", cottages.craftitem_slab_wood, "", },
		{"", cottages.craftitem_stick, "" }
	}
})

minetest.register_craft({
	output = "cottages:bench",
	recipe = {
		{"",              cottages.craftitem_wood, "", },
		{cottages.craftitem_stick, "",             cottages.craftitem_stick, }
	}
})


minetest.register_craft({
	output = "cottages:shelf",
	recipe = {
		{cottages.craftitem_stick,  cottages.craftitem_wood, cottages.craftitem_stick, },
		{cottages.craftitem_stick, cottages.craftitem_wood, cottages.craftitem_stick, },
		{cottages.craftitem_stick, "",             cottages.craftitem_stick}
	}
})

minetest.register_craft({
	output = "cottages:washing 2",
	recipe = {
		{cottages.craftitem_stick, },
		{cottages.craftitem_clay,  },
	}
})

minetest.register_craft({
	output = "cottages:stovepipe 2",
	recipe = {
		{cottages.craftitem_steel, '', cottages.craftitem_steel},
	}
})
