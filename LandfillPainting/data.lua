require "util"
local tile_sounds = require("__base__/prototypes/tile/tile-sounds")

-- Define the names and tile type lanfill we are adding
local item_tile_map = {
  ["landfill-dry-dirt"] = "dry-dirt",
  ["landfill-dirt"] = "dirt-4",
  ["landfill-grass"] = "grass-1",
  ["landfill-red-desert"] = "red-desert-1",
  ["landfill-sand"] = "sand-3",
  ["landfill"] = "landfill",
}

local tile_item_map = {}
local overwritable_tiles = data.raw.item["landfill"].place_as_tile.tile_condition

for tile_name, item_name in pairs({
  ["dry-dirt"] = "landfill-dry-dirt",
  ["dirt-1"] = "landfill-dirt",
  ["dirt-2"] = "landfill-dirt",
  ["dirt-3"] = "landfill-dirt",
  ["dirt-4"] = "landfill-dirt",
  ["dirt-5"] = "landfill-dirt",
  ["dirt-6"] = "landfill-dirt",
  ["dirt-7"] = "landfill-dirt",
  ["grass-1"] = "landfill-grass",
  ["grass-2"] = "landfill-grass",
  ["grass-3"] = "landfill-grass",
  ["grass-4"] = "landfill-grass",
  ["landfill"] = "landfill",
  ["red-desert-0"] = "landfill-red-desert",
  ["red-desert-1"] = "landfill-red-desert",
  ["red-desert-2"] = "landfill-red-desert",
  ["red-desert-3"] = "landfill-red-desert",
  ["sand-1"] = "landfill-sand",
  ["sand-2"] = "landfill-sand",
  ["sand-3"] = "landfill-sand",
}) do
  if data.raw.tile[tile_name] then
    tile_item_map[tile_name] = item_name
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
  technology = data.raw.technology["angels-water-washing-1"]
  data:extend({{
    type = "item-subgroup",
    name = "water-landfill",
    group = "angels-water-treatment",
    order = "eb"
  }})
  baserecipe.subgroup = "water-landfill"
  baserecipe.order = nil
else
  data:extend({{
    type = "item-subgroup",
    name = "terrain-landfill",
    group = "logistics",
    order = "hb"
  }})
  baserecipe.subgroup = "terrain-landfill"
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
  local item = {
    type = "item",
    name = item_name,
    localised_description = { "item-description.landfill" },
    icon = "__LandfillPainting__/graphics/icons/" .. item_name .. ".png",
    icon_size = 64,
    subgroup = "terrain",
    order = "c[landfill]-a[" .. item_name .. "]",
    stack_size = 100,
    place_as_tile =
    {
      result = tile_name,
      condition_size = 1,
      --condition = { layers = { ground_tile = true }},
      condition = { layers = {} },
      -- Enable all types of terrain that LandfillPainter allows the player to create to replace each other
      tile_condition = table.deepcopy(overwritable_tiles),
    },
  }
  local recipe = util.table.deepcopy(baserecipe)
  recipe.name = item_name
  recipe.results = {{ type = "item", name = item_name, amount = 1 }}

  data:extend({item, recipe})
  add_recipe_unlock(item_name)
end

for tile_name, item_name in pairs(tile_item_map) do
  local tile = data.raw.tile[tile_name]
  tile.can_be_part_of_blueprint = nil
  tile.is_foundation = true
  tile.build_sound = tile_sounds.building.landfill
end
