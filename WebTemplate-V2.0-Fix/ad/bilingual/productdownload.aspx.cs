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

public partial class ad_single_productdownload : System.Web.UI.Page
{
    #region Common Method

    protected void DropDownList_DataBound(object sender, EventArgs e)
    {
        var cbo = (RadComboBox)sender;
        cbo.Items.Insert(0, new RadComboBoxItem(""));
    }

    void DeleteFile(string strFileName)
    {
        if (!string.IsNullOrEmpty(strFileName))
        {
            var strFilePath = Server.MapPath("~/res/product/download/" + strFileName);

            if (File.Exists(strFilePath))
                File.Delete(strFilePath);
        }
    }

    #endregion

    #region Event

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    
    protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
    {
        if (e.CommandName == "QuickUpdate")
        {
            string ProductDownloadID, Priority, IsAvailable;
            var oProductDownload = new ProductDownload();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                ProductDownloadID = item.GetDataKeyValue("ProductDownloadID").ToString();
                Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oProductDownload.ProductDownloadQuickUpdate(
                    ProductDownloadID,
                    IsAvailable,
                    Priority
                );
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            string OldLinkDownload;
            var oProduct = new Product();

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                OldLinkDownload = ((HiddenField)item.FindControl("hdnLinkDownload")).Value;
                DeleteFile(OldLinkDownload);
            }
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var FileLinkDownload = (RadUpload)row.FindControl("FileLinkDownload");
            string strLinkDownload = FileLinkDownload.UploadedFiles.Count > 0 ? FileLinkDownload.UploadedFiles[0].GetName() : "";
            string strIsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();

            if (e.CommandName == "PerformInsert")
            {
                var dsInsertParam = ObjectDataSource1.InsertParameters;

                dsInsertParam["LinkDownload"].DefaultValue = strLinkDownload;
                dsInsertParam["IsAvailable"].DefaultValue = strIsAvailable;
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;
                var strOldLinkDownload = ((HiddenField)row.FindControl("hdnLinkDownload")).Value;
                var strOldImagePath = Server.MapPath("~/res/product/download/" + strOldLinkDownload);

                dsUpdateParam["LinkDownload"].DefaultValue = strLinkDownload;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;

                if (!string.IsNullOrEmpty(strLinkDownload))
                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);
            }

            if (!string.IsNullOrEmpty(strLinkDownload))
            {
                string strSavePath = Server.MapPath("~/res/product/download/" + strLinkDownload);
                FileLinkDownload.UploadedFiles[0].SaveAs(strSavePath);
            }
        }
    }
    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            var itemtype = e.Item.ItemType;
            var row = itemtype == GridItemType.EditFormItem ? (GridEditFormItem)e.Item : (GridEditFormInsertItem)e.Item;
            var FileLinkDownload = (RadUpload)row.FindControl("FileLinkDownload");

            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FileLinkDownload.ClientID));
        }
    }
    #endregion
    
}