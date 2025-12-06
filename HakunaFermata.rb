# Welcome to Sonic Pi

tempo = 30
/beep
kalimba
dark_ambience
blade
chiplead but quiet
fm
growl
hollow
organ_tonewheel
pluck
tech_saws
/

/# Brown noise imitation - consistent, relaxing underlayer
live_loop :brown_noise do
  with_fx :lpf, cutoff: 90 do
    with_fx :lpf, cutoff: 60 do
      synth :noise, release: 0.5, amp: 0.4
    end
  end

  sleep 0.1
end

set :scale, scale(:d4, :lydian) # Lydian scale - bright, magical tone

# Background vibe - evoke magical forest library
live_loop :forest_vibe do
  use_synth :hollow
  root = get(:scale).choose
  notes = [root, root + 7, root + 11]

  with_fx :reverb, room: 1, mix: 0.6 do # Reverberation - big room feeling
    play_chord notes, attack: 2, release: 8, amp: 0.2 # Slow, calm build and fade
  end

  sleep 6
end

# Floating lights imagery
live_loop :floating_lights do
  use_synth :kalimba

  with_fx :reverb, room: 1, mix: 0.7 do
    with_fx :echo, phase: (rrand(0.4, 0.8)), mix: 0.3 do
      n = scale(:d5, :lydian, num_octaves: 2).choose
      play n,
        attack: 0.1,
        release: rrand(1.5, 3.5),
        amp: 2,
        pan: rrand(-0.6, 0.6) # Panning - lights floating around you
    end
  end

  sleep rrand(0.8, 2.5) # Create irregular pattern - drifting lights
end/


/use_bpm 60

live_loop :lofi do
  with_fx :lpf, cutoff: 80 do
    with_fx :distortion, distort: 0.1 do
      live_loop :lofi_bass do
        use_synth :subpulse
        play :D5, attack: 0.1, sustain: 4, release: 1, amp: 0.03, cutoff: :D5 
        sleep 3
      end
    end
  end
end/

/define :forest_steps do
  with_fx :lpf, cutoff: 80 do
    synth :noise, amp: 0.12, attack: 0.005, release: 0.1
  end

  with_fx :hpf, cutoff: 70 do
    synth :cnoise, amp: 0.15, release: 0.05
  end

  if one_in(3)
    use_synth :hollow
    play :c4 + rrand(-2, 2), amp: 0.03, release: 0.2
  end
end

live_loop :forest_walk do
  forest_steps
  sleep rrand(0.45, 0.7)
end/
