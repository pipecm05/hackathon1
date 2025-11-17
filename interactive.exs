defmodule HackathonInteractive do
  def start do
    IO.puts("""
    \e[36m
    ╔══════════════════════════════════════════════════════════════╗
    ║                   HACKATHON CODE4FUTURE                     ║
    ║               SISTEMA INTERACTIVO AUTOMÁTICO                ║
    ╚══════════════════════════════════════════════════════════════╝
    \e[0m
    """)

    # Cargar el sistema
    load_system()

    # Mostrar menú principal
    main_menu()
  end

  defp load_system do
    IO.puts("📦 Cargando sistema Hackathon...")

    modules = [
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

    Enum.each(modules, fn module ->
      if File.exists?(module) do
        Code.compile_file(module)
        IO.puts("#{Path.basename(module)}")
      else
        IO.puts(" No encontrado: #{module}")
      end
    end)

    # Iniciar sistema
    Hackathon.start()
  end


  defp main_menu do
    IO.puts("""
    \n\e[32m
    MENÚ PRINCIPAL - ¿QUÉ QUIERES HACER?
    ========================================

    1. GESTIÓN DE PARTICIPANTES
    2. GESTIÓN DE EQUIPOS
    3. GESTIÓN DE PROYECTOS
    4. SISTEMA DE CHAT
    5. SISTEMA DE MENTORÍA
    6. VER REPORTES DEL SISTEMA
    7. MODO AUTOMÁTICO (DEMO)
    8. SALIR

    \e[0m
    """)

    IO.write("Selecciona una opción (1-8): ")

    case IO.read(:line) |> String.trim() do
      "1" -> participantes_menu()
      "2" -> equipos_menu()
      "3" -> proyectos_menu()
      "4" -> chat_menu()
      "5" -> mentoría_menu()
      "6" -> reportes_menu()
      "7" -> modo_automatico()
      "8" -> salir()
      _ ->
        IO.puts("\e[31m Opción inválida. Intenta de nuevo.\e[0m")
        main_menu()
    end
  end

  # 1. MENÚ DE PARTICIPANTES
  defp participantes_menu do
    IO.puts("""
    \n\e[34m
    👥 GESTIÓN DE PARTICIPANTES
    ===========================

    1. Registrar nuevo participante
    2. Ver participantes existentes
    3. Volver al menú principal
    \e[0m
    """)

    IO.write("Selecciona una opción (1-3): ")

    case IO.read(:line) |> String.trim() do
      "1" -> registrar_participante()
      "2" -> ver_participantes()
      "3" -> main_menu()
      _ ->
        IO.puts("\e[31m Opción inválida\e[0m")
        participantes_menu()
    end
  end

  defp registrar_participante do
    IO.puts("\n REGISTRAR NUEVO PARTICIPANTE")
    IO.write("   ID del participante: ")
    id = IO.read(:line) |> String.trim()

    IO.write("   Nombre completo: ")
    nombre = IO.read(:line) |> String.trim()

    IO.write("   Email: ")
    email = IO.read(:line) |> String.trim()

    case Hackathon.TeamManagement.register_participant(id, nombre, email) do
      {:ok, participante} ->
        IO.puts("\e[32m Participante registrado: #{participante.name}\e[0m")
      {:error, razon} ->
        IO.puts("\e[31m Error: #{razon}\e[0m")
    end

    participantes_menu()
  end

  defp ver_participantes do
    IO.puts("\n PARTICIPANTES REGISTRADOS:")
    # En un sistema real aquí obtendrías la lista de participantes
    IO.puts(" Función en desarrollo...")
    participantes_menu()
  end
end

# Iniciar el sistema interactivo
HackathonInteractive.start()
