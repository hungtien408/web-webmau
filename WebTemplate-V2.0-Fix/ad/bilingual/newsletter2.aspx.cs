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


public partial class ad_bilingual_newsletter : System.Web.UI.Page
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
        var dvEmail = (OdsNewsletter.Select() as DataView);
        string strHost = "tranlegroup.com";
        int iPort = 25;
        string strMailFrom = "webmaster@tranlegroup.com";
        string strPassword = "web123master";
        string strMailTo = (from DataRowView drv in dvEmail select drv["Email"].ToString()).ToList<string>().Aggregate((a, b) => a + ',' + b);
        string strCC = "";
        string strSubject = txtSubject.Text.Trim();
        string strBody = FCKEditorFix.Fix(txtBody.Content.Trim());
        bool bEnableSsl = false;

        TLLib.Common.SendMail(
            strHost,
            iPort,
            strMailFrom,
            strPassword,
            strMailTo,
            strCC,
            strSubject,
            strBody,
            bEnableSsl
        );

        lblSucess.Text = "Email has been send.";
    }
}