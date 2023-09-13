$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))

require 'dinner-planner-cli'

case ARGV.first
when '-h', '--help'
  puts 'USAGE:'
  puts '  --pdf FILENAME'
  puts '    Open FILENAME as a PDF'

  puts '  --show FILENAME'
  puts '    Log FILENAME to the console'

  puts '  --new FILENAME'
  puts '    Create FILENAME with template and open for editing'

  puts '  --cookbook PATH'
  puts '    Open all applicable recipes in one PDF'

  puts '  --count PATH'
  puts '    Count the number of recipes in each category'

  puts '  --list CATEGORY PATH'
  puts '    List the recipes in each CATEGORY in PATH'

  puts '  --import FILENAME PATH'
  puts '    Load thedinnerplanner JSON and save each recipe as its own TOML file in PATH'
when '--pdf'
  recipe = DinnerPlannerCli::Recipe.new(toml: TOML.load_file(ARGV[1]))

  DinnerPlannerCli::Services::OpenPdf.new(recipe).process
when '--show'
  recipe = DinnerPlannerCli::Recipe.new(toml: TOML.load_file(ARGV[1]))

  DinnerPlannerCli::Services::PrintToConsole.new(recipe).process
when '--cookbook'
  recipes = DinnerPlannerCli::Recipe.all(path: ARGV[1]).select(&:include_in_cookbook?)

  DinnerPlannerCli::Services::OpenPdf.new(recipes).process
when '--import'
  DinnerPlannerCli::Services::TheDinnerPlannerComImport.new(filename: ARGV[1], path: ARGV[2]).process
when '--count'
  DinnerPlannerCli::Recipe.all(path: ARGV[1]).group_by(&:category).each do |category, recipes|
    puts "Category: '#{category}', Recipes: #{recipes.size}"
  end
when '--list'
  DinnerPlannerCli::Recipe.all(path: ARGV[2]).select { |e| e.category.downcase == ARGV[1].downcase }.each do |recipe|
    puts recipe.name
  end
when '--new'
  DinnerPlannerCli::Services::NewRecipe.new(filename: ARGV[1]).process
when '--shopping-list'
  DinnerPlannerCli::Services::ShoppingList.new(filenames: ARGV[1..]).process
end
