using System;

namespace CalculadoraWeb
{
    public class Calculator
    {
        /// <summary>
        /// Realiza la suma de dos números
        /// </summary>
        /// <param name="a">Primer número</param>
        /// <param name="b">Segundo número</param>
        /// <returns>Resultado de la suma</returns>
        public static double Sumar(double a, double b)
        {
            return a + b;
        }

        /// <summary>
        /// Realiza la resta de dos números
        /// </summary>
        /// <param name="a">Primer número</param>
        /// <param name="b">Segundo número</param>
        /// <returns>Resultado de la resta</returns>
        public static double Restar(double a, double b)
        {
            return a - b;
        }

        /// <summary>
        /// Realiza la multiplicación de dos números
        /// </summary>
        /// <param name="a">Primer número</param>
        /// <param name="b">Segundo número</param>
        /// <returns>Resultado de la multiplicación</returns>
        public static double Multiplicar(double a, double b)
        {
            return a * b;
        }

        /// <summary>
        /// Valida que el texto ingresado sea un número válido
        /// </summary>
        /// <param name="texto">Texto a validar</param>
        /// <param name="numero">Número resultante si la validación es exitosa</param>
        /// <returns>True si es un número válido, False en caso contrario</returns>
        public static bool EsNumeroValido(string texto, out double numero)
        {
            return double.TryParse(texto, out numero);
        }
    }
}
