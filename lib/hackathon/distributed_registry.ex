defmodule Hackathon.DistributedRegistry do
  use GenServer

  defstruct nodes: %{}, services: %{}, load_metrics: %{}

  def start_link(_opts) do
    IO.puts("Iniciando registro distribuido...")
    case GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__) do
      {:ok, pid} ->
        IO.puts("Registro distribuido iniciado")
        {:ok, pid}
      error -> error
    end
  end

  def register_node(node_name, capabilities) do
    GenServer.cast(__MODULE__, {:register_node, node_name, capabilities})
  end

  def find_available_node(service) do
    GenServer.call(__MODULE__, {:find_available_node, service})
  end

  def init(state) do
    # Registrar nodo local
    local_capabilities = [:team_management, :project_registry, :chat, :mentorship]
    new_nodes = Map.put(state.nodes, :local, %{
      capabilities: local_capabilities,
      joined_at: :os.system_time(:seconds),
      status: :active,
      load: 0
    })

    IO.puts("Nodo local registrado con capacidades: #{inspect(local_capabilities)}")
    {:ok, %{state | nodes: new_nodes}}
  end
end
