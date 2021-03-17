defmodule ListFilterTest do
  use ExUnit.Case

  describe "filter/1" do
    test "when given a list with numerics and non-numerics, should return the odds count" do
      input = ["1", "3", "6", "43", "banana", "6", "abc"]

      response = ListFilter.filter(input)
      expected_response = {:ok, 3}

      assert response == expected_response
    end

    test "when given a input that is not a list, should return an error" do
      input = "banana"

      response = ListFilter.filter(input)
      expected_response = {:error, "Invalid input"}

      assert response == expected_response
    end
  end
end
