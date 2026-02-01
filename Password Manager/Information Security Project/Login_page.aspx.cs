using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Web.UI;

namespace Information_Security_Project
{
    public partial class Login_page : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager
                                          .ConnectionStrings["PMConnectionString"].ConnectionString;

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                Response.Write("<script>alert('⚠️ Please enter both email and password.');</script>");
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // ✅ Fetch UserId, PasswordHash, Salt
                string query = "SELECT UserId, PasswordHash, Salt, Username FROM Users WHERE Email = @Email";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int userId = (int)reader["UserId"];
                            string username = reader["Username"].ToString();
                            byte[] storedHash = (byte[])reader["PasswordHash"];
                            byte[] storedSalt = (byte[])reader["Salt"];

                            // Hash entered password with stored salt
                            byte[] enteredHash = HashPassword(password, storedSalt);

                            if (CompareHashes(storedHash, enteredHash))
                            {
                                // ✅ Save user info in session
                                Session["UserId"] = userId;
                                Session["Username"] = username;
                                Session["Email"] = email;

                                Response.Write("<script>alert('✅ Login Successful!');</script>");
                                Response.Redirect("Dashboard.aspx");
                            }
                            else
                            {
                                Response.Write("<script>alert('❌ Invalid Email or Password');</script>");
                            }
                        }
                        else
                        {
                            Response.Write("<script>alert('❌ Invalid Email or Password');</script>");
                        }
                    }
                }
            }
        }

        private byte[] HashPassword(string password, byte[] salt)
        {
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 100000, HashAlgorithmName.SHA256))
            {
                return pbkdf2.GetBytes(32); // 256-bit hash
            }
        }

        private bool CompareHashes(byte[] hash1, byte[] hash2)
        {
            if (hash1.Length != hash2.Length)
                return false;

            bool isEqual = true;
            for (int i = 0; i < hash1.Length; i++)
            {
                if (hash1[i] != hash2[i])
                {
                    isEqual = false;
                }
            }
            return isEqual;
        }
    }
}
