# Welcome to the Magical Forest Library :)

tempo = 35
set :start_chimes, false
set :stop_walk, false
set :brown_fade, false
set :stop_brown, false
set :fade_out, false
set :fade_in, false
set :chimes, false
set :stop_all, false
set :scale, scale(:d4, :lydian) # Lydian scale - bright, magical tone

# "Metronome" to keep loops in sync
in_thread do
  loop do
    cue :tick
    sleep 1
  end
end

/# Brown noise imitation - consistent, relaxing underlayer
in_thread do
  a = 0.2

  loop do
    if get(:brown_fade)
      a = 0.07
    end

    if get(:brown_stop)
      stop
    end

    with_fx :lpf, cutoff: 90 do
      with_fx :lpf, cutoff: 60 do
        synth :noise, release: 0.5, amp: a
      end
    end
    sleep 0.1
  end
end

sleep(2)

# A chime - summoning you to the library
in_thread do
  a = 0.02

  loop do
    if get(:stop_walk)
      a = 0
    end

    if get(:chimes)
      a = 0.07
    end

    if get(:stop_all)
      stop
    end

    with_fx :reverb, room: 1 do
      sample :ambi_glass_rub, amp: a, attack: 3, release: 0.3
    end
    a = a * 1.7
    sleep 6
  end
end

sleep(4)

# Walking through the forest
in_thread do
  loop do
    sync :tick

    if get(:stop_walk)
      stop
    end

    sample , start: 0.15, amp: 0.03
    sleep sample_duration 
  end
end

sleep(16)
set :brown_fade, true

# Background vibe - evoke magical forest library
in_thread do
  a = 0.2

  loop do
    if get(:fade_out)
      a = a * 0.5
      if a < 0.02
        stop
      end
    end

    set :stop_walk, true
    sync :tick
    use_synth :hollow
    root = get(:scale).choose
    notes = [root, root + 7, root + 11]

    with_fx :reverb, room: 0.5, mix: 0.6 do # Reverberation - big room feeling
      play_chord notes, attack: 2, release: 8, amp: a # Slow, calm build and fade
    end
    sleep 6
  end
end

sleep(12)

# Wind chimes
in_thread do
  sample , amp: 1, finish: 0.8
  sleep sample_duration 

  sleep 4

  loop do
    sync :tick

    if get(:fade_out)
      stop
    end

    if one_in(5)
      sample , amp: 0.2, finish: 0.8
      sleep sample_duration 
    end

    sleep 1
  end
end

sleep (12)
set :fade_in, true

# Floating lights imagery
in_thread do
  a = 1.3
  r = 0.5

  loop do
    sync :tick
    use_synth :kalimba

    if get(:fade_out)
      a = a * 0.7
      if a < 0.09
        a = 0.09
        r = 1
      end
    end

    with_fx :reverb, room: r, mix: 0.7 do
      with_fx :echo, phase: (rrand(0.4, 0.8)), mix: 0.3 do
        n = scale(:d5, :lydian, num_octaves: 1.8).choose
        play n, attack: 0.1, release: rrand(1.5, 3.5), amp: a, pan: rrand(-0.6, 0.6)
      end
    end

    sleep rrand(0.8, 2.5) # Create irregular pattern - drifting lights
  end
end

# Droning sound - "the forest is breathing"
in_thread do
  a = 0.009

  loop do
    if get(:fade_in)
      a = a * 1.5
      if a > 0.5
        set :fade_in, false
      end
    end

    use_synth :hollow

    play :d2, sustain: 16, release: 4, amp: a
    sleep 16
  end
end

sleep(60)
set :fade_out, true/

# Deepen and standardize the chords - a new discovery
in_thread do
  set :stop_brown, true
  set :chimes, true
  
  loop do
    sync :tick
    use_bpm tempo
    use_synth :hollow
    
    if get(:stop_all)
      with_fx :reverb, room: 1 do
        play chord(:a4, :major), amp: 0.4, attack: 0.7, sustain: 1, release: 0.01
        stop
      end
    end
    
    with_fx :reverb, room: 1, mix: 0.8 do
      play chord(:d4, :major), amp: 0.2, attack: 0.7, release: 2.3, pan: 1
      sleep 2
      play chord(:e4, :major), amp: 0.2, attack: 0.7, release: 2.3, pan: -1
      sleep 2
      play chord(:a4, :major), amp: 0.2, attack: 0.7, release: 2.3, pan: -1
    end
    sleep 2
  end
end

# Ascending the stairs
/in_thread do
  set :stop_brown, true
  set :chimes, true

  loop do
    sync :tick
    use_bpm tempo
    use_synth :hollow

    if get(:stop_all)
      stop
    end

    with_fx :reverb, room: 1, mix: 0.8 do
      play_pattern chord(:d4, :M7), amp: 0.2, attack: 0.7, release: 2.3, pan: rrand(-1, 1)
    end
    sleep 1
  end
end/

sleep(25)

set :stop_all, true

use_synth :hollow
play chord(:d, :major), amp: 0.02, attack: 0.5, sustain: 30, release: 3

sleep(8)

in_thread do
  use_bpm tempo
  
  with_fx :reverb, room: 1, mix: 0.85 do
    with_fx :echo, phase: 0.5, decay: 8, mix: 0.5 do
      use_synth :hollow
      