defmodule LiveViewStudio.StoresTest do
  use LiveViewStudio.DataCase

  alias LiveViewStudio.Stores

  describe "stores" do
    alias LiveViewStudio.Stores.Store

    @valid_attrs %{city: "some city", hours: "some hours", name: "some name", open: true, phone_number: "some phone_number", street: "some street", zip: "some zip"}
    @update_attrs %{city: "some updated city", hours: "some updated hours", name: "some updated name", open: false, phone_number: "some updated phone_number", street: "some updated street", zip: "some updated zip"}
    @invalid_attrs %{city: nil, hours: nil, name: nil, open: nil, phone_number: nil, street: nil, zip: nil}

    def store_fixture(attrs \\ %{}) do
      {:ok, store} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stores.create_store()

      store
    end

    test "list_stores/0 returns all stores" do
      store = store_fixture()
      assert Stores.list_stores() == [store]
    end

    test "get_store!/1 returns the store with given id" do
      store = store_fixture()
      assert Stores.get_store!(store.id) == store
    end

    test "create_store/1 with valid data creates a store" do
      assert {:ok, %Store{} = store} = Stores.create_store(@valid_attrs)
      assert store.city == "some city"
      assert store.hours == "some hours"
      assert store.name == "some name"
      assert store.open == true
      assert store.phone_number == "some phone_number"
      assert store.street == "some street"
      assert store.zip == "some zip"
    end

    test "create_store/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stores.create_store(@invalid_attrs)
    end

    test "update_store/2 with valid data updates the store" do
      store = store_fixture()
      assert {:ok, %Store{} = store} = Stores.update_store(store, @update_attrs)
      assert store.city == "some updated city"
      assert store.hours == "some updated hours"
      assert store.name == "some updated name"
      assert store.open == false
      assert store.phone_number == "some updated phone_number"
      assert store.street == "some updated street"
      assert store.zip == "some updated zip"
    end

    test "update_store/2 with invalid data returns error changeset" do
      store = store_fixture()
      assert {:error, %Ecto.Changeset{}} = Stores.update_store(store, @invalid_attrs)
      assert store == Stores.get_store!(store.id)
    end

    test "delete_store/1 deletes the store" do
      store = store_fixture()
      assert {:ok, %Store{}} = Stores.delete_store(store)
      assert_raise Ecto.NoResultsError, fn -> Stores.get_store!(store.id) end
    end

    test "change_store/1 returns a store changeset" do
      store = store_fixture()
      assert %Ecto.Changeset{} = Stores.change_store(store)
    end
  end
end
