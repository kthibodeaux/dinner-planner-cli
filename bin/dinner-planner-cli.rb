$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))

require 'dinner-planner-cli'
require 'optparse'

OptionParser.new do |parser|
  parser.on('--path PATH', 'Use PATH as the recipes folder') do |path|
    @path = path
  end

  parser.on('--pdf FILENAME', 'Open FILENAME as a PDF') do |filename|
    @task = :pdf
    @filename = filename
  end

  parser.on('--show FILENAME', 'Log FILENAME to the console') do |filename|
    @task = :show
    @filename = filename
  end

  parser.on('--new FILENAME', 'Create FILENAME with template and open for editing') do |filename|
    @task = :new
    @filename = filename
  end

  parser.on('--cookbook', 'Open all applicable recipes in one PDF. Requires --path') do
    @task = :cookbook
  end

  parser.on('--count', 'Count how many recipes are in each category. Requires --path') do
    @task = :count
  end

  parser.on('--list CATEGORY', 'List recipes for the given category. Requires --path') do |category|
    @task = :list
    @category = category
  end

  parser.on('--import FILENAME',
            'Load thedinnerplanner JSON and save each recipe as its own TOML file. Requires --path') do |filename|
    @task = :import
    @filename = filename
  end
end.parse!

case @task
when :pdf
  recipe = DinnerPlannerCli::Recipe.new(toml: TOML.load_file(@filename))

  DinnerPlannerCli::Services::OpenPdf.new(recipe).process
when :show
  recipe = DinnerPlannerCli::Recipe.new(toml: TOML.load_file(@filename))

  DinnerPlannerCli::Services::PrintToConsole.new(recipe).process
when :cookbook
  raise '--path is required' unless @path

  recipes = DinnerPlannerCli::Recipe.all(path: @path).select(&:include_in_cookbook?)

  DinnerPlannerCli::Services::OpenPdf.new(recipes).process
when :import
  raise '--path is required' unless @path

  DinnerPlannerCli::Services::TheDinnerPlannerComImport.new(filename: @filename, path: @path).process
when :count
  raise '--path is required' unless @path

  DinnerPlannerCli::Recipe.all(path: @path).group_by(&:category).each do |category, recipes|
    puts "Category: '#{category}', Recipes: #{recipes.size}"
  end
when :list
  raise '--path is required' unless @path

  DinnerPlannerCli::Recipe.all(path: @path).select { |e| e.category.downcase == @category.downcase }.each do |recipe|
    puts recipe.name
  end
when :new
  DinnerPlannerCli::Services::NewRecipe.new(filename: @filename).process
end
