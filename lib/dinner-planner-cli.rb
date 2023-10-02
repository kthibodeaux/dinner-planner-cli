require 'erb'
require 'ostruct'
require 'prawn'
require 'toml'

module DinnerPlannerCli
  module Services; end

  def self.template_directory
    File.expand_path('../templates', File.dirname(__FILE__))
  end

  def self.config
    DinnerPlannerCli.create_empty_config unless File.exist?('config.toml')

    @config ||= TOML.load_file('config.toml')
  end

  def self.create_empty_config
    puts 'No config.toml found, creating empty config'

    File.open('config.toml', 'w') do |f|
      f.puts '[shopping_list]'
      f.puts '  ignore = ['
      f.puts '  ]'
    end
  end
end

Dir[File.dirname(__FILE__) + '/**/*.rb'].each { |file| require file }
