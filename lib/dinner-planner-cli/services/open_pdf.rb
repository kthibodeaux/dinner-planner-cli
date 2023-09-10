class DinnerPlannerCli::Services::OpenPdf
  def initialize(recipes)
    @recipes = Array(recipes)
  end

  def process
    Prawn::Document.generate('temp.pdf') do |pdf|
      pdf.font_families.update('FiraSans' => {
                                 normal: 'fonts/regular.ttf',
                                 italic: 'fonts/italic.ttf',
                                 bold: 'fonts/bold.ttf',
                                 bold_italic: 'fonts/bold_italic.ttf'
                               })
      pdf.font 'FiraSans'

      recipes.each_with_index do |recipe, index|
        pdf.start_new_page unless index.zero?

        pdf.font_size 20
        pdf.text recipe.name
        pdf.stroke_horizontal_rule

        if recipe.ingredients.any?
          pdf.move_down 20
          pdf.font_size 14
          pdf.text 'Ingredients'
          pdf.move_down 5
          pdf.font_size 12
          recipe.ingredients.each do |ingredient|
            pdf.text ingredient
          end
        end

        next unless recipe.steps.any?

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

  attr_reader :recipes
end
