class DinnerPlannerCli::Services::ShoppingList
  def initialize(filenames:)
    @filenames = filenames
  end

  def process
    ingredients = {}

    filenames.each do |filename|
      recipe = DinnerPlannerCli::Recipe.new(toml: TOML.load_file(filename))
      recipe.all_ingredients.map { |e| DinnerPlannerCli::Ingredient.new(e) }.each do |e|
        ingredients[e.item] ||= []
        ingredients[e.item] << e.quantity unless e.quantity.nil?
      end
    end

    ingredients.each do |item, quantities|
      puts "#{item} (#{quantities.join(', ')})"
    end
  end

  private

  attr_reader :filenames
end
