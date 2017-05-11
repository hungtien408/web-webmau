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

    void DeleteImage(string strManufacturerImage)
    {
        if (!string.IsNullOrEmpty(strManufacturerImage))
        {
            string strOldImagePath = Server.MapPath("~/res/manufacturer/" + strManufacturerImage);
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
            ObjectDataSource1.SelectParameters["ManufacturerName"].DefaultValue = value;
            ObjectDataSource1.DataBind();
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "QuickUpdate")
        {
            string ManufacturerID, Priority, IsAvailable;
            var oManufacturer = new Manufacturer1();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                ManufacturerID = item.GetDataKeyValue("ManufacturerID").ToString();
                Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oManufacturer.ManufacturerQuickUpdate(
                    ManufacturerID,
                    IsAvailable,
                    Priority
                );
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            var oManufacturer = new Manufacturer1();

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                string strManufacturerImage = ((HiddenField)item.FindControl("hdnManufacturerImage")).Value;

                if (!string.IsNullOrEmpty(strManufacturerImage))
                {
                    string strSavePath = Server.MapPath("~/res/manufacturer/" + strManufacturerImage);
                    if (File.Exists(strSavePath))
                        File.Delete(strSavePath);
                }
            }
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var FileManufacturerImage = (RadUpload)row.FindControl("FileManufacturerImage");

            string strManufacturerName = ((TextBox)row.FindControl("txtManufacturerName")).Text.Trim();
            string strManufacturerNameEn = ((TextBox)row.FindControl("txtManufacturerNameEn")).Text.Trim();
            string strConvertedManufacturerName = Common.ConvertTitle(strManufacturerName);
            string strManufacturerImage = FileManufacturerImage.UploadedFiles.Count > 0 ? FileManufacturerImage.UploadedFiles[0].GetName() : "";
            string strIsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();
            string strPriority = ((RadNumericTextBox)row.FindControl("txtPriority")).Text.Trim();
            string strProductID = string.IsNullOrEmpty(Request.QueryString["pi"]) ? "" : Request.QueryString["pi"];
            string strContent = FCKEditorFix.Fix(((RadEditor)row.FindControl("txtContent")).Content.Trim());
            string strContentEn = FCKEditorFix.Fix(((RadEditor)row.FindControl("txtContentEn")).Content.Trim());

            var oManufacturer = new Manufacturer1();

            if (e.CommandName == "PerformInsert")
            {
                strManufacturerImage = oManufacturer.ManufacturerInsert(
                    strManufacturerName,
                    strManufacturerNameEn,
                    strConvertedManufacturerName,
                    strManufacturerImage,
                    strIsAvailable,
                    strPriority,
                    strProductID,
                    strContent,
                    strContentEn
                    );
                string strFullPath = "~/res/manufacturer/" + strManufacturerImage;

                if (!string.IsNullOrEmpty(strManufacturerImage))
                {
                    FileManufacturerImage.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    //string bgColor = "#ffffff";
                    //ResizeCropImage.ResizeWithBackGroundColor(strFullPath, 190, 120, bgColor);
                    //ResizeCropImage.ResizeByWidth(strFullPath, 180);
                    ResizeCropImage.ResizeByCondition(strFullPath, 200, 200);
                }
                RadGrid1.Rebind();
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;
                var strManufacturerID = row.GetDataKeyValue("ManufacturerID").ToString();
                var strOldManufacturerImage = ((HiddenField)row.FindControl("hdnManufacturerImage")).Value;
                var strOldImagePath = Server.MapPath("~/res/manufacturer/" + strOldManufacturerImage);

                dsUpdateParam["ManufacturerName"].DefaultValue = strManufacturerName;
                dsUpdateParam["ManufacturerNameEn"].DefaultValue = strManufacturerNameEn;
                dsUpdateParam["ConvertedManufacturerName"].DefaultValue = strConvertedManufacturerName;
                dsUpdateParam["ManufacturerImage"].DefaultValue = strManufacturerImage;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;
                dsUpdateParam["ProductID"].DefaultValue = strProductID;

                if (!string.IsNullOrEmpty(strManufacturerImage))
                {
                    var strFullPath = "~/res/manufacturer/" + strConvertedManufacturerName + "-" + strManufacturerID + strManufacturerImage.Substring(strManufacturerImage.LastIndexOf('.'));

                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);

                    FileManufacturerImage.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    //string bgColor = "#ffffff";
                    //ResizeCropImage.ResizeWithBackGroundColor(strFullPath, 180, 120, bgColor);
                    ResizeCropImage.ResizeByCondition(strFullPath, 200, 200);
                    //ResizeCropImage.ResizeByWidth(strFullPath, 180);
                }
            }
        }
        if (e.CommandName == "DeleteImage")
        {
            var oManufacturer = new Manufacturer1();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strManufacturerID = s[0];
            var strManufacturerImage = s[1];

            oManufacturer.ManufacturerImageDelete(strManufacturerID);
            DeleteImage(strManufacturerImage);
            RadGrid1.Rebind();
        }
    }
    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            var itemtype = e.Item.ItemType;
            var row = itemtype == GridItemType.EditFormItem ? (GridEditFormItem)e.Item : (GridEditFormInsertItem)e.Item;
            var FileManufacturerImage = (RadUpload)row.FindControl("FileManufacturerImage");

            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FileManufacturerImage.ClientID));
        }
    }
    #endregion
}