using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ad_bilingual_siteconfig : System.Web.UI.Page
{
    #region Common Method

    #endregion

    #region Event
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            var fileMap = new ExeConfigurationFileMap() { ExeConfigFilename = Server.MapPath("~/config/app.config") };
            var config = ConfigurationManager.OpenMappedExeConfiguration(fileMap, ConfigurationUserLevel.None);
            var section = (AppSettingsSection)config.GetSection("appSettings");
            var strUseSSL = section.Settings["UseSSL"].Value;

            txtHost.Text = section.Settings["Host"].Value;
            txtPort.Text = section.Settings["Port"].Value;
            txtEmail.Text = section.Settings["Email"].Value;
            txtUserName.Text = section.Settings["UserName"].Value;
            txtReceivedEmails.Text = section.Settings["ReceivedEmails"].Value;
            chkUseSSL.Checked = strUseSSL.ToLower() == "true" ? true : false;
        }
    }

    protected void btnSaveEmail_Click(object sender, EventArgs e)
    {
        lblSaveEmail.Text = "";
        var fileMap = new ExeConfigurationFileMap() { ExeConfigFilename = Server.MapPath("~/config/app.config") };
        var config = ConfigurationManager.OpenMappedExeConfiguration(fileMap, ConfigurationUserLevel.None);
        var section = (AppSettingsSection)config.GetSection("appSettings");
        var strUseSSL = section.Settings["UseSSL"].Value;

        section.Settings["Host"].Value=txtHost.Text;
        section.Settings["Port"].Value=txtPort.Text;
        section.Settings["Email"].Value = txtEmail.Text;
        section.Settings["UserName"].Value = txtUserName.Text;
        section.Settings["Password"].Value = TLLib.MD5Hash.Encrypt(txtPassword.Text.Trim(), true);
        section.Settings["ReceivedEmails"].Value = txtReceivedEmails.Text;
        section.Settings["UseSSL"].Value = chkUseSSL.Checked.ToString().ToLower();

        config.Save(ConfigurationSaveMode.Full);  // Save changes

        lblSaveEmail.Text = "Done.";
    }
    #endregion
}