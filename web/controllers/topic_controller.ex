defmodule Discuss.TopicController do
    use Discuss.Web, :controller
    alias Discuss.Topic

    plug Discuss.Plugs.RequireAuth when action in [:new, :edit, :update, :delete, :create]
    plug :check_topic_oener when action in [:edit, :update, :delete]

    def index(conn, _params) do
        # IO.puts("########################################################################")
        # IO.inspect(conn)
        # IO.puts("########################################################################")
        topics = Repo.all(Topic)
        
        render conn, "index.html", topics: topics
    end
        
    def show(conn, %{"id" => topic_id}) do
        topic = Repo.get!(Topic, topic_id)
        render conn, "show.html", topic: topic
    end

    def new(conn, _params) do
        changeset = Topic.changeset(%Topic{}, %{})

        render conn, "new.html", changeset: changeset
    end

    def create(conn, %{"topic" => topic}) do
        
        changeset = conn.assigns.user
            |>build_assoc(:topics) # Same as writing out of the pip|>build_assoc(conn.assigns.user, :topics)
            |>Topic.changeset(topic) # Same as writing out of the pip|>build_assoc|>Topic.changset(%Topic{user_id: 1}, topic)

        case Repo.insert(changeset) do
            {:ok, _topic} -> 
                conn
                |>put_flash(:info, "Topic added!")
                |>redirect(to: topic_path(conn, :index))
            {:error, changeset} -> 
                render conn, "new.html", changeset: changeset
        end
    end

    def edit(conn, %{"id" => topic_id}) do
        topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(topic)

        render conn, "edit.html", changeset: changeset, topic: topic
    end
    
    def update(conn, %{"id" => topic_id, "topic" => topic_title}) do
        old_topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(old_topic, topic_title)

        case Repo.update(changeset) do
            {:ok, _topic} ->
                conn
                |>put_flash(:info, "Topic successfully updated!")
                |>redirect(to: topic_path(conn, :index))
            {:error, changeset} ->
                conn
                |>put_flash(:error, "Topic wasn't updated!")
                |>render("edit.html", changeset: changeset, topic: old_topic)
                
        end
    end

    def delete(conn, %{"id" => topic_id}) do
        Repo.get!(Topic, topic_id)
        |>Repo.delete!

        IO.puts("delete triggered")

        conn
        |>put_flash(:info, "Topic was deleted!")
        |>redirect(to: topic_path(conn, :index))
        

    end

    def check_topic_oener(conn, _opt) do
        %{params: %{"id" => topic_id}} = conn
        if (Repo.get(Topic, topic_id) !== nil) && (Repo.get(Topic, topic_id).user_id === conn.assigns.user.id) do
            conn
        else
            conn
            |>put_flash(:warning, "This is not your topic!")
            |>redirect(to: topic_path(conn, :index))
            |>halt()
        end
        # # IO.puts("########################################################################")
        # # IO.inspect(conn)
        # # IO.puts("########################################################################")
        
    end
end