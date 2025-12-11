# Welcome to the Magical Forest Library :)

tempo = 35
set :stop_walk, false
set :brown_fade, false
set :stop_brown, false
set :fade_out, false
set :fade_in, false
set :stop_all, false
set :scale, scale(:d4, :lydian) # Lydian scale - bright, magical tone

# "Metronome" to keep loops in sync
in_thread do
  loop do
    cue :tick
    sleep 1
  end
end

# Brown noise imitation - consistent, relaxing underlayer
in_thread do
  a = 0.2

  loop do
    if get(:brown_fade)
      a = 0.1
    end

    if get(:brown_stop)
      stop
    end
    # Add control n for slider fade

    with_fx :lpf, cutoff: 90 do
      with_fx :lpf, cutoff: 60 do
        synth :noise, release: 0.5, amp: a
      end
    end
    sleep 0.1
  end
end

sleep(3)

# Tones, summoning you to the library
in_thread do
  sync :tick
  a = 0.02

  4.times do
    with_fx :reverb, room: 1 do
      sample :ambi_glass_rub, amp: a, attack: 3, release: 0.3
      a = a * 1.7
      sleep 6
    end
  end
end

sleep(4)

# Walking through the forest
in_thread do
  sync :tick

  loop do
    if get(:stop_walk)
      stop
    end

    sample #, amp: 0.05, start: 0.15
    sleep sample_duration #
  end
end

sleep(16)
set :brown_fade, true

# Background vibe - evoke magical forest library
in_thread do
  set :stop_walk, true
  sync :tick
  use_synth :hollow
  a = 0.2

  loop do
    if get(:fade_out)
      a = a * 0.5
      if a < 0.02
        stop
      end
    end

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
  sync :tick

  sample #, amp: 1, finish: 0.8
  sleep sample_duration #

  sleep 4

  loop do
    if get(:fade_out)
      stop
    end

    if one_in(5)
      sample #, amp: 0.35, finish: 0.8
      sleep sample_duration #
    end

    sleep 1
  end
end

sleep (12)
set :fade_in, true

# Floating lights imagery
in_thread do
  sync :tick
  use_synth :kalimba
  a = 1.3
  r = 0.5

  loop do
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
  sync :tick
  use_synth :hollow
  a = 0.009

  loop do
    if get(:fade_in)
      a = a * 1.5
      if a > 0.5
        set :fade_in, false
      end
    end

    play :d2, sustain: 16, release: 4, amp: a
    sleep 16

    if get(:stop_all)
      stop
    end
  end
end

sleep(60)
set :fade_out, true

# Tones call you to ascend the stairs
in_thread do
  sync :tick
  a = 0.2

  4.times do
    with_fx :reverb, room: 0.6 do
      sample :ambi_glass_rub, amp: a, attack: 3, release: 0.3
    end
    a = a * 1.7
  end
end

# Ascending the stairs to the heart of the library
in_thread do
  sync :tick
  use_synth :hollow
  set :stop_brown, true
  
  a_tone = 0.1
  a_chord = 0.2
  
  4.times do
    with_fx :reverb, room: 0.6 do
      sample :ambi_glass_rub, amp: a_tone, attack: 6
    end
    a_tone = a_tone * 1.5
    
    with_fx :reverb, room: 1, mix: 0.8 do
      play chord(:d4, :major), amp: a_chord, attack: 0.7, release: 2.3, pan: 1
      sleep 3
      play chord(:e4, :major), amp: a_chord, attack: 0.7, release: 2.3, pan: -1
      sleep 3
      play chord(:a4, :major), amp: a_chord, attack: 0.7, release: 2.1, pan: -1
      sleep 3
    end
    a_chord = a_chord + 0.15
  end
  
  with_fx :reverb, room: 1 do
    play chord(:a4, :major), amp: 0.65, attack: 0.7, sustain: 4, release: 2
    stop
  end
end

sleep(38)

in_thread do
  a = 0.3
  loop do
    with_fx :reverb, room: 1, mix: 0.5 do
      sample :bd_fat, amp: a, attack: 0.01
    end
    
    if get(:low_drum)
      a = 0.1
    end
    
    if get(:stop_all)
      stop
    end
    
    sleep 1
  end
end

sleep(10)

