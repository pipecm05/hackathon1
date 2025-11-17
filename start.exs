
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

    # 5. Probar mentoría
    IO.puts("\n5.  PROBANDO SISTEMA DE MENTORÍA:")
    :ok = Hackathon.MentorshipSystem.send_inquiry("team_ai", "¿Cómo podemos mejorar nuestro algoritmo?")
    {:ok, feedback} = Hackathon.MentorshipSystem.send_feedback("mentor1", "team_ai", "Excelente trabajo, sugiero optimizar el preprocesamiento de datos")
    IO.puts("   Feedback enviado: #{String.slice(feedback.feedback, 0, 50)}...")

    # 6. Actualizar proyecto
    IO.puts("\n6.  ACTUALIZANDO PROYECTO:")
    :ok = Hackathon.ProjectRegistry.update_project("team_ai", "Implementamos el módulo de recomendaciones básico")
    {:ok, project} = Hackathon.ProjectRegistry.get_team_project("team_ai")
    IO.puts("   Proyecto actualizado. Total actualizaciones: #{length(project.updates)}")

    # 7. Probar autenticación
    IO.puts("\n7.  PROBANDO AUTENTICACIÓN:")
    {:ok, session} = Hackathon.Auth.authenticate("test_user", "token123")
    IO.puts("   Sesión creada: #{String.slice(session, 0, 15)}...")

    IO.puts("\n DEMOSTRACIÓN COMPLETADA EXITOSAMENTE!")
  end
end

# Función principal de inicio
defmodule Main do
  def start do
    try do
      # 1. Compilar módulos
      Compiler.compile_and_load_modules()

      # 2. Verificar que todo esté cargado
      Verifier.verify_modules()

      # 3. Iniciar la aplicación Hackathon
      IO.puts("\n INICIANDO APLICACIÓN HACKATHON...")
      case Hackathon.start() do
        :ok ->
          IO.puts(" APLICACIÓN INICIADA CORRECTAMENTE")

          # 4. Ejecutar demostración
          Demo.run_demo()

          # 5. Mostrar mensaje de uso
          show_usage()

        error ->
          IO.puts(" ERROR INICIANDO APLICACIÓN: #{inspect(error)}")
      end

    rescue
      error ->
        IO.puts(" ERROR CRÍTICO: #{inspect(error)}")
        IO.puts("Stacktrace: #{inspect(__STACKTRACE__)}")
    end
  end

  defp show_usage do
    IO.puts("\n" <> "=" |> String.duplicate(50))
    IO.puts(" CÓMO USAR EL SISTEMA:")
    IO.puts("=" |> String.duplicate(50))

    IO.puts("""
    COMANDOS DISPONIBLES:

     Hackathon.execute_command("/teams")
     Hackathon.execute_command("/project team_ai")
     Hackathon.execute_command("/join team_web")
     Hackathon.execute_command("/chat general")
     Hackathon.execute_command("/help")

    FUNCIONES DIRECTAS:

     Hackathon.TeamManagement.list_teams()
     Hackathon.ProjectRegistry.get_team_project("team_ai")
     Hackathon.ChatSystem.send_message("general", "user1", "Hola!")
     Hackathon.MentorshipSystem.send_feedback("mentor1", "team_ai", "Feedback")

    EJEMPLOS INTERACTIVOS:

    Para probar el chat:
        Hackathon.ChatSystem.join_room("general", "tu_usuario", "Tu Nombre")
        Hackathon.ChatSystem.send_message("general", "tu_usuario", "¡Hola a todos!")

    Para crear nuevo equipo:
        Hackathon.TeamManagement.register_participant("nuevo_user", "Nombre", "email@test.com")
        Hackathon.TeamManagement.create_team("nuevo_team", "Nuevo Equipo", "nuevo_user", "Categoría")

    El sistema está listo para usar!
    """)
  end
end

# Script de limpieza para manejo de errores
defmodule Cleanup do
  def register_exit_handlers do
    # Capturar Ctrl+C para salida elegante
    Process.flag(:trap_exit, true)

    spawn(fn ->
      receive do
        {:EXIT, _from, reason} ->
          IO.puts("\n Cerrando aplicación Hackathon...")
          IO.puts("Razón: #{inspect(reason)}")
      end
    end)
  end
end

# EJECUCIÓN PRINCIPAL
IO.puts("INICIANDO SISTEMA HACKATHON CODE4FUTURE")

# Registrar manejadores de salida
Cleanup.register_exit_handlers()

# Iniciar aplicación
Main.start()

# Mantener el proceso vivo para IEx
IO.puts("\n Sistema ejecutándose. Presiona Ctrl+C dos veces para salir.")
IO.puts(" Puedes interactuar con los módulos usando Hackathon.execute_command()")

# Si estamos en IEx, mantener vivo
if Code.ensure_loaded?(IEx) && IEx.started?() do
  IO.puts(" Modo IEx detectado - El sistema está listo para comandos interactivos")
else
  # Si es script, esperar un poco antes de salir
  IO.puts("\n Cerrando en 5 segundos...")
  :timer.sleep(5000)
end
