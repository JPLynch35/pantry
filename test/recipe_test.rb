require 'minitest/autorun'
require 'minitest/pride'
require './lib/recipe'

class RecipeTest < Minitest::Test
  def test_it_has_a_name
    r = Recipe.new("Cheese Pizza")
    assert_equal "Cheese Pizza", r.name
  end

  def test_ingredients_start_as_empty
    r = Recipe.new("Cheese Pizza")
    expected = {}
    assert_equal expected, r.ingredients
  end

  def test_it_can_add_an_ingredient
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Flour", 500) # 500 "UNIVERSAL UNITS"
    assert_equal ["Flour"], r.ingredient_types
    r.add_ingredient("Cheese", 1500)
    assert_equal ["Flour", "Cheese"], r.ingredient_types
  end

  def test_ingredients_are_aded_to_ingredients_list
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Flour", 20) # 500 "UNIVERSAL UNITS"
    r.add_ingredient("Cheese", 20)
    expected =  {
                'Cheese' => 20,
                'Flour' => 20
                }
    assert_equal expected, r.ingredients
  end

  def test_it_tracks_amount_of_a_recipe_required
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Flour", 500)
    assert_equal 500, r.amount_required("Flour")
  end
end
