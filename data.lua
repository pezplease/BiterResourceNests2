require "prototypes.biter-data"
require "prototypes.resource-biters"
require "prototypes.nest-attack-data"

-- Prevent vanilla biters/spitters/worms and their nests from being placed during map generation
if settings.startup["resource-biters-disable-vanilla-biters"].value then
  if data.raw["unit-spawner"]["biter-spawner"] then
    data.raw["unit-spawner"]["biter-spawner"].autoplace = nil
  end
  if data.raw["unit-spawner"]["spitter-spawner"] then
    data.raw["unit-spawner"]["spitter-spawner"].autoplace = nil
  end

  local worm_names = {
    "small-worm-turret",
    "medium-worm-turret",
    "big-worm-turret",
    "behemoth-worm-turret",
  }
  for _, worm_name in pairs(worm_names) do
    if data.raw["turret"][worm_name] then
      data.raw["turret"][worm_name].autoplace = nil
    end
  end
end

-- Create autoplace controls for each resource biter nest
local autoplace_controls = {}
local control_names = {}
for resource_key, resource_data in pairs(resource_list) do
  if resource_key ~= "generic" then
    local control_name = "active-biter-spawner-" .. resource_data.name
    table.insert(autoplace_controls, {
      type = "autoplace-control",
      name = control_name,
      localised_name = {"", {"entity-name.active-biter-spawner-" .. resource_data.name}},
      richness = true,
      order = "b-b-" .. resource_data.name,
      category = "enemy",
      can_be_disabled = true,
    })
    table.insert(control_names, control_name)
  end
end
data:extend(autoplace_controls)

-- Add the autoplace controls to Nauvis so they appear in map generation
if data.raw["planet"]["nauvis"] then
  local nauvis = data.raw["planet"]["nauvis"]
  if nauvis.map_gen_settings then
    nauvis.map_gen_settings.autoplace_controls = nauvis.map_gen_settings.autoplace_controls or {}
    for _, control_name in pairs(control_names) do
      -- frequency multiplies directly into the probability expression below,
      -- so bumping the default here makes nests ~40% more common out of the box
      nauvis.map_gen_settings.autoplace_controls[control_name] = { frequency = 4 }
    end
  end
end

--[[ add_res_list_to_table("jello", { name = "jello", unit_types = biter_list}) for the life of me i cant figure out why this fails]]
--setup_nest_attacks(resource_list)

setup_biter_corpses(resource_list)
--setup_resource_nest_corpse(resource_list)

--setup all biter types for each resource, with a generic fallback nest
setup_resource_biters(resource_list)

--setup all resource nests for each resource, with a generic fallback nest
setup_resource_nests(resource_list)
