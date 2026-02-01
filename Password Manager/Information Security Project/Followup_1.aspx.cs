using System;
using System.Data.SqlClient;
using System.IO;

namespace Information_Security_Project
{
    public partial class Followup_1 : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager
                                          .ConnectionStrings["PMConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string username = txtUsername.Text.Trim();
            string filePath = null;

            if (string.IsNullOrEmpty(username))
            {
                lblMessage.Text = "⚠️ Username is required.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // ✅ Handle profile picture upload
            if (fuProfilePic.HasFile)
            {
                try
                {
                    string folderPath = Server.MapPath("~/Uploads/ProfilePics/");
                    if (!Directory.Exists(folderPath))
                        Directory.CreateDirectory(folderPath);

                    string fileName = $"{Guid.NewGuid()}_{fuProfilePic.FileName}";
                    filePath = "~/Uploads/ProfilePics/" + fileName;
                    fuProfilePic.SaveAs(Path.Combine(folderPath, fileName));
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "❌ Error uploading file: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }
            }
            // else → leave filePath = null (will be handled in Followup_2)

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string query = "UPDATE Users SET Username = @Username, PfpPath = @PfpPath WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Username", username);

                    // store NULL if no file uploaded
                    if (filePath == null)
                        cmd.Parameters.AddWithValue("@PfpPath", DBNull.Value);
                    else
                        cmd.Parameters.AddWithValue("@PfpPath", filePath);

                    cmd.Parameters.AddWithValue("@UserId", userId);

                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        Response.Redirect("Followup_2.aspx");
                    }
                    else
                    {
                        lblMessage.Text = "❌ Update failed. Try again.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                }
            }
        }
    }
}
