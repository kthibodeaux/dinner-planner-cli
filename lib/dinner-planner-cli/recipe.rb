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
    Array(toml['ingredients']).map { |e| e.gsub('; ', ' ') }
  end

  def steps
    Array(toml['steps']).map.with_index(1) do |step, index|
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

  def groups
    Array(toml['groups'])
  end

  private

  attr_reader :toml
end
