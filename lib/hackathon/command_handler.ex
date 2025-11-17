defmodule Hackathon.CommandHandler do
  use GenServer

  def start_link(_opts) do
    case GenServer.start_link(__MODULE__, %{}, name: __MODULE__) do
      {:ok, pid} ->
        IO.puts("Manejador de comandos iniciado")
        {:ok, pid}
      error -> error
    end
  end

  def process_command(command, user_id) do
    GenServer.call(__MODULE__, {:process_command, command, user_id})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:process_command, command, user_id}, _from, state) do
    response = case parse_command(command) do
      {:teams} ->
        handle_teams_command()

      {:teams, category} when is_binary(category) ->
        handle_teams_by_category_command(category)

      {:project, team_name} ->
        handle_project_command(team_name)

      {:join, team_name} ->
        handle_join_command(team_name, user_id)

      {:chat, room_name} ->
        handle_chat_command(room_name, user_id)

      {:help} ->
        handle_help_command()

      {:unknown, cmd} ->
        "Comando desconocido: #{cmd}. Use /help para ver comandos disponibles."

      _ ->
        "Error procesando comando. Use /help para ayuda."
    end

    {:reply, response, state}
  end


end
