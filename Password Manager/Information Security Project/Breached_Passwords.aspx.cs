using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Information_Security_Project
{
    public partial class Breached_Passwords : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PMConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
            }
        }
        private void LoadCategories()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT CategoryName FROM Categories", con);
                SqlDataReader reader = cmd.ExecuteReader();
                ddlCategories.Items.Clear();

                ddlCategories.Items.Add(new ListItem("Select Category", ""));
                while (reader.Read())
                {
                    ddlCategories.Items.Add(new ListItem(reader["CategoryName"].ToString(), reader["CategoryName"].ToString()));
                }

                ddlCategories.Items.Add(new ListItem("No Category", "NoCategory"));
                con.Close();
            }
        }

        protected void chkAllCategories_CheckedChanged(object sender, EventArgs e)
        {
            ddlCategories.Enabled = !chkAllCategories.Checked;
        }

        protected void btnCheckSingle_Click(object sender, EventArgs e)
        {
            string password = txtPassword.Text.Trim();
            bool breached = CheckPasswordBreached(password);

            DataTable dt = new DataTable();
            dt.Columns.Add("SiteName");
            dt.Columns.Add("PasswordMasked");
            dt.Columns.Add("Category");
            dt.Columns.Add("Status");

            dt.Rows.Add("-", MaskPassword(password), "-", breached ? "Breached" : "Safe");
            gvResults.DataSource = dt;
            gvResults.DataBind();
        }

        protected void btnCheckBulk_Click(object sender, EventArgs e)
        {
            DataTable dtResults = new DataTable();
            dtResults.Columns.Add("SiteName");
            dtResults.Columns.Add("PasswordMasked");
            dtResults.Columns.Add("Category");
            dtResults.Columns.Add("Status");

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                string query = "SELECT SiteName, Password, Category FROM Vault WHERE UserId=@UserId";
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;
                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                if (!chkAllCategories.Checked && !string.IsNullOrEmpty(ddlCategories.SelectedValue))
                {
                    if (ddlCategories.SelectedValue == "NoCategory")
                    {
                        query += " AND Category IS NULL";
                    }
                    else
                    {
                        query += " AND Category=@Category";
                        cmd.Parameters.AddWithValue("@Category", ddlCategories.SelectedValue);
                    }
                }

                cmd.CommandText = query;

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string pwd = reader["Password"].ToString();
                    dtResults.Rows.Add(
                        reader["SiteName"],
                        MaskPassword(pwd),
                        reader["Category"] == DBNull.Value ? "No Category" : reader["Category"].ToString(),
                        CheckPasswordBreached(pwd) ? "Breached" : "Safe"
                    );
                }

                con.Close();
            }

            gvResults.DataSource = dtResults;
            gvResults.DataBind();
        }

        private bool CheckPasswordBreached(string password)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM BreachedPasswords WHERE Password=@Password", con);
                cmd.Parameters.AddWithValue("@Password", password);
                int count = (int)cmd.ExecuteScalar();
                con.Close();
                return count > 0;
            }
        }

        private string MaskPassword(string password)
        {
            return new string('*', password.Length);
        }
    }
}
