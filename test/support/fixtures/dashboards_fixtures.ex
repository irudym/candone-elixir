defmodule Candone.DashboardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Candone.Dashboards` context.
  """

  @doc """
  Generate a dashboard.
  """
  def dashboard_fixture(attrs \\ %{}) do
    {:ok, dashboard} =
      attrs
      |> Enum.into(%{

      })
      |> Candone.Dashboards.create_dashboard()

    dashboard
  end
end
