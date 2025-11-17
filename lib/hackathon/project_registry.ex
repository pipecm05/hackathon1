defmodule Hackathon.ProjectRegistry do
  use GenServer

  defstruct projects: %{}, categories: MapSet.new(), team_projects: %{}

  def start_link(_opts) do
    IO.puts("Iniciando registro de proyectos...")
    case GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__) do
      {:ok, pid} ->
        IO.puts("Registro de proyectos iniciado")
        {:ok, pid}
      error -> error
    end
  end

  def register_project(team_id, project_name, description, category) do
    GenServer.call(__MODULE__, {:register_project, team_id, project_name, description, category})
  end

  def update_project(team_id, update_message) do
    GenServer.cast(__MODULE__, {:update_project, team_id, update_message})
  end

  def get_projects_by_category(category) do
    GenServer.call(__MODULE__, {:get_projects_by_category, category})
  end

  def get_team_project(team_id) do
    GenServer.call(__MODULE__, {:get_team_project, team_id})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:register_project, team_id, project_name, description, category}, _from, state) do
    project = %{
      id: "project_#{team_id}",
      team_id: team_id,
      name: project_name,
      description: description,
      category: category,
      status: :active,
      created_at: :os.system_time(:seconds),
      updates: [],
      feedback: []
    }

    new_projects = Map.put(state.projects, project.id, project)
    new_categories = MapSet.put(state.categories, category)
    new_team_projects = Map.put(state.team_projects, team_id, project.id)

    new_state = %{state |
      projects: new_projects,
      categories: new_categories,
      team_projects: new_team_projects
    }

    IO.puts("Proyecto registrado: #{project_name} por equipo #{team_id}")
    {:reply, {:ok, project}, new_state}
  end
end
