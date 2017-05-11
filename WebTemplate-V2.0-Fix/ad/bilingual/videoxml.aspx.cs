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


public partial class ad_single_photoalbum : System.Web.UI.Page
{
    #region Common Method

    void DeleteImage(string strImageName)
    {
        if (!string.IsNullOrEmpty(strImageName))
        {
            var strImagePath = Server.MapPath("~/" + strImageName);
            if (File.Exists(strImagePath))
                File.Delete(strImagePath);
        }
    }
    void DeleteVideo(string strVideoName)
    {
        if (!string.IsNullOrEmpty(strVideoName))
        {
            var strVideoPath = Server.MapPath("~/" + strVideoName);
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
            ObjectDataSource1.SelectParameters["keyWord"].DefaultValue = value;
            ObjectDataSource1.DataBind();
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "DeleteSelected")
        {
            var oPhotoAlbum = new PhotoAlbum();
            string ide, OldImageName, OldVideoName;

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                ide = item.GetDataKeyValue("ide").ToString();
                OldImageName = ((HiddenField)item.FindControl("hdnImage")).Value;
                OldVideoName = ((HiddenField)item.FindControl("hdnVideo")).Value;

                DeleteImage(OldImageName);
                DeleteVideo(OldVideoName);
                oPhotoAlbum.PhotoAlbumDelete(ide);
            }
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var FileImagePath = (RadUpload)row.FindControl("FileImagePath");
            var FileVideoPath = (RadUpload)row.FindControl("FileVideoPath");

            string strID = ((HiddenField)row.FindControl("hdnID")).Value;
            var strOldImagePath = ((HiddenField)row.FindControl("hdnOldImage")).Value;
            var strOldVideoPath = ((HiddenField)row.FindControl("hdnOldVideo")).Value;
            var strImagePath = FileImagePath.UploadedFiles.Count > 0 ? FileImagePath.UploadedFiles[0].GetName() : "";
            var strVideoPath = FileVideoPath.UploadedFiles.Count > 0 ? FileVideoPath.UploadedFiles[0].GetName() : "";
            var strTitle = ((TextBox)row.FindControl("txtTitle")).Text.Trim();
            var strConvertedTitle = Common.ConvertTitle(strTitle);
            var strDescription = ((TextBox)row.FindControl("txtDescription")).Text.Trim();
            //var strTitleEn = ((TextBox)row.FindControl("txtTitleEn")).Text.Trim();
            //var strDescriptionEn = ((TextBox)row.FindControl("txtDescriptionEn")).Text.Trim();
            var oVideoXML = new VideoXML();
            strID = !string.IsNullOrEmpty(strID) ? strID : oVideoXML.VideoSelectTopID("~/playlist.xml");
            strImagePath = string.IsNullOrEmpty(strImagePath) ? strOldImagePath : "video_" + strID + strImagePath.Substring(strImagePath.LastIndexOf('.'));
            strVideoPath = string.IsNullOrEmpty(strVideoPath) ? strOldVideoPath : "video_" + strID + strVideoPath.Substring(strVideoPath.LastIndexOf('.'));
            

            if (e.CommandName == "PerformInsert")
            {
                var dsInsertParam = ObjectDataSource1.InsertParameters;

                oVideoXML.VideoInsert("~/playlist.xml", strTitle, strDescription, "res/videoxml/" + strVideoPath, "res/videoxml/thumbs/" + strImagePath);

                if (FileImagePath.UploadedFiles.Count > 0)
                {
                    strImagePath = "~/res/videoxml/thumbs/" + strImagePath;
                    FileImagePath.UploadedFiles[0].SaveAs(Server.MapPath(strImagePath));
                }

                if (FileVideoPath.UploadedFiles.Count > 0)
                {
                    strVideoPath = "~/res/videoxml/" + strVideoPath;
                    FileVideoPath.UploadedFiles[0].SaveAs(Server.MapPath(strVideoPath));
                }
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;

                oVideoXML.VideoUpdate("~/playlist.xml", strID, strTitle, strDescription, "res/videoxml/" + strVideoPath, "res/videoxml/thumbs/" + strImagePath);

                if (FileImagePath.UploadedFiles.Count > 0)
                {
                    strOldImagePath = Server.MapPath("~/" + strOldImagePath);
                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);

                    strImagePath = "~/res/videoxml/thumbs/" + strImagePath;
                    FileImagePath.UploadedFiles[0].SaveAs(Server.MapPath(strImagePath));
                }

                if (FileVideoPath.UploadedFiles.Count > 0)
                {
                    strOldVideoPath = Server.MapPath("~/" + strOldVideoPath);
                    if (File.Exists(strOldVideoPath))
                        File.Delete(strOldVideoPath);

                    strVideoPath = "~/res/videoxml/" + strVideoPath;
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
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId1'] = '{0}';", FileImagePath.ClientID));
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId2'] = '{0}';", FileVideoPath.ClientID));
        }
    }
    #endregion
}