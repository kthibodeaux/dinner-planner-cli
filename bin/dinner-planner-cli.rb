$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))

require 'dinner-planner-cli'
require 'optparse'

OptionParser.new do |parser|
  parser.on('-s', '--show FILENAME', 'Open FILENAME as a PDF') do |filename|
    DinnerPlannerCli::Recipe.new(filename: filename).to_pdf
  end

  parser.on('--import FILENAME', 'Load thedinnerplanner JSON and save each recipe as its own TOML file') do |filename|
    DinnerPlannerCli::TheDinnerPlannerComImport.new(filename: filename).process
  end
end.parse!
