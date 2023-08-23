def startup_tick args
  if args.state.tick_count == 1
    args.audio[:music] = { input: "sounds/forestwalk.ogg", looping: true }
  end 
  args.outputs.sprites << {
    x: 0,
    y: 0,
    w: args.grid.w,
    h: args.grid.h,
    a: 150,
    path: 'sprites/background.png'
  }
  args.outputs.sprites << {
    x: 40,
    y: args.grid.h - 160,
    w: 605,
    h: 150,
    path: 'sprites/title.png'
  }
    labels = []
    labels << {
      x: 650,
      y: args.grid.h - 40,
      text: "Version #{VERSION}",
      size_enum: 5,
    }
    labels << {
      x: 40,
      y: args.grid.h - 170,
      text: "by Aquillo",
    }
    labels << {
      x: 40,
      y: args.grid.h - 240,
      text: "Protect the Halfling Hotpot in the center of the Village",
    }
    labels << {
      x: 40,
      y: args.grid.h - 280,
      text: "What is your name Hero?",
    }
    labels << {
      x: 40,
      y: args.grid.h - 310,
      text: "#{args.state.input_ip}",
    }
    if args.inputs.keyboard.enter
      args.state.input_ip ? $name = args.state.input_ip :  $name = "The Unknown" 
      args.outputs.sounds << "sounds/fireball.wav"
      args.state.scene = "title"
      return
    end
    args.state.input_ip ||= ""
    if args.inputs.text != []
        if args.inputs.text[0] != '^'
          args.state.input_ip += args.inputs.text[0]
        end
    end
    
    val = args.inputs.keyboard.backspace
    if val
        time_since = args.tick_count - val
        if args.inputs.keyboard.key_down.backspace || (time_since > 30 && time_since % 2 == 0)
            args.state.input_ip.chop!
        end
    end
    args.outputs.labels << labels
  end