def startup_tick args
    labels = []
    labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Halfling Holdout Version 0.5",
      size_enum: 6,
    }
    labels << {
      x: 40,
      y: args.grid.h - 88,
      text: "by Aquillo",
    }
    labels << {
      x: 40,
      y: args.grid.h - 140,
      text: "Protect the Halfling Hotpot in the center of the Village",
    }
    labels << {
      x: 40,
      y: args.grid.h - 180,
      text: "What is your name Hero?",
    }
    labels << {
      x: 40,
      y: args.grid.h - 200,
      text: "#{args.state.input_ip}",
    }
    if args.inputs.keyboard.enter
      $name = args.state.input_ip 
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