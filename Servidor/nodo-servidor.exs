defmodule NodoServidor do
  @nombre_servicio_local :servicio_cadenas

  @autores [
    %{
      cedula: "1002456789",
      nombre: "Laura",
      apellidos: "Rojas Gómez",
      programa: "Ingeniería de Sistemas",
      titulo: "Ingeniera de Sistemas"
    },
    %{
      cedula: "1003567890",
      nombre: "Andrés",
      apellidos: "Morales Pérez",
      programa: "Ingeniería de Sistemas",
      titulo: "Ingeniero de Sistemas"
    },
    %{
      cedula: "1004678901",
      nombre: "Camila",
      apellidos: "Torres López",
      programa: "Ingeniería Electrónica",
      titulo: "Ingeniera Electrónica"
    },
    %{
      cedula: "1005789012",
      nombre: "Juan",
      apellidos: "Herrera Ramírez",
      programa: "Ingeniería de Software",
      titulo: "Ingeniero de Software"
    },
    %{
      cedula: "1006890123",
      nombre: "Valentina",
      apellidos: "Castaño Gil",
      programa: "Ingeniería de Sistemas",
      titulo: "Ingeniera de Sistemas"
    },
    %{
      cedula: "1007901234",
      nombre: "Carlos",
      apellidos: "Nieto Salazar",
      programa: "Ingeniería Electrónica",
      titulo: "Ingeniero Electrónico"
    },
    %{
      cedula: "1008123456",
      nombre: "Nelson",
      apellidos: "Gonzalez Londoño",
      programa: "Ingeniería de Software",
      titulo: "Ingeniero de Software"
    },
    %{
      cedula: "1009345678",
      nombre: "Felipe",
      apellidos: "Orozco Téllez",
      programa: "Ingeniería de Sistemas",
      titulo: "Ingeniero de Sistemas"
    },
    %{
      cedula: "1010456789",
      nombre: "Daiana",
      apellidos: "Flores Ruiz",
      programa: "Ingeniería de Sistemas",
      titulo: "Ingeniera de Sistemas"
    },
    %{
      cedula: "1011567890",
      nombre: "Santiago",
      apellidos: "Ramos Silva",
      programa: "Ingeniería Electrónica",
      titulo: "Ingeniero Electrónico"
    }
  ]
  @trabajos [
    %{
      fecha: "2024-11-25",
      titulo: "Desarrollo de un sistema distribuido para la gestión de taxis urbanos en Elixir",
      descripcion: "Implementa un sistema multijugador concurrente para la gestión de una flota de taxis en Elixir, aplicando procesos, GenServers y supervisores dinámicos.",
      autores: ["1002456789", "1003567890"]
    },
    %{
      fecha: "2024-12-01",
      titulo: "Sistema de monitoreo energético basado en IoT para campus universitarios",
      descripcion: "Diseña una red de sensores IoT para monitorear el consumo energético en tiempo real, optimizando recursos mediante un servidor central.",
      autores: ["1004678901", "1007901234"]
    },
    %{
      fecha: "2025-01-15",
      titulo: "Aplicación móvil para la gestión de billeteras virtuales seguras",
      descripcion: "Permite realizar transacciones seguras y registrar historiales de usuario, con categorías personalizadas y validación de operaciones.",
      autores: ["1005789012", "1006890123"]
    },
    %{
      fecha: "2025-02-05",
      titulo: "Plataforma educativa gamificada para el aprendizaje de programación funcional",
      descripcion: "Combina desafíos y recompensas para enseñar Elixir y Haskell usando procesos concurrentes y visualización de actores.",
      autores: ["1011567890", "1010456789"]
    },
    %{
      fecha: "2025-02-25",
      titulo: "Análisis predictivo de tráfico urbano mediante aprendizaje automático",
      descripcion: "Aplica modelos de regresión y redes neuronales para predecir la congestión vehicular en tiempo real.",
      autores: ["1009345678", "1003567890", "1004678901"]
    },
    %{
      fecha: "2025-03-10",
      titulo: "Sistema de gestión de reservas hoteleras con JavaFX y arquitectura MVC",
      descripcion: "Permite registrar habitaciones, clientes y reservas aplicando principios de arquitectura limpia en JavaFX.",
      autores: ["1005789012", "1008123456"]
    },
    %{
      fecha: "2025-04-12",
      titulo: "Simulador de ciberataques para entrenamiento en seguridad informática",
      descripcion: "Implementa un entorno controlado para practicar defensa ante ataques comunes, orientado a la formación de analistas de ciberseguridad.",
      autores: ["1006890123", "1009345678"]
    },
    %{
      fecha: "2025-05-01",
      titulo: "Red neuronal para detección temprana de fallas en sistemas eléctricos industriales",
      descripcion: "Utiliza modelos de deep learning para detectar anomalías en señales eléctricas y anticipar fallas industriales.",
      autores: ["1004678901", "1007901234"]
    },
    %{
      fecha: "2025-06-22",
      titulo: "Chatbot inteligente para atención al cliente usando procesamiento de lenguaje natural",
      descripcion: "Desarrolla un chatbot entrenado con datos de soporte técnico, capaz de atender múltiples usuarios en paralelo usando concurrencia.",
      autores: ["1002456789", "1008123456", "1005789012"]
    },
    %{
      fecha: "2025-07-10",
      titulo: "Sistema de detección de intrusiones en redes mediante aprendizaje automático",
      descripcion: "Desarrolla un IDS basado en aprendizaje supervisado para detectar patrones anómalos en tráfico de red.",
      autores: ["1009345678","1003567890"]
    }
  ]


  def main() do
    Util.mostrar_mensaje("PROCESO Principal (Servidor iniciado)")
    Process.register(self(), @nombre_servicio_local)
    loop()
  end

  defp loop() do
    receive do
      {pid_cliente, :listar_trabajos} ->
        send(pid_cliente, {:trabajos, @trabajos})
        loop()

      {pid_cliente, {:autores, titulo}} ->
        trabajo = Enum.find(@trabajos, &(&1.titulo == titulo))
        if trabajo do
          autores = Enum.filter(@autores, &(&1.cedula in trabajo.autores))
          send(pid_cliente, {:autores, autores})
        else
          send(pid_cliente, {:error, "Trabajo no encontrado"})
        end
        loop()

      _ ->
        loop()
    end
  end
end

NodoServidor.main()
