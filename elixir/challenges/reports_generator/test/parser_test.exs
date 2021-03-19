defmodule ReportsGenerator.ParserTest do
  use ExUnit.Case

  alias ReportsGenerator.Parser

  describe "parse_file/1" do
    test "parses the file" do
      file_name = "report_test.csv"

      response =
        file_name
        |> Parser.parse_file()
        |> Enum.map(& &1)

      expected_response = [
        ["daniele", 7, 29, 4, 2018],
        ["mayk", 4, 9, 12, 2019],
        ["daniele", 5, 27, 12, 2016],
        ["mayk", 1, 2, 12, 2017],
        ["giuliano", 3, 13, 2, 2017],
        ["cleiton", 1, 22, 6, 2020],
        ["giuliano", 6, 18, 2, 2019],
        ["jakeliny", 8, 18, 7, 2017],
        ["joseph", 3, 17, 3, 2017],
        ["jakeliny", 6, 23, 3, 2019]
      ]

      assert response == expected_response
    end
  end
end
