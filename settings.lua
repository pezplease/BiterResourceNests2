local mod_name = "resource-biters-"


data:extend({
	{
		type = "bool-setting",
		name = mod_name .. "add-resource-to-drop-table",
		order = "a3",
		setting_type = "startup",
		default_value = false,
	},
	{
		type = "double-setting",
		name = mod_name .. "resource-drop-rate",
		order = "a4",
		setting_type = "startup",
		default_value = 1,
		minimum_value = 0.001,
		maximum_value = 1,

	},
	{
		type = "double-setting",
		name = mod_name .. "resource-drop-amount",
		order = "a4-2",
		setting_type = "startup",
		default_value = 1,
		minimum_value = 0.01,
		maximum_value = 100,

	},
	{
		type = "double-setting",
		name = mod_name .. "biter-health-multiplier",
		order = "a6",
		setting_type = "startup",
		default_value = 1,
		minimum_value = 0.01,
		maximum_value = 15,
	},
	{
		type = "bool-setting",
		name = mod_name .. "disable-expansion",
		order = "b1",
		setting_type = "runtime-global",
		default_value = false,
	},
})
