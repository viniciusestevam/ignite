defmodule ReportsGeneratorParallelTest do
  use ExUnit.Case

  describe "build/1" do
    test "builds the report" do
      filename = "report_test.csv"

      response = ReportsGeneratorParallel.build(filename)

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

  describe "build_from_many/1" do
    test "when a file list is provided, builds the report" do
      filenames = ["report_test.csv", "report_test.csv", "report_test.csv"]

      response = ReportsGeneratorParallel.build_from_many(filenames)

      expected_response =
        {:ok,
         %{
           "all_hours" => %{
             "cleiton" => 3,
             "daniele" => 36,
             "giuliano" => 27,
             "jakeliny" => 42,
             "joseph" => 9,
             "mayk" => 15
           },
           "hours_per_month" => %{
             "cleiton" => %{"junho" => 3},
             "daniele" => %{"abril" => 21, "dezembro" => 15},
             "giuliano" => %{"fevereiro" => 27},
             "jakeliny" => %{"julho" => 24, "março" => 18},
             "joseph" => %{"março" => 9},
             "mayk" => %{"dezembro" => 15}
           },
           "hours_per_year" => %{
             "cleiton" => %{2020 => 3},
             "daniele" => %{2016 => 15, 2018 => 21},
             "giuliano" => %{2017 => 9, 2019 => 18},
             "jakeliny" => %{2017 => 24, 2019 => 18},
             "joseph" => %{2017 => 9},
             "mayk" => %{2017 => 3, 2019 => 12}
           }
         }}

      assert response == expected_response
    end

    test "when a file list is not provided, returns an error" do
      response = ReportsGeneratorParallel.build_from_many("banana")

      expected_response = {:error, "Please provide a list of strings"}
      assert response == expected_response
    end
  end
end
