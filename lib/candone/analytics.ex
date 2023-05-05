defmodule Candone.Analytics do
  import Ecto.Query, warn: false
  alias Candone.Repo

  alias Candone.Tasks.Task

  def cost_per_week do
    q = from t in Task, group_by: t.done_at_ww, select: %{ww: t.done_at_ww, cost_per_week: sum(t.cost)}
    Repo.all(q)
  end

  @doc """
  Returns the list of cost per week for the provided number of last weeks.

  ## Examples

      iex> list_tasks(5)
      [%{cost_per_week: 100, ww: 10}, ..]

  """
  def cost_per_week(last) do
    start_week = Candone.DateUtils.get_current_week() - last
    start_week = if start_week < 0, do: 0, else: start_week
    q = from t in Task, group_by: t.done_at_ww, where: t.done_at_ww >= ^start_week, select: %{ww: t.done_at_ww, cost_per_week: sum(t.cost)}
    result = Repo.all(q)
    week_cost = Enum.reduce(result, %{}, fn elem, acc ->
      Map.put(acc, elem.ww, elem.cost_per_week)
    end)
    IO.inspect(week_cost)
    filled = Enum.reduce(start_week..Candone.DateUtils.get_current_week(), week_cost, fn ww, acc ->
      if !Map.has_key?(acc, ww) do
        Map.put(acc, ww, 0)
      else
        acc
      end
    end)
    filled
  end

  @doc """
  Returns ww value from arrays of maps
  """

end
