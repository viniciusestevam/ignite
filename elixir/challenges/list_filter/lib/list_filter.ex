defmodule ListFilter do
  def filter(list) when is_list(list) do
    result =
      list
      |> Enum.count(&filter_odd(&1))

    {:ok, result}
  end

  def filter(_) do
    {:error, "Invalid input"}
  end

  defp filter_odd(elem) do
    elem
    |> Integer.parse()
    |> is_odd()
  end

  defp is_odd({int, _}), do: rem(int, 2) === 1

  defp is_odd(:error), do: false
end
