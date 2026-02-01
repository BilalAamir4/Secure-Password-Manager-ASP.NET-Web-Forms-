using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace Information_Security_Project
{
    public partial class Signup : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PMConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSignup_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            if (password != confirmPassword)
            {
                lblMessage.Text = "⚠️ Passwords do not match.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            byte[] salt = GenerateSalt();

            byte[] passwordHash = HashPassword(password, salt);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string checkEmailQuery = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                using (SqlCommand checkEmailCmd = new SqlCommand(checkEmailQuery, con))
                {
                    checkEmailCmd.Parameters.AddWithValue("@Email", email);
                    int emailExists = (int)checkEmailCmd.ExecuteScalar();

                    if (emailExists > 0)
                    {
                        lblMessage.Text = "⚠️ Email already registered. Please use another.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        return;
                    }
                }

                string insertQuery = @"INSERT INTO Users (Email, PasswordHash, Salt, CreatedAt) 
                       OUTPUT INSERTED.UserId
                       VALUES (@Email, @PasswordHash, @Salt, GETDATE())";

                using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@PasswordHash", passwordHash);
                    cmd.Parameters.AddWithValue("@Salt", salt);

                    int newUserId = (int)cmd.ExecuteScalar();  

                    // ✅ store UserId in session
                    Session["UserId"] = newUserId;

                    Response.Redirect("Followup_1.aspx");
                }

            }
        }

        private byte[] GenerateSalt()
        {
            byte[] salt = new byte[32]; 
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(salt);
            }
            return salt;
        }

        private byte[] HashPassword(string password, byte[] salt)
        {
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 100000, HashAlgorithmName.SHA256))
            {
                return pbkdf2.GetBytes(32); 
            }
        }
    }
}
