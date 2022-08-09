defmodule LiveViewStudio.GitRepos do
  @moduledoc """
  The GitRepos context.
  """

  import Ecto.Query, warn: false
  alias LiveViewStudio.Repo

  alias LiveViewStudio.GitRepos.GitRepo

  @doc """
  Returns the list of git_repos.

  ## Examples

      iex> list_git_repos()
      [%GitRepo{}, ...]

  """
  def list_git_repos do
    Repo.all(GitRepo)
  end

  @doc """
  Gets a single git_repo.

  Raises `Ecto.NoResultsError` if the Git repo does not exist.

  ## Examples

      iex> get_git_repo!(123)
      %GitRepo{}

      iex> get_git_repo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_git_repo!(id), do: Repo.get!(GitRepo, id)

  @doc """
  Creates a git_repo.

  ## Examples

      iex> create_git_repo(%{field: value})
      {:ok, %GitRepo{}}

      iex> create_git_repo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_git_repo(attrs \\ %{}) do
    %GitRepo{}
    |> GitRepo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a git_repo.

  ## Examples

      iex> update_git_repo(git_repo, %{field: new_value})
      {:ok, %GitRepo{}}

      iex> update_git_repo(git_repo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_git_repo(%GitRepo{} = git_repo, attrs) do
    git_repo
    |> GitRepo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a git_repo.

  ## Examples

      iex> delete_git_repo(git_repo)
      {:ok, %GitRepo{}}

      iex> delete_git_repo(git_repo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_git_repo(%GitRepo{} = git_repo) do
    Repo.delete(git_repo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking git_repo changes.

  ## Examples

      iex> change_git_repo(git_repo)
      %Ecto.Changeset{data: %GitRepo{}}

  """
  def change_git_repo(%GitRepo{} = git_repo, attrs \\ %{}) do
    GitRepo.changeset(git_repo, attrs)
  end

  @doc """
  Returns the list of git_repos based on criteria.

  ## Examples

      iex> list_git_repos()
      [%GitRepo{}, ...]

  """
  def list_git_repos(criteria) when is_list(criteria) do
    query = from(g in GitRepo)

    Enum.reduce(criteria, query, fn
      {:language, ""}, query ->
        query

      {:language, language}, query ->
        from q in query,
          where: q.language == ^language

      {:license, ""}, query ->
        query

      {:license, license}, query ->
        from q in query,
          where: q.license == ^license
    end)
  end
end
