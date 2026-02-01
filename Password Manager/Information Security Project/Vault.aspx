<%@ Page Title="Vault" Language="C#" MasterPageFile="~/Main_Master_file.Master"
    AutoEventWireup="true" CodeBehind="Vault.aspx.cs" Inherits="Information_Security_Project.Vault" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <script>
        // Show/hide password in the add panel
        function togglePassword() {
            const pwdBox = document.getElementById("txtPasswordNew");
            pwdBox.type = pwdBox.type === "password" ? "text" : "password";
        }

        // Show password temporarily in the GridView
        function showPassword(anchor) {
            var container = anchor.parentElement;
            var hiddenField = container.querySelector("input[type=hidden]");
            var maskedSpan = container.querySelector(".masked");

            if (!hiddenField || !maskedSpan) return false;

            maskedSpan.textContent = hiddenField.value;

            setTimeout(function () {
                maskedSpan.textContent = "••••••••";
            }, 5000);

            return false;
        }

        // Generate a random password
        function generatePassword() {
            const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+";
            let pass = "";
            for (let i = 0; i < 12; i++) {
                pass += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            const pwdBox = document.getElementById('<%= txtPasswordNew.ClientID %>');
            pwdBox.value = pass;
            checkStrength(pass);
        }

        // Live password strength checker
        function checkStrength(password) {
            let strengthBar = document.getElementById("passwordStrength");
            let strengthLabel = document.getElementById("strengthLabel");
            let hiddenField = document.getElementById('<%= hfPasswordStrength.ClientID %>');

            let strength = "";
            let score = 0;

            if (!password) {
                strengthBar.innerText = "";
                strengthLabel.innerText = "";
                strengthBar.style.color = "#444";
                hiddenField.value = "";
                return;
            }

            if (password.length >= 8) score++;
            if (/[A-Z]/.test(password)) score++;
            if (/[0-9]/.test(password)) score++;
            if (/[^A-Za-z0-9]/.test(password)) score++;

            if (score <= 1) {
                strength = "Weak";
                strengthBar.style.color = "#e74c3c";
                strengthLabel.style.color = "#e74c3c";
            } else if (score == 2) {
                strength = "Medium";
                strengthBar.style.color = "#f39c12";
                strengthLabel.style.color = "#f39c12";
            } else {
                strength = "Strong";
                strengthBar.style.color = "#27ae60";
                strengthLabel.style.color = "#27ae60";
            }

            strengthBar.innerText = strength;
            strengthLabel.innerText = strength;
            hiddenField.value = strength;
        }

        // Neon cursor glow effect
        document.addEventListener("mousemove", (e) => {
            const glow = document.querySelector(".cursor-glow");
            if (!glow) return;
            glow.style.left = `${e.clientX}px`;
            glow.style.top = `${e.clientY}px`;
        });
    </script>

    <style>
        :root {
            --bg-dark: #0d1117;
            --card-bg: #161b22;
            --accent: #369eff;
            --text-light: #e6e6e6;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: var(--bg-dark);
            color: var(--text-light);
            margin: 0;
            padding: 0;
            position: relative;
            overflow-x: hidden;
        }

        .cursor-glow {
            position: fixed;
            width: 250px;
            height: 250px;
            background: radial-gradient(circle, rgba(54,158,255,0.25) 0%, transparent 80%);
            border-radius: 50%;
            pointer-events: none;
            transform: translate(-50%, -50%);
            transition: all 0.1s ease;
            z-index: 1;
        }

        .container {
            width: 85%;
            max-width: 1100px;
            margin: 2rem auto;
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 16px;
            box-shadow: 0 0 25px rgba(54,158,255,0.15);
            position: relative;
            z-index: 2;
            transition: all 0.3s ease;
        }

        .container:hover {
            box-shadow: 0 0 35px rgba(54,158,255,0.3);
            transform: scale(1.01);
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .top-bar h2 {
            color: var(--accent);
            text-shadow: 0 0 8px rgba(54,158,255,0.8);
        }

        .btn {
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
            color: white;
        }

        .btn:hover {
            box-shadow: 0 0 10px var(--accent);
            transform: translateY(-2px);
        }

        .btn-add { background: #27ae60; }
        .btn-edit { background: #2980b9; }
        .btn-delete { background: #c0392b; }
        .btn-filter { background: #369eff; }

        table {
            width: 100%;
            border-collapse: collapse;
            color: var(--text-light);
        }

        th, td {
            padding: 0.9rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        th {
            background: rgba(54,158,255,0.1);
            color: var(--accent);
            text-align: left;
        }

        tr:hover {
            background: rgba(54,158,255,0.05);
            transition: 0.3s ease;
        }

        .masked {
            letter-spacing: 2px;
        }

        .eye-icon {
            margin-left: 8px;
            color: var(--accent);
            cursor: pointer;
            transition: 0.3s;
        }

        .eye-icon:hover {
            text-shadow: 0 0 8px var(--accent);
        }

        /* Add Panel */
        .add-card {
            background: rgba(22,27,34,0.95);
            border: 1px solid rgba(54,158,255,0.2);
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 1.5rem;
            box-shadow: 0 0 20px rgba(54,158,255,0.15);
        }

        .add-card h3 {
            color: var(--accent);
            text-shadow: 0 0 10px rgba(54,158,255,0.5);
            margin-bottom: 1rem;
        }

        .add-card input, .add-card select {
            width: 100%;
            padding: 0.7rem 1rem;
            margin-bottom: 1rem;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.15);
            background: #0d1117;
            color: var(--text-light);
            transition: 0.3s ease;
        }

        .add-card input:focus, .add-card select:focus {
            border-color: var(--accent);
            box-shadow: 0 0 10px rgba(54,158,255,0.5);
            outline: none;
        }

        .actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

       /* CheckboxList styling - refined sizes */
/* Container for the CheckBoxList */
.checkbox-list {
    display: flex;
    flex-direction: column; /* vertical stack */
    gap: 6px; /* spacing between rows */
    margin-top: 10px;
}

/* Each checkbox row */
.checkbox-list span {
    display: flex;
    align-items: center; /* align checkbox and text */
    gap: 6px; /* space between checkbox and text */
}

/* Checkbox input itself */
.checkbox-list input[type="checkbox"] {
    width: 16px;
    height: 16px;
    margin: 0; /* remove default spacing */
    cursor: pointer;
    accent-color: #369eff; /* your theme accent */
}

/* Label text */
.checkbox-list label {
    font-size: 0.95rem;
    color: var(--text-light);
    line-height: 1.2;
    cursor: pointer;
}




        /* Expiry Tag */
        .expiry-card {
            display: inline-block;
            padding: 0.3rem 0.7rem;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: bold;
            margin-left: 8px;
        }
        .expiry-safe { background: #27ae60; color: white; }
        .expiry-warning { background: #f39c12; color: white; }
        .expiry-neutral { background: var(--accent); color: white; }

    </style>

   <div class="cursor-glow"></div>

<asp:HiddenField ID="hfPasswordStrength" runat="server" />

<div class="container">
    <div class="top-bar">
        <h2>Saved Passwords</h2>
        <div>
            <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn btn-filter" OnClick="btnFilter_Click" />
            <asp:Button ID="btnAdd" runat="server" Text="+ Add New Password" CssClass="btn btn-add" OnClick="btnAdd_Click" />
        </div>
    </div>

    <!-- Filter Panel for multiple categories -->
    <asp:Panel ID="pnlFilter" runat="server" CssClass="add-card" Visible="false" style="margin-bottom:1rem;">
        <h3>Filter by Categories</h3>
        <asp:CheckBoxList ID="cblCategories" runat="server" RepeatDirection="Vertical" CssClass="checkbox-list" />

        <div class="actions" style="margin-top:10px;">
            <asp:Button ID="btnApplyFilter" runat="server" Text="Apply Filter" CssClass="btn btn-filter" OnClick="btnApplyFilter_Click" />
            <asp:Button ID="btnClearFilter" runat="server" Text="Clear Filter" CssClass="btn btn-delete" OnClick="btnClearFilter_Click" />
        </div>
    </asp:Panel>

    <asp:GridView ID="gvVault" runat="server" AutoGenerateColumns="False"
        CssClass="vault-table"
        DataKeyNames="VaultId"
        OnRowEditing="gvVault_RowEditing"
        OnRowCancelingEdit="gvVault_RowCancelingEdit"
        OnRowUpdating="gvVault_RowUpdating"
        OnRowDeleting="gvVault_RowDeleting"
        GridLines="None"
        CellPadding="8"
        ShowHeader="true">

        <Columns>
            <asp:BoundField DataField="SiteName" HeaderText="Website/App" />
            <asp:BoundField DataField="Username" HeaderText="Username" />

            <asp:TemplateField HeaderText="Password">
                <ItemTemplate>
                    <span class="masked">••••••••</span>
                    <asp:HiddenField ID="hfPassword" runat="server" Value='<%# Eval("PasswordDecrypted") %>' />
                    <a href="#" class="eye-icon" onclick="return showPassword(this);" title="Show Password">
                        <i class="fa fa-eye"></i>
                    </a>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtPassword" runat="server" Text='<%# Bind("PasswordDecrypted") %>' />
                </EditItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Actions & Expiry">
                <ItemTemplate>
                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn btn-edit" Text="Edit"></asp:LinkButton>
                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"
                        CssClass="btn btn-delete" Text="Delete"
                        OnClientClick="return confirm('Are you sure you want to delete this record?');"></asp:LinkButton>

                    <span class="expiry-card <%# GetExpiryClass(Eval("LastRotated")) %>">
                        <%# GetExpiryText(Eval("LastRotated")) %>
                    </span>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" CssClass="btn btn-add" Text="Update"></asp:LinkButton>
                    <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CssClass="btn btn-delete" Text="Cancel"></asp:LinkButton>
                </EditItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <asp:Panel ID="pnlAdd" runat="server" Visible="false" CssClass="add-card">
        <h3>Add New Password</h3>

        <asp:TextBox ID="txtSiteName" runat="server" Placeholder="Site / App Name"></asp:TextBox>
        <asp:TextBox ID="txtUsername" runat="server" autocomplete="off" Placeholder="Email / Username"></asp:TextBox>

        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="dropdown" AppendDataBoundItems="true">
            <asp:ListItem Text="-- Select Category (Optional) --" Value="" />
        </asp:DropDownList>

        <div style="display:flex; align-items:center; gap:10px; margin-top:10px;">
            <asp:TextBox ID="txtPasswordNew" runat="server"
                ClientIDMode="Static"
                autocomplete="new-password"
                Placeholder="Password"
                onkeyup="checkStrength(this.value)"></asp:TextBox>

            <asp:Button ID="btnGenerate" runat="server" Text="Generate"
                CssClass="btn btn-filter" OnClick="btnGenerate_Click" />

            <button type="button" class="btn btn-filter" onclick="togglePassword()" title="Show/Hide Password">
                👁
            </button>
        </div>

        <div style="margin-top:5px;">
            <span id="strengthLabel" style="font-weight:bold;"></span>
        </div>
        <span id="passwordStrength" style="font-weight:bold; margin-left:5px;"></span>

        <div class="actions" style="margin-top:15px;">
            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-add" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-delete"
                OnClick="btnCancel_Click" CausesValidation="false" />
        </div>
    </asp:Panel>
</div>
</asp:Content>
