require "util"
local tile_sounds = require("__base__/prototypes/tile/tile-sounds")

-- Define the names and tile type landfill we are adding
local item_tile_map = {
  ["landfill-dry-dirt"] = "lp-dry-dirt",
  ["landfill-dirt"] = "lp-dirt-4",
  ["landfill-grass"] = "lp-grass-1",
  ["landfill-red-desert"] = "lp-red-desert-1",
  ["landfill-sand"] = "lp-sand-3",
  ["landfill"] = "landfill",
}

local overwritable_tiles = data.raw.item["landfill"].place_as_tile.tile_condition

for _, tile_name in pairs({
  "dry-dirt",
  "dirt-1",
  "dirt-2",
  "dirt-3",
  "dirt-4",
  "dirt-5",
  "dirt-6",
  "dirt-7",
  "grass-1",
  "grass-2",
  "grass-3",
  "grass-4",
  "landfill",
  "red-desert-0",
  "red-desert-1",
  "red-desert-2",
  "red-desert-3",
  "sand-1",
  "sand-2",
  "sand-3",
}) do
  if data.raw.tile[tile_name] then
    table.insert(overwritable_tiles, tile_name)
  end
end

-- Get the vanilla landfill recipe and technology prototypes
local baserecipe = data.raw.recipe["landfill"]
local technology = data.raw.technology["landfill"]

if mods["angelssmelting"] and data.raw.technology["angels-water-washing-1"] and
   (data.raw.technology["angels-water-washing-1"].enabled == nil or data.raw.technology["angels-water-washing-1"].enabled) and
   data.raw.recipe["angels-solid-mud-landfill"] then
  baserecipe = data.raw.recipe["angels-solid-mud-landfill"]
  data:extend({{
    type = "item-subgroup",
    name = "landfill",
    group = "angels-water-treatment",
    order = "eb"
  }})
  baserecipe.subgroup = "landfill"
  baserecipe.order = nil
else
  data:extend({{
    type = "item-subgroup",
    name = "landfill",
    group = "logistics",
    order = "hb"
  }})
  baserecipe.subgroup = "landfill"
end

local function add_recipe_unlock(recipe_name)
  local addit = true
  if not technology.effects then
    technology.effects = {}
  end
  for _, effect in pairs(technology.effects) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      addit = false
    end
  end
  if addit then
    table.insert(technology.effects, { type = "unlock-recipe", recipe = recipe_name })
  end
end

-- Add new items and recipes for each terrain type
for item_name, tile_name in pairs(item_tile_map) do
  local tile = table.deepcopy(data.raw.tile[string.sub(tile_name, 4)] or data.raw.tile["landfill"])
  tile.name = tile_name
  data:extend({tile})
  local allowed_tiles = table.deepcopy(overwritable_tiles)
  for i, tile in pairs(allowed_tiles) do
    if tile == string.sub(tile_name, 4) then
	  table.remove(allowed_tiles, i)
	end
  end
  local item = {
    type = "item",
    name = item_name,
    localised_description = { "item-description.landfill" },
    icon = "__LandfillPainting__/graphics/icons/" .. item_name .. ".png",
    icon_size = 64,
    subgroup = "landfill",
    order = "c[landfill]-a[" .. item_name .. "]",
    stack_size = 100,
    place_as_tile =
    {
      result = tile_name,
      condition_size = 1,
      condition = { layers = {} },
      -- Enable all types of terrain that LandfillPainter allows the player to create to replace each other
      tile_condition = table.deepcopy(allowed_tiles),
    },
  }
  data:extend({item})
  if not data.raw.recipe[item_name] then
    local recipe = util.table.deepcopy(baserecipe)
    recipe.name = item_name
    recipe.results = {{ type = "item", name = item_name, amount = 1 }}
    data:extend({recipe})
  end
  add_recipe_unlock(item_name)
end

local mine_landfill = data.raw.tile["landfill"].mined_sound
for item_name, tile_name in pairs(item_tile_map) do
  local tile = data.raw.tile[tile_name]
  if tile then
    tile.can_be_part_of_blueprint = nil
    tile.build_sound = tile_sounds.building.landfill
    tile.minable = {mining_time = 0.5, result = item_name}
    tile.mined_sound = mine_landfill
    tile.placeable_by = {item = item_name, count = 1}
    tile.is_foundation = true
  end
end
