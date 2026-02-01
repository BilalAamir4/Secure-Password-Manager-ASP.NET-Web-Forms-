using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Information_Security_Project
{
    public partial class Vault : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private static readonly byte[] Key = Encoding.UTF8.GetBytes("MyUltraSecurePasswordKey1234567!");
       
        private static readonly byte[] IV = Encoding.UTF8.GetBytes("MySecretIV123456");
       
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login_page.aspx");
            }

            if (!IsPostBack)
            {
                BindVault();
                LoadCategories();
            }
        }

        private void LoadCategories()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT CategoryId, CategoryName FROM Categories", con);
                con.Open();
                ddlCategory.DataSource = cmd.ExecuteReader();
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "CategoryId";
                ddlCategory.DataBind();
                ddlCategory.Items.Insert(0, new ListItem("-- Select Category (Optional) --", ""));
            }
        }

        private void BindVault()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT VaultId, SiteName, Username, PasswordEncrypted, LastRotated FROM Vault WHERE UserId=@UserId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Add decrypted password column for edit mode
                dt.Columns.Add("PasswordDecrypted", typeof(string));
                foreach (DataRow row in dt.Rows)
                {
                    row["PasswordDecrypted"] = DecryptPassword((byte[])row["PasswordEncrypted"]);
                }

                gvVault.DataSource = dt;
                gvVault.DataBind();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            pnlAdd.Visible = true;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            byte[] encrypted = EncryptPassword(txtPasswordNew.Text);
            string strength = hfPasswordStrength.Value; // Get value from hidden field

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO Vault 
                (UserId, SiteName, Username, PasswordEncrypted, CategoryId, Strength, LastRotated) 
                VALUES (@UserId, @SiteName, @Username, @PasswordEncrypted, @CategoryId, @Strength, GETDATE())";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                cmd.Parameters.AddWithValue("@SiteName", txtSiteName.Text);
                cmd.Parameters.AddWithValue("@Username", txtUsername.Text);
                cmd.Parameters.AddWithValue("@PasswordEncrypted", encrypted);
                cmd.Parameters.AddWithValue("@Strength", strength); // Pass the strength here

                if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
                    cmd.Parameters.AddWithValue("@CategoryId", ddlCategory.SelectedValue);
                else
                    cmd.Parameters.AddWithValue("@CategoryId", DBNull.Value);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            pnlAdd.Visible = false;
            BindVault();
        }



        protected void gvVault_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvVault.EditIndex = e.NewEditIndex;
            BindVault();
        }

        protected void gvVault_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvVault.EditIndex = -1;
            BindVault();
        }

        protected void gvVault_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int vaultId = Convert.ToInt32(gvVault.DataKeys[e.RowIndex].Value);
            TextBox txtPassword = (TextBox)gvVault.Rows[e.RowIndex].FindControl("txtPassword");
            byte[] encrypted = EncryptPassword(txtPassword.Text);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "UPDATE Vault SET PasswordEncrypted=@PasswordEncrypted, LastUpdated=GETDATE(), LastRotated=GETDATE() WHERE VaultId=@VaultId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@VaultId", vaultId);
                cmd.Parameters.AddWithValue("@PasswordEncrypted", encrypted);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            gvVault.EditIndex = -1;
            BindVault();
        }

        protected void gvVault_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int vaultId = Convert.ToInt32(gvVault.DataKeys[e.RowIndex].Value);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Vault WHERE VaultId=@VaultId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@VaultId", vaultId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            BindVault();
        }

       
        private byte[] EncryptPassword(string plainText)
        {
            using (Aes aes = Aes.Create())
            {
                aes.Key = Key;
                aes.IV = IV;

                using (var encryptor = aes.CreateEncryptor(aes.Key, aes.IV))
                {
                    byte[] plainBytes = Encoding.UTF8.GetBytes(plainText);
                    return PerformCryptography(plainBytes, encryptor);
                }
            }
        }

        private string DecryptPassword(byte[] cipherText)
        {
            using (Aes aes = Aes.Create())
            {
                aes.Key = Key;
                aes.IV = IV;

                using (var decryptor = aes.CreateDecryptor(aes.Key, aes.IV))
                {
                    byte[] decryptedBytes = PerformCryptography(cipherText, decryptor);
                    return Encoding.UTF8.GetString(decryptedBytes);
                }
            }
        }

        private byte[] PerformCryptography(byte[] data, ICryptoTransform transform)
        {
            using (var ms = new System.IO.MemoryStream())
            using (var cs = new CryptoStream(ms, transform, CryptoStreamMode.Write))
            {
                cs.Write(data, 0, data.Length);
                cs.FlushFinalBlock();
                return ms.ToArray();
            }
        }

       
        protected string GetExpiryText(object lastRotated)
        {
            DateTime rotated = Convert.ToDateTime(lastRotated);
            int daysLeft = 90 - (DateTime.Now - rotated).Days; 
            return daysLeft + " days left";
        }

        protected string GetExpiryClass(object lastRotated)
        {
            DateTime rotated = Convert.ToDateTime(lastRotated);
            int daysLeft = 90 - (DateTime.Now - rotated).Days;

            if (daysLeft <= 20) return "expiry-card expiry-warning";
            if (daysLeft <= 40) return "expiry-card expiry-neutral";
            return "expiry-card expiry-safe";
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlAdd.Visible = false; 
            txtSiteName.Text = string.Empty;
            txtUsername.Text = string.Empty;
            txtPasswordNew.Text = string.Empty;
        }
        protected string GetPasswordStrengthClass(object passwordObj)
        {
            string pwd = passwordObj?.ToString() ?? "";
            if (pwd.Length < 6 || !System.Text.RegularExpressions.Regex.IsMatch(pwd, "[0-9]"))
                return "weak";  
            if (pwd.Length < 10 || !System.Text.RegularExpressions.Regex.IsMatch(pwd, "[^a-zA-Z0-9]"))
                return "medium"; 
            return "strong";     
        }

        protected string GetPasswordStrengthText(object passwordObj)
        {
            string pwd = passwordObj?.ToString() ?? "";
            if (pwd.Length < 6 || !System.Text.RegularExpressions.Regex.IsMatch(pwd, "[0-9]"))
                return "Weak";
            if (pwd.Length < 10 || !System.Text.RegularExpressions.Regex.IsMatch(pwd, "[^a-zA-Z0-9]"))
                return "Medium";
            return "Strong";
        }

        private string GeneratePassword()
        {
            const string upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            const string lower = "abcdefghijklmnopqrstuvwxyz";
            const string digits = "0123456789";
            const string special = "!@#$%^&*()-_=+[]{};:,.?";

            string allChars = upper + lower + digits + special;
            Random rand = new Random();

            // Ensure at least one of each category
            string password = "" +
                upper[rand.Next(upper.Length)] +
                lower[rand.Next(lower.Length)] +
                digits[rand.Next(digits.Length)] +
                special[rand.Next(special.Length)];

            // Fill remaining up to length (16 chars)
            for (int i = password.Length; i < 16; i++)
            {
                password += allChars[rand.Next(allChars.Length)];
            }

            // Shuffle the result so it’s not predictable
            return new string(password.OrderBy(_ => rand.Next()).ToArray());
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            string newPassword = GeneratePassword();

            // Put password directly in textbox
            txtPasswordNew.Text = newPassword;

            // Update strength label via JS
            ScriptManager.RegisterStartupScript(this, this.GetType(), "setStrength",
                $"checkStrength('{newPassword}');", true);
        }
        private void LoadFilterCategories()
        {
            if (Session["UserId"] == null) return;

            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT CategoryId, CategoryName FROM Categories WHERE UserId=@UserId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        cblCategories.DataSource = reader;
                        cblCategories.DataTextField = "CategoryName";
                        cblCategories.DataValueField = "CategoryId";
                        cblCategories.DataBind();
                    }
                }
            }

            // Optional: if you want a "select all/none" option
            if (cblCategories.Items.Count == 0)
            {
                cblCategories.Items.Add(new ListItem("No categories available", "0"));
                cblCategories.Enabled = false;
            }
        }


        // Toggle filter panel visibility
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            pnlFilter.Visible = !pnlFilter.Visible;

            if (pnlFilter.Visible)
            {
                LoadFilterCategories(); // Populate the CheckBoxList only when visible
            }
        }

        // Apply filter based on selected categories
        protected void btnApplyFilter_Click(object sender, EventArgs e)
        {
            var selectedCategories = cblCategories.Items.Cast<ListItem>()
                                         .Where(i => i.Selected)
                                         .Select(i => i.Value)
                                         .ToList();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT VaultId, SiteName, Username, PasswordEncrypted, LastRotated " +
                               "FROM Vault WHERE UserId=@UserId";

                if (selectedCategories.Any())
                {
                    // Build IN clause for selected categories
                    string inClause = string.Join(",", selectedCategories);
                    query += $" AND CategoryId IN ({inClause})";
                }

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                dt.Columns.Add("PasswordDecrypted", typeof(string));
                foreach (DataRow row in dt.Rows)
                {
                    row["PasswordDecrypted"] = DecryptPassword((byte[])row["PasswordEncrypted"]);
                }

                gvVault.DataSource = dt;
                gvVault.DataBind();
            }
        }

        // Clear filter and show all records
        protected void btnClearFilter_Click(object sender, EventArgs e)
        {
            foreach (ListItem item in cblCategories.Items)
                item.Selected = false;

            pnlFilter.Visible = false;
            BindVault();
        }
    }
}
