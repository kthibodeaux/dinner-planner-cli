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

        write_group(pdf, recipe.ingredients, recipe.steps)

        recipe.groups.each do |_, group|
          write_group(pdf, group['ingredients'], group['steps'], group['name'])
        end
      end
    end

    `xdg-open temp.pdf`
    `rm temp.pdf`
  end

  private

  attr_reader :recipes

  def write_group(pdf, ingredients, steps, name = nil)
    ingredients_title = name ? "#{name} Ingredients" : 'Ingredients'
    steps_title = name ? "#{name} Steps" : 'Steps'

    if ingredients.any?
      pdf.move_down 20
      pdf.font_size 14
      pdf.text ingredients_title
      pdf.move_down 5
      pdf.font_size 12
      ingredients.each do |ingredient|
        pdf.text ingredient
      end
    end

    return unless steps.any?

    pdf.move_down 20
    pdf.font_size 14
    pdf.text steps_title
    pdf.move_down 5
    pdf.font_size 12
    steps.each do |step|
      pdf.text step
    end
  end
end
