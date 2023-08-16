def greet friend
  "Hello #{friend}!"
end

def tick args
  args.outputs.labels << [120,120, greet("Dragon")]
  args.outputs.labels << [120,100, greet("Oboe")]
end
