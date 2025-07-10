using System;
using System.Web.UI;

namespace CalculadoraWeb
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Código que se ejecuta cuando la página se carga
            if (!IsPostBack)
            {
                // Primera carga de la página
                LimpiarFormulario();
            }
        }

        protected void btnSumar_Click(object sender, EventArgs e)
        {
            RealizarOperacion("suma");
        }

        protected void btnRestar_Click(object sender, EventArgs e)
        {
            RealizarOperacion("resta");
        }

        protected void btnMultiplicar_Click(object sender, EventArgs e)
        {
            RealizarOperacion("multiplicacion");
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        private void RealizarOperacion(string tipoOperacion)
        {
            try
            {
                // Ocultar mensajes anteriores
                pnlError.Visible = false;
                pnlResultado.Visible = false;

                // Validar y obtener los números
                double numero1, numero2;
                
                if (!Calculator.EsNumeroValido(txtNumero1.Text.Trim(), out numero1))
                {
                    MostrarError("Por favor, ingrese un número válido en el primer campo.");
                    return;
                }

                if (!Calculator.EsNumeroValido(txtNumero2.Text.Trim(), out numero2))
                {
                    MostrarError("Por favor, ingrese un número válido en el segundo campo.");
                    return;
                }

                // Realizar la operación según el tipo
                double resultado = 0;
                string operacionTexto = "";

                switch (tipoOperacion.ToLower())
                {
                    case "suma":
                        resultado = Calculator.Sumar(numero1, numero2);
                        operacionTexto = $"{numero1} + {numero2} = {resultado}";
                        break;
                    
                    case "resta":
                        resultado = Calculator.Restar(numero1, numero2);
                        operacionTexto = $"{numero1} - {numero2} = {resultado}";
                        break;
                    
                    case "multiplicacion":
                        resultado = Calculator.Multiplicar(numero1, numero2);
                        operacionTexto = $"{numero1} × {numero2} = {resultado}";
                        break;
                    
                    default:
                        MostrarError("Operación no válida.");
                        return;
                }

                // Mostrar el resultado
                MostrarResultado(operacionTexto);
            }
            catch (Exception ex)
            {
                MostrarError($"Error al realizar la operación: {ex.Message}");
            }
        }

        private void MostrarResultado(string resultado)
        {
            lblResultado.Text = resultado;
            pnlResultado.Visible = true;
            pnlError.Visible = false;
        }

        private void MostrarError(string mensaje)
        {
            lblError.Text = mensaje;
            pnlError.Visible = true;
            pnlResultado.Visible = false;
        }

        private void LimpiarFormulario()
        {
            txtNumero1.Text = "";
            txtNumero2.Text = "";
            pnlResultado.Visible = false;
            pnlError.Visible = false;
            
            // Enfocar el primer campo
            txtNumero1.Focus();
        }
    }
}
