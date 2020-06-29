defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth
    
    def callback(conn, parms) do
        IO.puts("###########################################################################")
        IO.inspect(conn.assigns)
        IO.puts("###########################################################################")
        IO.inspect(parms)
        IO.puts("###########################################################################")
    end
end