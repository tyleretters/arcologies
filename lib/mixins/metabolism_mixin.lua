-- requires offset
metabolism_mixin = {}

metabolism_mixin.init = function(self)

  self.setup_metabolism = function(self)
    self.metabolism_key = "METABOLISM"
    self.metabolism = 13
    self.metabolism_min = 0
    self.metabolism_max = 16
    self:register_save_key("metabolism")
    self:register_menu_getter(self.metabolism_key, self.metabolism_menu_getter)
    self:register_menu_setter(self.metabolism_key, self.metabolism_menu_setter)
    self:register_arc_style({
      key = self.metabolism_key,
      style_getter = function() return "sweet_sixteen" end,
      style_max_getter = function() return 360 end,
      sensitivity = .05,
      offset = 180,
      wrap = false,
      snap = true,
      min = self.metabolism_min,
      max = self.metabolism_max,
      value_getter = self.get_metabolism,
      value_setter = self.set_metabolism
    })
    self:register_modulation_target({
      key = self.metabolism_key,
      inc = self.metabolism_increment,
      dec = self.metabolism_decrement
    })
  end

  self.metabolism_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_metabolism(self:get_metabolism() + value)
  end

  self.metabolism_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_metabolism(self:get_metabolism() - value)
  end

  self.get_metabolism = function(self)
    return self.metabolism
  end

  self.set_metabolism = function(self, i)
    self.metabolism = util.clamp(i, self.metabolism_min, self.metabolism_max)
    self.callback(self, "set_metabolism")
  end

  self.metabolism_menu_getter = function(self)
    return self:get_metabolism()
  end

  self.metabolism_menu_setter = function(self, i)
    self:set_metabolism(self.metabolism + i)
  end

  self.get_metabolism_steps = function(self)
    local steps = {}
    steps[0]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    steps[1]  = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    steps[2]  = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}
    steps[3]  = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0}
    steps[4]  = {1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0}
    steps[5]  = {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0}
    steps[6]  = {1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0}
    steps[7]  = {1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0}
    steps[8]  = {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0}
    steps[9]  = {1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0}
    steps[10] = {1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0}
    steps[11] = {1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0}
    steps[12] = {1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1}
    steps[13] = {1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0}
    steps[14] = {1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1}
    steps[15] = {1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0}
    steps[16] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1} 
    local to_bools = {}
    for k,v in pairs(steps[self:get_metabolism()]) do
      table.insert(to_bools, v == 1)
    end
    return to_bools
  end

  self.get_inverted_metabolism = function(self)
    -- could do this as a loop but this doubles as a developer guide
    local i = {}
    i[0]  = 0
    i[1]  = 16
    i[2]  = 15
    i[3]  = 14
    i[4]  = 13
    i[5]  = 12
    i[6]  = 11
    i[7]  = 10
    i[8]  = 9
    i[9]  = 8
    i[10] = 7
    i[11] = 6
    i[12] = 5
    i[13] = 4
    i[14] = 3
    i[15] = 2
    i[16] = 1
    return i[self:get_metabolism()]
  end

  self.inverted_metabolism_check = function(self)
    if self.metabolism == 0 then
      return false
    else
      return (((counters:this_beat() - self.offset) % self:get_inverted_metabolism()) == 1) or (self:get_inverted_metabolism() == 1)
    end
  end

end