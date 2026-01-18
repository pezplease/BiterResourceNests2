function specilized_biter_results(resource_type)
    biter_units = {
        {
            resource_type .. "-" .. "small-biter",
            {
                {
                    0,
                    0.3
                },
                {
                    0.6,
                    0
                }
            }
        },
        {
            resource_type .. "-" .. "medium-biter",
            {
                {
                    .2,
                    0
                },
                {
                    0.6,
                    0.3
                },
                {
                    0.7,
                    0.1
                }
            }
        },
        {
            resource_type .. "-" .. "big-biter",
            {
                {
                    0.2,
                    0
                },
                {
                    1,
                    0.4
                }
            }
        },
        {
            resource_type .. "-" .. "behemoth-biter",
            {
                {
                    0.85,
                    0
                },
                {
                    1,
                    0.3
                }
            }
        }
    }
    return biter_units
end

function specilized_spitter_results(resource_type)
    spitter_units = {
        {
            resource_type .. "-" .. "small-biter",
            {
                {
                    0,
                    0.3
                },
                {
                    0.6,
                    0
                }
            }
        },
        {
            resource_type .. "-" .. "small-spitter",
            {
                {
                    0,
                    0.3
                },
                {
                    0.35,
                    0.1
                },
                {
                    0.6,
                    0
                }
            }
        },
        {
            resource_type .. "-" .. "medium-spitter",
            {
                {
                    0.2,
                    0.2
                },
                {
                    0.7,
                    0.3
                },
                {
                    0.9,
                    0.1
                }
            }
        },
        {
            resource_type .. "-" .. "big-spitter",
            {
                {
                    0.2,
                    0.05
                },
                {
                    1,
                    0.4
                }
            }
        },
        {
            resource_type .. "-" .. "big-biter",
            {
                {
                    0.25,
                    0.01
                },
                {
                    1,
                    0.4
                }
            }
        },
        {
            resource_type .. "-" .. "behemoth-spitter",
            {
                {
                    0.75,
                    0
                },
                {
                    1,
                    0.15
                }
            }
        }
    }
    return spitter_units
end

--default list of biters for generic resource
biter_list = {
    "small-biter",
    "medium-biter",
    "big-biter",
    "behemoth-biter",
}
--specialized list of biters and spitters
spitter_list = {
    "small-biter",
    "medium-biter",
    "big-biter",
    "behemoth-biter",

    "small-spitter",
    "medium-spitter",
    "big-spitter",
    "behemoth-spitter",
}


generic_spawner_data = {
    name = "generic",
    color_data = {
         r = 0.3, g = 0.3, b = 0.3, a = 1
    },
    damage_type = "physical",
    loot_name = nil,
    biter_data = {
        health_multiplier = .9,
        speed_multiplier = 1,
        damage_multiplier = 1,
    },
    unit_types = biter_list,
    spawner_data = {
        --max_health = 350,
        --spawning_cooldown = { 4, 6 },
        --max_units = 50,
        corpse = "big-explosion",
        --nest_attack = "boulder",
    },
    resistance_data =
    {
        physdec = 0,
        physperc = 10,
        expdec = 0,
        expperc = 10,
        aciddec = 0,
        acidperc = 10,
        firedec = 0,
        fireperc = 10,
        laserdec = 0,
        laserperc = 10,
        elecdec = 0,
        elecperc = 10,
        poisdec = 0,
        poisperc = 10,
        impdec = 0,
        impperc = 10
    }
}
function create_biter_template(overrides)
    local function deep_copy(original)
        local copy = {}
        for k, v in pairs(original) do
            if type(v) == "table" then
                copy[k] = deep_copy(v)
            else
                copy[k] = v
            end
        end
        return copy
    end
    local template = deep_copy(generic_spawner_data)
    if overrides then
        for k, v in pairs(overrides) do
            if type(v) == "table" and type(template[k]) == "table" then
                for sub_k, sub_v in pairs(v) do
                    template[k][sub_k] = sub_v -- Override only specific sub-keys
                end
            else
                template[k] = v -- Override full values
            end
        end
    end

    return template
end

resource_list = {
    ["iron-ore"] = create_biter_template(
        {
            damage_type = "physical",
            loot_name = "iron-ore",
            name = "iron-ore",
            biter_data = { health_multiplier = 1.1, speed_multiplier = 0.65 },
            color_data = { r = 0.45, g = 0.6, b = 0.9, a = 1 },
            resistance_data =
            {
            physperc = 20,
            physdec = -5,
            },
        }),

    ["generic"] = create_biter_template({ name = "generic" }),

    ["copper-ore"] = create_biter_template({
        damage_type = "acid",
        loot_name = "copper-ore",
        name = "copper-ore",
        unit_types = spitter_list,
        color_data = { r = 0.803, g = 0.388, b = 0.215, a = 1 },
        resistance_data = {
            acidperc = 70,
            poisperc = 90,
        },
        spawner_data = {
            nest_attack = "both",
        },
    }),
    ["coal"] = create_biter_template({
        damage_type = "explosion",
        loot_name = "coal",
        name = "coal",
        spawner_data = {
            nest_attack = "both",
        },
        unit_types = spitter_list,
        color_data = { r = 0.2, g = 0.2, b = 0.2, a = 1 },
        biter_overrides = {
            health_multiplier = 1.2,
            speed_multiplier = .55,
            damage_multiplier = 2,
        },
         resistance_data = {
             impperc = 20,
             expperc = -20,
             fireperc = -35,
             poisperc = 85,
         }
    }),
    ["stone"] = create_biter_template({
        name = "stone",
        damage_type = "physical",
        loot_name = "stone",
        --spawner_data = {
            --max_health = 3300},

        color_data = { r = 0.99, g = 0.99, b = 0.99, a = 1 },
        biter_data = {
            health_multiplier = 1.45,
            speed_multiplier = 0.25,
            damage_multiplier = 2
        },
        resistance_data = {
            impperc = -40,
            expperc = -50,
            elecperc = 70,
            laserperc = 70,
            poisperc = 98,
            physperc = 35,
            fireperc = 25,
        }
    }),
    ["uranium-ore"] = create_biter_template({
        name = "uranium-ore",
        damage_type = "poison",
        loot_name = "uranium-ore",
        color_data = { r = 0.25, g = 0.91, b = 0.25, a = 1 },
        biter_data = {
            health_multiplier = 1.6,
            speed_multiplier = 1,
            damage_multiplier = 2
        },
        unit_types = spitter_list,
        resistance_data = {
            physdec = 5,
            physperc = 20,
            elecperc = 15,
            acidperc = 99,
            poisperc = 99,
            impperc = 15,
            expperc = -40,
            expdec = -10,
        },
        spawner_data = {
            nest_attack = "both",
        },
    }
    ),
    ["crude-oil"] = create_biter_template({
        name = "crude-oil",
        damage_type = "fire",
        --awner_data = {
        --    max_health = 3000,
        --    spawning_cooldown = {15,20},
        --    nest_attack = "spitter",
        --},
        unit_types = spitter_list,
        biter_data = {
            health_multiplier = 0.65,
            speed_multiplier = 1.65,
            damage_multiplier = 0.75,
        },
        color_data = { r = 0.89, g = 0.349, b = 0.588, a = 1 },
        resistance_data = {
            fireperc = -85,
            expperc = -35,
            poisperc = 85,
            physperc = 20,
        }
    })
}


function add_res_list_to_table(res_name, overrides)
        table.insert(resource_list,{
            [res_name] = create_biter_template(overrides)}
    )
end

