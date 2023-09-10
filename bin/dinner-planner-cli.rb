$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))

require 'dinner-planner-cli'

DinnerPlannerCli::Recipe.new(filename: 'example.toml').print
