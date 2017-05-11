using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.IO;
using TLLib;

public partial class ad_single_projectvideo : System.Web.UI.Page
{
    #region Common Method

    void DeleteImage(string strOldImageName)
    {
        if (!string.IsNullOrEmpty(strOldImageName))
        {
            var strOldImagePath = Server.MapPath("~/res/project/video/thumbs/" + strOldImageName);

            if (File.Exists(strOldImagePath))
                File.Delete(strOldImagePath);
        }
    }

    void DeleteVideo(string strOldVideoName)
    {
        if (!string.IsNullOrEmpty(strOldVideoName))
        {
            var strOldVideoPath = Server.MapPath("~/res/project/video/" + strOldVideoName);

            if (File.Exists(strOldVideoPath))
                File.Delete(strOldVideoPath);
        }
    }

    #endregion

    #region Event

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void RadSlider1_ValueChanged(object sender, EventArgs e)
    {
        var selectedValue = ((RadSlider)sender).Value;

        if (selectedValue == 1m)
        {
            ImageHeight = Unit.Pixel(150);
            ImageWidth = Unit.Pixel(150);
            RadListView1.PageSize = 20;
        }
        else if (selectedValue == 2m)
        {
            ImageHeight = Unit.Pixel(200);
            ImageWidth = Unit.Pixel(200);
            RadListView1.PageSize = 10;
        }
        else if (selectedValue == 3m)
        {
            ImageHeight = Unit.Pixel(350);
            ImageWidth = Unit.Pixel(350);
            RadListView1.PageSize = 6;
        }

        RadListView1.CurrentPageIndex = 0;
        RadListView1.Rebind();
    }

    protected Unit ImageWidth
    {
        get
        {
            object state = ViewState["ImageWidth"] ?? Unit.Pixel(150);
            return (Unit)state;
        }
        private set { ViewState["ImageWidth"] = value; }
    }

    protected Unit ImageHeight
    {
        get
        {
            object state = ViewState["ImageHeight"] ?? Unit.Pixel(150);
            return (Unit)state;
        }
        private set { ViewState["ImageHeight"] = value; }
    }

