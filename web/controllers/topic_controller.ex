defmodule Discuss.TopicController do
    use Discuss.Web, :controller
    alias Discuss.Topic

    def index(conn, _params) do
        topics = Repo.all(Topic)
        
        render conn, "index.html", topics: topics
    end

    def new(conn, _params) do
        changeset = Topic.changeset(%Topic{}, %{})

        render conn, "new.html", changeset: changeset
    end

    def create(conn, %{"topic" => topic}) do
        changeset = Topic.changeset(%Topic{}, topic)

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
end

# chack if there is more options to put flash than :info