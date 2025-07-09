using System;

namespace Proyecto2Net48
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("=== PROYECTO 2 - .NET Framework 4.8 ===");
            Console.WriteLine($"Fecha y hora: {DateTime.Now:yyyy-MM-dd HH:mm:ss}");
            Console.WriteLine($"Versión de .NET Framework: {Environment.Version}");
            Console.WriteLine($"Sistema operativo: {Environment.OSVersion}");
            Console.WriteLine($"Máquina: {Environment.MachineName}");
            Console.WriteLine();

            // Probar la calculadora
            var calc = new Calculator();
            
            Console.WriteLine("=== PRUEBAS DE CALCULADORA ===");
            Console.WriteLine($"5 + 3 = {calc.Add(5, 3)}");
            Console.WriteLine($"10 - 4 = {calc.Subtract(10, 4)}");
            Console.WriteLine($"6 * 7 = {calc.Multiply(6, 7)}");
            Console.WriteLine($"20 / 4 = {calc.Divide(20, 4)}");
            
            try
            {
                Console.WriteLine($"División por cero: {calc.Divide(10, 0)}");
            }
            catch (DivideByZeroException ex)
            {
                Console.WriteLine($"Error capturado: {ex.Message}");
            }
            
            Console.WriteLine();
            Console.WriteLine("=== COMPILACIÓN Y EJECUCIÓN EXITOSA ===");
            Console.WriteLine("El proyecto se ha compilado y ejecutado correctamente en el self-hosted runner");
            
            Console.WriteLine("\nPresiona cualquier tecla para continuar...");
            Console.ReadKey();
        }
    }
}
