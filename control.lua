-- Map resource biter unit names to their nest type
local function get_nest_type_for_unit(unit_name)
  local resource_types = {"iron-ore", "copper-ore", "coal", "stone", "uranium-ore", "crude-oil"}

  for _, resource in pairs(resource_types) do
    if string.find(unit_name, "^" .. resource .. "%-") then
      return "active-biter-spawner-" .. resource
    end
  end

  return nil -- Not a resource biter, use default expansion behavior
end

-- Handle biter nest built by expansion
script.on_event(defines.events.on_biter_base_built, function(event)
  -- Check if expansion replacement is disabled
  if settings.global["resource-biters-disable-expansion"].value then
    return
  end
  local entity = event.entity
  if not entity or not entity.valid then return end

  -- Only process spawner types
  if entity.type ~= "unit-spawner" then return end

  -- Check if this is a default biter-spawner that was created by expansion
  if entity.name ~= "biter-spawner" then return end

  -- Find units nearby that belong to the same force to determine what type of nest to create
  local nearby_units = entity.surface.find_entities_filtered{
    position = entity.position,
    radius = 64,
    force = entity.force,
    type = "unit"
  }

  -- Count resource biter types nearby
  local resource_counts = {}
  for _, unit in pairs(nearby_units) do
    if unit.valid then
      local nest_type = get_nest_type_for_unit(unit.name)
      if nest_type then
        resource_counts[nest_type] = (resource_counts[nest_type] or 0) + 1
      end
    end
  end

  -- Find the most common resource biter type
  local best_nest_type = nil
  local best_count = 0
  for nest_type, count in pairs(resource_counts) do
    if count > best_count then
      best_count = count
      best_nest_type = nest_type
    end
  end

  -- If we found resource biters nearby, replace the nest with the appropriate type
  if best_nest_type then
    local surface = entity.surface
    local position = entity.position
    local force = entity.force
    local health_ratio = entity.health / entity.max_health

    -- Destroy the default nest
    entity.destroy()

    -- Create the resource-specific nest
    local new_nest = surface.create_entity{
      name = best_nest_type,
      position = position,
      force = force
    }

    if new_nest and new_nest.valid then
      new_nest.health = new_nest.max_health * health_ratio
    end
  end
end)
