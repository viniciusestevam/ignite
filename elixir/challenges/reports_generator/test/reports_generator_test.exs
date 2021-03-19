defmodule ReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "builds the report" do
      filename = "report_test.csv"

      response = ReportsGenerator.build(filename)

      expected_response = %{
        "all_hours" => %{
          "cleiton" => 1,
          "daniele" => 12,
          "giuliano" => 9,
          "jakeliny" => 14,
          "joseph" => 3,
          "mayk" => 5
        },
        "hours_per_month" => %{
          "cleiton" => %{"junho" => 1},
          "daniele" => %{"dezembro" => 5, "abril" => 7},
          "giuliano" => %{"fevereiro" => 9},
          "jakeliny" => %{"março" => 6, "julho" => 8},
          "joseph" => %{"março" => 3},
          "mayk" => %{"dezembro" => 5}
        },
        "hours_per_year" => %{
          "cleiton" => %{2020 => 1},
          "daniele" => %{2016 => 5, 2018 => 7},
          "giuliano" => %{2017 => 3, 2019 => 6},
          "jakeliny" => %{2017 => 8, 2019 => 6},
          "joseph" => %{2017 => 3},
          "mayk" => %{2017 => 1, 2019 => 4}
        }
      }

      assert expected_response == response
    end
  end
end
