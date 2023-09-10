$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))

require 'dinner-planner-cli'
require 'optparse'

OptionParser.new do |parser|
  parser.on('-s', '--show FILENAME', 'Open FILENAME as a PDF') do |filename|
    DinnerPlannerCli::Recipe.new(filename: filename).to_pdf
  end
end.parse!
