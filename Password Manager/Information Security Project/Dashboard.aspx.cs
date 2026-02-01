using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Information_Security_Project
{
    public partial class Dashboard : Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PMConnectionString"].ConnectionString;
        private readonly int ExpiryDays = 60;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
                Response.Redirect("Login_page.aspx");

            if (!IsPostBack)
            {
                LoadPasswordStrength();
                LoadPasswordExpiry();
                LoadCategories();
            }
        }

        #region Password Strength
        private void LoadPasswordStrength()
        {

            int userId = Convert.ToInt32(Session["UserId"]);
            int total = 0, strong = 0, medium = 0, weak = 0;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Strength FROM Vault WHERE UserId=@UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    total++;
                    string strength = reader["Strength"].ToString().Trim();
                    if (strength.Equals("Strong", StringComparison.OrdinalIgnoreCase)) strong++;
                    else if (strength.Equals("Medium", StringComparison.OrdinalIgnoreCase)) medium++;
                    else if (strength.Equals("Weak", StringComparison.OrdinalIgnoreCase)) weak++;
                }
            }

            if (total > 0)
            {
                double strongPerc = (strong / (double)total) * 100;
                double mediumPerc = (medium / (double)total) * 100;
                double weakPerc = (weak / (double)total) * 100;

                strongFill.Style["width"] = strongPerc + "%";
                mediumFill.Style["width"] = mediumPerc + "%";
                weakFill.Style["width"] = weakPerc + "%";

                strongFill.Style["background"] = "green";
                mediumFill.Style["background"] = "orange";
                weakFill.Style["background"] = "red";

                lblStrengthText.Text = $"Strong: {strongPerc:0}% | Medium: {mediumPerc:0}% | Weak: {weakPerc:0}%";
            }
        }
        #endregion

        #region Password Expiry
        private void LoadPasswordExpiry()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            int expired = 0, expiringSoon = 0, healthy = 0;
            DateTime now = DateTime.Now;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT LastRotated FROM Vault WHERE UserId=@UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    DateTime lastRotated = Convert.ToDateTime(reader["LastRotated"]);
                    int daysSince = (now - lastRotated).Days;

                    if (daysSince >= ExpiryDays)
                        expired++;
                    else if (daysSince >= ExpiryDays - 14)
                        expiringSoon++;
                    else
                        healthy++;
                }
            }

            int total = expired + expiringSoon + healthy;

            double healthyPerc = total > 0 ? (healthy / (double)total) * 100 : 0;
            double soonPerc = total > 0 ? (expiringSoon / (double)total) * 100 : 0;
            double expiredPerc = total > 0 ? (expired / (double)total) * 100 : 0;

            // Apply width + color to each segment
            expiryHealthyFill.Style["width"] = healthyPerc + "%";
            expiryHealthyFill.Style["background"] = "green";

            expirySoonFill.Style["width"] = soonPerc + "%";
            expirySoonFill.Style["background"] = "orange";

            expiryExpiredFill.Style["width"] = expiredPerc + "%";
            expiryExpiredFill.Style["background"] = "red";

            // Text below bar
            lblExpiryInfo.Text = $"Healthy: {healthy} | Expiring Soon: {expiringSoon} | Expired: {expired}";
        }

        #endregion

        #region Category Management
        protected void LoadCategories()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT CategoryId, CategoryName, CreatedAt FROM Categories WHERE UserId=@UserId ORDER BY CreatedAt DESC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            rptCategories.DataSource = dt;
            rptCategories.DataBind();
            pnlEdit.Style["display"] = "none";
            lblCategoryMessage.Text = "";
            lblEditMessage.Text = "";
        }

        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            string name = txtCategoryName.Text?.Trim();
            if (string.IsNullOrEmpty(name))
            {
                lblCategoryMessage.Text = "Category name cannot be empty.";
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO Categories (CategoryName, UserId) VALUES (@CategoryName, @UserId)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryName", name);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            txtCategoryName.Text = "";
            LoadCategories();
            lblCategoryMessage.Text = "Category added successfully!";
        }

        protected void rptCategories_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            int categoryId = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "Edit") BeginEditCategory(categoryId);
            else if (e.CommandName == "Delete") DeleteCategory(categoryId);
        }

        private void BeginEditCategory(int categoryId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT CategoryName FROM Categories WHERE CategoryId=@CategoryId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        txtEditCategoryName.Text = result.ToString();
                        hfEditCategoryId.Value = categoryId.ToString();
                        pnlEdit.Style["display"] = "block";
                        lblEditMessage.Text = "";
                    }
                }
            }
        }

        protected void btnUpdateCategory_Click(object sender, EventArgs e)
        {
            int categoryId = Convert.ToInt32(hfEditCategoryId.Value);
            string newName = txtEditCategoryName.Text?.Trim();
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE Categories SET CategoryName=@CategoryName WHERE CategoryId=@CategoryId AND UserId=@UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryName", newName);
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            pnlEdit.Style["display"] = "none";
            hfEditCategoryId.Value = "";
            txtEditCategoryName.Text = "";
            LoadCategories();
            lblEditMessage.Text = "Category updated successfully!";
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            pnlEdit.Style["display"] = "none";
            hfEditCategoryId.Value = "";
            txtEditCategoryName.Text = "";
        }

        private void DeleteCategory(int categoryId)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Categories WHERE CategoryId=@CategoryId AND UserId=@UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            LoadCategories();
        }
        #endregion

        protected void btnAddPassword_Click(object sender, EventArgs e)
        {
            Response.Redirect("Vault.aspx");
        }
    }
}
