<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="Information_Security_Project.Signup" %>

    <!DOCTYPE html>
    <html lang="en" xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Signup</title>
    <style>
        .container {
     position: relative;
    width: 500px;   /* increased width */
     height: 500px;  /* increased height */
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
     transform-origin: 250px;
     transform: rotate(calc(var(--i) * (360deg / 50)));
     animation: blink 3s linear infinite;
     animation-delay: calc(var(--i) * (3s / 50));
    }


        @keyframes blink {
          0% { background: #0ef; }
          25% { background: #2c4766; }
        }

        .signup-box {
          position: absolute;
          width: 80%;
          max-width: 300px;
          z-index: 1;
          padding: 20px;
          border-radius: 20px;
          background: transparent;
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

     
        input[type=text],
        input[type=email],
        input[type=password] {
          width: 70%;
          height: 40px;
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
          display: block;
          margin: 0 auto;
        }

        input::placeholder {
          color: transparent;
        }

        input:focus {
          border-color: #0ef;
        }

        .input-box label {
          position: absolute;
          top: 50%;
          left: calc(15%); /* align with input’s left padding */
          transform: translateY(-50%);
          font-size: 1em;
          pointer-events: none;
          transition: 0.25s ease;
          color: #fff;
          z-index: 3;
        }

        input:focus ~ label,
        input:not(:placeholder-shown) ~ label,
        input[value]:not([value=""]) ~ label {
          top: -10px;
          font-size: 0.8em;
          background: #1f293a;
          padding: 0 6px;
          color: #0ef;
        }

        .btn {
          width: 70%;
          height: 40px;
          background: #0ef;
          border: none;
          outline: none;
          border-radius: 40px;
          cursor: pointer;
          font-size: 1em;
          color: #1f293a;
          font-weight: 600;
          margin: 10px auto;
          display: block;
        }

        .login-link {
          margin: 10px 0;
          text-align: center;
        }

        .login-link a {
          font-size: 1em;
          color: #0ef;
          text-decoration: none;
          font-weight: 600;
        }

        @media (max-width:420px){
          .container{ width:320px; height:320px; margin:40px auto; }
          input[type=email], input[type=password], input[type=text]{ width:100%; }
        }
    </style>
</head><body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="signup-box">
                <h2>Sign Up</h2>

                <div class="input-box">
                    <asp:TextBox ID="txtEmail" runat="server" ClientIDMode="Static"
                                 CssClass="input" TextMode="Email"
                                 placeholder=" " autocomplete="off" />
                    <label for="txtEmail">Email</label>
                </div>
                 
                <div class="input-box">
                    <asp:TextBox ID="txtPassword" runat="server" ClientIDMode="Static"
                                 CssClass="input" TextMode="Password"
                                 placeholder=" " autocomplete="off" />
                    <label for="txtPassword">Password</label>
                </div>

                <div class="input-box">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" ClientIDMode="Static"
                                 CssClass="input" TextMode="Password"
                                 placeholder=" " autocomplete="off" />
                    <label for="txtConfirmPassword">Confirm Password</label>
                </div>

                <asp:Button ID="btnSignup" runat="server" CssClass="btn" Text="Sign Up" OnClick="btnSignup_Click" />

                <!-- Label to show success/error messages -->
                <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>

                <div class="login-link">
                    <a href="Login_page.aspx">Already have an account? Login</a>
                </div>
            </div>

            <%-- Circular animation spans --%>
            <%
                for (int i = 0; i < 50; i++) {
                    Response.Write($"<span style=\"--i:{i};\"></span>");
                }
            %>
        </div>
    </form>
</body>

</html>
