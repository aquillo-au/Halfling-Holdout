class GameOver
  attr_gtk
  def initialize(args)
    @scored = true if args.state.score > args.state.high_scores[-1][:score] || args.state.high_scores.size < 10
      
    if @scored
      args.state.high_scores << {
        name: $name,
        score: args.state.score,
        character: $player_choice
      }
      args.state.high_scores = args.state.high_scores.sort_by { |hash| -hash[:score] }
      if args.state.high_scores.size > 10
        args.state.high_scores.pop
      end
      output_string = args.state.high_scores.map do |entry|
        "#{entry[:name]} ^ #{entry[:score]} ^ #{entry[:character]}"
      end.join("\n")
      args.gtk.write_file(HIGH_SCORE_FILE, output_string)
    end
  end

  def tick
    @labels = []
    generate_labels(args)

    args.outputs.labels << @labels
  
    if args.inputs.keyboard.key_down.h
      #args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
      $title = Title.new(args)
      args.state.scene = "title"
      return
    end
  end

  private

  def generate_labels(args)
    @labels << {
      x: 585,
      y: 550,
      text: "High Scores!",
      size_enum: 5,
    }
    args.state.high_scores.each_with_index do |score, index|
      args.outputs.labels << [565, (510 - (index*25)) , "#{score.name} with #{score.score} as the #{score.character.capitalize}"]
    end

    if args.state.score > args.state.high_scores[-1][:score]
      @labels << {
        x: 260,
        y: args.grid.h - 90,
        text: "New high-score!",
        size_enum: 3,
      }
    else
      @labels << {
        x: 260,
        y: args.grid.h - 90,
        text: "Score to beat: #{args.state.high_scores[-1][:score]}",
        size_enum: 3,
      }
    end

    @labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Game Over!",
      size_enum: 10,
    }
    @labels << {
      x: 40,
      y: args.grid.h - 90,
      text: "Score: #{args.state.score}",
      size_enum: 4,
    }
    @labels << {
      x: 40,
      y: args.grid.h - 132,
      text: "h to restart",
      size_enum: 2,
    }
  end
  
end