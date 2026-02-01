using System;
using System.Data.SqlClient;

namespace Information_Security_Project
{
    public partial class Followup_2 : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager
                                          .ConnectionStrings["PMConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string gender = ddlGender.SelectedValue;
            DateTime? birthday = null;

            if (!string.IsNullOrWhiteSpace(txtBirthday.Text))
            {
                if (DateTime.TryParse(txtBirthday.Text, out DateTime parsedDate))
                {
                    birthday = parsedDate;
                }
                else
                {
                    lblMessage.Text = "⚠️ Invalid date format.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // Step 1: check if PfpPath is already set
                string existingPath = null;
                string checkQuery = "SELECT PfpPath FROM Users WHERE UserId = @UserId";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@UserId", userId);
                    object result = checkCmd.ExecuteScalar();
                    if (result != DBNull.Value && result != null)
                        existingPath = result.ToString();
                }

                // Step 2: decide default PFP if none uploaded
                string finalPfpPath = existingPath; // keep uploaded pic
                if (string.IsNullOrEmpty(existingPath))
                {
                    if (gender == "Male")
                        finalPfpPath = "~/Uploads/Boy PFP.png";
                    else if (gender == "Female")
                        finalPfpPath = "~/Uploads/Girl PFP.png";
                }

                // Step 3: update Gender, Birthday, and PfpPath
                string query = "UPDATE Users SET Gender = @Gender, Birthday = @Birthday, PfpPath = @PfpPath WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Gender", gender);
                    cmd.Parameters.AddWithValue("@Birthday", (object)birthday ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@PfpPath", (object)finalPfpPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        lblMessage.Text = "✅ Profile setup completed successfully!";
                        lblMessage.ForeColor = System.Drawing.Color.Green;

                        // Redirect to login or vault
                        Response.Redirect("Login_page.aspx");
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
