defmodule TrivWeb.PageController do
  use TrivWeb, :controller

  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    # render(conn, "index.html")
    live_render(conn, TrivWeb.Scoreboard,
      session: %{
        current_user_id: get_session(conn, :user_id)
      }
    )
  end

  def not_found(conn, _params), do: redirect(conn, to: "/")
end
