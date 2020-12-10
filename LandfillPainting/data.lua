require "util"

local function findname(t, name)
  for i,v in ipairs(t) do
    if v.name == name then
      return v
    end
  end
end

local terrains = {
  "dry-dirt",
  "dirt-4",
  "grass-1",
  "red-desert-1",
  "sand-3"
}
local names = {
  ["dry-dirt"] = "tile-name.dry-dirt",
  ["dirt-4"] = "autoplace-control-names.dirt",
  ["grass-1"] = "autoplace-control-names.grass",
  ["red-desert-1"] = "autoplace-control-names.desert",
  ["sand-3"] = "autoplace-control-names.sand"
}

local baserecipe = data.raw.recipe['landfill']
local technology = data.raw.technology['landfill']

if mods['angelssmelting'] and data.raw.technology['water-washing-1'] and
   (data.raw.technology['water-washing-1'].enabled == nil or data.raw.technology['water-washing-1'].enabled) and
   data.raw.recipe['solid-mud-landfill'] then
  baserecipe = data.raw.recipe['solid-mud-landfill']
  technology = data.raw.technology['water-washing-1']
  data:extend({{
    type = "item-subgroup",
    name = "water-landfill",
    group = "water-treatment",
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

for _,v in ipairs(terrains) do
  local item = {
    type = "item",
    name = "landfill-" .. v,
    localised_name = {names[v]},
    localised_description = {"item-description.landfill"},
    icon = "__LandfillPainting__/graphics/icons/landfill-" .. v .. ".png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "terrain",
    order = "c[landfill]-a[" .. v .. "]",
    stack_size = 100,
    place_as_tile =
    {
      result = v,
      condition_size = 1,
      condition = {'layer-15'}
    }
  }
  local recipe = util.table.deepcopy(baserecipe)
  recipe.name = "landfill-" .. v
  if recipe.results then
    recipe.results[1].name = "landfill-" .. v
  else
    recipe.result = "landfill-" .. v
  end

  data:extend({item})
  data:extend({recipe})
  table.insert(technology.effects, { type = "unlock-recipe", recipe = "landfill-" .. v })
end

data.raw.item['landfill'].icon = "__LandfillPainting__/graphics/icons/landfill-landfill.png"
data.raw.item['landfill'].place_as_tile.condition = {'layer-15'}

-- dry-dirt -> dirt-1 -> dirt-2 ->dirt-3
-- dirt-4 -> dirt-5 -> dirt-6 -> dirt-7
-- grass-1 -> grass-3 -> grass-2 -> grass-4
-- red-desert-1 -> red-desert-2 -> red-desert-3 -> red-desert-4
-- sand-3 -> sand-1 -> sand-2
if settings.startup['landfillpainting-use-rotation'].value then
  data.raw.tile['dry-dirt'].next_direction = 'dirt-1'
  data.raw.tile['dirt-1'].next_direction = 'dirt-2'
  data.raw.tile['dirt-2'].next_direction = 'dirt-3'
  data.raw.tile['dirt-3'].next_direction = 'dry-dirt'

  data.raw.tile['dirt-4'].next_direction = 'dirt-5'
  data.raw.tile['dirt-5'].next_direction = 'dirt-6'
  data.raw.tile['dirt-6'].next_direction = 'dirt-7'
  data.raw.tile['dirt-7'].next_direction = 'dirt-4'

  data.raw.tile['grass-1'].next_direction = 'grass-3'
  data.raw.tile['grass-3'].next_direction = 'grass-2'
  data.raw.tile['grass-2'].next_direction = 'grass-4'
  data.raw.tile['grass-4'].next_direction = 'grass-1'

  data.raw.tile['red-desert-0'].next_direction = 'red-desert-1'
  data.raw.tile['red-desert-1'].next_direction = 'red-desert-2'
  data.raw.tile['red-desert-2'].next_direction = 'red-desert-3'
  data.raw.tile['red-desert-3'].next_direction = 'red-desert-0'

  data.raw.tile['sand-3'].next_direction = 'sand-1'
  data.raw.tile['sand-1'].next_direction = 'sand-2'
  data.raw.tile['sand-2'].next_direction = 'sand-3'
end

local allterrain = {
  'dry-dirt',
  'dirt-1',
  'dirt-2',
  'dirt-3',
  'dirt-4',
  'dirt-5',
  'dirt-6',
  'dirt-7',
  'grass-1',
  'grass-2',
  'grass-3',
  'grass-4',
  'red-desert-0',
  'red-desert-1',
  'red-desert-2',
  'red-desert-3',
  'sand-1',
  'sand-2',
  'sand-3'
}
for _,v in pairs(allterrain) do
  data.raw.tile[v].can_be_part_of_blueprint = nil
end
