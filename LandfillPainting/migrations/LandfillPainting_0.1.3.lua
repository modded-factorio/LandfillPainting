-- Define the names of each terrain type we're adding
local terrains = {
  "dry-dirt",
  "dirt-4",
  "grass-1",
  "red-desert-1",
  "sand-3"
}

for _, force in pairs(game.forces) do
  force.reset_technologies()
  force.reset_recipes()
  
  -- Get appropriate technology
  local tech = force.technologies['landfill']
  if force.technologies['water-washing'] and 
     force.technologies['water-washing'].enabled then
    tech = force.technologies['water-washing']
  end

  -- Enable recipes if technology is researched
  if tech and tech.researched then
    for i,v in ipairs(terrains) do
      force.recipes['landfill-' .. v].enabled = true
    end
  end
end