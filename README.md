# Triv

Triv has two principal components; an interactive control script for the master of ceremony and a server that receives HTTP POST's from buzzer clients and the mentioned control script, as well as host the real-time web interface used to display questions, answers and buzz order.

Triv is mainly written in Elixir, using the Phoenix web framework for the web parts and the LiveView library for making the web UI real-time. The control script is written in bash and uses jq and cURL to get things done.

## How to Run

Once you're set up, you just start the server and the interactive control script.

* Start Phoenix endpoint with `mix phx.server`.
* Start the Triv Command Central with `.../trivng/ctrl.sh localhost:4000`, in order to interact with the admin API.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser to view the current question, candidate answers and players/teams who have hit their buzzers.

## Dependencies

Before you can run the server you need to download and compile a few dependencies:

_It is **strongly** suggested that you use the [asdf version manager](https://asdf-vm.com/) to install erlang, elixir and node. It will pick up which versions you need from the `.tools-versions` file._

* Install `jq` and `curl` with your OS-specific package manager.
* Install Erlang, Elixir and Node.js with `asdf install`.
* Install Elixir dependencies with `mix deps.get`.
* Install Node.js dependencies with `cd assets && npm install`.
