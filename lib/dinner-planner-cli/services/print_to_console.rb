class DinnerPlannerCli::Services::PrintToConsole
  def initialize(recipe)
    @recipe = recipe
  end

  def process
    puts recipe.name
    puts '-' * 80

    recipe.groups.each do |group|
      write_group(group.ingredients, group.steps, group.name)
    end
  end

  private

  attr_reader :recipe

  def write_group(ingredients, steps, name = nil)
    ingredients_title = name || 'Ingredients'

    if ingredients.any?
      puts ''
      puts ingredients_title

      ingredients.each do |ingredient|
        puts "  * #{ingredient}"
      end
    end

    return unless steps.any?

    puts ''

    steps.each do |step|
      puts "  #{step}"
    end
  end
end
