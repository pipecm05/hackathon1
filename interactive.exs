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

end

# Iniciar el sistema interactivo
HackathonInteractive.start()
