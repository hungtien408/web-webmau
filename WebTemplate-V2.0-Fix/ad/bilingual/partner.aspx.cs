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


public partial class ad_single_partner : System.Web.UI.Page
{
    #region Common Method

    protected void DropDownList_DataBound(object sender, EventArgs e)
    {
        var cbo = (RadComboBox)sender;
        cbo.Items.Insert(0, new RadComboBoxItem(""));
    }

    void DeleteImage(string strPartnerImage)
    {
        if (!string.IsNullOrEmpty(strPartnerImage))
        {
            string strOldImagePath = Server.MapPath("~/res/partner/" + strPartnerImage);
            if (File.Exists(strOldImagePath))
                File.Delete(strOldImagePath);
        }
    }

    #endregion

    #region Event

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public void RadGrid1_ItemCreated(object sender, Telerik.Web.UI.GridItemEventArgs e)
    {
        if (e.Item is GridCommandItem)
        {
            GridCommandItem commandItem = (e.Item as GridCommandItem);
            PlaceHolder container = (PlaceHolder)commandItem.FindControl("PlaceHolder1");
            Label label = new Label();
            label.Text = "&nbsp;&nbsp;";

            container.Controls.Add(label);

            for (int i = 65; i <= 65 + 25; i++)
            {
                LinkButton linkButton1 = new LinkButton();

                LiteralControl lc = new LiteralControl("&nbsp;&nbsp;");

                linkButton1.Text = "" + (char)i;

                linkButton1.CommandName = "alpha";
                linkButton1.CommandArgument = "" + (char)i;

                container.Controls.Add(linkButton1);
                container.Controls.Add(lc);
            }

            LiteralControl lcLast = new LiteralControl("&nbsp;");
            container.Controls.Add(lcLast);

            LinkButton linkButtonAll = new LinkButton();
            linkButtonAll.Text = "Tất cả";
            linkButtonAll.CommandName = "NoFilter";
            container.Controls.Add(linkButtonAll);
        }
    }
    protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
    {
        if (e.CommandName == "alpha" || e.CommandName == "NoFilter")
        {
            String value = null;
            switch (e.CommandName)
            {
                case ("alpha"):
                    {
                        value = string.Format("{0}%", e.CommandArgument);
                        break;
                    }
                case ("NoFilter"):
                    {
                        value = "%";
                        break;
                    }
            }
            ObjectDataSource1.SelectParameters["PartnerName"].DefaultValue = value;
            ObjectDataSource1.DataBind();
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "QuickUpdate")
        {
            string PartnerID, Priority, IsAvailable;
            var oPartner = new Partner();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                PartnerID = item.GetDataKeyValue("PartnerID").ToString();
                Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oPartner.PartnerQuickUpdate(
                    PartnerID,
                    IsAvailable,
                    Priority
                );
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            var oPartner = new Partner();

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                string strPartnerImage = ((HiddenField)item.FindControl("hdnPartnerImage")).Value;

                if (!string.IsNullOrEmpty(strPartnerImage))
                {
                    string strSavePath = Server.MapPath("~/res/partner/" + strPartnerImage);
                    if (File.Exists(strSavePath))
                        File.Delete(strSavePath);
                }
            }
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var FilePartnerImage = (RadUpload)row.FindControl("FilePartnerImage");

            string strPartnerName = ((TextBox)row.FindControl("txtPartnerName")).Text.Trim();
            string strPartnerNameEn = ((TextBox)row.FindControl("txtPartnerNameEn")).Text.Trim();
            string strAddress = ((TextBox)row.FindControl("txtAddress")).Text.Trim();
            string strLinkWebsite = ((TextBox)row.FindControl("txtLinkWebsite")).Text.Trim();
            string strConvertedPartnerName = Common.ConvertTitle(strPartnerName);
            string strPartnerImage = FilePartnerImage.UploadedFiles.Count > 0 ? FilePartnerImage.UploadedFiles[0].GetName() : "";
            string strIsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();
            string strPriority = ((RadNumericTextBox)row.FindControl("txtPriority")).Text.Trim();

            var oPartner = new Partner();

            if (e.CommandName == "PerformInsert")
            {
                strPartnerImage = oPartner.PartnerInsert(
                    strPartnerName,
                    strPartnerNameEn,
                    strConvertedPartnerName,
                    strPartnerImage,
                    strAddress,
                    strLinkWebsite,
                    strIsAvailable,
                    strPriority
                    );
                string strFullPath = "~/res/partner/" + strPartnerImage;

                if (!string.IsNullOrEmpty(strPartnerImage))
                {
                    FilePartnerImage.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 200, 200);
                }
                RadGrid1.Rebind();
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;
                var strPartnerID = row.GetDataKeyValue("PartnerID").ToString();
                var strOldPartnerImage = ((HiddenField)row.FindControl("hdnPartnerImage")).Value;
                var strOldImagePath = Server.MapPath("~/res/partner/" + strOldPartnerImage);

                dsUpdateParam["PartnerName"].DefaultValue = strPartnerName;
                dsUpdateParam["PartnerNameEn"].DefaultValue = strPartnerNameEn;
                dsUpdateParam["ConvertedPartnerName"].DefaultValue = strConvertedPartnerName;
                dsUpdateParam["PartnerImage"].DefaultValue = strPartnerImage;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;

                if (!string.IsNullOrEmpty(strPartnerImage))
                {
                    var strFullPath = "~/res/partner/" + strConvertedPartnerName + "-" + strPartnerID + strPartnerImage.Substring(strPartnerImage.LastIndexOf('.'));

                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);

                    FilePartnerImage.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 200, 200);
                }
            }
        }
        if (e.CommandName == "DeleteImage")
        {
            var oPartner = new Partner();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strPartnerID = s[0];
            var strPartnerImage = s[1];

            oPartner.PartnerImageDelete(strPartnerID);
            DeleteImage(strPartnerImage);
            RadGrid1.Rebind();
        }
    }
    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            var itemtype = e.Item.ItemType;
            var row = itemtype == GridItemType.EditFormItem ? (GridEditFormItem)e.Item : (GridEditFormInsertItem)e.Item;
            var FilePartnerImage = (RadUpload)row.FindControl("FilePartnerImage");

            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FilePartnerImage.ClientID));
        }
    }
    #endregion
}