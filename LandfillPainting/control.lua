local tilelookup =
{
  ['dry-dirt'] = 'landfill-dry-dirt',
  ['dirt-1'] = 'landfill-dry-dirt',
  ['dirt-2'] = 'landfill-dry-dirt',
  ['dirt-3'] = 'landfill-dry-dirt',

  ['dirt-4'] = 'landfill-dirt-4',
  ['dirt-5'] = 'landfill-dirt-4',
  ['dirt-6'] = 'landfill-dirt-4',
  ['dirt-7'] = 'landfill-dirt-4',

  ['grass-1'] = 'landfill-grass-1',
  ['grass-2'] = 'landfill-grass-1',
  ['grass-3'] = 'landfill-grass-1',
  ['grass-4'] = 'landfill-grass-1',
  ['landfill'] = 'landfill',

  ['red-desert-0'] = 'landfill-red-desert-1',
  ['red-desert-1'] = 'landfill-red-desert-1',
  ['red-desert-2'] = 'landfill-red-desert-1',
  ['red-desert-3'] = 'landfill-red-desert-1',

  ['sand-1'] = 'landfill-sand-3',
  ['sand-2'] = 'landfill-sand-3',
  ['sand-3'] = 'landfill-sand-3'
}

sb_tiles = 
{
  ['sand-4'] = true,
  ['sand-5'] = true
}

local function tilebuilt(e)
  if not e.item then
    return {count = 0}
  end
  local placeitem = e.item.name
  local refundcount = 0
  for _,v in pairs(e.tiles) do
    if (tilelookup[v.old_tile.name] == placeitem) or sb_tiles[v.old_tile.name] then
      refundcount = refundcount + 1
    end
  end
  return {name = placeitem, count = refundcount}
end

script.on_event(defines.events.on_player_built_tile, function(e)
  local refund = tilebuilt(e)
  if refund.count > 0 and e.stack and e.item and e.stack.valid then
    local holding = 0
    if e.stack.valid_for_read then
      holding = e.stack.count
    end
    local fill = math.min(e.item.stack_size - holding, refund.count)
    if fill > 0 then
      e.stack.transfer_stack({name = refund.name, count = fill})
      refund.count = refund.count - fill
    end
  end
  if refund.count > 0 then
    game.players[e.player_index].insert(refund)
  end
end)

script.on_event(defines.events.on_robot_built_tile, function(e)
  local refund = tilebuilt(e)
  if refund.count > 0 then
    e.robot.get_inventory(defines.inventory.robot_cargo).insert(refund)
  end
end)
