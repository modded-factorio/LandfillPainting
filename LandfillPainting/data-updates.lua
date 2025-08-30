local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")

for _, v in pairs(data.raw.tile) do
  if v.minable then
    local found = false
    for _, c in pairs(v.collision_mask or {}) do
      if c == tile_collision_masks.ground() then
        found = true
      end
    end
    if not found then
      if not v.collision_mask then
        v.collision_mask = {}
      end
      table.insert(v.collision_mask, tile_collision_masks.ground())
    end
  end
end

local technology = data.raw.technology["angels-water-washing-2"]

if technology and technology.effects then
  for i, effect in pairs(technology.effects) do
    if effect.type == "unlock-recipe" and effect.recipe == "angels-solid-mud-landfill" then
      table.remove(technology.effects, i)
    end
  end
end

technology = data.raw.technology["angels-water-washing-1"]
if technology then
  table.insert(technology.effects, { type = "unlock-recipe", recipe = "angels-solid-mud-landfill" })
end
