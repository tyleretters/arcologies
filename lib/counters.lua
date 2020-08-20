local counters = {}

function counters.init()
  counters.message = 0
  counters.default_message_length = 40

  counters.ui = metro.init()
  counters.ui.time = 1 / 30
  counters.ui.count = -1
  counters.ui.play = 1
  counters.ui.frame = 1
  counters.ui.quarter_frame = 1
  counters.ui.event = counters.optician

  counters.music = metro.init()
  counters.music.time = 60 / params:get("bpm")
  counters.music.count = -1
  counters.music.play = 1
  counters.music.generation = 1
  counters.music.event = counters.conductor

  counters.grid = metro.init()
  counters.grid.time = 1 / 30
  counters.grid.count = -1
  counters.grid.play = 1
  counters.grid.frame = 1
  counters.grid.event = counters.gridmeister
end

function counters.conductor()
  counters.music.time = parameters.bpm_to_seconds
  if sound.playback == 0 then return end
  counters.music.generation = counters.music.generation + 1
  keeper:setup()
  keeper:spawn_signals()
  keeper:propagate_signals()
  keeper:collide_signals()
  keeper:collide_signals_and_cells()
  keeper:delete_signals()
  redraw()
end


function counters:reset_enc(e)
  enc_counter[e] = {
    this_clock = nil,
    waiting = false
  }
end

function counters.redraw_clock()
  while true do
    if fn.dirty_screen() then
      redraw()
      fn.dirty_screen(false)
    end
    if fn.dirty_grid() then
      g:grid_redraw()
    end
    clock.sleep(1 / 30)
  end
end

function counters.optician()
  counters.ui.frame = counters.ui.frame + 1
  if counters.ui.frame % 4 == 0 then
    counters.ui.quarter_frame = counters.ui.quarter_frame +1
  end
  if fn.no_grid() then page:set_error(1) else page:clear_error() end
  fn.dirty_screen(true)
  redraw()
end



function counters.gridmeister()
  counters.grid.frame = counters.grid.frame + 1
end

function counters.grid_frame()
  return counters.grid.frame
end

function counters.music_generation()
  return counters.music.generation
end

function counters.this_beat()
  return (counters.music_generation() % sound.length) + 1
end

function counters.ui_quarter_frame_fmod(i)
  return math.fmod(counters.ui.quarter_frame, i) + 1
end
function counters.generation_fmod(i)
  return math.fmod(counters.music_generation(), i) + 1
end

return counters