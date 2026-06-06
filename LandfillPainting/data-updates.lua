local technology = data.raw.technology['water-washing-2']

if technology and technology.effects then
  for i, effect in pairs(technology.effects) do
    if effect.type == 'unlock-recipe' and effect.recipe == 'solid-mud-landfill' then
      table.remove(technology.effects, i)
    end
  end
end

technology = data.raw.technology['water-washing-1']
if technology then
  table.insert(technology.effects, {type = 'unlock-recipe', recipe = 'solid-mud-landfill'})
end
