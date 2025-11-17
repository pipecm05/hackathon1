defmodule Hackathon.TeamManagement do
  use GenServer

  defstruct teams: %{}, participants: %{}, team_participants: %{}

  # API Pública
  def start_link(_opts) do
    IO.puts("Iniciando gestión de equipos...")
    case GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__) do
      {:ok, pid} ->
        IO.puts("Gestión de equipos iniciada")
        {:ok, pid}
      error ->
        IO.puts("Error en gestión de equipos: #{inspect(error)}")
        error
    end
  end

  def register_participant(id, name, email) do
    GenServer.call(__MODULE__, {:register_participant, id, name, email})
  end

  def create_team(team_id, team_name, creator_id, category) do
    GenServer.call(__MODULE__, {:create_team, team_id, team_name, creator_id, category})
  end

  def join_team(participant_id, team_id) do
    GenServer.call(__MODULE__, {:join_team, participant_id, team_id})
  end

  def list_teams do
    GenServer.call(__MODULE__, :list_teams)
  end

  def list_teams_by_category(category) do
    GenServer.call(__MODULE__, {:list_teams_by_category, category})
  end

  def get_team(team_id) do
    GenServer.call(__MODULE__, {:get_team, team_id})
  end

  # Callbacks del GenServer
  def init(state) do
    {:ok, state}
  end

  def handle_call({:register_participant, id, name, email}, _from, state) do
    participant = %{id: id, name: name, email: email, joined_at: :os.system_time(:seconds)}
    new_participants = Map.put(state.participants, id, participant)
    new_state = %{state | participants: new_participants}
    IO.puts("Participante registrado: #{name}")
    {:reply, {:ok, participant}, new_state}
  end

  def handle_call({:create_team, team_id, team_name, creator_id, category}, _from, state) do
    case Map.get(state.participants, creator_id) do
      nil ->
        {:reply, {:error, "Participante no encontrado"}, state}

      _creator ->
        team = %{
          id: team_id,
          name: team_name,
          creator_id: creator_id,
          category: category,
          created_at: :os.system_time(:seconds),
          status: :active,
          participants: [creator_id]
        }

        new_teams = Map.put(state.teams, team_id, team)
        new_team_participants = Map.put(state.team_participants, team_id, [creator_id])

        new_state = %{state |
          teams: new_teams,
          team_participants: new_team_participants
        }

        IO.puts("Equipo creado: #{team_name} en categoría #{category}")
        {:reply, {:ok, team}, new_state}
    end
  end
end
