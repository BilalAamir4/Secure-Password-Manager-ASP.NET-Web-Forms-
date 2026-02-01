<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Main_Master_file.Master"
    AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Information_Security_Project.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* Layout */
        .dashboard-container {
            padding: 30px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .top-row, .bottom-row {
            display: flex;
            gap: 20px;
        }

        .top-row .card, .bottom-row .card, .single-card-row .card {
            background: rgba(30,30,47,0.9);
            border-radius: 14px;
            padding: 25px;
            border: 1px solid rgba(54,158,255,0.4);
            box-shadow: 0 0 10px rgba(54,158,255,0.25);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            color: #fff;
        }

        .card h3 {
            color: #369eff;
            margin-bottom: 15px;
            text-shadow: 0 0 6px rgba(54,158,255,0.6);
        }

        .card:hover {
            box-shadow: 0 0 30px rgba(54,158,255,0.6);
            transform: translateY(-4px);
            border-color: #369eff;
        }

        /* Strength / Expiry Bars */
        .strength-bar, .expiry-bar {     
        display: flex;
        width: 100%;
        height: 25px;
        overflow: hidden;
        border-radius: 10px;
        background: #151528;
        }
            height: 25px;
            border-radius: 10px;
            background: #151528;
            overflow: hidden;
            margin-bottom: 10px;
        }

        .strength-fill, .expiry-fill {
              height: 100%;
    transition: width 0.4s ease;
        }

        .btn {
            padding: 10px 18px;
            border-radius: 8px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .btn-primary {
            background: #0d1736;
            color: #fff;
            border: 1px solid #369eff;
        }

        .btn-secondary {
            background: #252540;
            color: #fff;
            border: 1px solid rgba(54,158,255,0.3);
        }

        .input-neon {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            background: #151528;
            border: 1px solid #369eff;
            color: #fff;
            outline: none;
        }

        .input-neon:focus {
            border-color: #6ab8ff;
        }

        .bottom-row {
    display: flex;
    justify-content: center;
}

.quick-card {
    width: 60%;
    max-width: 700px;
    text-align: center;         /* centers text + inline elements */
    display: flex;
    flex-direction: column;     /* stack elements vertically */
    align-items: center;        /* centers buttons & blocks */
}


    </style>

    <!-- Dashboard Container -->
    <div class="dashboard-container">

        <!-- Top Row: Password Health + Expiry -->
        <div class="top-row">

            <!-- Password Strength Card -->
           <div class="card" style="flex:1">
    <h3>Password Health</h3>

    <div class="strength-bar">
    <div id="strongFill" runat="server" class="strength-fill"></div>
    <div id="mediumFill" runat="server" class="strength-fill"></div>
    <div id="weakFill" runat="server" class="strength-fill"></div>
</div>
               <p>
    <asp:Label ID="lblStrengthText" runat="server" />
</p>
</div>

            <!-- Password Expiry Card -->
            <div class="card" style="flex:1">
    <h3>Password Expiry</h3>

    <div class="expiry-bar">
    <div id="expiryHealthyFill" runat="server" class="expiry-fill"></div>
    <div id="expirySoonFill" runat="server" class="expiry-fill"></div>
    <div id="expiryExpiredFill" runat="server" class="expiry-fill"></div>
</div>

<p>
    <asp:Label ID="lblExpiryInfo" runat="server" />
</p>
</div>
            </div>
        <div class="bottom-row">
    <div class="card quick-card">
        <h3>Quick Actions</h3>
        <asp:Button ID="btnAddPassword" runat="server" Text="➕ Add New Password"
            CssClass="btn btn-primary" OnClick="btnAddPassword_Click" />
    </div>
</div>
        </div>


        <!-- Category Section -->
        <div class="single-card-row">
            <div class="card">
                <h3>Manage Categories</h3>
                <asp:TextBox ID="txtCategoryName" runat="server" CssClass="input-neon" Placeholder="Enter category name..." />
                <br /><br />
                <asp:Button ID="btnAddCategory" runat="server" Text="Add Category" CssClass="btn btn-secondary" OnClick="btnAddCategory_Click" />
                <br /><br />
                <asp:Label ID="lblCategoryMessage" runat="server" ForeColor="#369eff" />

                <hr style="border-color: rgba(54,158,255,0.3);" />

                <asp:Repeater ID="rptCategories" runat="server" OnItemCommand="rptCategories_ItemCommand">
                    <ItemTemplate>
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
                            <span><%# Eval("CategoryName") %></span>
                            <div>
                                <asp:Button ID="btnEditCategory" runat="server" CommandName="Edit" CommandArgument='<%# Eval("CategoryId") %>'
                                    Text="Edit" CssClass="btn btn-primary" />
                                <asp:Button ID="btnDeleteCategory" runat="server" CommandName="Delete" CommandArgument='<%# Eval("CategoryId") %>'
                                    Text="Delete" CssClass="btn btn-secondary" OnClientClick="return confirm('Are you sure?');" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <!-- Edit Panel -->
                <asp:Panel ID="pnlEdit" runat="server" Style="display:none; margin-top:15px;">
                    <asp:HiddenField ID="hfEditCategoryId" runat="server" />
                    <asp:TextBox ID="txtEditCategoryName" runat="server" CssClass="input-neon" Placeholder="Edit category name..." />
                    <br /><br />
                    <asp:Button ID="btnUpdateCategory" runat="server" Text="Update" CssClass="btn btn-primary" OnClick="btnUpdateCategory_Click" />
                    <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancelEdit_Click" Style="margin-left:10px;" />
                    <br /><br />
                    <asp:Label ID="lblEditMessage" runat="server" ForeColor="#369eff" />
                </asp:Panel>
            </div>
        </div>
    </div>
    </div>

</asp:Content>
