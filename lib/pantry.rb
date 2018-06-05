require './lib/recipe'

class Pantry
  attr_reader :stock,
              :shopping_list

  def initialize
    @stock = Hash.new(0)
    @shopping_list = Hash.new(0)
  end

  def stock_check(ingredient)
    @stock[ingredient]
  end

  def restock(ingredient, quantity)
    @stock[ingredient] = @stock[ingredient] + quantity
  end

  def add_to_shopping_list(recipe)
    @shopping_list = recipe.ingredients.merge(@shopping_list)
  end
end
