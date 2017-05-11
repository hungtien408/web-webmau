using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using TLLib;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Data;
using System.Web.Security;
using System.Net;
using System.Net.Mail;
using System.Configuration;


public partial class ad_newsletter : System.Web.UI.Page
{
    #region Common Method

    protected void DropDownList_DataBound(object sender, EventArgs e)
    {
        var cbo = (RadComboBox)sender;
        cbo.Items.Insert(0, new RadComboBoxItem(""));
    }

    #endregion

    #region Event

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    #endregion
    protected void btnSendEmail_Click(object sender, EventArgs e)
    {
        lblSucess.Text = "";
        var fileMap = new ExeConfigurationFileMap() { ExeConfigFilename = Server.MapPath("~/config/app.config") };
        var config = ConfigurationManager.OpenMappedExeConfiguration(fileMap, ConfigurationUserLevel.None);
        var section = (AppSettingsSection)config.GetSection("appSettings");
        var strUseSSL = section.Settings["UseSSL"].Value;
        var strPort = section.Settings["Port"].Value;

        var dvEmail = (OdsNewsletter.Select() as DataView);
        var strHost = section.Settings["Host"].Value;
        int n;
        var isNumeric = int.TryParse(strPort, out n);
        var iPort = isNumeric ? n : 0;
        var strMailFrom = section.Settings["Email"].Value;
        var strDisplayName = "News & Orders";
        var strUserName = section.Settings["UserName"].Value;
        var strPassword = MD5Hash.Decrypt(section.Settings["Password"].Value, true);
        var bEnableSsl = strUseSSL.ToLower() == "true";
        var strMailTo = "";
        var strCC = "";
        var strSubject = txtSubject.Text.Trim();
        var strBody = txtContent.Content;
        if (RadGrid1.SelectedItems.Count == 0)
        {
            //strMailTo = (from DataRowView drv in dvEmail select drv["Email"].ToString()).ToList<string>().Aggregate((a, b) => a + ',' + b);
            if (dvEmail != null && dvEmail.Count > 0)
            {
                foreach (DataRow drv in dvEmail.Table.Rows)
                {
                    strMailTo = drv["Email"].ToString();
                    Common.SendMail(
                    strHost,
                    iPort,
                    strMailFrom,
                    strDisplayName,
                    strUserName,
                    strPassword,
                    strMailTo,
                    strCC,
                    strSubject,
                    strBody,
                    bEnableSsl
                    );
                }
            }
        }
        else
        {
            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                strMailTo = item["Email"].Text;
                Common.SendMail(
                strHost,
                iPort,
                strMailFrom,
                strDisplayName,
                strUserName,
                strPassword,
                strMailTo,
                strCC,
                strSubject,
                strBody,
                bEnableSsl
                );
            }
        }
        clearText();
        lblSucess.Text = "Email has been send.";
    }
    public void clearText()
    {
        txtSubject.Text = "";
    }
    //private bool sendEmail(string msg)
    //{
    //    var strEmail = "abin2323@gmail.com";
    //    var fileMap = new ExeConfigurationFileMap() { ExeConfigFilename = Server.MapPath("~/config/app.config") };
    //    var config = ConfigurationManager.OpenMappedExeConfiguration(fileMap, ConfigurationUserLevel.None);
    //    var section = (AppSettingsSection)config.GetSection("appSettings");
    //    var strUseSSL = section.Settings["UseSSL"].Value;
    //    var strPort = section.Settings["Port"].Value;
    //    var strHost = section.Settings["Host"].Value;
    //    int n;
    //    bool isNumeric = int.TryParse(strPort, out n);
    //    var iPort = isNumeric ? n : 0;
    //    var strMailFrom = section.Settings["Email"].Value;
    //    var strUserName = section.Settings["UserName"].Value;
    //    var strPassword = TLLib.MD5Hash.Decrypt(section.Settings["Password"].Value, true);
    //    var strReceivedEmails = section.Settings["ReceivedEmails"].Value;
    //    var bEnableSsl = strUseSSL.ToLower() == "true" ? true : false;
    //    var strSubject = "Orders";
    //    var strBody = msg;
    //    strReceivedEmails += "," + strEmail;
    //    var lstMailTo = strReceivedEmails.Replace(',', ';').Split(';').ToList<string>();
    //    //var lstMailTo = new List<string>() { strReceivedEmails, txtEmail.Text.Trim().ToString() };
    //    var lstCC = new List<string>(); ;
    //    var lstAttachment = new List<string>();

    //    var bSendSuccess = Common.SendMail(strHost,
    //                iPort,
    //                strMailFrom,
    //                strUserName,
    //                strPassword,
    //                lstMailTo,
    //                lstCC,
    //                lstAttachment,
    //                strSubject,
    //                strBody,
    //                bEnableSsl
    //            );

    //    return bSendSuccess;
    //}
}