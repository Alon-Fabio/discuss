defmodule Discuss.CommentsChannel do
    use Discuss.Web, :channel
    alias Discuss.{Topic, Comment}

    def join("comments:" <> topic_id ,_params ,socket) do
        topic_it = String.to_integer(topic_id)
        topic = Repo.get(Topic, topic_id)
        {:ok, %{"Name: " <> topic.title =>"No: " <> topic_id }, assign(socket, :topic, topic)}
    end

    def handle_in(name, %{"content" => content}, socket) do
        topic = socket.assigns.topic

        changeset = topic
            |> build_assoc(:comments)
            |> Comment.changeset(%{"content" => content})

        case Repo.insert(changeset) do
            {:ok, socket} ->
                {:reply, :ok, socket}
            {:error, _message} ->
                {:reply, {:error, %{errors: changeset}}, socket}
        end
    end
end