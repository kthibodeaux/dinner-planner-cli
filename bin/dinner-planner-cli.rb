$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))

require 'dinner-planner-cli'
require 'optparse'

OptionParser.new do |parser|
  parser.on('-s', '--show FILENAME', 'Open FILENAME as a PDF') do |filename|
    recipe = DinnerPlannerCli::Recipe.new(toml: TOML.load_file(filename))

    DinnerPlannerCli::Services::OpenPdf.new(recipe).process
  end

  parser.on('--cookbook', 'Open all applicable recipes in one PDF') do
    recipes = DinnerPlannerCli::Recipe.all.select(&:include_in_cookbook?)

    DinnerPlannerCli::Services::OpenPdf.new(recipes).process
  end

  parser.on('--import FILENAME', 'Load thedinnerplanner JSON and save each recipe as its own TOML file') do |filename|
    DinnerPlannerCli::Services::TheDinnerPlannerComImport.new(filename: filename).process
  end
end.parse!
