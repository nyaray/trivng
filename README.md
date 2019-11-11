# Triv

Before you can run the server you need to download and compile a few dependencies:

_It is **strongly** suggested that you use the [asdf version manager](https://asdf-vm.com/) to install erlang, elixir and node. It will pick up which versions you need from the .tools-versions file._

* Install dependencies with `mix deps.get`
* Install Node.js dependencies with `cd assets && npm install`

Once you're set, all you need to do is:

* Start Phoenix endpoint with `mix phx.server`
* Start the Triv Command Central with `.../trivng/ctrl.sh localhost:4000`, in order to interact with the admin API.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser to view the current question, candidate answers and players/teams who have hit their buzzers.
