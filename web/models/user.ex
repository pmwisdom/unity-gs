defmodule UnityGs.User do
  use UnityGs.Web, :model

  schema "users" do
    field :username, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username])
    |> unique_constraint(:username)
    |> validate_required([:username])
  end
end
