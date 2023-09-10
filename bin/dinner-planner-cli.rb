$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))

require 'dinner-planner-cli'
require 'optparse'

OptionParser.new do |parser|
  parser.on('--path PATH', 'Use PATH as the recipes folder') do |pathname|
    DinnerPlannerCli.set_folder pathname
  end

  parser.on('-s', '--show FILENAME', 'Open FILENAME as a PDF') do |filename|
    @task = :show
    @filename = filename
  end

  parser.on('--cookbook', 'Open all applicable recipes in one PDF') do
    @task = :cookbook
  end

  parser.on('--count', 'Count how many recipes are in each category') do
    @task = :count
  end

  parser.on('--list CATEGORY', 'List recipes for the given category') do |category|
    @task = :list
    @category = category
  end

  parser.on('--import FILENAME', 'Load thedinnerplanner JSON and save each recipe as its own TOML file') do |filename|
    @task = :import
    @filename = filename
  end
end.parse!

case @task
when :show
  recipe = DinnerPlannerCli::Recipe.new(toml: TOML.load_file(@filename))

  DinnerPlannerCli::Services::OpenPdf.new(recipe).process
when :cookbook
  recipes = DinnerPlannerCli::Recipe.all.select(&:include_in_cookbook?)

  DinnerPlannerCli::Services::OpenPdf.new(recipes).process
when :import
  DinnerPlannerCli::Services::TheDinnerPlannerComImport.new(filename: @filename).process
when :count
  DinnerPlannerCli::Recipe.all.group_by(&:category).each do |category, recipes|
    puts "Category: '#{category}', Recipes: #{recipes.size}"
  end
when :list
  DinnerPlannerCli::Recipe.all.select { |e| e.category.downcase == @category.downcase }.each do |recipe|
    puts recipe.name
  end
end
