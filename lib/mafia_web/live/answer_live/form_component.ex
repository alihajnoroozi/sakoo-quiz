defmodule MafiaWeb.AnswerLive.FormComponent do
  use MafiaWeb, :live_component

  alias Mafia.Game

  @impl true
  def update(%{answer: answer} = assigns, socket) do
    changeset = Game.change_answer(answer)

    {:ok,
     socket
     |> assign(assigns)
     |> allow_upload(:uploaded_image, accept: ~w(.png .jpg .jpeg), max_entries: 1)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"answer" => answer_params}, socket) do
    changeset =
      socket.assigns.answer
      |> Game.change_answer(answer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"answer" => answer_params}, socket) do
    uploaded_files =
      consume_uploaded_entries(
        socket,
        :uploaded_image,
        fn %{path: path}, _entry ->
          dest = Path.join("priv/static/uploads", Path.basename(path))
          File.cp!(path, dest)
          Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
        end
      )
    if uploaded_files |> List.first()  do
      save_answer(
        socket,
        socket.assigns.action,
        Map.put(
          answer_params,
          "image_path",
          uploaded_files
          |> List.first()
        )
      )
    else
      save_answer(socket, socket.assigns.action, answer_params)
    end
  end

  defp save_answer(socket, :edit, answer_params) do
    case Game.update_answer(socket.assigns.answer, answer_params) do
      {:ok, _answer} ->
        {:noreply,
         socket
         |> put_flash(:info, "گزینه با موفقیت ویرایش شد")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_answer(socket, :new, answer_params) do
#    IO.inspect(socket.assigns.question_id)
    answer_params = Map.put(answer_params, "question_id" , socket.assigns.question_id)
    answer_params = Map.put(answer_params, "count" , 0)
    case Game.create_answer(answer_params) do
      {:ok, _answer} ->
        {:noreply,
         socket
         |> put_flash(:info, "گزینه با موفقیت اضافه شد")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