    protected void RadListView1_ItemCreated(object sender, RadListViewItemEventArgs e)
    {
        if (e.Item.ItemType == RadListViewItemType.InsertItem || e.Item.ItemType == RadListViewItemType.EditItem)
        {
            var item = e.Item;
            var FileImagePath = (RadUpload)item.FindControl("FileImagePath");
            var FileVideoPath = (RadUpload)item.FindControl("FileVideoPath");
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId1'] = '{0}';", FileImagePath.ClientID));
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId2'] = '{0}';", FileVideoPath.ClientID));
        }
    }
    protected void RadListView1_ItemCommand(object sender, RadListViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
            {
                var item = e.ListViewItem;
                var FileImagePath = (RadUpload)item.FindControl("FileImagePath");
                var FileVideoPath = (RadUpload)item.FindControl("FileVideoPath");

                string strProjectVideoID;
                var strProjectID = Request.QueryString["PI"];
                var strProjectTitle = ((Label)FormView1.FindControl("lblProjectTitle")).Text.Trim();
                var strConvertedProjectTitle = Common.ConvertTitle(strProjectTitle);
                var strImagePath = FileImagePath.UploadedFiles.Count > 0 ? FileImagePath.UploadedFiles[0].GetName() : "";
                var strVideoPath = FileVideoPath.UploadedFiles.Count > 0 ? FileVideoPath.UploadedFiles[0].GetName() : "";
                var strTitle = ((TextBox)item.FindControl("txtTitle")).Text.Trim();
                var strDescription = ((TextBox)item.FindControl("txtDescription")).Text.Trim();
                var strTitleEn = ((TextBox)item.FindControl("txtTitleEn")).Text.Trim();
                var strDescriptionEn = ((TextBox)item.FindControl("txtDescriptionEn")).Text.Trim();
                var strIsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();
                var strPriority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                var oProjectVideo = new ProjectVideo();

                if (e.CommandName == "PerformInsert")
                {
                    strProjectVideoID = oProjectVideo.ProjectVideoInsert(
                            strTitle,
                            strDescription,
                            strTitleEn,
                            strDescriptionEn,
                            strConvertedProjectTitle,
                            strImagePath,
                            strVideoPath,
                            strProjectID,
                            strIsAvailable,
                            strPriority).ToString();
                    RadListView1.InsertItemPosition = RadListViewInsertItemPosition.None;
                }
                else
                {
                    strProjectVideoID = ((HiddenField)item.FindControl("hdnProjectVideoID")).Value;
                    var strOldImagePath = ((HiddenField)item.FindControl("hdnImagePath")).Value;
                    var strOldVideoPath = ((HiddenField)item.FindControl("hdnProjectVideoPath")).Value;
                    var dsUpdateParam = ObjectDataSource1.UpdateParameters;

                    if (!string.IsNullOrEmpty(strVideoPath))
                    {
                        strOldVideoPath = Server.MapPath("~/res/project/video/" + strOldVideoPath);
                        if (File.Exists(strOldVideoPath))
                            File.Delete(strOldVideoPath);
                    }
                    if (!string.IsNullOrEmpty(strImagePath))
                    {
                        strOldImagePath = Server.MapPath("~/res/project/video/thumbs/" + strOldImagePath);
                        if (File.Exists(strOldImagePath))
                            File.Delete(strOldImagePath);
                    }

                    dsUpdateParam["ImagePath"].DefaultValue = strImagePath;
                    dsUpdateParam["ProjectVideoPath"].DefaultValue = strVideoPath;
                    dsUpdateParam["ConvertedTitle"].DefaultValue = strConvertedProjectTitle;
                }


                string strFullVideoPath = "~/res/project/video/" + (string.IsNullOrEmpty(strConvertedProjectTitle) ? "" : strConvertedProjectTitle + "-") + strProjectVideoID + Path.GetExtension(strVideoPath);
                string strFullImagePath = "~/res/project/video/thumbs/" + (string.IsNullOrEmpty(strConvertedProjectTitle) ? "" : strConvertedProjectTitle + "-") + strProjectVideoID + Path.GetExtension(strImagePath);

                if (!string.IsNullOrEmpty(strVideoPath))
                {
                    FileVideoPath.UploadedFiles[0].SaveAs(Server.MapPath(strFullVideoPath));
                }
                if (!string.IsNullOrEmpty(strImagePath))
                {
                    FileImagePath.UploadedFiles[0].SaveAs(Server.MapPath(strFullImagePath));
                    ResizeCropImage.ResizeByCondition(strFullImagePath, 600, 600);
                }
            }
            else if (e.CommandName == "Delete")
            {
                var strOldImagePath = ((HiddenField)e.ListViewItem.FindControl("hdnImagePath")).Value;
                DeleteImage(strOldImagePath);
            }
            else if (e.CommandName == "QuickUpdate")
            {
                string ProjectVideoID, Priority, IsAvailable;
                var oProjectVideo = new ProjectVideo();

                foreach (RadListViewDataItem item in RadListView1.Items)
                {
                    ProjectVideoID = item.GetDataKeyValue("ProjectVideoID").ToString();
                    Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                    IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                    oProjectVideo.ProjectVideoQuickUpdate(
                        ProjectVideoID,
                        IsAvailable,
                        Priority
                    );
                }
            }
            else if (e.CommandName == "DeleteSelected")
            {
                var oProjectVideo = new ProjectVideo();
                string ProjectVideoID, OldImagePath, OldVideoPath;

                foreach (RadListViewDataItem item in RadListView1.Items)
                {
                    var chkSelect = (CheckBox)item.FindControl("chkSelect");

                    if (chkSelect.Checked)
                    {
                        ProjectVideoID = item.GetDataKeyValue("ProjectVideoID").ToString();
                        OldImagePath = ((HiddenField)item.FindControl("hdnImagePath")).Value;
                        OldVideoPath = ((HiddenField)item.FindControl("hdnVideoPath")).Value;

                        DeleteImage(OldImagePath);
                        DeleteVideo(OldVideoPath);
                        oProjectVideo.ProjectVideoDelete(ProjectVideoID);
                    }
                }
            }
            RadListView1.Rebind();
        }
        catch (Exception ex)
        {
            lblError.Text = ex.Message;
        }
    }

    #endregion
}