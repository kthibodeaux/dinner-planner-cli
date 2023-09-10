class DinnerPlannerCli::Recipe
  def self.all
    Dir
      .entries(DinnerPlannerCli.folder)
      .reject { |e| ['.', '..', '.gitkeep'].include?(e) }
      .map { |e| new(toml: TOML.load_file("#{DinnerPlannerCli.folder}/#{e}")) }
      .sort_by(&:name)
  end

  def initialize(toml:)
    @toml = toml
  end

  def name
    toml['name']
  end

  def ingredients
    ingredients_for(toml['ingredients'])
  end

  def steps
    steps_for(toml['steps'])
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

  def groups
    Array(toml['groups']).map do |_, group|
      OpenStruct.new({
                       name: group['name'],
                       ingredients: ingredients_for(group['ingredients']),
                       steps: steps_for(group['steps'])
                     })
    end
  end

  private

  attr_reader :toml

  def ingredients_for(raw_array)
    Array(raw_array).map { |e| e.gsub('; ', ' ') }
  end

  def steps_for(raw_array)
    Array(raw_array).map.with_index(1) do |step, index|
      "#{index}. #{step}"
    end
  end
end
