defmodule Hackathon.Auth do
  use GenServer

  defstruct users: %{}, sessions: %{}

  def start_link(_opts) do
    case GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__) do
      {:ok, pid} ->
        IO.puts("Sistema de autenticación iniciado")
        {:ok, pid}
      error -> error
    end
  end

  def authenticate(user_id, token) do
    GenServer.call(__MODULE__, {:authenticate, user_id, token})
  end

  def logout(user_id) do
    GenServer.cast(__MODULE__, {:logout, user_id})
  end

  def init(state) do
    {:ok, state}
  end

  
end
