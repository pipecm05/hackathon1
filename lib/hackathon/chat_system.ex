defmodule Hackathon.ChatSystem do
  use GenServer

  defstruct rooms: %{}, room_participants: %{}, messages: %{}

  def start_link(_opts) do
    IO.puts("Iniciando sistema de chat...")
    case GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__) do
      {:ok, pid} ->
        IO.puts("Sistema de chat iniciado")
        {:ok, pid}
      error -> error
    end
  end

  def join_room(room_name, participant_id, participant_name) do
    GenServer.call(__MODULE__, {:join_room, room_name, participant_id, participant_name})
  end

  def send_message(room_name, participant_id, message) do
    GenServer.cast(__MODULE__, {:send_message, room_name, participant_id, message})
  end

  def get_message_history(room_name, limit \\ 50) do
    GenServer.call(__MODULE__, {:get_message_history, room_name, limit})
  end

  def create_room(room_name, topic) do
    GenServer.call(__MODULE__, {:create_room, room_name, topic})
  end

end
