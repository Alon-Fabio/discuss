defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth

    alias Discuss.User
    
    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
       user_params = %{email: auth.info.email, token: auth.credentials.token, provider: "github"}
       changeset = User.changeset(%User{}, user_params)
       
       
       signin(conn, changeset)
       
    end

    def signout(conn, _params) do
        conn
        |>configure_session(drop: true)
        |>redirect(to: topic_path(conn, :index))
    end

    defp signin(conn, params) do
        # IO.puts("################################################")
        # IO.inspect(conn.assigns)
        # IO.puts("################################################")
        case insert_or_update_user(params) do
            {:ok, user} ->
                conn
                |>put_flash(:info, "Welcome back!")
                |>put_session(:user_id, user.id)
                # Adds the user_id var to the conn object with the id in the user object that we got from auth.
                |>redirect(to: topic_path(conn, :index))
            {:error, _changeset} ->
                conn
                |>put_flash(:error, "Sorry, something went wrong")
                |>redirect(to: topic_path(conn, :index))
        end
    end

    defp insert_or_update_user(changeset) do
        case Repo.get_by(User, email: changeset.changes.email) do
            nil->
                Repo.insert(changeset)
            user->
                {:ok, user}
        end
        
    end
    
end