<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Main_Master_file.Master" AutoEventWireup="true" CodeBehind="Profile_Page.aspx.cs" Inherits="Information_Security_Project.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .profile-card {
            max-width: 400px;
            margin: 40px auto;
            padding: 20px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            text-align: center;
            color: #000;
        }

        .profile-pic {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #0ef;
            margin-bottom: 15px;
        }

        .profile-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 15px 0;
            gap: 10px;
        }

        .profile-label {
            font-weight: bold;
            flex: 1;
            text-align: left;
        }

        .profile-value {
            flex: 2;
            text-align: left;
        }

        .profile-value input {
            width: 100%;
            max-width: 220px;
            padding: 6px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .edit-btn {
            padding: 4px 10px;
            border: none;
            background: #0ef;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            margin-left: 8px;
            flex-shrink: 0;
        }

        .edit-btn:hover {
            background: #09c;
            color: #fff;
        }

        .save-btn {
            margin-top: 20px;
            padding: 10px 20px;
            border: none;
            background: #0ef;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
        }

        .save-btn:hover {
            background: #09c;
            color: #fff;
        }

        .fu-center {
            display: flex;
            justify-content: center;
            margin-top: 10px;
        }
    </style>

    <div class="profile-card">

        <!-- Profile Picture -->
        <asp:Image ID="imgProfilePic" runat="server" CssClass="profile-pic" />

        <!-- File Upload (hidden initially) -->
        <div class="fu-center">
            <asp:FileUpload ID="fuProfilePic" runat="server" Style="display:none;" />
        </div>

        <!-- EDIT → SAVE button flow -->
        <button type="button" id="btnEditPic" class="edit-btn" onclick="enableProfilePic()">Edit Picture</button>

        <asp:Button ID="btnSavePic" runat="server" Text="Save Picture" CssClass="save-btn"
            Style="display:none;" OnClick="btnSavePic_Click" />

        <br /><br />

        <!-- Username -->
        <div class="profile-row">
            <div class="profile-label">Username:</div>
            <div class="profile-value">
                <asp:TextBox ID="txtUsername" runat="server" ReadOnly="true"></asp:TextBox>
            </div>
            <button type="button" class="edit-btn" onclick="enableEdit('<%= txtUsername.ClientID %>')">Edit</button>
        </div>

        <!-- Email -->
        <div class="profile-row">
            <div class="profile-label">Email:</div>
            <div class="profile-value">
                <asp:TextBox ID="txtEmail" runat="server" ReadOnly="true"></asp:TextBox>
            </div>
            <button type="button" class="edit-btn" onclick="enableEdit('<%= txtEmail.ClientID %>')">Edit</button>
        </div>

        <!-- Password -->
        <div class="profile-row">
            <div class="profile-label">Password:</div>
            <div class="profile-value">
                <asp:Label ID="lblPasswordStars" runat="server" Text="********"></asp:Label>
                <asp:TextBox ID="txtOldPassword" runat="server" TextMode="Password" Placeholder="Old Password" Style="display:none; margin-bottom:5px;"></asp:TextBox>
                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" Placeholder="New Password" Style="display:none;"></asp:TextBox>
            </div>
            <button type="button" class="edit-btn" onclick="enablePasswordEdit()">Edit</button>
        </div>

        <!-- Save All Profile Changes (text fields) -->
        <asp:Button ID="btnSave" runat="server" Text="Save Changes" OnClick="btnSave_Click" CssClass="save-btn" />

        <br /><br />
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
    </div>

    <script>

        // Enable editing for username/email
        function enableEdit(fieldId) {
            var field = document.getElementById(fieldId);
            if (field) {
                field.readOnly = false;
                field.style.border = "1px solid #007bff";
                field.focus();
            }
        }

        // Show file upload + switch edit → save
        function enableProfilePic() {
            document.getElementById('<%= fuProfilePic.ClientID %>').style.display = "block";
            document.getElementById('btnEditPic').style.display = "none";
            document.getElementById('<%= btnSavePic.ClientID %>').style.display = "inline-block";
        }

        // Live picture preview
        document.getElementById('<%= fuProfilePic.ClientID %>').addEventListener('change', function () {
            let file = this.files[0];
            if (file) {
                let reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('<%= imgProfilePic.ClientID %>').src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        });

        // Show password fields
        function enablePasswordEdit() {
            document.getElementById('<%= lblPasswordStars.ClientID %>').style.display = "none";
            document.getElementById('<%= txtOldPassword.ClientID %>').style.display = "block";
            document.getElementById('<%= txtNewPassword.ClientID %>').style.display = "block";
        }
    </script>

</asp:Content>
