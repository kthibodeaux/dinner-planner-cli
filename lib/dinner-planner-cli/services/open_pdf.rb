class DinnerPlannerCli::Services::OpenPdf
  CATEGORY_SIZE = 32
  HEADER_SIZE = 20
  DEFAULT_TEXT_SIZE = 12

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

      if recipes.size == 1
        write_recipe(pdf, recipes.first)
      else
        recipes.group_by(&:category).sort_by(&:first).each_with_index do |(category, category_recipes), index|
          pdf.start_new_page unless index.zero?
          write_category(pdf, category)

          category_recipes.each_with_index do |recipe, _index|
            pdf.start_new_page

            write_recipe(pdf, recipe)
          end
        end
      end
    end

    `xdg-open temp.pdf`
    `rm temp.pdf`
  end

  private

  attr_reader :recipes

  def write_category(pdf, name)
    pdf.move_down 100
    pdf.font_size CATEGORY_SIZE
    pdf.text name
    pdf.stroke_horizontal_rule
  end

  def write_recipe(pdf, recipe)
    pdf.font_size HEADER_SIZE
    pdf.text recipe.name
    pdf.stroke_horizontal_rule

    pdf.font_size recipe.text_size || DEFAULT_TEXT_SIZE

    write_group(pdf, recipe.ingredients, recipe.steps)

    recipe.groups.each do |group|
      write_group(pdf, group.ingredients, group.steps, group.name)
    end
  end

  def write_group(pdf, ingredients, steps, name = nil)
    ingredients_title = name || 'Ingredients'

    pdf.move_down 10

    if ingredients.any?
      pdf.text ingredients_title, style: :bold
      pdf.move_down 5
      ingredients.each do |ingredient|
        pdf.text "• #{ingredient}"
      end
      pdf.move_down 5
    end

    return unless steps.any?

    pdf.text name, style: :bold if !ingredients.any? && name

    steps.each do |step|
      pdf.text step
    end
  end
end
