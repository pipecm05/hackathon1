
IO.puts("=" |> String.duplicate(50))
IO.puts("HACKATHON - SISTEMA COLABORATIVO")
IO.puts("=" |> String.duplicate(50))

# Función para compilar y cargar módulos
defmodule Compiler do
  def compile_and_load_modules do
    IO.puts("\n COMPILANDO MÓDULOS...")

    modules = [
      # Orden correcto de compilación (dependencias primero)
      "lib/hackathon.ex",
      "lib/hackathon/application.ex",
      "lib/hackathon/supervisor.ex",
      "lib/hackathon/auth.ex",
      "lib/hackathon/distributed_registry.ex",
      "lib/hackathon/team_management.ex",
      "lib/hackathon/project_registry.ex",
      "lib/hackathon/chat_system.ex",
      "lib/hackathon/mentorship_system.ex",
      "lib/hackathon/command_handler.ex"
    ]

    Enum.each(modules, fn module_path ->
      if File.exists?(module_path) do
        case Code.compile_file(module_path) do
          [] ->
            IO.puts("✅ #{module_path}")
          compiled when is_list(compiled) ->
            IO.puts("✅ #{module_path}")
          error ->
            IO.puts("ERROR en #{module_path}: #{inspect(error)}")
        end
      else
        IO.puts("ARCHIVO NO ENCONTRADO: #{module_path}")
      end
    end)

    IO.puts("TODOS LOS MÓDULOS COMPILADOS EXITOSAMENTE!")
  end
end

# Función para verificar módulos cargados
defmodule Verifier do
  def verify_modules do
    IO.puts("\n VERIFICANDO MÓDULOS CARGADOS...")

    modules = [
      Hackathon,
      Hackathon.Application,
      Hackathon.Supervisor,
      Hackathon.Auth,
      Hackathon.DistributedRegistry,
      Hackathon.TeamManagement,
      Hackathon.ProjectRegistry,
      Hackathon.ChatSystem,
      Hackathon.MentorshipSystem,
      Hackathon.CommandHandler
    ]

    Enum.each(modules, fn module ->
      case Code.ensure_loaded(module) do
        {:module, _} ->
          IO.puts("✅ #{module}")
        {:error, reason} ->
          IO.puts("❌ #{module}: #{reason}")
      end
    end)
  end
end

# Función para demostración del sistema
defmodule Demo do
  def run_demo do
    IO.puts("\n INICIANDO DEMOSTRACIÓN DEL SISTEMA...")

    # 1. Probar comandos básicos
    IO.puts("\n1.  PROBANDO COMANDOS:")
    IO.puts(Hackathon.execute_command("/help"))

    # 2. Listar equipos
    IO.puts("\n2.  LISTANDO EQUIPOS:")
    IO.puts(Hackathon.execute_command("/teams"))

    # 3. Ver proyecto específico
    IO.puts("\n3.  VIENDO PROYECTO DE AI INNOVATORS:")
    IO.puts(Hackathon.execute_command("/project team_ai"))

    # 4. Probar chat
    IO.puts("\n4.  PROBANDO SISTEMA DE CHAT:")
    {:ok, _} = Hackathon.ChatSystem.create_room("demo", "Sala de demostración")
    {:ok, _} = Hackathon.ChatSystem.join_room("demo", "demo_user", "Usuario Demo")
    :ok = Hackathon.ChatSystem.send_message("demo", "demo_user", "¡Hola desde la demostración!")

    # Obtener historial de mensajes
    {:ok, messages} = Hackathon.ChatSystem.get_message_history("demo", 5)
    IO.puts("   Mensajes en sala 'demo': #{length(messages)}")
  end
end
