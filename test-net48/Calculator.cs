using System;

namespace TestNet48
{
    public class Calculator
    {
        public int Add(int a, int b)
        {
            return a + b;
        }
        
        public int Subtract(int a, int b)
        {
            return a - b;
        }
        
        public int Multiply(int a, int b)
        {
            return a * b;
        }
        
        public double Divide(double a, double b)
        {
            if (b == 0)
            {
                throw new ArgumentException("No se puede dividir entre cero");
            }
            return a / b;
        }
        
        public bool IsPrime(int number)
        {
            if (number < 2) return false;
            for (int i = 2; i <= Math.Sqrt(number); i++)
            {
                if (number % i == 0) return false;
            }
            return true;
        }
    }
}
