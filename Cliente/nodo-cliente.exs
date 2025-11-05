defmodule NodoCliente do
  @nombre_servicio_local :servicio_respuesta
  @nodo_remoto :"nodoservidor@25.1.4.245"
  @servicio_remoto {:servicio_cadenas, @nodo_remoto}

  def main() do
    Util.mostrar_mensaje_java("PROCESO Secundario (Cliente iniciado)")
    Process.register(self(), @nombre_servicio_local)

    case Node.connect(@nodo_remoto) do
      true ->
        Util.mostrar_mensaje_java("Conectado al nodo servidor")
        solicitar_lista_trabajos()
      false ->
        Util.mostrar_error("No se pudo conectar con el nodo servidor ")
    end
  end

  defp solicitar_lista_trabajos() do
    send(@servicio_remoto, {self(), :listar_trabajos})

    receive do
      {:trabajos, lista} ->
        cadena_trabajos =
          Enum.with_index(lista, 1)
          |> Enum.map(fn {trabajo, i} ->
            "#{i}. #{trabajo.titulo} (#{trabajo.fecha})"
          end)
          |> Enum.join("\n")
        indice = Util.ingresar("\nLISTA DE TRABAJOS DE GRADO: \n #{cadena_trabajos}\nSeleccione un trabajo por número: ", length(lista), :spiner)

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
        cadena_autores =
        Enum.map(lista_autores, fn a ->
          "- #{a.nombre} #{a.apellidos} | #{a.programa} | #{a.titulo}"
        end)
        |> Enum.join("\n")
        Util.mostrar_mensaje_java("\nAUTORES DEL TRABAJO '#{titulo}': \n#{cadena_autores}")

      {:error, msg} ->
        Util.mostrar_error(msg)
    end
  end
end

NodoCliente.main()
