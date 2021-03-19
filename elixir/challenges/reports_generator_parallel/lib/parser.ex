defmodule ReportsGeneratorParallel.Parser do
  def parse_file(filename) do
    "reports/#{filename}"
    |> File.stream!()
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.downcase()
    |> String.split(",")
    |> parse_numbers()
  end

  defp parse_numbers([head | tail]), do: [head] ++ Enum.map(tail, &String.to_integer/1)
end
