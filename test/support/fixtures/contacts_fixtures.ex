defmodule Candone.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Candone.Contacts` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        address: "some address",
        description: "some description",
        name: "some name"
      })
      |> Candone.Contacts.create_company()

    company
  end

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        description: "some description",
        first_name: "some first_name",
        last_name: "some last_name",
        middle_name: "some middle_name"
      })
      |> Candone.Contacts.create_person()

    person
  end
end
