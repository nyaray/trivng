# Triv

Triv has two principal components; an interactive control script for the master of ceremony and a server that receives HTTP POSTs from buzzer clients and the mentioned control script, as well as hosts the real-time web interface used to display questions, answers and buzz order.

Triv is mainly written in Elixir, using the Phoenix web framework for the REST and web parts and the LiveView library for making the web UI real-time. The control script is written in bash and uses jq and cURL to get things done.

## Running Triv

Once you're set up, you just need to start the server and the interactive control script to have some fun :).

* Start Triv with `mix phx.server` or `iex -S mix phx.server` to get a shell into the running server.
* Start the Triv Command Central with `.../trivng/ctrl.sh localhost:4000`, in order to interact with the admin API.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser to view the current question, candidate answers and players/teams who have hit their buzzers.

## Installing Dependencies

Before you can run the server you need to download and compile a few dependencies:

_It is **strongly** suggested that you use the [asdf version manager](https://asdf-vm.com/) to install erlang, elixir and node. It will pick up which versions you need from the `.tools-versions` file._

* Install `jq` and `curl` with your OS-specific package manager.
* Install Erlang, Elixir and Node.js with `asdf install`.
* Install Elixir dependencies with `mix deps.get`.
* Install Node.js dependencies with `cd assets && npm install`.

## Features

There is a real-time web-based scoreboard, a REST API and control script, that is run from the computer hosting Triv.

### Real-time View/Scoreboard

The real-time scoreboard is expected to be shown on a big TV that can be seen by all the players and currently shows:

* The current question.
* Answer suggestions.
* An indicator, signalling whether or not team buzzes are accepted.
* The name of the first team to respond.
* If any, the list of teams, in order, that responded after the first responding team.

### Rest API

The Triv REST API exposes endpoints with a couple of accepted requests:

* `/api` accepts `POST` requests, like `{"action": action, ...}` where `action` is:
  * `clear` clear the current first responder and duds (non-first responders, in order).
  * `buzz` register a team buzz, additional fields:
    * `team_token`, the name of the team.
  * `set_question` set a new question on the big screen/scoreboard, additional fields:
    * `question`, an object containing:
      * `question`, the question itself
      * `correct_answer`, the correct answer
      * `incorrect_answer`, an array of incorrect answers (typically 1 or 3 for boolean and multiple choice questions, respectively).
  * `reveal` reveal the correct answer of the currently set question
* `/api/echo` accepts any verb and replies with `200 OK` and echoes back what you sent to it.
  * _NOTE: empty bodies are replied to with `204 No Content`._

### Control Script

The shell script `ctrl.sh` runs a control loop to allow you to select commands to send to the server for playing and testing purposes.

* `e` - Exit
* `c` - Clear
* `n` - New question, fetches a question from `opentdb.com` and forwards it to Triv.
* `r` - Reveal answer.
* `1` - Buzz test team foo.
* `2` - Buzz test team bar.
* `3` - Buzz test team baz.

## Backlog

* [ ] A structured way of providing questions from a file
* [ ] (maybe?!?) Porting `ctrl.sh` to an interactive function to be run from the shell
* [ ] ...
