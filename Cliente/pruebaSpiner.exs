defmodule Prueba do
   def main do
    resultado = Util.ingresar("Seleccione un número", 4, :spiner)
    IO.puts("Valor recibido: #{inspect(resultado)}")
  end
end

Prueba.main()
