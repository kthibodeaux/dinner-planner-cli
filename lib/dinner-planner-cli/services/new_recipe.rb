class DinnerPlannerCli::Services::NewRecipe
  def initialize(filename:)
    @filename = filename
  end

  def process
    File.open(full_filepath, 'w') do |f|
      f.puts <<~EOF
        name = ""
        category = "Main"
        include_in_cookbook = true
        source = ""

        ingredients = [
          "",
          "",
        ]

        steps = [
          "",
          "",
        ]
      EOF
    end

    system("$EDITOR \"#{full_filepath}\"")
  end

  private

  attr_reader :filename

  def full_filepath
    if filename.end_with?('.toml')
      "#{DinnerPlannerCli.folder}/#{filename}"
    else
      "#{DinnerPlannerCli.folder}/#{filename}.toml"
    end
  end
end
