require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  setup do
    @test_category = Category.new(
      name: 'Test Category',
      description: 'Random detail description'
    )
  end

  test "category should not be valid without name" do
    @test_category.name = nil
    assert @test_category.invalid?
  end

  test "category should not be valid without description" do
    @test_category.description = nil
    assert @test_category.invalid?
  end

  test "category should be valid with all details" do
    assert @test_category.valid?
  end
end
