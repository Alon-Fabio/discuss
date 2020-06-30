defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth

    alias Discuss.User
    
    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, parms) do
        # IO.puts("################################################")
        # IO.inspect(auth)
        # IO.puts("################################################")
       user_params = %{email: auth.info.email, token: auth.credentials.token, provider: "github"}

       changeset = User.changeset{%User{}, user_params}
        
    end
end