defmodule Candone.PeopleTest do
  use Candone.DataCase

  alias Candone.Contacts
  import Candone.ContactsFixtures

  defp create_people(_) do
    people = Enum.map(1..3, fn _ -> person_fixture() end)
    people_ids = Enum.join(Enum.map(people, & &1.id), ",")
    %{ people: people, people_ids: people_ids }
  end

  describe "people" do
    setup [:create_people]

    test "get_people_from_string/1 with provided list of ids return a list with people", %{people: people, people_ids: people_ids} do
      assert Contacts.get_people_from_string(people_ids) == people
    end

    test "get_people_from_string/1 with an empty string returns an empty list" do
      assert Contacts.get_people_from_string("") == []
    end

    
  end
end