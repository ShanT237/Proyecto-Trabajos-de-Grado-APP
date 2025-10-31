defmodule Util do
  @doc """
  Muestra un mensaje utilizando un script externo de Python.

  ## Parámetros
    - mensaje: El mensaje a mostrar.

  ## Ejemplo
      Util.mostrar_mensaje("Hola mundo")
  """
  def mostrar_mensaje(mensaje) do
    IO.puts(mensaje)
  end


  def ingresar(mensaje, :boolean) do
    valor = mensaje
    |> ingresar(:texto)
    |> String.downcase()

    Enum.member?(["si", "Si", "s"], valor)
  end

  def ingresar(mensaje, tipo) when tipo not in [:texto, :entero, :real] do
    raise ArgumentError, "Tipo de dato no soportado. Use :texto, :entero o :real."
  end

  @doc """
  Solicita al usuario que ingrese un texto.

  ## Parámetros
    - mensaje: El mensaje a mostrar como prompt.
    - :texto: Indica que se espera un texto.

  ## Ejemplo
      Util.ingresar("Ingrese su nombre", :texto)
  """
  def ingresar(mensaje, :texto) do
    case System.cmd("java", ["-cp", ".", "Formulario", "input", mensaje]) do
      {output, 0} ->
        String.trim(output)
      {_error, _code} ->
        nil
    end
  end

  @doc """
  Solicita al usuario que ingrese un número entero. Si la entrada no es válida,
  muestra un error y vuelve a solicitar la entrada.

  ## Parámetros
    - mensaje: El mensaje a mostrar como prompt.
    - :entero: Indica que se espera un entero.

  ## Ejemplo
      Util.ingresar("Ingrese su edad", :entero)
  """
  def ingresar(mensaje, :entero) do
    case System.cmd("java", ["-cp", ".", "Formulario", "input", mensaje]) do
      {output, 0} ->
        output
        |> String.trim()
        |> Integer.parse()
        |> case do
          {int, ""} -> int
          _ -> mostrar_error("Error, se espera un número entero."); ingresar(mensaje, :entero)
        end
      {_error, _code} ->
        mostrar_error("Error al ingresar el entero."); ingresar(mensaje, :entero)
    end
  end

  @doc """
  Solicita al usuario que ingrese un número real mostrando el `mensaje` dado.
  Valida la entrada y repite hasta que sea válida.
  """
  def ingresar(mensaje, :real) do
    case System.cmd("java", ["-cp", ".", "Formulario", "input", mensaje]) do
      {output, 0} ->
        output
        |> String.trim()
        |> Float.parse()
        |> case do
          {float, ""} -> float
          _ -> mostrar_error("Error, se espera un número real."); ingresar(mensaje, :real)
        end
      {_error, _code} ->
        mostrar_error("Error al ingresar el número real."); ingresar(mensaje, :real)
    end
  end

  @doc """
  Muestra un mensaje de error en la salida estándar de error.

  ## Parámetros
    - mensaje: El mensaje de error a mostrar.

  ## Ejemplo
      Util.mostrar_error("Ocurrió un error")
  """
  def mostrar_error(mensaje) do
    IO.puts(:standard_error, mensaje)
  end
end
