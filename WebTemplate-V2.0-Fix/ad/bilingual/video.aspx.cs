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


public partial class ad_single_video : System.Web.UI.Page
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
            var strImagePath = Server.MapPath("~/res/video/thumbs/" + strImageName);
            if (File.Exists(strImagePath))
                File.Delete(strImagePath);
        }
    }
    void DeleteVideo(string strVideoName)
    {
        if (!string.IsNullOrEmpty(strVideoName))
        {
            var strVideoPath = Server.MapPath("~/res/video/" + strVideoName);
            if (File.Exists(strVideoPath))
                File.Delete(strVideoPath);
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
            ObjectDataSource1.SelectParameters["Title"].DefaultValue = value;
            ObjectDataSource1.DataBind();
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "DeleteSelected")
        {
            var oVideo = new Video();
            string VideoID, OldImageName, OldVideoName;

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                VideoID = item.GetDataKeyValue("VideoID").ToString();
                OldImageName = ((HiddenField)item.FindControl("hdnImagePath")).Value;
                OldVideoName = ((HiddenField)item.FindControl("hdnVideoPath")).Value;

                DeleteImage(OldImageName);
                DeleteVideo(OldVideoName);
                oVideo.VideoDelete(VideoID);
            }
        }
        else if (e.CommandName == "QuickUpdate")
        {
            string VideoID, Priority, IsAvailable;
            var oVideo = new Video();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                VideoID = item.GetDataKeyValue("VideoID").ToString();
                Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oVideo.VideoQuickUpdate(
                    VideoID,
                    IsAvailable,
                    Priority
                );
            }
        }
        else if (e.CommandName == "DeleteImage")
        {
            var oVideo = new Video();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strVideoID = s[0];
            var strImageName = s[1];

            oVideo.VideoImageDelete(strVideoID);
            DeleteImage(strImageName);
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var FileImagePath = (RadUpload)row.FindControl("FileImagePath");
            var FileVideoPath = (RadUpload)row.FindControl("FileVideoPath");

            var strVideoID = ((HiddenField)row.FindControl("hdnVideoID")).Value;
            var strOldImagePath = ((HiddenField)row.FindControl("hdnOldImagePath")).Value;
            var strOldVideoPath = ((HiddenField)row.FindControl("hdnOldVideoPath")).Value;
            var strImagePath = FileImagePath.UploadedFiles.Count > 0 ? FileImagePath.UploadedFiles[0].GetName() : "";
            var strVideoPath = FileVideoPath.UploadedFiles.Count > 0 ? FileVideoPath.UploadedFiles[0].GetName() : "";
            var strTitle = ((TextBox)row.FindControl("txtTitle")).Text.Trim();
            var strTitleEn = ((TextBox)row.FindControl("txtTitleEn")).Text.Trim();
            var strConvertedTitle = Common.ConvertTitle(strTitle);
            var strDescription = ((TextBox)row.FindControl("txtDescription")).Text.Trim();
            var strDescriptionEn = ((TextBox)row.FindControl("txtDescriptionEn")).Text.Trim();
            var strVideoCategoryID = ((RadComboBox)row.FindControl("ddlCategory")).SelectedValue;
            var strIsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();

            var oVideo = new Video();
            strVideoID = !string.IsNullOrEmpty(strVideoID) ? strVideoID : oVideo.VideoSelectMaxID();
            strImagePath = string.IsNullOrEmpty(strImagePath) ? "" : (string.IsNullOrEmpty(strConvertedTitle) ? "" : strConvertedTitle + "-") + strVideoID + strImagePath.Substring(strImagePath.LastIndexOf('.'));
            strVideoPath = string.IsNullOrEmpty(strVideoPath) ? "" : (string.IsNullOrEmpty(strConvertedTitle) ? "" : strConvertedTitle + "-") + strVideoID + strVideoPath.Substring(strVideoPath.LastIndexOf('.'));


            if (e.CommandName == "PerformInsert")
            {
                var dsInsertParam = ObjectDataSource1.InsertParameters;

                dsInsertParam["ImagePath"].DefaultValue = strImagePath;
                dsInsertParam["VideoPath"].DefaultValue = strVideoPath;
                dsInsertParam["ConvertedTitle"].DefaultValue = strConvertedTitle;
                dsInsertParam["VideoCategoryID"].DefaultValue = strVideoCategoryID;
                dsInsertParam["IsAvailable"].DefaultValue = strIsAvailable;

                if (FileImagePath.UploadedFiles.Count > 0)
                {
                    strImagePath = "~/res/video/thumbs/" + strImagePath;
                    FileImagePath.UploadedFiles[0].SaveAs(Server.MapPath(strImagePath));
                }

                if (FileVideoPath.UploadedFiles.Count > 0)
                {
                    strVideoPath = "~/res/video/" + strVideoPath;
                    FileVideoPath.UploadedFiles[0].SaveAs(Server.MapPath(strVideoPath));
                }
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;

                dsUpdateParam["ImagePath"].DefaultValue = strImagePath;
                dsUpdateParam["VideoPath"].DefaultValue = strVideoPath;
                dsUpdateParam["ConvertedTitle"].DefaultValue = strConvertedTitle;
                dsUpdateParam["VideoCategoryID"].DefaultValue = strVideoCategoryID;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;

                if (FileImagePath.UploadedFiles.Count > 0)
                {
                    strOldImagePath = Server.MapPath("~/res/video/thumbs/" + strOldImagePath);
                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);

                    strImagePath = "~/res/video/thumbs/" + strImagePath;
                    FileImagePath.UploadedFiles[0].SaveAs(Server.MapPath(strImagePath));
                }

                if (FileVideoPath.UploadedFiles.Count > 0)
                {
                    strOldVideoPath = Server.MapPath("~/res/video/" + strOldVideoPath);
                    if (File.Exists(strOldVideoPath))
                        File.Delete(strOldVideoPath);

                    strVideoPath = "~/res/video/" + strVideoPath;
                    FileVideoPath.UploadedFiles[0].SaveAs(Server.MapPath(strVideoPath));
                }
            }
        }
    }
    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            var itemtype = e.Item.ItemType;
            var row = itemtype == GridItemType.EditFormItem ? (GridEditFormItem)e.Item : (GridEditFormInsertItem)e.Item;
            var FileImagePath = (RadUpload)row.FindControl("FileImagePath");
            var FileVideoPath = (RadUpload)row.FindControl("FileVideoPath");

            var dv = (DataView)ObjectDataSource1.Select();
            var VideoID = ((HiddenField)row.FindControl("hdnVideoID")).Value;
            var ddlCategory = (RadComboBox)row.FindControl("ddlCategory");

            if (!string.IsNullOrEmpty(VideoID))
            {
                dv.RowFilter = "VideoID = " + VideoID;

                if (!string.IsNullOrEmpty(dv[0]["VideoCategoryID"].ToString()))
                    ddlCategory.SelectedValue = dv[0]["VideoCategoryID"].ToString();
            }

            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId1'] = '{0}';", FileImagePath.ClientID));
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId2'] = '{0}';", FileVideoPath.ClientID));
        }
    }
    #endregion
}