defmodule TrivWeb.ApiController do
  use TrivWeb, :controller
  require Logger

  # TODO: /echo endpoint that replies with a 200 and same entity

  def process(conn, params) do
    case get_req_header(conn, "content-type") |> Enum.map(&String.downcase/1) do
      ["application/json"] -> do_process(conn, params)
      c_type_raw -> unsupported_mtype(conn, c_type_raw)
    end
  end

  def echo(conn, _params) do
    case Plug.Conn.read_body(conn) do
      {:ok, "", conn} -> send_resp(conn, 204, "")
      {:ok, body, conn} -> do_echo_body(conn, body)
      {:more, _partial, conn} -> send_resp(conn, 400, "Request too big.")
      {:error, reason} -> send_resp(conn, 500, inspect(reason))
    end
  end

  def bad_method(conn, _params), do: send_resp(conn, 405, "Method Not Allowed. Expected POST.")
  def not_found(conn, _params), do: send_resp(conn, 404, "Not found")

  defp do_process(conn, params = %{"action" => action}) do
    Logger.info("Received action: #{inspect(action)}")

    case action do
      "clear" -> json(conn, Triv.GameServer.clear_buzz())
      "buzz" -> json(conn, do_buzz(conn, params["team_token"]))
      "set_question" -> json(conn, Triv.GameServer.update_question(params["question"]))
      "reveal" -> json(conn, Triv.GameServer.reveal())
      _ -> bad_request(conn)
    end
  end

  defp do_process(conn, params) do
    Logger.warn("Received unexpected params: #{inspect(params)}")
    bad_request(conn)
  end

  defp do_buzz(conn, team_token) do
    peer = get_peer_data(conn)[:address]
    Triv.GameServer.buzz(peer, team_token)
  end

  defp bad_request(conn), do: send_resp(conn, 400, "Meaningless payload received.")

  defp do_echo_body(conn, body) do
    case Poison.decode(body) do
      {:ok, entity} ->
        json(conn, entity)

      {:error, %{:__struct__ => struct}} ->
        resp_body = struct |> to_string() |> String.split(".") |> List.last()
        send_resp(conn, 400, resp_body)
    end
  end

  defp unsupported_mtype(conn, c_type_raw) do
    send_resp(
      conn,
      415,
      "Unsupported Media Type(s): #{c_type_raw |> inspect()}. Expected content type application/json."
    )
  end
end