# Opening the mysterious book to a wave of knowledge and magic
in_thread do
  sync :tick
  set :low_drum, true
  use_bpm tempo
  base = chord(:d4, :major)
  extensions = [:e5, :gs4, :b4]
  notes = base + extensions
  
  with_fx :reverb, room: 1, mix: 0.85 do
    with_fx :echo, phase: 0.5, decay: 8, mix: 0.5 do
      use_synth :hollow
      play_chord notes, amp: 0.6, attack: 0.9, sustain: 3, release: 6
      
      use_synth :kalimba
      play_chord notes, amp: 1.2, attack: 0.1, sustain: 2, release: 5
    end
    
    with_fx :hpf, cutoff: 50 do
      synth :noise, amp: 0.1, attack: 0.1, sustain: 1, release: 5
    end
    
    sample "/Users/amonaghan/ComputationalCreativity/M3_HakunaFermata/chimes.wav", amp: 2, finish: 0.5
  end
end

# The aftermath of the wave of knowledge
in_thread do
  sync :tick
  use_bpm tempo
  use_synth :hollow
  
  2.times do
    with_fx :reverb, room: 1, mix: 0.7 do
      play chord(:d4, :major), amp: 0.25, attack: 2, sustain: 4, release: 4
      sleep 6
      play chord(:b3, :minor), amp: 0.25, attack: 2, sustain: 4, release: 4
      sleep 6
      play chord(:e4, :major), amp: 0.25, attack: 2, sustain: 4, release: 4
      sleep 6
      play chord(:a3, :minor), amp: 0.25, attack: 2, sustain: 4, release: 4
      sleep 6
    end
  end
end

sleep (30)

# Begin a new melody
in_thread do
  sync :tick
  use_bpm tempo
  use_synth :kalimba

  loop do
    with_fx :reverb, room: 1, mix: 0.8 do
      n = scale(:d5, :lydian, num_octaves: 1).choose
      n -= [0, 0, 0, 12].choose
      play n, amp: 1.3, attack: 0.05, release: rrand(2, 4), pan: rrand(-0.4, 0.4)
      sleep rrand(2, 4)
    end

    if get(:stop_all)
      stop
    end
  end
end

sleep(40)

# One final chord
in_thread do
  sync :tick
  use_bpm tempo
  use_synth :hollow

  with_fx :reverb, room: 1, mix: 0.9 do
    play chord(:d4, :major), amp: 0.25, attack: 0.3, sustain: 6, release: 8
  end
end

sleep(6)

# Fading chimes and tones
in_thread do
  sync :tick
  a = 0.2

  sample "/Users/amonaghan/ComputationalCreativity/M3_HakunaFermata/chimes.wav", amp: 0.5, finish: 0.8
  sleep sample_duration "/Users/amonaghan/ComputationalCreativity/M3_HakunaFermata/chimes.wav"

  loop do
    with_fx :reverb, room: 1 do
      sample :ambi_glass_rub, amp: a, attack: 3, release: 0.3
    end
    a = a * 0.5
    sleep 6

    if get(:stop_all)
      stop
    end
  end
end

sleep(2)

# Leaving the library, but softer
in_thread do
  sync :tick
  use_bpm tempo

  2.times do
    sample "/Users/amonaghan/ComputationalCreativity/M3_HakunaFermata/walking.wav", amp: 0.2, start: 0.2
    sleep sample_duration "/Users/amonaghan/ComputationalCreativity/M3_HakunaFermata/walking.wav"
  end

  sample "/Users/amonaghan/ComputationalCreativity/M3_HakunaFermata/chimes.wav", amp: 0.5, finish: 0.8
  sleep sample_duration "/Users/amonaghan/ComputationalCreativity/M3_HakunaFermata/chimes.wav"

  set :stop_all, true
end

# Reintroduce brown noise
in_thread do
  sync :tick
  use_bpm tempo
  a = 0.05

  loop do
    with_fx :lpf, cutoff: 90 do
      with_fx :lpf, cutoff: 60 do
        synth :noise, release: 0.5, amp: a
      end
    end

    a = a * 1.7
    if a > 0.2
      a = 0.2
    end

    sleep 0.1

    if get(:stop_all)
      stop
    end
  end
end/

