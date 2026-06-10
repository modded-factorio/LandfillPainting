if mods["angelsrefining"] and angelsmods.trigger.washing_tech then
  local OV = angelsmods.functions.OV
  OV.remove_unlock("angels-water-washing-2", "angels-solid-mud-landfill")
  OV.add_unlock("angels-water-washing-1", "angels-solid-mud-landfill")
  OV.add_prereq("landfill", "angels-water-washing-1")
  OV.execute()
end
