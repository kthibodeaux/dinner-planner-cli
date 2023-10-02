class DinnerPlannerCli::Services::OpenHtml
  def initialize(recipes)
    @recipes = Array(recipes)
  end

  def process
    File.open('temp.html', 'w') do |file|
      file.write(ERB.new(
        File.read("#{DinnerPlannerCli.template_directory}/cookbook.html.erb"),
        trim_mode: '-'
      ).result(binding))
    end

    `xdg-open temp.html`
    sleep 5
    `rm temp.html`
  end
end
