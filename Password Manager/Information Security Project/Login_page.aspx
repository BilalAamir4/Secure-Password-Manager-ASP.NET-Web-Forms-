<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login_page.aspx.cs" Inherits="Information_Security_Project.Login_page" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Card Component</title>
    <style>

        .container {
          position: relative;
          width: 400px;
          height: 400px;
          display: flex;
          justify-content: center;
          align-items: center;
          border-radius: 50%;
          overflow: hidden;
          margin: 100px auto;
        }

        .container span {
          position: absolute;
          left: 0;
          width: 32px;
          height: 6px;
          background: #2c4766;
          border-radius: 80px;
          transform-origin: 200px;
          transform: rotate(calc(var(--i) * (360deg / 50)));
          animation: blink 3s linear infinite;
          animation-delay: calc(var(--i) * (3s / 50));
        }

        @keyframes blink {
          0% { background: #0ef; }
          25% { background: #2c4766; }
        }

        .login-box {
          position: absolute;
          width: 80%;
          max-width: 300px;
          z-index: 1;
          padding: 20px;
          border-radius: 20px;
          background: transparent; /* label background matches this */
        }

        form {
          width: 100%;
          padding: 0 10px;
        }

        h2 {
          font-size: 1.8em;
          color: #0ef;
          text-align: center;
          margin-bottom: 10px;
        }

        .input-box {
          position: relative;
          margin: 15px 0;
          width: 100%;
        }

        /* Target email/password/text types that ASP.NET may output */
    input[type=email],
    input[type=password],
    input[type=text] {
     width: 70%;              /* reduced from 80% */
     height: 40px;            /* slightly shorter to fit circle */
     background: transparent;
     border: 2px solid #2c4766;
     outline: none;
     border-radius: 40px;
    font-size: 1em;
    color: #0ef;
    padding: 0 15px;
     transition: 0.25s ease;
     position: relative;
     z-index: 2;
  
    /* Center horizontally */
     display: block;
     margin: 0 auto;
    }

        /* hide browser placeholder visually (we use label instead) */
        input::placeholder {
          color: transparent;
        }

        input:focus {
          border-color: #0ef;
        }

        /* Floating label base */
        .input-box label {
          position: absolute;
          top: 50%;
          left: 15px;
          transform: translateY(-50%);
          font-size: 1em;
          pointer-events: none;
          transition: 0.25s ease;
          color: #fff;
          z-index: 3; /* above input borders */
        }

        /* When focused or filled — move label up, small, black background and ferozi color */
        input:focus ~ label,
        input:not(:placeholder-shown) ~ label,
        /* fallback for older markup-based detection */
        input[value]:not([value=""]) ~ label {
          top: -10px;
          font-size: 0.8em;
          background: #1f293a; /* same as .login-box */
          padding: 0 6px;
          color: #0ef;
        }

        .forgot-pass {
          margin: -10px 0 10px;
          text-align: center;
        }

        .forgot-pass a {
          font-size: 0.85em;
          color: #fff;
          text-decoration: none;
        }

        .btn {
         width: 70%;          /* reduced to match textbox size */
         height: 40px;        /* slightly shorter to fit circle */
         background: #0ef;
         border: none;
         outline: none;
         border-radius: 40px;
        cursor: pointer;
        font-size: 1em;
        color: #1f293a;
        font-weight: 600;
         margin: 10px auto;   /* centers the button */
         display: block;      /* required for margin auto to work */
        }


        .signup-link {
          margin: 10px 0;
          text-align: center;
        }

        .signup-link a {
          font-size: 1em;
          color: #0ef;
          text-decoration: none;
          font-weight: 600;
        }

        /* small responsive tweak */
        @media (max-width:420px){
          .container{ width:320px; height:320px; margin:40px auto; }
          input[type=email], input[type=password], input[type=text]{ width:100%; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="login-box">
                <h2>Login</h2>

                <div class="input-box">
                    <!-- ClientIDMode="Static" ensures the label's for matches the rendered input id. -->
                    <asp:TextBox ID="txtEmail" runat="server"
                                 ClientIDMode="Static"
                                 CssClass="input"
                                 TextMode="Email"
                                 placeholder="Email/Username " autocomplete="off" />
                    <label for="txtEmail">Email</label>
                </div>

                <div class="input-box">
                    <asp:TextBox ID="txtPassword" runat="server"
                                 ClientIDMode="Static"
                                 CssClass="input"
                                 TextMode="Password"
                                 placeholder="Password " autocomplete="off" />
                    <label for="txtPassword">Password</label>
                </div>

                <div class="forgot-pass">
                    <a href="#">Forgot your password?</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" CssClass="btn" Text="Login" OnClick="btnLogin_Click" />

                <div class="signup-link">
                    <a href="Signup.aspx">Sign Up</a>
                </div>
            </div>

            <%-- Circular spans (keeps your original animation) --%>
            <%
                for (int i = 0; i < 50; i++) {
                    Response.Write($"<span style=\"--i:{i};\"></span>");
                }
            %>
        </div>
    </form>
</body>
</html>

