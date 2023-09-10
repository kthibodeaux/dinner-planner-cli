class DinnerPlannerCli::Recipe
  def initialize(filename:)
    @filename = filename
  end

  def to_pdf
    Prawn::Document.generate("./temp.pdf") do |pdf|
      pdf.font_size 20
      pdf.text toml['name']
      pdf.stroke_horizontal_rule

      if toml['ingredients']
        pdf.move_down 20
        pdf.font_size 14
        pdf.text 'Ingredients'
        pdf.move_down 5
        pdf.font_size 12
        toml['ingredients'].each do |ingredient|
          pdf.text ingredient.gsub('; ', ' ')
        end
      end

      if toml['steps']
        pdf.move_down 20
        pdf.font_size 14
        pdf.text 'Steps'
        pdf.move_down 5
        pdf.font_size 12
        toml['steps'].each.with_index(1) do |step, index|
          pdf.text "#{index}. #{step}"
        end
      end
    end

    `xdg-open temp.pdf`
  end

  private

  attr_reader :filename

  def toml
    @toml ||= TOML.load_file("recipes/#{filename}")
  end
end
