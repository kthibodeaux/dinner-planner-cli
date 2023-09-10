require 'prawn'
require 'toml'

module DinnerPlannerCli
end

Dir[File.dirname(__FILE__) + '/**/*.rb'].each { |file| require file }
