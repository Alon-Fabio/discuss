defmodule Discuss.Plugs.SetUser do
    import Plug.Conn
    # assign() comes from Phoenix.Conn
    import Phoenix.Controller
    # get_session() comes from Phoenix.Controller

    alias Discuss.Repo
    alias Discuss.User

    def init(_params) do
    end

    def call(conn, _params) do
        user_id = get_session(conn, :user_id)
        
        cond do
            user = user_id && Repo.get(User, user_id) ->
                assign(conn, :user, user)
            true ->
                assign(conn, :user, nil)

        end
        # ↑ Will return a conn object ↑.
    end
    
end