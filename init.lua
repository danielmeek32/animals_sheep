--= Sheep for Animals mod =--
-- Copyright (c) 2016 Daniel <https://github.com/danielmeek32>
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

local function shear(self, drop_count)
	if self.has_wool == true then
		self.has_wool = false
		local pos = self.object:getpos()
		core.sound_play("animals_shears", {pos = pos, gain = 1, max_hear_distance = 10})
		self.object:set_properties({textures = {"animals_sheep.png"}})
		animals.dropItems(pos, {{"wool:white", drop_count}})
	end
end

local def = {
	name = "animals:sheep",
	stats = {
		hp = 8,
		lifetime = 450, -- 7,5 Minutes
		jump_height = 1.0,
		eat_nodes = {"default:dirt_with_grass"},
		follow_items = {"farming:wheat"},
		follow_speed = 1.0,
		follow_radius = 5,
		follow_stop_distance = 1.5,
		tame_items = {"farming:wheat"},
		breed_items = {"farming:wheat"},
		breedtime = 300, -- 5 Minutes
		lovetime = 10, -- 10 Seconds
	},

	model = {
		mesh = "animals_sheep.b3d",
		textures = {"animals_sheep.png^animals_sheep_white.png"},
		collisionbox = {-0.5, -0.01, -0.55, 0.5, 1.1, 0.55},
		rotation = -90.0,
		collide_with_objects = true,
		animations = {
			idle = {start = 1, stop = 60, speed = 15},
			walk = {start = 81, stop = 101, speed = 18},
			walk_long = {start = 81, stop = 101, speed = 18},
			eat = {start = 107, stop = 170, speed = 12, loop = false},
			follow = {start = 81, stop = 101, speed = 15},
			death = {start = 171, stop = 191, speed = 32, loop = false, duration = 2.52},
		},
	},

	sounds = {
		on_damage = {name = "animals_sheep", gain = 1.0, distance = 10},
		on_death = {name = "animals_sheep", gain = 1.0, distance = 10},
		swim = {name = "animals_splash", gain = 1.0, distance = 10,},
		random = {
			idle = {name = "animals_sheep", gain = 0.6, distance = 10, time_min = 23},
		},
	},

	modes = {
		idle = {chance = 0.5, duration = 10, update_yaw = 8},
		walk = {chance = 0.14, duration = 4.5, moving_speed = 1.3},
		walk_long = {chance = 0.11, duration = 8, moving_speed = 1.3, update_yaw = 5},
		eat = {chance = 0.25, duration = 4},
	},

	drops = function(self)
		local items = {{"animals:flesh"}}
		if self.has_wool then
			table.insert(items, {"wool:white", {min = 1, max = 2}})
		end
		animals.dropItems(self.object:getpos(), items)
	end,

	spawning = {
		abm_nodes = {
			spawn_on = {"default:dirt_with_grass"},
		},
		abm_interval = 55,
		abm_chance = 7800,
		max_number = 1,
		number = {min = 1, max = 3},
		time_range = {min = 5100, max = 18300},
		light = {min = 10, max = 15},
		height_limit = {min = 0, max = 25},
	},

	get_staticdata = function(self)
		return {
			has_wool = self.has_wool
		}
	end,

	on_activate = function(self, staticdata)
		if self.has_wool == nil then
			self.has_wool = true
		elseif self.has_wool == false then
			self.object:set_properties({textures = {"animals_sheep.png"}})
		end
	end,

	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		if item then
			local name = item:get_name()
			 if name == "animals_sheep:shears" and self.has_wool then
				shear(self, math.random(2, 3))
				item:add_wear(65535/100)
				if not core.setting_getbool("creative_mode") then
					clicker:set_wielded_item(item)
				end
				return true
			end
		end
		return false
	end,

	on_eat = function(self)
		self.has_wool = true
		self.object:set_properties({textures = {"animals_sheep.png^animals_sheep_white.png"}})
	end
}

animals.registerMob(def)
