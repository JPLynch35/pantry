require './lib/recipe'

class Pantry
  attr_reader :stock,
              :shopping_list,
              :cookbook

  def initialize
    @stock = Hash.new(0)
    @shopping_list = Hash.new(0)
    @cookbook = Array.new
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
    end.chomp
  end

  def add_to_cookbook(recipe)
    (@cookbook << recipe) if recipe.instance_of?(Recipe)
  end

  def check_recipe_against_stock(recipe)
    rei = recipe.ingredients
    si = @stock
    valid_ingredients = rei.keys.find_all do |ingredient|
      si[ingredient] >= rei[ingredient]
    end
    valid_ingredients.length == rei.keys.length
  end

  def what_can_i_make
    @cookbook.inject(Array.new) do |collector, recipe|
      if check_recipe_against_stock(recipe) == true
        collector << recipe.name
      end
      collector
    end
  end
end
