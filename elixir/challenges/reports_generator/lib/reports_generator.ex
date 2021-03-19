defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

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
