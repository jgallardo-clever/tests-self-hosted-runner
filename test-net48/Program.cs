using System;

namespace TestNet48
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("¡Hola! Proyecto de prueba .NET 4.8");
            Console.WriteLine("======================================");
            
            // Crear instancia de calculadora
            Calculator calc = new Calculator();
            
            // Realizar algunas operaciones
            int suma = calc.Add(5, 3);
            int resta = calc.Subtract(10, 4);
            int multiplicacion = calc.Multiply(7, 6);
            double division = calc.Divide(20, 4);
            
            Console.WriteLine($"Suma: 5 + 3 = {suma}");
            Console.WriteLine($"Resta: 10 - 4 = {resta}");
            Console.WriteLine($"Multiplicación: 7 * 6 = {multiplicacion}");
            Console.WriteLine($"División: 20 / 4 = {division}");
            
            Console.WriteLine("\nPresione cualquier tecla para salir...");
            Console.ReadKey();
        }
    }
}
