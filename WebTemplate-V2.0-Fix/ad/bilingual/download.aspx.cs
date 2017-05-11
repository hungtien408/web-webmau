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

public partial class ad_single_download : System.Web.UI.Page
{

    #region Common Method

    protected void DropDownList_DataBound(object sender, EventArgs e)
    {
        var cbo = (RadComboBox)sender;
        cbo.Items.Insert(0, new RadComboBoxItem(""));
    }

    void DeleteImage(string strImageName)
    {
        if (!string.IsNullOrEmpty(strImageName))
        {
            var strImagePath = Server.MapPath("~/res/download/thumbs/" + strImageName);
            if (File.Exists(strImagePath))
                File.Delete(strImagePath);
        }
    }
    void DeleteDownload(string strDownloadName)
    {
        if (!string.IsNullOrEmpty(strDownloadName))
        {
            var strFilePath = Server.MapPath("~/res/download/" + strDownloadName);
            if (File.Exists(strFilePath))
                File.Delete(strFilePath);
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
            ObjectDataSource1.SelectParameters["DownloadName"].DefaultValue = value;
            ObjectDataSource1.DataBind();
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "QuickUpdate")
        {
            string DownloadID, Priority, IsAvailable;
            var oDownload = new Download();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                DownloadID = item.GetDataKeyValue("DownloadID").ToString();
                Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oDownload.DownloadQuickUpdate(
                    DownloadID,
                    IsAvailable,
                    Priority
                );
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            string OldImageName, OldFilePath;
            var oDownload = new Download();

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                OldImageName = ((HiddenField)item.FindControl("hdnImageName")).Value;
                OldFilePath = ((HiddenField)item.FindControl("hdnFilePath")).Value;
                DeleteImage(OldImageName);
                DeleteDownload(OldFilePath);
            }
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var FileImageName = (RadUpload)row.FindControl("FileImageName");
            var FileFilePath = (RadUpload)row.FindControl("FileFilePath");
            var oDownload = new Download();

            string DownloadID = ((HiddenField)row.FindControl("hdnDownloadID")).Value;
            string OldImageName = ((HiddenField)row.FindControl("hdnOldImageName")).Value;
            string OldFilePath = ((HiddenField)row.FindControl("hdnOldFilePath")).Value;
            string ImageName = FileImageName.UploadedFiles.Count > 0 ? FileImageName.UploadedFiles[0].GetName() : "";
            string FilePath = FileFilePath.UploadedFiles.Count > 0 ? FileFilePath.UploadedFiles[0].GetName() : "";
            string Priority = ((RadNumericTextBox)row.FindControl("txtPriority")).Text.Trim();
            string DownloadName = ((TextBox)row.FindControl("txtDownloadName")).Text.Trim();
            string DownloadNameEn = ((TextBox)row.FindControl("txtDownloadNameEn")).Text.Trim();
            string ConvertedDownloadName = Common.ConvertTitle(DownloadName);
            string DownloadCategoryID = ((RadComboBox)row.FindControl("ddlCategory")).SelectedValue;
            string IsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();

            if (e.CommandName == "PerformInsert")
            {
                DownloadID = oDownload.DownloadInsert(
                    DownloadName,
                    DownloadNameEn, 
                    ConvertedDownloadName, 
                    ImageName, 
                    FilePath, 
                    DownloadCategoryID, 
                    IsAvailable, 
                    Priority
                ).ToString();

                ImageName = string.IsNullOrEmpty(ImageName) ? "" : (string.IsNullOrEmpty(ConvertedDownloadName) ? "" : ConvertedDownloadName + "-") + DownloadID + Path.GetExtension(FileImageName.UploadedFiles[0].GetName());

                string strFullImagePath = "~/res/download/thumbs/" + ImageName;
                string strFullFilePath = "~/res/download/" + FilePath;

                if (FileFilePath.UploadedFiles.Count > 0)
                {
                    FileFilePath.UploadedFiles[0].SaveAs(Server.MapPath(strFullFilePath));
                }

                if (FileImageName.UploadedFiles.Count > 0)
                {
                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullImagePath));
                    ResizeCropImage.ResizeByCondition(strFullImagePath, 120, 120);
                }
                RadGrid1.Rebind();
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;
                var strOldImagePath = Server.MapPath("~/res/download/thumbs/" + OldImageName);
                var strOldFilePath = Server.MapPath("~/res/download/" + OldFilePath);

                dsUpdateParam["ConvertedDownloadName"].DefaultValue = ConvertedDownloadName;
                dsUpdateParam["ImageName"].DefaultValue = ImageName;
                dsUpdateParam["FilePath"].DefaultValue = FilePath;
                dsUpdateParam["DownloadCategoryID"].DefaultValue = DownloadCategoryID;
                dsUpdateParam["IsAvailable"].DefaultValue = IsAvailable;

                if (!string.IsNullOrEmpty(FilePath))
                {
                    if (File.Exists(strOldFilePath))
                        File.Delete(strOldFilePath);

                    string strFullPath = "~/res/download/" + FilePath;

                    FileFilePath.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                }

                if (!string.IsNullOrEmpty(ImageName))
                {
                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);

                    ImageName = (string.IsNullOrEmpty(ConvertedDownloadName) ? "" : ConvertedDownloadName + "-") + DownloadID + ImageName.Substring(ImageName.LastIndexOf('.'));

                    string strFullPath = "~/res/download/thumbs/" + ImageName;

                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 120, 120);
                }

                
            }
        }
        if (e.CommandName == "DeleteImage")
        {
            var oDownload = new Download();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strDownloadID = s[0];
            var ImageName = s[1];

            oDownload.DownloadImageDelete(strDownloadID);
            DeleteImage(ImageName);
            RadGrid1.Rebind();
        }
    }
    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            var itemtype = e.Item.ItemType;
            var row = itemtype == GridItemType.EditFormItem ? (GridEditFormItem)e.Item : (GridEditFormInsertItem)e.Item;
            var FileImageName = (RadUpload)row.FindControl("FileImageName");
            var FileFilePath = (RadUpload)row.FindControl("FileFilePath");
            var dv = (DataView)ObjectDataSource1.Select();
            var DownloadID = ((HiddenField)row.FindControl("hdnDownloadID")).Value;
            var ddlCategory = (RadComboBox)row.FindControl("ddlCategory");

            if (!string.IsNullOrEmpty(DownloadID))
            {
                dv.RowFilter = "DownloadID = " + DownloadID;

                if (!string.IsNullOrEmpty(dv[0]["DownloadCategoryID"].ToString()))
                    ddlCategory.SelectedValue = dv[0]["DownloadCategoryID"].ToString();
            }
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId1'] = '{0}';", FileImageName.ClientID));
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId2'] = '{0}';", FileFilePath.ClientID));
        }
    }

    #endregion

}