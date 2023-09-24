class DinnerPlannerCli::Recipe
  def self.all
    Dir
      .entries(Dir.pwd)
      .reject { |e| ['.', '..', 'fonts', 'config.toml'].include?(e) }
      .map { |e| new(toml: TOML.load_file("#{Dir.pwd}/#{e}")) }
      .sort_by { |e| e.name.downcase }
  end

  def initialize(toml:)
    @toml = toml
  end

  def text_size
    toml['text_size']
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

  def all_ingredients
    a = Array(toml['ingredients'])
    b = Array(toml['groups']).map(&:last).map { |e| Array(e['ingredients']) }
    (a + b).flatten
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
