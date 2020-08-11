local page = {}

function page.init()
  page.active_page = 1
  page.selected_item = 1
  page_items = {}
  page_items[1] = 5
  page_items[2] = 4
  page_items[3] = 5
  page.items = page_items[page.active_page]
end

function page:select(i)
  self.active_page = i
  self.items = page_items[self.active_page]
  self.selected_item = 1
  dirty_screen(true)
end


function page:change_selected_item_value(d)

  local cache
  local p = page.active_page
  local s = page.selected_item

  -- home
  if p == 1 then
    if s == 1 then
      sound:set_playback(d)
    elseif s == 2 then
      params:set("bpm", util.clamp(params:get("bpm") + d, 20, 240))
    elseif s == 3 then
      sound:cycle_meter(d)
    elseif s == 4 then
      sound:cycle_scale(d)
    elseif s == 5 then
      set_seed(util.clamp(seed + d, 0, math.floor(grid_width() * grid_height() / 4)))
    end

  -- cell designer
  elseif p == 2 then
    if not keeper.is_cell_selected then return end
    if s == 1 then
      keeper.selected_cell:set_structure(util.clamp(keeper.selected_cell.structure + d, 1, 3))
    elseif s == 2 then
      keeper.selected_cell:set_offset(util.clamp(keeper.selected_cell.offset + d, 0, sound.meter - 1))
    elseif s == 3 then
      set_note(d)
    elseif s == 4 then
      keeper.selected_cell:set_velocity(util.clamp(keeper.selected_cell.velocity + d, 1, 127))
    end

  -- analysis
  elseif p == 3 then
    -- nothing to change here
  end
  dirty_screen(true)
end







function page:render()
  self.active_page = page.active_page
  self.selected_item = page.selected_item
  graphics:top_menu()
  graphics:select_tab(self.active_page)
  graphics:top_message()
  graphics:page_name(dictionary.pages[self.active_page])
  if self.active_page == 1 then
    self:one()
  elseif self.active_page == 2 then
    self:two()
  elseif self.active_page == 3 then
    self:three()
  end
  dirty_screen(true)
end











-- home
function page:one()
  graphics:panel()
  graphics:menu_highlight(self.selected_item)
  graphics:text(2, 18, sound.playback == 0 and "READY" or "PLAYING")  
  graphics:text(2, 26, "BPM")
  graphics:bpm(55, 32, params:get("bpm"), 0)
  graphics:text(2, 34, "METER")
  graphics:text(2, 42, "SCALE")
  graphics:text(2, 50, "SEED " .. seed)

  graphics:playback_icon(56, 35)
  graphics:icon(76, 35, sound.meter, self.selected_item == 3 and 1 or 0)
  
  if is_deleting() then
    graphics:icon(56, 35, "D:", 1)
    graphics:icon(76, 35, "D:", 1)
  end
  
  -- graphics:text(98, 52, sound.default_out_name, 0)

  graphics:text(56, 61, sound.current_scale_name, 0)
  graphics:rect(126, 55, 2, 7, 15)
end









-- structures
function page:two()
  graphics:panel()
  graphics:menu_highlight(self.selected_item)
  if is_selecting_note() then
    graphics:piano(keeper.selected_cell.sound)
    graphics:sound_enable()
  else
    graphics:cell_id()
    if not keeper.is_cell_selected then
      graphics:cell()
      graphics:draw_ports()
      graphics:structure_disable()
      graphics:offset_disable()
      graphics:sound_disable()
      graphics:velocity_disable()
    elseif keeper.selected_cell.structure == 1 then
      graphics:hive()
      graphics:draw_ports()
      graphics:structure_type(dictionary.structures[1])
      graphics:structure_enable()
      graphics:offset_enable()
      graphics:sound_disable()
      graphics:velocity_disable()
    elseif keeper.selected_cell.structure == 2 then
      graphics:shrine()
      graphics:draw_ports()    
      graphics:structure_type(dictionary.structures[2])
      graphics:structure_enable()
      graphics:offset_disable()
      graphics:sound_enable()
      graphics:velocity_enable()
    elseif keeper.selected_cell.structure == 3 then
      graphics:gate()
      graphics:draw_ports(-5)
      graphics:structure_type(dictionary.structures[3])
      graphics:structure_enable()
      graphics:offset_disable()
      graphics:sound_disable()
      graphics:velocity_disable()
    end
  end
end





-- analysis
function page:three()
  graphics:analysis(self.selected_item)
end



return page