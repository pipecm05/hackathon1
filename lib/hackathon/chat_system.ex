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
  def init(state) do
    general_room = %{name: "general", topic: "Canal general para anuncios", type: :announcements}
    new_rooms = Map.put(state.rooms, "general", general_room)
    new_messages = Map.put(state.messages, "general", [])

    initial_state = %{state | rooms: new_rooms, messages: new_messages}
    IO.puts("Sala general creada")
    {:ok, initial_state}
  end

  def handle_call({:join_room, room_name, participant_id, participant_name}, _from, state) do
    case Map.get(state.rooms, room_name) do
      nil ->
        {:reply, {:error, "Sala no encontrada"}, state}

      room ->
        current_participants = Map.get(state.room_participants, room_name, %{})
        new_participants = Map.put(current_participants, participant_id, participant_name)
        new_room_participants = Map.put(state.room_participants, room_name, new_participants)

        IO.puts("#{participant_name} se unió a la sala #{room_name}")
        new_state = %{state | room_participants: new_room_participants}
        {:reply, {:ok, room}, new_state}
    end
  end

  def handle_call({:create_room, room_name, topic}, _from, state) do
    room = %{name: room_name, topic: topic, type: :thematic, created_at: :os.system_time(:seconds)}
    new_rooms = Map.put(state.rooms, room_name, room)
    new_messages = Map.put(state.messages, room_name, [])

    new_state = %{state | rooms: new_rooms, messages: new_messages}
    IO.puts("Sala temática creada: #{room_name} - #{topic}")
    {:reply, {:ok, room}, new_state}
  end
end
