defmodule LiveViewStudio.GitReposTest do
  use LiveViewStudio.DataCase

  alias LiveViewStudio.GitRepos

  describe "git_repos" do
    alias LiveViewStudio.GitRepos.GitRepo

    @valid_attrs %{fork: true, language: "some language", license: "some license", name: "some name", owner_login: "some owner_login", owner_url: "some owner_url", stars: 42, url: "some url"}
    @update_attrs %{fork: false, language: "some updated language", license: "some updated license", name: "some updated name", owner_login: "some updated owner_login", owner_url: "some updated owner_url", stars: 43, url: "some updated url"}
    @invalid_attrs %{fork: nil, language: nil, license: nil, name: nil, owner_login: nil, owner_url: nil, stars: nil, url: nil}

    def git_repo_fixture(attrs \\ %{}) do
      {:ok, git_repo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> GitRepos.create_git_repo()

      git_repo
    end

    test "list_git_repos/0 returns all git_repos" do
      git_repo = git_repo_fixture()
      assert GitRepos.list_git_repos() == [git_repo]
    end

    test "get_git_repo!/1 returns the git_repo with given id" do
      git_repo = git_repo_fixture()
      assert GitRepos.get_git_repo!(git_repo.id) == git_repo
    end

    test "create_git_repo/1 with valid data creates a git_repo" do
      assert {:ok, %GitRepo{} = git_repo} = GitRepos.create_git_repo(@valid_attrs)
      assert git_repo.fork == true
      assert git_repo.language == "some language"
      assert git_repo.license == "some license"
      assert git_repo.name == "some name"
      assert git_repo.owner_login == "some owner_login"
      assert git_repo.owner_url == "some owner_url"
      assert git_repo.stars == 42
      assert git_repo.url == "some url"
    end

    test "create_git_repo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GitRepos.create_git_repo(@invalid_attrs)
    end

    test "update_git_repo/2 with valid data updates the git_repo" do
      git_repo = git_repo_fixture()
      assert {:ok, %GitRepo{} = git_repo} = GitRepos.update_git_repo(git_repo, @update_attrs)
      assert git_repo.fork == false
      assert git_repo.language == "some updated language"
      assert git_repo.license == "some updated license"
      assert git_repo.name == "some updated name"
      assert git_repo.owner_login == "some updated owner_login"
      assert git_repo.owner_url == "some updated owner_url"
      assert git_repo.stars == 43
      assert git_repo.url == "some updated url"
    end

    test "update_git_repo/2 with invalid data returns error changeset" do
      git_repo = git_repo_fixture()
      assert {:error, %Ecto.Changeset{}} = GitRepos.update_git_repo(git_repo, @invalid_attrs)
      assert git_repo == GitRepos.get_git_repo!(git_repo.id)
    end

    test "delete_git_repo/1 deletes the git_repo" do
      git_repo = git_repo_fixture()
      assert {:ok, %GitRepo{}} = GitRepos.delete_git_repo(git_repo)
      assert_raise Ecto.NoResultsError, fn -> GitRepos.get_git_repo!(git_repo.id) end
    end

    test "change_git_repo/1 returns a git_repo changeset" do
      git_repo = git_repo_fixture()
      assert %Ecto.Changeset{} = GitRepos.change_git_repo(git_repo)
    end
  end
end
