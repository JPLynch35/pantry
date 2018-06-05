require 'minitest/autorun'
require 'minitest/pride'
require './lib/pantry'
require './lib/recipe'

class PantryTest < Minitest::Test
  def test_it_exists
    pantry = Pantry.new
    assert_instance_of Pantry, pantry
  end

  def test_stock_starts_empty
    pantry = Pantry.new
    expected = {}
    assert_equal expected, pantry.stock
  end

  def test_stock_check_checks_stock_of_empty_pantry
    pantry = Pantry.new
    actual = pantry.stock_check('Cheese')
    assert_equal 0, actual
  end

  def test_can_restock_ingredients
    pantry = Pantry.new
    actual = pantry.stock_check('Cheese')
    assert_equal 0, actual
    pantry.restock('Cheese', 10)
    actual = pantry.stock_check('Cheese')
    assert_equal 10, actual
  end

  def test_can_add_more_stock_to_exisiting_stock
    pantry = Pantry.new
    pantry.restock('Cheese', 10)
    actual = pantry.stock_check('Cheese')
    assert_equal 10, actual
    pantry.restock('Cheese', 20)
    actual = pantry.stock_check('Cheese')
    assert_equal 30, actual
  end

  def test_can_add_a_recipe_to_shopping_list
    pantry = Pantry.new
    r = Recipe.new('Cheese Pizza')
    expected = {}
    assert_equal expected, pantry.shopping_list
    r.add_ingredient('Flour', 20)
    r.add_ingredient('Cheese', 20)
    pantry.add_to_shopping_list(r)
    expected =  {
                'Cheese' => 20,
                'Flour' => 20
                }
    assert_equal expected, pantry.shopping_list
  end

  def test_can_add_multiple_recipes_to_shopping_list
    pantry = Pantry.new
    r1 = Recipe.new('Cheese Pizza')
    r1.add_ingredient('Flour', 20)
    r1.add_ingredient('Cheese', 20)
    pantry.add_to_shopping_list(r1)
    r2 = Recipe.new('Spaghetti')
    r2.add_ingredient('Spaghetti Noodles', 10)
    r2.add_ingredient('Marinara Sauce', 10)
    r2.add_ingredient('Cheese', 5)
    pantry.add_to_shopping_list(r2)
    expected = {
                'Cheese' => 25,
                'Flour' => 20,
                'Spaghetti Noodles' => 10,
                'Marinara Sauce' => 10
                }
    assert_equal expected, pantry.shopping_list
  end

  def test_can_print_the_shopping_list
    pantry = Pantry.new
    r1 = Recipe.new('Cheese Pizza')
    r1.add_ingredient('Cheese', 20)
    r1.add_ingredient('Flour', 20)
    pantry.add_to_shopping_list(r1)
    r2 = Recipe.new('Spaghetti')
    r2.add_ingredient('Spaghetti Noodles', 10)
    r2.add_ingredient('Marinara Sauce', 10)
    r2.add_ingredient('Cheese', 5)
    pantry.add_to_shopping_list(r2)
    expected = "* Cheese: 25\n* Flour: 20\n* Spaghetti Noodles: 10\n* Marinara Sauce: 10"
    assert_equal expected, pantry.print_shopping_list
  end

  def test_can_add_recipes_to_cookbook
    pantry = Pantry.new
    r1 = Recipe.new('Cheese Pizza')
    r1.add_ingredient('Cheese', 20)
    r1.add_ingredient('Flour', 20)
    r2 = Recipe.new('Pickles')
    r2.add_ingredient('Brine', 10)
    r2.add_ingredient('Cucumbers', 30)
    r3 = Recipe.new('Peanuts')
    r3.add_ingredient('Raw nuts', 10)
    r3.add_ingredient('Salt', 10)
    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)
    expected = [r1, r2, r3]
    assert_equal expected, pantry.cookbook
  end

  def test_can_check_recipe_against_stock_for_validity
    pantry = Pantry.new
    r1 = Recipe.new('Cheese Pizza')
    r1.add_ingredient('Cheese', 20)
    r1.add_ingredient('Flour', 20)
    r2 = Recipe.new('Pickles')
    r2.add_ingredient('Brine', 10)
    r2.add_ingredient('Cucumbers', 30)
    pantry.restock('Cheese', 10)
    pantry.restock('Flour', 20)
    pantry.restock('Brine', 40)
    pantry.restock('Cucumbers', 120)
    pantry.restock('Raw nuts', 20)
    pantry.restock('Salt', 20)
    refute pantry.check_recipe_against_stock(r1)
    assert pantry.check_recipe_against_stock(r2)
  end

  def test_can_make_valid_list_of_recipes_you_can_make
    pantry = Pantry.new
    r1 = Recipe.new('Cheese Pizza')
    r1.add_ingredient('Cheese', 20)
    r1.add_ingredient('Flour', 20)
    r2 = Recipe.new('Pickles')
    r2.add_ingredient('Brine', 10)
    r2.add_ingredient('Cucumbers', 30)
    r3 = Recipe.new('Peanuts')
    r3.add_ingredient('Raw nuts', 10)
    r3.add_ingredient('Salt', 10)
    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)
    pantry.restock('Cheese', 10)
    pantry.restock('Flour', 20)
    pantry.restock('Brine', 40)
    pantry.restock('Cucumbers', 120)
    pantry.restock('Raw nuts', 20)
    pantry.restock('Salt', 20)
    expected = [r2, r3]
    assert_equal expected, pantry.make_list_of_valid_recipes
  end

  def test_can_see_what_you_can_make_with_stock
    pantry = Pantry.new
    r1 = Recipe.new('Cheese Pizza')
    r1.add_ingredient('Cheese', 20)
    r1.add_ingredient('Flour', 20)
    r2 = Recipe.new('Pickles')
    r2.add_ingredient('Brine', 10)
    r2.add_ingredient('Cucumbers', 30)
    r3 = Recipe.new('Peanuts')
    r3.add_ingredient('Raw nuts', 10)
    r3.add_ingredient('Salt', 10)
    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)
    pantry.restock('Cheese', 10)
    pantry.restock('Flour', 20)
    pantry.restock('Brine', 40)
    pantry.restock('Cucumbers', 120)
    pantry.restock('Raw nuts', 20)
    pantry.restock('Salt', 20)
    expected = ['Pickles', 'Peanuts']
    assert_equal expected, pantry.what_can_i_make
  end

  def test_can_find_quantity_can_make_per_recipe
    pantry = Pantry.new
    r1 = Recipe.new('Cheese Pizza')
    r1.add_ingredient('Cheese', 20)
    r1.add_ingredient('Flour', 20)
    r2 = Recipe.new('Pickles')
    r2.add_ingredient('Brine', 10)
    r2.add_ingredient('Cucumbers', 30)
    r3 = Recipe.new('Peanuts')
    r3.add_ingredient('Raw nuts', 10)
    r3.add_ingredient('Salt', 10)
    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)
    pantry.restock('Cheese', 10)
    pantry.restock('Flour', 20)
    pantry.restock('Brine', 40)
    pantry.restock('Cucumbers', 120)
    pantry.restock('Raw nuts', 20)
    pantry.restock('Salt', 20)
    assert_equal 0, pantry.check_recipe_against_stock_for_quantity(r1)
    assert_equal 4, pantry.check_recipe_against_stock_for_quantity(r2)
    assert_equal 2, pantry.check_recipe_against_stock_for_quantity(r3)
  end

  def test_can_see_how_many_you_can_make_with_stock
    pantry = Pantry.new
    r1 = Recipe.new('Cheese Pizza')
    r1.add_ingredient('Cheese', 20)
    r1.add_ingredient('Flour', 20)
    r2 = Recipe.new('Pickles')
    r2.add_ingredient('Brine', 10)
    r2.add_ingredient('Cucumbers', 30)
    r3 = Recipe.new('Peanuts')
    r3.add_ingredient('Raw nuts', 10)
    r3.add_ingredient('Salt', 10)
    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)
    pantry.restock('Cheese', 10)
    pantry.restock('Flour', 20)
    pantry.restock('Brine', 40)
    pantry.restock('Cucumbers', 120)
    pantry.restock('Raw nuts', 20)
    pantry.restock('Salt', 20)
    expected = {
                'Pickles' => 4,
                'Peanuts' => 2
                }
    assert_equal expected, pantry.how_many_can_i_make
  end
end
