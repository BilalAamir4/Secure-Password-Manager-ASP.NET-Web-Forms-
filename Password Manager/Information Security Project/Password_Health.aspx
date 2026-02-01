<%@ Page Title="Password Health" Language="C#" MasterPageFile="~/Main_Master_file.Master" AutoEventWireup="true" CodeBehind="Password_Health.aspx.cs" Inherits="Information_Security_Project.Password_Health" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
/* ==== VAULT THEME - APPLIED TO PASSWORD HEALTH PAGE ==== */

:root {
    --bg-dark: #0d1117;
    --card-bg: #161b22;
    --accent: #369eff;
    --text-light: #e6e6e6;
}

/* Global Page */
body {
    font-family: 'Segoe UI', sans-serif;
    background: var(--bg-dark);
    color: var(--text-light);
    margin: 0;
    padding: 0;
    position: relative;
    overflow-x: hidden;
}

/* Page container alignment */
#MainContent {
    display: flex;               /* changed from block → flex */
    justify-content: center;     /* added horizontal centering */
    align-items: flex-start;     /* keeps top alignment */
    padding: 30px 20px;
    min-height: 100vh;
    box-sizing: border-box;
}

/* Page Heading */
h2 {
    color: var(--accent);
    text-shadow: 0 0 8px rgba(54,158,255,0.8);
    margin-bottom: 1.5rem;
    text-align: center;
    font-size: 1.8rem;
}

/* ==== Vault Table Styling ==== */
.table {
    width: 100%;
    max-width: 1100px;
    border-collapse: collapse;
    background: var(--card-bg);
    border-radius: 14px;
    overflow: hidden;
    box-shadow: 0 0 25px rgba(54,158,255,0.15);
    position: relative;
    z-index: 2;
    transition: all 0.3s ease;
    margin: 0 auto 2rem auto;   /* force table to center */
    font-size: 18px;            /* increased font size */
}

.table:hover {
    box-shadow: 0 0 35px rgba(54,158,255,0.3);
    transform: scale(1.01);
}

/* Table Header */
.table th {
    background: rgba(54,158,255,0.1);
    color: var(--accent);
    text-shadow: 0 0 6px rgba(54,158,255,0.8);
    padding: 16px 20px;         /* slightly bigger for balance */
    font-size: 18px;            /* increased */
    font-weight: 600;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    text-align: left;
    letter-spacing: 0.5px;
}

/* Table Cells */
.table td {
    padding: 16px 20px;         /* increased spacing */
    border-bottom: 1px solid rgba(255,255,255,0.05);
    color: var(--text-light);
    line-height: 1.6;
    vertical-align: middle;
    font-size: 16px;            /* increased font size */
    font-weight: 400;
}

/* Table Row Hover */
.table tr:hover {
    background: rgba(54,158,255,0.05);
    transition: 0.3s ease;
}

/* Table Fonts Match Vault */
.table th, .table td {
    font-family: 'Segoe UI', sans-serif;
}

/* Button Styling (Vault Look) */
.btn {
    padding: 0.6rem 1.2rem;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: bold;
    transition: all 0.3s ease;
    color: white;
    background: var(--accent);
    box-shadow: 0 0 10px rgba(54,158,255,0.4);
    font-family: 'Segoe UI', sans-serif;
}

.btn:hover {
    box-shadow: 0 0 15px var(--accent);
    transform: translateY(-2px);
    background: #2980b9;
}

/* Strength Indicators */
.weak { color: #e74c3c; font-weight: bold; text-shadow: 0 0 5px #e74c3c; }
.medium { color: #f39c12; font-weight: bold; text-shadow: 0 0 5px #f39c12; }
.strong { color: #27ae60; font-weight: bold; text-shadow: 0 0 5px #27ae60; }

/* Optional Neon Cursor (Vault Theme) */
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
.header-bold {
    font-weight: bold !important;   /* strong bold */
    font-size: 17px !important;    /* slightly bigger */
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
</style>


   <div class="cursor-glow" id="cursorGlow"></div>

<script>
    document.addEventListener('mousemove', (e) => {
        const glow = document.getElementById('cursorGlow');
        glow.style.left = e.pageX + 'px';
        glow.style.top = e.pageY + 'px';
    });
</script>

<!-- 🔵 CARD CONTAINER ADDED -->
<div class="container">

    <h2>Password Health</h2>

    <asp:GridView ID="gvPasswordHealth" runat="server" AutoGenerateColumns="False" DataKeyNames="VaultId"
        CssClass="table" OnRowCommand="gvPasswordHealth_RowCommand" GridLines="None">
        <Columns>
            <asp:BoundField DataField="SiteName" HeaderText="Site"
                HeaderStyle-CssClass="header-bold" />

            <asp:BoundField DataField="Username" HeaderText="Username"
                HeaderStyle-CssClass="header-bold" />

            
            <asp:TemplateField HeaderText="Password" HeaderStyle-CssClass="header-bold">
                <ItemTemplate>
                    <asp:Label ID="lblPassword" runat="server" Text="********"></asp:Label>
                    <asp:Button ID="btnReveal" runat="server" CommandName="Reveal"
                                CommandArgument='<%# Eval("VaultId") %>'
                                Text="👁" CssClass="btn" />
                </ItemTemplate>
            </asp:TemplateField>

   
            <asp:TemplateField HeaderText="Strength" HeaderStyle-CssClass="header-bold">
                <ItemTemplate>
                    <span class='<%# GetStrengthClass(Eval("Strength")) %>'>
                        <%# Eval("Strength") %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="LastRotated" HeaderText="Last Rotated"
                DataFormatString="{0:yyyy-MM-dd}" HeaderStyle-CssClass="header-bold" />
        </Columns>
    </asp:GridView>

</div>


    </asp:Content>
