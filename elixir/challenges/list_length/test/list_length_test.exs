defmodule ListLengthTest do
  use ExUnit.Case
  doctest ListLength

  describe "call/1" do
    test "returns the list sum" do
      list = [1, 2, 3]

      response = ListLength.call(list)
      expected_response = 3

      assert response == expected_response
    end
  end
end
