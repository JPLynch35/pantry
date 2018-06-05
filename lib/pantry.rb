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
    ingredients_added = recipe.ingredients
    ingredients_added.keys.inject(@shopping_list) do |shopping_list, ingredient|
      shopping_list[ingredient] = shopping_list[ingredient] + ingredients_added[ingredient]
      shopping_list
    end
  end

  def print_shopping_list
    ingredients = @shopping_list.keys
    print_out = ingredients.inject('') do |print_out, ingredient|
      print_out += "* #{ingredient}: #{@shopping_list[ingredient]}\n"
      print_out
    end
    require 'pry'; binding.pry
  end
end
