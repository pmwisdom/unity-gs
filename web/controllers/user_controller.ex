defmodule UnityGs.UserController do
  use UnityGs.Web, :controller

  alias UnityGs.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => stringified_params}) do
    IO.inspect "USERNAME"
    IO.inspect stringified_params
    user_params = Poison.decode!(stringified_params)
    IO.inspect user_params
    # This is very bad never do this
    existing_user = Repo.get_by(User, username: user_params["username"])

    if existing_user != nil do
        render(conn, "show.json", user: existing_user)
    else
      changeset = User.changeset(%User{}, user_params)

      IO.puts "CHANGESET"
      IO.inspect changeset

      case Repo.insert(changeset) do
        {:ok, user} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", user_path(conn, :show, user))
          |> render("show.json", user: user)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(UnityGs.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def show(conn, %{"username" => username}) do
    user = Repo.get!(User, username: username)

    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(UnityGs.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
