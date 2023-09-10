class DinnerPlannerCli::Recipe
  def initialize(toml:)
    @toml = toml
  end

  def name
    toml['name']
  end

  def ingredients
    toml['ingredients'].map { |e| e.gsub('; ', ' ') }
  end

  def steps
    toml['steps'].map.with_index(1) do |step, index|
      "#{index}. #{step}"
    end
  end

  def category
    toml['category']
  end

  def source
    toml['source']
  end

  def needs_sides?
    toml['needs_sides']
  end

  def include_in_cookbook?
    toml['include_in_cookbook']
  end

  private

  attr_reader :toml
end
