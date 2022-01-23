defmodule Candone.ContactsTest do
  use Candone.DataCase

  alias Candone.Contacts

  describe "companies" do
    alias Candone.Contacts.Company

    import Candone.ContactsFixtures

    @invalid_attrs %{address: nil, description: nil, name: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Contacts.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Contacts.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{address: "some address", description: "some description", name: "some name"}

      assert {:ok, %Company{} = company} = Contacts.create_company(valid_attrs)
      assert company.address == "some address"
      assert company.description == "some description"
      assert company.name == "some name"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{address: "some updated address", description: "some updated description", name: "some updated name"}

      assert {:ok, %Company{} = company} = Contacts.update_company(company, update_attrs)
      assert company.address == "some updated address"
      assert company.description == "some updated description"
      assert company.name == "some updated name"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Contacts.update_company(company, @invalid_attrs)
      assert company == Contacts.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Contacts.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Contacts.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Contacts.change_company(company)
    end
  end

  describe "people" do
    alias Candone.Contacts.Person

    import Candone.ContactsFixtures

    @invalid_attrs %{description: nil, first_name: nil, last_name: nil, middle_name: nil}

    test "list_people/0 returns all people" do
      person = person_fixture()
      assert Contacts.list_people() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Contacts.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{description: "some description", first_name: "some first_name", last_name: "some last_name", middle_name: "some middle_name"}

      assert {:ok, %Person{} = person} = Contacts.create_person(valid_attrs)
      assert person.description == "some description"
      assert person.first_name == "some first_name"
      assert person.last_name == "some last_name"
      assert person.middle_name == "some middle_name"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      update_attrs = %{description: "some updated description", first_name: "some updated first_name", last_name: "some updated last_name", middle_name: "some updated middle_name"}

      assert {:ok, %Person{} = person} = Contacts.update_person(person, update_attrs)
      assert person.description == "some updated description"
      assert person.first_name == "some updated first_name"
      assert person.last_name == "some updated last_name"
      assert person.middle_name == "some updated middle_name"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Contacts.update_person(person, @invalid_attrs)
      assert person == Contacts.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Contacts.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Contacts.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Contacts.change_person(person)
    end
  end
end
