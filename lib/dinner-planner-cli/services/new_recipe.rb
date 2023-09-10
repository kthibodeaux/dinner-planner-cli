class DinnerPlannerCli::Services::NewRecipe
  def initialize(filename:)
    @filename = filename
  end

  def process
    File.open(filepath, 'w') do |f|
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

    system("$EDITOR \"#{filepath}\"")
  end

  private

  attr_reader :filename

  def filepath
    if filename.end_with?('.toml')
      filename
    else
      "#{filename}.toml"
    end
  end
end
