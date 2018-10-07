defmodule Discuss.CommentsChannel do 
  use Discuss.Web, :channel
  alias Discuss.Topic

  def join("comments:" <> topic_id,_params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Repo.get(Topic, topic_id)

    {:ok, %{}, asign(socket, :topic, topic)}
  end

  def handle_in(name, %{content => content}, socket) do
    topic = socket.assigns.topic

    changeset = 
      Topic
      |> build_assoc(:contents)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end

    {:reply, :ok, socket}
  end
end
