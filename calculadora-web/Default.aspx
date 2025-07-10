<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CalculadoraWeb.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Calculadora Web - CleverIT</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <div class="container">
        <h1>🧮 Calculadora Web</h1>
        
        <form id="form1" runat="server">
            <div class="calculator">
                <div class="input-group">
                    <label for="txtNumero1">Primer Número:</label>
                    <asp:TextBox ID="txtNumero1" runat="server" CssClass="input-field" 
                                 placeholder="Ingrese el primer número" />
                </div>
                
                <div class="input-group">
                    <label for="txtNumero2">Segundo Número:</label>
                    <asp:TextBox ID="txtNumero2" runat="server" CssClass="input-field" 
                                 placeholder="Ingrese el segundo número" />
                </div>
                
                <div class="button-group">
                    <asp:Button ID="btnSumar" runat="server" Text="+ Sumar" 
                                CssClass="calc-button btn-suma" OnClick="btnSumar_Click" />
                    
                    <asp:Button ID="btnRestar" runat="server" Text="- Restar" 
                                CssClass="calc-button btn-resta" OnClick="btnRestar_Click" />
                    
                    <asp:Button ID="btnMultiplicar" runat="server" Text="× Multiplicar" 
                                CssClass="calc-button btn-multiplicacion" OnClick="btnMultiplicar_Click" />
                </div>
                
                <asp:Button ID="btnLimpiar" runat="server" Text="🗑️ Limpiar" 
                            CssClass="clear-button" OnClick="btnLimpiar_Click" />
                
                <asp:Panel ID="pnlResultado" runat="server" CssClass="result-container" Visible="false">
                    <div class="result-label">Resultado:</div>
                    <div class="result-value">
                        <asp:Label ID="lblResultado" runat="server" />
                    </div>
                </asp:Panel>
                
                <asp:Panel ID="pnlError" runat="server" CssClass="error-message" Visible="false">
                    <asp:Label ID="lblError" runat="server" />
                </asp:Panel>
            </div>
        </form>
        
        <div class="footer">
            <p>© 2025 CleverIT - Calculadora Web v1.0</p>
            <p>Desarrollado con ASP.NET Framework 4.8</p>
        </div>
    </div>
</body>
</html>
