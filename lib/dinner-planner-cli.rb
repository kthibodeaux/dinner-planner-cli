require 'ostruct'
require 'prawn'
require 'toml'

module DinnerPlannerCli
  module Services; end

  def self.set_folder(folder)
    @folder = folder
  end

  def self.folder
    File.expand_path(@folder || './recipes')
  end
end

Dir[File.dirname(__FILE__) + '/**/*.rb'].each { |file| require file }
