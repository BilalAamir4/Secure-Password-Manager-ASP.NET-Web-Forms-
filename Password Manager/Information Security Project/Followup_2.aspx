<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Followup_2.aspx.cs" Inherits="Information_Security_Project.Followup_2" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Profile Setup - Step 2</title>
    <style>
        /* 🔹 Reuse same CSS from Signup page 🔹 */
        .container { position: relative; width: 500px; height: 500px; display: flex; justify-content: center; align-items: center; border-radius: 50%; overflow: hidden; margin: 100px auto; }
        .container span { position: absolute; left: 0; width: 32px; height: 6px; background: #2c4766; border-radius: 80px; transform-origin: 250px; transform: rotate(calc(var(--i) * (360deg / 50))); animation: blink 3s linear infinite; animation-delay: calc(var(--i) * (3s / 50)); }
        @keyframes blink { 0% { background: #0ef; } 25% { background: #2c4766; } }
        .signup-box { position: absolute; width: 80%; max-width: 300px; z-index: 1; padding: 20px; border-radius: 20px; background: transparent; }
        form { width: 100%; padding: 0 10px; }
        h2 { font-size: 1.8em; color: #0ef; text-align: center; margin-bottom: 10px; }
        .input-box { position: relative; margin: 15px 0; width: 100%; }
        select, input[type=date] {
            width: 70%; height: 40px; background: transparent; border: 2px solid #2c4766; outline: none;
            border-radius: 40px; font-size: 1em; color: #0ef; padding: 0 15px; transition: 0.25s ease;
            display: block; margin: 0 auto;
        }
        .btn { width: 70%; height: 40px; background: #0ef; border: none; border-radius: 40px; cursor: pointer; font-size: 1em; color: #1f293a; font-weight: 600; margin: 10px auto; display: block; }
        .message-label { margin-top: 10px; font-size: 14px; display: block; text-align: center; }
        @media (max-width:420px) {
            .container { width:320px; height:320px; margin:40px auto; }
            select, input[type=date] { width:100%; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="signup-box">
                <h2>Profile Setup - Step 2</h2>

                <div class="input-box">
                    <asp:DropDownList ID="ddlGender" runat="server" CssClass="input">
                        <asp:ListItem Text="Select Gender" Value="NotSpecified" />
                        <asp:ListItem Text="Male" Value="Male" />
                        <asp:ListItem Text="Female" Value="Female" />
                    </asp:DropDownList>
                </div>

                <div class="input-box">
                    <asp:TextBox ID="txtBirthday" runat="server" CssClass="input" TextMode="Date" />
                    <label for="txtBirthday">Birthday</label>
                </div>

                <asp:Button ID="btnFinish" runat="server" CssClass="btn" Text="Finish" OnClick="btnFinish_Click" />
                <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>
            </div>

            <% for (int i = 0; i < 50; i++) { Response.Write($"<span style=\"--i:{i};\"></span>"); } %>
        </div>
    </form>
</body>
</html>
