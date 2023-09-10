require 'ostruct'
require 'prawn'
require 'toml'

module DinnerPlannerCli
  module Services; end
end

Dir[File.dirname(__FILE__) + '/**/*.rb'].each { |file| require file }
