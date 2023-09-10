require 'json'

class DinnerPlannerCli::Services::TheDinnerPlannerComImport
  def initialize(filename:, path:)
    @filename = filename
    @path = path
  end

  def process
    JSON.parse(File.read(filename)).each do |raw|
      recipe = {}
      recipe['name'] = raw['name'] if raw['name']
      recipe['category'] = raw['category'] if raw['category']
      recipe['notes'] = raw['notes'] if raw['notes'].any?
      recipe['steps'] = raw['steps'] if raw['steps'].any?

      if raw['sourceUrl']
        recipe['source'] = raw['sourceUrl']
      elsif raw['cookbookName']
        recipe['source'] = if raw['cookbookPage']
                             "#{raw['cookbookName']} p.#{raw['cookbookPage']}"
                           else
                             raw['cookbookName']
                           end
      end

      recipe['include_in_cookbook'] = true if raw['isPublic']

      recipe['ingredients'] = raw['ingredients'] if raw['ingredients'].any?

      toml_filename = "#{recipe['name'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')}.toml"

      File.open("#{path}/#{toml_filename}", 'w') do |f|
        f.puts TOML::Generator.new(recipe).body
      end
    end
  end

  private

  attr_reader :filename, :path
end
