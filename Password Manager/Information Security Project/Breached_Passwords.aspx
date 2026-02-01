<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Breached_Passwords.aspx.cs" MasterPageFile="~/Main_Master_file.Master" Inherits="Information_Security_Project.Breached_Passwords" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Outer cursor glow -->
    <div class="cursor-glow"></div>

    <div class="card-container">
        <div class="vault-card">
            <!-- Inner glow inside card -->
            <div class="card-inner-glow"></div>

            <h2>Check Breached Passwords</h2>

            <!-- Single Password Check -->
            <div class="section">
                <asp:TextBox ID="txtPassword" runat="server" CssClass="vault-textbox" placeholder="Enter password to check"></asp:TextBox>
                <asp:Button ID="btnCheckSingle" runat="server" Text="Check Password" CssClass="vault-button" OnClick="btnCheckSingle_Click" />
            </div>

            <hr />

            <!-- Category / Bulk Check -->
            <div class="section">
                <!-- New Section Title -->
                <h2 class="vault-section-title">Select Categories to Check</h2>

                <asp:Label ID="lblCategory" runat="server" Text="Select Category:" CssClass="vault-label"></asp:Label>
                <asp:DropDownList ID="ddlCategories" runat="server" CssClass="vault-dropdown"></asp:DropDownList>
                <asp:CheckBox ID="chkAllCategories" runat="server" Text="Check All Categories" CssClass="vault-checkbox" AutoPostBack="true" OnCheckedChanged="chkAllCategories_CheckedChanged" />
                <br /><br />
                <asp:Button ID="btnCheckBulk" runat="server" Text="Check Passwords" CssClass="vault-button" OnClick="btnCheckBulk_Click" />
            </div>

            <hr />

            <!-- Results -->
            <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="false" CssClass="vault-gridview">
                <Columns>
                    <asp:BoundField DataField="SiteName" HeaderText="Site" />
                    <asp:BoundField DataField="PasswordMasked" HeaderText="Password" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <style>
        /* Outer cursor glow */
        .cursor-glow {
            position: fixed;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(54,158,255,0.2) 0%, transparent 80%);
            pointer-events: none;
            transform: translate(-50%, -50%);
            z-index: 0;
            transition: all 0.05s linear;
        }

        /* Card Container */
        .card-container {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding-top: 60px;
            position: relative;
        }

        /* Vault Card */
        .vault-card {
            position: relative;
            background-color: rgba(22, 27, 34, 0.85); /* semi-transparent to show inner glow */
            padding: 30px 40px;
            border-radius: 12px;
            width: 550px;
            text-align: center;
            overflow: hidden;
            transition: all 0.3s ease-in-out;
        }

        /* Inner glow inside card */
        .card-inner-glow {
            position: absolute;
            width: 400px;
            height: 400px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(54,158,255,0.25) 0%, transparent 70%);
            pointer-events: none;
            transform: translate(-50%, -50%);
            z-index: 0;
            transition: all 0.05s linear;
        }

        /* Vault Card Title */
        .vault-card h2 {
            margin-bottom: 20px;
            color: #369eff;
            position: relative;
            z-index: 1;
        }

        .vault-textbox {
            width: 100%;
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #369eff;
            background-color: #0d1117;
            color: #e6e6e6;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .vault-button {
            background-color: #369eff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            margin-top: 5px;
            transition: all 0.2s ease-in-out;
        }

        .vault-button:hover {
            background-color: #2673cc;
            box-shadow: 0 0 15px #369effaa;
        }

       /* The dropdown itself */
.vault-dropdown {
    background-color: #0d1117; /* card dark background */
    color: #e6e6e6;            /* light text */
    border: 1px solid #369eff; /* theme accent border */
    border-radius: 6px;
    padding: 10px 12px;
    font-size: 16px;
    font-weight: 500;
    margin: 10px 0;
    width: 100%;
    cursor: pointer;
    transition: all 0.2s ease-in-out;
    appearance: none;           /* remove default arrow */
    -webkit-appearance: none;
    -moz-appearance: none;
    text-align: left;
}

/* Hover / focus on dropdown */
.vault-dropdown:hover,
.vault-dropdown:focus {
    border-color: #2673cc;
    box-shadow: 0 0 8px #369eff44;
    outline: none;
    background-color: #161b22;
}

/* Styling the options (works in most browsers) */
.vault-dropdown option {
    background-color: #161b22;  /* darker background for options */
    color: #e6e6e6;             /* light text */
    padding: 8px 12px;
}

/* Optional: style the selected option differently */
.vault-dropdown option:checked {
    background-color: #369eff22; /* slight blue highlight */
    color: #e6e6e6;
}



        .vault-checkbox {
            color: #e6e6e6;
            font-size: 14px;
            margin-left: 10px;
        }

        .vault-gridview {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .vault-gridview th {
            background-color: #0d1117;
            color: #369eff;
            padding: 8px;
        }

        .vault-gridview td {
            background-color: #161b22;
            color: #e6e6e6;
            padding: 8px;
        }

        .section {
            margin-bottom: 20px;
        }

   .vault-section-title {
    color: #369eff;
    font-size: 24px;           /* same as main title */
    font-weight: 600;
    margin-bottom: 20px;
    text-align: center;
    position: relative;
    z-index: 1;
    
    /* Glow effect */
    text-shadow: 0 0 5px #369eff77, 0 0 10px #369eff44;
}
   /* Highlighted option on hover (cursor over an option) */
.vault-dropdown option:hover {
    background-color: #2673cc33; /* subtle semi-transparent blue glow */
    color: #e6e6e6;              /* keep text light */
}



        hr {
            border: 0.5px solid #369eff33;
            margin: 20px 0;
        }
    </style>

    <script>
        // Outer cursor glow
        const cursorGlow = document.querySelector('.cursor-glow');
        document.addEventListener('mousemove', e => {
            cursorGlow.style.left = e.clientX + 'px';
            cursorGlow.style.top = e.clientY + 'px';
        });

        // Inner glow inside card
        const cardGlow = document.querySelector('.card-inner-glow');
        const card = document.querySelector('.vault-card');
        card.addEventListener('mousemove', e => {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            cardGlow.style.left = x + 'px';
            cardGlow.style.top = y + 'px';
        });
    </script>

</asp:Content>