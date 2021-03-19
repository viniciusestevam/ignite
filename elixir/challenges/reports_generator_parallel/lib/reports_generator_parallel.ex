defmodule ReportsGeneratorParallel do
  alias ReportsGeneratorParallel.Parser

  @months %{
    1 => "janeiro",
    2 => "fevereiro",
    3 => "março",
    4 => "abril",
    5 => "maio",
    6 => "junho",
    7 => "julho",
    8 => "agosto",
    9 => "setembro",
    10 => "outubro",
    11 => "novembro",
    12 => "dezembro"
  }

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(reports_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build_from_many(filenames) when not is_list(filenames) do
    {:error, "Please provide a list of strings"}
  end

  def build_from_many(filenames) do
    result =
      filenames
      |> Task.async_stream(&build/1)
      |> Enum.reduce(reports_acc(), fn {:ok, result}, report -> sum_reports(report, result) end)

    {:ok, result}
  end

  defp sum_reports(
         %{
           "all_hours" => all_hours1,
           "hours_per_month" => hours_per_month1,
           "hours_per_year" => hours_per_year1
         },
         %{
           "all_hours" => all_hours2,
           "hours_per_month" => hours_per_month2,
           "hours_per_year" => hours_per_year2
         }
       ) do
    all_hours = merge_maps(all_hours1, all_hours2)
    hours_per_month = merge_maps(hours_per_month1, hours_per_month2)
    hours_per_year = merge_maps(hours_per_year1, hours_per_year2)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, &deep_resolve/3)
  end

  defp deep_resolve(_key, left = %{}, right = %{}) do
    merge_maps(left, right)
  end

  defp deep_resolve(_key, left, right) do
    left + right
  end

  defp sum_values([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = Map.update(all_hours, name, hours, &sum(&1, hours))

    month_name = @months[month]

    hours_per_month =
      Map.update(
        hours_per_month,
        name,
        %{month_name => hours},
        &sum_hours(&1, month_name, hours)
      )

    hours_per_year =
      Map.update(
        hours_per_year,
        name,
        %{year => hours},
        &sum_hours(&1, year, hours)
      )

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp sum_hours(map, key, hours),
    do: Map.update(map, key, hours, &sum(&1, hours))

  defp sum(v1, v2), do: v1 + v2

  defp reports_acc do
    %{"all_hours" => %{}, "hours_per_month" => %{}, "hours_per_year" => %{}}
  end

  defp build_report(all_hours, hours_per_month, hours_per_year),
    do: %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
end
