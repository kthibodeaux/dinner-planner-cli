class DinnerPlannerCli::Services::OpenRecipePdf
  def initialize(filename:)
    @filename = filename
  end

  def process
    Prawn::Document.generate('./temp.pdf') do |pdf|
      pdf.font_size 20
      pdf.text recipe.name
      pdf.stroke_horizontal_rule

      if recipe.ingredients
        pdf.move_down 20
        pdf.font_size 14
        pdf.text 'Ingredients'
        pdf.move_down 5
        pdf.font_size 12
        recipe.ingredients.each do |ingredient|
          pdf.text ingredient
        end
      end

      if recipe.steps
        pdf.move_down 20
        pdf.font_size 14
        pdf.text 'Steps'
        pdf.move_down 5
        pdf.font_size 12
        recipe.steps.each do |step|
          pdf.text step
        end
      end
    end

    `xdg-open temp.pdf`
    `rm temp.pdf`
  end

  private

  attr_reader :filename

  def recipe
    @recipe ||= DinnerPlannerCli::Recipe.new(toml: TOML.load_file(filename))
  end
end
