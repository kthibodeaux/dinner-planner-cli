class DinnerPlannerCli::Ingredient
  attr_reader :raw

  def initialize(raw)
    @raw = raw
  end

  def quantity
    return unless raw.include?(';')

    raw.split(';').first.strip
  end

  def notes
    return unless raw.include?('(')

    raw.split('(').last.sub(')', '').strip
  end

  def item
    e = raw
    e = e.split(';').last if e.include?(';')
    e = e.split('(').first if e.include?('(')
    e.strip
  end
end
