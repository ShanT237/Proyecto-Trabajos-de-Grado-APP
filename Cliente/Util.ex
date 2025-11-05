defmodule Util do
  @moduledoc """
Módulo con funciones que se reutilizan
- autor: Nelson Gonzalez
- fecha: 26/08/2025
- licencia: GNU GPL v3
"""
  def mostrar_mensaje(mensaje) do
        mensaje
        |>IO.puts()
  end
  def mostrar_mensaje_java(mensaje) do
  System.cmd("java",["-cp", ".", "Ventana", mensaje])
  end

  def ingresar_texto(mensaje) do
    mensaje
    |> IO.gets()
    |> String.trim()
  end

  def ingresar(mensaje, :texto) do
    case System.cmd("java", ["-cp", ".", "Mensaje","input", mensaje]) do
    {output, 0} ->
      IO.puts("Texto ingresado correctamente.")
      IO.puts("Entrada: #{output}")
      String.trim(output) # Retorna la entrada sin espacios extra
    {error, code} ->
      IO.puts("Error al ingresar el texto. Código: #{code}")
      IO.puts("Detalles: #{error}")
      nil
    end
  end

  def ingresar(mensaje, :formulario)do
    case System.cmd("java", ["-cp", ".", "Formulario","input", mensaje]) do
      {output, 0} ->
        IO.puts("Texto ingresado correctamente.")
        IO.puts("Entrada: #{output}")
        String.trim(output) # Retorna la entrada sin espacios extra
      {error, code} ->
        IO.puts("Error al ingresar el texto. Código: #{code}")
        IO.puts("Detalles: #{error}")
        nil
    end
  end

  def ingresar(mensaje, :entero) do
    try do
      mensaje
      |> ingresar(:texto)
      |> String.to_integer()
    rescue
      ArgumentError ->
        "Error, se espera que ingrese un número entero\n"
        |> mostrar_error()

        mensaje
        |> ingresar(:entero)
    end
  end

  def ingresar(mensaje, maximo, :spiner) do
    # Asegurar que todos los argumentos sean cadenas (binaries)
    maximo_str = to_string(maximo)
    mensaje_str = to_string(mensaje)

    case System.cmd("java", ["-cp", ".", "Spiner", "input", maximo_str, mensaje_str]) do
      {output, 0} ->
        salida = String.trim(output)
        if salida != "" do
          String.to_integer(salida)
        else
          nil
        end

      {error, code} ->
        IO.puts("Error al ingresar el texto. Código: #{code}")
        IO.puts("Detalles: #{error}")
        nil
    end
  end



  def mostrar_error(mensaje) do
    IO.puts(:standard_error, mensaje)
  end

  def ingresar(mensaje, :real) do
    try do mensaje
      |> ingresar(:texto)
      |> String.to_float()
    rescue
      ArgumentError ->
        "Error, se espera que ingrese un número real\n"
        |> mostrar_error()

        mensaje
        |> ingresar(:real)
    end
  end

end
