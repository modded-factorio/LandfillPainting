for _, force in pairs(game.forces) do
  force.reset_technologies()
  force.reset_recipes()
  local tech = force.technologies['landfill']
  if force.technologies['water-washing'] and force.technologies['water-washing'].enabled then
    tech = force.technologies['water-washing']
  end
  if tech.researched then
    for _,v in ipairs(tech.effects) do
      if v.type == 'unlock-recipe' then
        force.recipes[v.recipe].enabled = true
      end
    end
  end
end

