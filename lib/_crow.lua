_crow = {}

function _crow.init()
  crow.init()
  crow.clear()
  crow.reset()
  crow.output[2].action = "pulse(.025, 5)"
  crow.output[4].action = "pulse(.025, 5)"
  crow.ii.pullup(true)
  crow.ii.jf.mode(1)
end

function _crow:jf(note)
  crow.ii.jf.play_note((sound:snap_note(sound:transpose_note(note)) - 60) / 12, 5)
end

function _crow:play(note, pair)
  local output_pairs = {{1,2},{3,4}}
  crow.output[output_pairs[pair][1]].volts = (note - 60) / 12
  crow.output[output_pairs[pair][2]].execute()
end

return _crow