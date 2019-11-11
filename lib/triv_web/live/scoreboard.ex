defmodule TrivWeb.Scoreboard do
  use Phoenix.LiveView

  require Logger

  def render(assigns), do: Phoenix.View.render(TrivWeb.PageView, "index.html", assigns)

  # def mount(%{current_user_id: user_id}, socket) do
  def mount(%{current_user_id: user_id}, socket) do
    connected = connected?(socket)

    Logger.debug(
      "mounted (connected: #{connected}) PID \"#{inspect(self())}\" with user ID \"#{user_id}\""
    )

    {:ok, game} = Triv.GameServer.join()
    Logger.debug("Seeding assigns with: #{inspect(game)}")
    socket = seed_socket(game, socket)

    {:ok, socket}
  end

  def handle_info({:broadcast, triv_event}, socket) do
    updated_socket =
      case triv_event do
        {:question, q} -> handle_question(q, socket)
        :clear -> assign(socket, %{:buzz => nil, :duds => nil})
        {k, v} when k in ~w(buzz duds gating revealing)a -> assign(socket, k, v)
        ignored -> inspect_debug(ignored, socket)
      end

    {:noreply, updated_socket}
  end

  def handle_info(unexpected, socket) do
    Logger.debug("live view got unexpected: #{inspect(unexpected)}")
    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug("live view terminated: #{inspect(reason)}")

    :ok
  end

  #
  # Internals
  #

  defp seed_socket(game, socket) do
    Logger.debug("live view seeding assignments: \n#{inspect(game, pretty: true)}")
    question = game[:question]
    {correct_answer, candidate_answers} = extract_question(question)

    assign(socket,
      current_question: question["question"] || "",
      current_answer: correct_answer,
      candidate_answers: candidate_answers,
      buzz: game[:buzz],
      duds: game[:duds] || [],
      revealing: game[:revealing] || false,
      gating: game[:gating] || false
    )
  end

  defp handle_question(q, socket) do
    {correct_answer, candidate_answers} = extract_question(q)

    assign(socket, %{
      :current_question => q["question"],
      :current_answer => correct_answer,
      :candidate_answers => candidate_answers,
      :revealing => false
    })
  end

  defp extract_question(q) do
    correct_answer = q["correct_answer"] || ""
    incorrect_answers = q["incorrect_answers"] || []
    answers = [correct_answer | incorrect_answers]

    candidate_answers =
      case q["type"] do
        "boolean" -> answers |> Enum.shuffle()
        _ -> answers |> Enum.sort()
      end

    {correct_answer, candidate_answers}
  end

  defp inspect_debug(ignored, socket) do
    Logger.debug("broadcast ignored: #{inspect(ignored)}")
    socket
  end
end
