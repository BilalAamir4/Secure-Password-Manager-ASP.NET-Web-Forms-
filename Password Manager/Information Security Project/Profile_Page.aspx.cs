using System;
using System.Data.SqlClient;
using System.IO;
using System.Web;

namespace Information_Security_Project
{
    public partial class Profile : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager
                                          .ConnectionStrings["PMConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserData();
            }
        }

        private void LoadUserData()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Username, Email, PfpPath FROM Users WHERE UserId=@UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtUsername.Text = reader["Username"].ToString();
                    txtEmail.Text = reader["Email"].ToString();

                    string pfpPath = reader["PfpPath"].ToString();
                    imgProfilePic.ImageUrl = !string.IsNullOrEmpty(pfpPath)
                        ? pfpPath
                        : "~/Assets/default-pfp.png";
                }
            }
        }

        // 🔥 NEW: Save Picture Button
        protected void btnSavePic_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            if (!fuProfilePic.HasFile)
            {
                lblMessage.Text = "❌ Please choose a picture first.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string folderPath = Server.MapPath("~/Uploads/ProfilePics/");
            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            string fileName = "pfp_" + userId + Path.GetExtension(fuProfilePic.FileName);
            string fullPath = Path.Combine(folderPath, fileName);
            string dbPath = "~/Uploads/ProfilePics/" + fileName;

            // Save file (overwrite allowed)
            fuProfilePic.SaveAs(fullPath);

            // Update DB path
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE Users SET PfpPath=@PfpPath WHERE UserId=@UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@PfpPath", dbPath);
                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // Update image immediately without full reload
            imgProfilePic.ImageUrl = dbPath;

            lblMessage.Text = "✔ Picture updated successfully!";
            lblMessage.ForeColor = System.Drawing.Color.Green;
        }

        // ✔ Old save button (unchanged)
        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string newUsername = txtUsername.Text.Trim();
            string newEmail = txtEmail.Text.Trim();

            string oldUsername = "";
            string oldEmail = "";
            string oldPfpPath = "";

            // --- Fetch old values ---
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand getCmd = new SqlCommand(
                    "SELECT Username, Email, PfpPath FROM Users WHERE UserId=@UserId", conn);
                getCmd.Parameters.AddWithValue("@UserId", userId);

                SqlDataReader reader = getCmd.ExecuteReader();
                if (reader.Read())
                {
                    oldUsername = reader["Username"].ToString();
                    oldEmail = reader["Email"].ToString();
                    oldPfpPath = reader["PfpPath"].ToString();
                }
            }

            // --- Detect changes ---
            bool usernameChanged = oldUsername != newUsername;
            bool emailChanged = oldEmail != newEmail;
            bool pictureChanged = fuProfilePic.HasFile;

            string filePath = null;

            if (pictureChanged)
            {
                string folderPath = Server.MapPath("~/Uploads/ProfilePics/");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                string fileName = "pfp_" + userId + Path.GetExtension(fuProfilePic.FileName);
                filePath = "~/Uploads/ProfilePics/" + fileName;

                fuProfilePic.SaveAs(Path.Combine(folderPath, fileName));
            }

            // --- Update database ---
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string query = "UPDATE Users SET Username=@Username, Email=@Email"
                             + (pictureChanged ? ", PfpPath=@PfpPath" : "")
                             + " WHERE UserId=@UserId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Username", newUsername);
                cmd.Parameters.AddWithValue("@Email", newEmail);
                if (pictureChanged)
                    cmd.Parameters.AddWithValue("@PfpPath", filePath);
                cmd.Parameters.AddWithValue("@UserId", userId);

                cmd.ExecuteNonQuery();
            }

            // --- Build success message ---
            string message = "";

            if (!usernameChanged && !emailChanged && !pictureChanged)
            {
                message = "No changes were made.";
            }
            else
            {
                if (usernameChanged) message += "Username updated successfully. ";
                if (emailChanged) message += "Email updated successfully. ";
                if (pictureChanged) message += "Profile picture updated successfully.";
            }

            lblMessage.Text = message;
            lblMessage.ForeColor = System.Drawing.Color.Green;

            // Reload updated data without redirect
            LoadUserData();
        }

    }
}
