class DinnerPlannerCli::Recipe
  def initialize(filename:)
    @filename = filename
  end

  def print
    puts toml['name']
    puts toml['category']
    puts toml['ingredients']
    puts toml['steps']
  end

  private

  attr_reader :filename

  def toml
    @toml ||= TOML.load_file("recipes/#{filename}")
  end
end
