defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth

    alias Discuss.User
    
    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
       user_params = %{email: auth.info.email, token: auth.credentials.token, provider: "github"}
        # IO.puts("################################################")
        # email: "alon.the.fabio@gmail.com",
        #   provider: "github",
        #   token: "f7fa80ad10afd94eafe33025e41abc54cbb46b67"
        # IO.puts("################################################")
       changeset = User.changeset(%User{}, user_params)
       
       IO.puts("################################################")
       IO.inspect(changeset)
       IO.puts("################################################")
       signin(conn, changeset)
       
    end

    defp signin(conn, params) do
        # IO.puts("################################################")
        # IO.inspect(params)
        # IO.puts("################################################")
        case insert_or_update_user(params) do
            {:ok, user} ->
                conn
                |>put_flash(:info, "Welcome back!")
                |>put_session(:user_ID, user.id)
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