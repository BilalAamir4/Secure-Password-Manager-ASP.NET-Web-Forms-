<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Followup_1.aspx.cs" Inherits="Information_Security_Project.Followup_1" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Profile Setup - Step 1</title>
    <style>
        /* 🔹 Bigger animated circle */
        .container {
            position: relative;
            width: 600px;   /* increased */
            height: 600px;  /* increased */
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
            transform-origin: 300px; /* bigger to match 600px circle */
            transform: rotate(calc(var(--i) * (360deg / 60)));
            animation: blink 3s linear infinite;
            animation-delay: calc(var(--i) * (3s / 60));
        }
        @keyframes blink {
            0% { background: #0ef; }
            25% { background: #2c4766; }
        }

        .signup-box {
            position: absolute;
            width: 85%;
            max-width: 400px;
            z-index: 1;
            padding: 20px;
            border-radius: 20px;
            background: transparent;
            text-align: center;
        }

        h2 { font-size: 1.8em; color: #0ef; margin-bottom: 15px; }

        /* Round Profile Picture */
        .profile-pic {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #0ef;
            margin: 0 auto 15px auto;
            display: block;
        }

        .input-box { position: relative; margin: 15px 0; width: 100%; }

        input[type=text], input[type=file] {
            width: 80%;
            height: 40px;
            background: transparent;
            border: 2px solid #2c4766;
            outline: none;
            border-radius: 40px;
            font-size: 1em;
            color: #0ef;
            padding: 0 15px;
            transition: 0.25s ease;
            display: block;
            margin: 0 auto;
        }

        input::placeholder { color: transparent; }
        input:focus { border-color: #0ef; }

        .input-box label {
            position: absolute;
            top: 50%;
            left: 12%;
            transform: translateY(-50%);
            font-size: 1em;
            pointer-events: none;
            transition: 0.25s ease;
            color: #fff;
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
            width: 80%;
            height: 40px;
            background: #0ef;
            border: none;
            border-radius: 40px;
            cursor: pointer;
            font-size: 1em;
            color: #1f293a;
            font-weight: 600;
            margin: 10px auto;
            display: block;
        }

        .message-label { margin-top: 10px; font-size: 14px; display: block; text-align: center; }

        @media (max-width:420px) {
            .container { width:350px; height:350px; margin:40px auto; }
            .profile-pic { width: 90px; height: 90px; }
            input[type=text], input[type=file] { width:100%; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="signup-box">
                <h2>Profile Setup - Step 1</h2>

                <!-- Default Profile Picture -->
                <img src='<%# ResolveUrl("~/Uploads/PFP_Selection.png") %>' 
     alt="Profile Picture" 
     class="profile-pic" 
     runat="server" />


                <div class="input-box">
                    <asp:FileUpload ID="fuProfilePic" runat="server" CssClass="input" />
                    <label for="fuProfilePic">Choose Profile Picture</label>
                </div>

                <div class="input-box">
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="input"
                                 placeholder="Username" autocomplete="off" />
                    <label for="txtUsername">Username</label>
                </div>

                <asp:Button ID="btnNext" runat="server" CssClass="btn" Text="Next" OnClick="btnNext_Click" />
                <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>
            </div>

            <% for (int i = 0; i < 60; i++) { Response.Write($"<span style=\"--i:{i};\"></span>"); } %>
        </div>
    </form>
</body>
</html>
