defmodule NodoCliente do
  @nombre_servicio_local :servicio_respuesta
  @nodo_remoto :"nodoservidor@schwarz"
  @servicio_remoto {:servicio_cadenas, @nodo_remoto}

  def main() do
    Util.mostrar_mensaje("PROCESO Secundario (Cliente iniciado)")
    Process.register(self(), @nombre_servicio_local)

    case Node.connect(@nodo_remoto) do
      true ->
        Util.mostrar_mensaje("Conectado al nodo servidor")
        solicitar_lista_trabajos()
      false ->
        Util.mostrar_error("No se pudo conectar con el nodo servidor ")
    end
  end

  defp solicitar_lista_trabajos() do
    send(@servicio_remoto, {self(), :listar_trabajos})

    receive do
      {:trabajos, lista} ->
        IO.puts("\nLISTA DE TRABAJOS DE GRADO:")
        Enum.with_index(lista, 1)
        |> Enum.each(fn {trabajo, i} ->
          IO.puts("#{i}. #{trabajo.titulo} (#{trabajo.fecha})")
        end)

        IO.puts("\nSeleccione un trabajo por número: ")
        indice = IO.gets("> ") |> String.trim() |> String.to_integer()

        case Enum.at(lista, indice - 1) do
          nil -> Util.mostrar_error("Número inválido")
          trabajo -> solicitar_autores(trabajo.titulo)
        end
    end
  end

  defp solicitar_autores(titulo) do
    send(@servicio_remoto, {self(), {:autores, titulo}})

    receive do
      {:autores, lista_autores} ->
        IO.puts("\nAUTORES DEL TRABAJO '#{titulo}':")
        Enum.each(lista_autores, fn a ->
          IO.puts("- #{a.nombre} #{a.apellidos} | #{a.programa} | #{a.titulo}")
        end)

      {:error, msg} ->
        Util.mostrar_error(msg)
    end
  end
end

NodoCliente.main()
