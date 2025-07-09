using System;

namespace Proyecto2Net48
{
    /// <summary>
    /// Clase calculadora para demostrar funcionalidades básicas
    /// </summary>
    public class Calculator
    {
        /// <summary>
        /// Suma dos números enteros
        /// </summary>
        /// <param name="a">Primer número</param>
        /// <param name="b">Segundo número</param>
        /// <returns>Resultado de la suma</returns>
        public int Add(int a, int b)
        {
            return a + b;
        }

        /// <summary>
        /// Resta dos números enteros
        /// </summary>
        /// <param name="a">Minuendo</param>
        /// <param name="b">Sustraendo</param>
        /// <returns>Resultado de la resta</returns>
        public int Subtract(int a, int b)
        {
            return a - b;
        }

        /// <summary>
        /// Multiplica dos números enteros
        /// </summary>
        /// <param name="a">Primer factor</param>
        /// <param name="b">Segundo factor</param>
        /// <returns>Resultado de la multiplicación</returns>
        public int Multiply(int a, int b)
        {
            return a * b;
        }

        /// <summary>
        /// Divide dos números enteros
        /// </summary>
        /// <param name="a">Dividendo</param>
        /// <param name="b">Divisor</param>
        /// <returns>Resultado de la división</returns>
        /// <exception cref="DivideByZeroException">Se lanza cuando el divisor es cero</exception>
        public double Divide(int a, int b)
        {
            if (b == 0)
            {
                throw new DivideByZeroException("No es posible dividir entre cero");
            }
            return (double)a / b;
        }

        /// <summary>
        /// Calcula el factorial de un número
        /// </summary>
        /// <param name="n">Número del cual calcular el factorial</param>
        /// <returns>Factorial del número</returns>
        /// <exception cref="ArgumentException">Se lanza cuando el número es negativo</exception>
        public long Factorial(int n)
        {
            if (n < 0)
            {
                throw new ArgumentException("El factorial no está definido para números negativos");
            }
            
            if (n <= 1)
            {
                return 1;
            }
            
            long result = 1;
            for (int i = 2; i <= n; i++)
            {
                result *= i;
            }
            return result;
        }

        /// <summary>
        /// Verifica si un número es primo
        /// </summary>
        /// <param name="number">Número a verificar</param>
        /// <returns>True si es primo, False en caso contrario</returns>
        public bool IsPrime(int number)
        {
            if (number <= 1)
                return false;
            
            if (number <= 3)
                return true;
                
            if (number % 2 == 0 || number % 3 == 0)
                return false;
                
            for (int i = 5; i * i <= number; i += 6)
            {
                if (number % i == 0 || number % (i + 2) == 0)
                    return false;
            }
            
            return true;
        }
    }
}
