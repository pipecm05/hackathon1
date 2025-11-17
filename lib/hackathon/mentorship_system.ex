defmodule Hackathon.MentorshipSystem do
  use GenServer

  defstruct mentors: %{}, team_mentors: %{}, feedback_history: %{}, inquiries: %{}

  def start_link(_opts) do
    IO.puts("Iniciando sistema de mentoría...")
    case GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__) do
      {:ok, pid} ->
        IO.puts("Sistema de mentoría iniciado")
        {:ok, pid}
      error -> error
    end
  end

  def register_mentor(mentor_id, name, expertise) do
    GenServer.call(__MODULE__, {:register_mentor, mentor_id, name, expertise})
  end

  def assign_mentor_to_team(team_id, mentor_id) do
    GenServer.call(__MODULE__, {:assign_mentor_to_team, team_id, mentor_id})
  end

  def send_inquiry(team_id, question) do
    GenServer.cast(__MODULE__, {:send_inquiry, team_id, question})
  end

  def send_feedback(mentor_id, team_id, feedback) do
    GenServer.call(__MODULE__, {:send_feedback, mentor_id, team_id, feedback})
  end

  def get_team_feedback(team_id) do
    GenServer.call(__MODULE__, {:get_team_feedback, team_id})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:register_mentor, mentor_id, name, expertise}, _from, state) do
    mentor = %{
      id: mentor_id,
      name: name,
      expertise: expertise,
      registered_at: :os.system_time(:seconds),
      status: :active
    }

    new_mentors = Map.put(state.mentors, mentor_id, mentor)
    new_state = %{state | mentors: new_mentors}
    IO.puts("Mentor registrado: #{name} - #{inspect(expertise)}")
    {:reply, {:ok, mentor}, new_state}
  end
end
