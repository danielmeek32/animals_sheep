--= Sheep for Animals mod =--
-- Copyright (c) 2017 Daniel <https://github.com/danielmeek32>
--
-- Modified from the original version for Creatures MOB-Engine (cme)
-- Copyright (c) 2015 BlockMen <blockmen2015@gmail.com>
--
-- init.lua
--
-- This software is provided 'as-is', without any express or implied warranty. In no
-- event will the authors be held liable for any damages arising from the use of
-- this software.
--
-- Permission is granted to anyone to use this software for any purpose, including
-- commercial applications, and to alter it and redistribute it freely, subject to the
-- following restrictions:
--
-- 1. The origin of this software must not be misrepresented; you must not
-- claim that you wrote the original software. If you use this software in a
-- product, an acknowledgment in the product documentation is required.
-- 2. Altered source versions must be plainly marked as such, and must not
-- be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.
--

-- shears
core.register_tool(":animals_sheep:shears", {
	description = "Shears",
	inventory_image = "animals_shears.png",
})

core.register_craft({
	output = 'animals_sheep:shears',
	recipe = {
		{'', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:stick'},
	}
})

local def = {
	name = "animals:sheep",
	parameters = {
		hp = 8,
		life_time = 450, -- 7,5 Minutes
		eat_nodes = {"default:dirt_with_grass"},
		follow_items = {"farming:wheat"},
		follow_speed = 1.0,
		follow_distance = 5,
		follow_stop_distance = 1.5,
		tame_items = {"farming:wheat"},
		breed_items = {"farming:wheat"},
		breed_distance = 4,
		breed_time = 10, -- 10 Seconds
		breed_cooldown_time = 300, -- 5 Minutes
		death_duration = 2.52,
	},

	model = {
		mesh = "animals_sheep.b3d",
		textures = {"animals_sheep.png^animals_sheep_white.png"},
		collisionbox = {-0.4, 0, -0.4, 0.4, 1.25, 0.4},
		rotation = -90.0,
		collide_with_objects = true,
	},

	animations = {
		idle = {start = 1, stop = 60, speed = 15},
		walk = {start = 81, stop = 101, speed = 18},
		walk_long = {start = 81, stop = 101, speed = 18},
		eat = {start = 107, stop = 170, speed = 12, loop = false},
		follow = {start = 81, stop = 101, speed = 15},
		death = {start = 171, stop = 191, speed = 32, loop = false},
	},

	sounds = {
		damage = {name = "animals_sheep", gain = 1.0, max_hear_distance = 10},
		death = {name = "animals_sheep", gain = 1.0, max_hear_distance = 10},
		swim = {name = "animals_splash", gain = 1.0, max_hear_distance = 10},
		idle = {name = "animals_sheep", gain = 0.6, max_hear_distance = 10, min_interval = 3, max_interval = 12},
		shear = {name = "animals_shears", gain = 1, max_hear_distance = 10},
	},

	modes = {
		idle = {chance = 0.5, duration = 10, direction_change_interval = 8},
		walk = {chance = 0.14, duration = 4.5, moving_speed = 1.3},
		walk_long = {chance = 0.11, duration = 8, moving_speed = 1.3, direction_change_interval = 5},
		eat = {chance = 0.25, duration = 4},
	},

	drops = function(self)
		local items = {{name = "animals:flesh"}}
		if self.has_wool then
			table.insert(items, {name = "wool:white", min = 1, max = 2})
		end
		return items
	end,

	spawning = {
		nodes = {"default:dirt_with_grass"},
		interval = 60,
		chance = 8192,
		min_time = 6000,
		max_time = 18000,
		min_height = 0,
		max_height = 24,
		surrounding_distance = 16,
		max_surrounding_count = 0,
		min_spawn_count = 1,
		max_spawn_count = 3,
		spawn_area = 4,
	},

	get_staticdata = function(self)
		return {
			has_wool = self.has_wool
		}
	end,

	on_activate = function(self, staticdata)
		local table = minetest.deserialize(staticdata)
		if table and type(table) == "table" then
			self.has_wool = table.has_wool
		end
		if self.has_wool == nil then
			self.has_wool = true
		end

		if self.has_wool == false then
			self:get_luaentity():set_properties({textures = {"animals_sheep.png"}})
		end
	end,

	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		if item then
			local name = item:get_name()
			 if name == "animals_sheep:shears" and self.has_wool then
				self.has_wool = false
				self:play_sound("shear")
				self:get_luaentity():set_properties({textures = {"animals_sheep.png"}})
				self:drop_items({{name = "wool:white", min = 2, max = 3}})
				item:add_wear(65535/100)
				if not minetest.setting_getbool("creative_mode") then
					clicker:set_wielded_item(item)
				end
				return true
			end
		end
		return false
	end,

	on_eat = function(self)
		self.has_wool = true
		self:get_luaentity():set_properties({textures = {"animals_sheep.png^animals_sheep_white.png"}})
	end
}

animals.register(def)
