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
  
  ['red-desert-0'] = 'landfill-red-desert-1',
  ['red-desert-1'] = 'landfill-red-desert-1',
  ['red-desert-2'] = 'landfill-red-desert-1',
  ['red-desert-3'] = 'landfill-red-desert-1',

  ['sand-1'] = 'landfill-sand-3',
  ['sand-2'] = 'landfill-sand-3',
  ['sand-3'] = 'landfill-sand-3',

  ['landfill'] = 'landfill',
}

local function tilebuilt(e)
  if not e.item then
    return {}
  end

  local refunds = {}
  local total = 0
  for _,v in pairs(e.tiles) do
    local refunditem = tilelookup[v.old_tile.name]
    if refunditem then
      refunds[refunditem] = (refunds[refunditem] or 0) + 1
      total = total + 1
    end
  end

  return refunds, total
end

script.on_event(defines.events.on_player_built_tile, function(e)
  local refunds,_ = tilebuilt(e)
  
  if e.stack and e.stack.valid and e.item and refunds[e.item.name] and refunds[e.item.name] > 0 then
    local refundname = e.item.name
    
    local holding = 0
    if e.stack.valid_for_read then
      holding = e.stack.count
    end
    
    local fill = math.min(e.item.stack_size - holding, refunds[refundname])
    if fill > 0 then
      e.stack.transfer_stack({name = refundname, count = fill})
      refunds[refundname] = refunds[refundname] - fill
    end
  end

  for refundname, refundcount in pairs(refunds) do
    if refundcount > 0 then
      game.players[e.player_index].insert( { name = refundname, count = refundcount } )
    end
  end

end)

script.on_event(defines.events.on_robot_built_tile, function(e)
  local refunds, total = tilebuilt(e)
  
  -- a robot can't carry multiple stacks, so take first stack and insert it with total amount
  local firstrefundname,_ = next(refunds)
  if firstrefundname then
    e.robot.get_inventory(defines.inventory.robot_cargo).insert( { name = firstrefundname, count = total } )
  end
end)
