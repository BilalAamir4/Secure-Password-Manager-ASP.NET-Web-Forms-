using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Information_Security_Project
{
    public partial class Password_Health : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private static readonly byte[] Key = Encoding.UTF8.GetBytes("MyUltraSecurePasswordKey1234567!"); // 32 bytes for AES-256
        private static readonly byte[] IV = Encoding.UTF8.GetBytes("MySecretIV123456"); // 16 bytes for AES

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
                Response.Redirect("Login_page.aspx");

            if (!IsPostBack)
                BindPasswords();
        }

        private void BindPasswords()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT VaultId, SiteName, Username, Strength, LastRotated FROM Vault WHERE UserId=@UserId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvPasswordHealth.DataSource = dt;
                gvPasswordHealth.DataBind();
            }
        }

        protected void gvPasswordHealth_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Reveal")
            {
                int vaultId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = "SELECT PasswordEncrypted FROM Vault WHERE VaultId=@VaultId AND UserId=@UserId";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@VaultId", vaultId);
                    cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                    con.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        string decrypted = DecryptPassword((byte[])result);

                        // Find the row where button was clicked
                        GridViewRow row = ((Button)e.CommandSource).NamingContainer as GridViewRow;
                        Label lblPassword = (Label)row.FindControl("lblPassword");

                        // Show decrypted password temporarily
                        lblPassword.Text = decrypted;
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "hidePwd" + vaultId,
                            $"setTimeout(function(){{ document.getElementById('{lblPassword.ClientID}').innerText = '********'; }}, 5000);", true);
                    }
                }
            }
        }
        private string DecryptPassword(byte[] cipherText)
        {
            using (Aes aes = Aes.Create())
            {
                aes.Key = Key;
                aes.IV = IV;
                aes.Padding = PaddingMode.PKCS7;
                aes.Mode = CipherMode.CBC;

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

        protected string GetStrengthClass(object strengthObj)
        {
            string strength = strengthObj?.ToString().ToLower() ?? "";

            switch (strength)
            {
                case "weak":
                    return "weak";
                case "medium":
                    return "medium";
                case "strong":
                    return "strong";
                default:
                    return "";
            }
        }
    }
}
