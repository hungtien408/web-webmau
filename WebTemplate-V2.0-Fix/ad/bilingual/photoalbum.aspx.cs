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

    protected void DropDownList_DataBound(object sender, EventArgs e)
    {
        var cbo = (RadComboBox)sender;
        cbo.Items.Insert(0, new RadComboBoxItem(""));
    }

    void DeleteImage(string strImageName)
    {
        if (!string.IsNullOrEmpty(strImageName))
        {
            string strOldImagePath = Server.MapPath("~/res/photoalbumcategory/" + strImageName);
            if (File.Exists(strOldImagePath))
                File.Delete(strOldImagePath);
        }
    }

    void DeletePhotoAlbum(string strImageName)
    {
        if (!string.IsNullOrEmpty(strImageName))
        {
            var strImagePath = Server.MapPath("~/res/photoalbum/" + strImageName);
            var strThumbImagePath = Server.MapPath("~/res/photoalbum/thumbs/" + strImageName);

            if (File.Exists(strImagePath))
                File.Delete(strImagePath);
            if (File.Exists(strThumbImagePath))
                File.Delete(strThumbImagePath);
        }
    }

    #endregion

    #region Event

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TempImage = new DataTable();
            TempImage.Columns.Add("ImageName");
        }
    }

    protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
    {
        if (e.CommandName == "QuickUpdate")
        {
            string PhotoAlbumCategoryID, Priority, IsShowOnMenu, IsShowOnHomePage, IsAvailable;
            var oPhotoAlbumCategory = new PhotoAlbumCategory();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                PhotoAlbumCategoryID = item.GetDataKeyValue("PhotoAlbumCategoryID").ToString();
                Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                IsShowOnMenu = ((CheckBox)item.FindControl("chkIsShowOnMenu")).Checked.ToString();
                IsShowOnHomePage = ((CheckBox)item.FindControl("chkIsShowOnHomePage")).Checked.ToString();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oPhotoAlbumCategory.PhotoAlbumCategoryQuickUpdate(
                    PhotoAlbumCategoryID,
                    IsShowOnMenu,
                    IsShowOnHomePage,
                    IsAvailable,
                    Priority
                );
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            var oPhotoAlbum = new PhotoAlbum();

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                string strImageName = ((HiddenField)item.FindControl("hdnImageName")).Value;

                DeleteImage(strImageName);

                var PhotoAlbumCategoryID = item["PhotoAlbumCategoryID"].Text;

                var dtPhotoAlbum = oPhotoAlbum.PhotoAlbumSelectAll("", "", "", PhotoAlbumCategoryID, "", "", "");

                if (dtPhotoAlbum.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtPhotoAlbum.Rows)
                    {
                        strImageName = dr["ImageName"].ToString();
                        DeletePhotoAlbum(strImageName);
                    }
                }
            }
        }
        else if (e.CommandName == "InitInsert" || e.CommandName == "EditSelected" || e.CommandName == "Edit")
        {
            TempImage.Rows.Clear();
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var FileImageName = (RadUpload)row.FindControl("FileImageName");

            string PhotoAlbumCategoryID = ((HiddenField)row.FindControl("hdnPhotoAlbumCategoryID")).Value;
            string strPhotoAlbumCategoryName = ((RadTextBox)row.FindControl("txtPhotoAlbumCategoryName")).Text.Trim();
            string strPhotoAlbumCategoryNameEn = ((RadTextBox)row.FindControl("txtPhotoAlbumCategoryNameEn")).Text.Trim();
            string strConvertedPhotoAlbumCategoryName = Common.ConvertTitle(strPhotoAlbumCategoryName);
            string strImageName = FileImageName.UploadedFiles.Count > 0 ? FileImageName.UploadedFiles[0].GetName() : "";
            string strIsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();
            string strIsShowOnMenu = ((CheckBox)row.FindControl("chkIsShowOnMenu")).Checked.ToString();
            string strIsShowOnHomePage = ((CheckBox)row.FindControl("chkIsShowOnHomePage")).Checked.ToString();
            string strPriority = ((RadNumericTextBox)row.FindControl("txtPriority")).Text.Trim();

            var oPhotoAlbumCategory = new PhotoAlbumCategory();

            if (e.CommandName == "PerformInsert")
            {
                strImageName = oPhotoAlbumCategory.PhotoAlbumCategoryInsert(
                    strImageName,
                    strPhotoAlbumCategoryName,
                    strPhotoAlbumCategoryNameEn,
                    strConvertedPhotoAlbumCategoryName,
                    strIsShowOnMenu,
                    strIsShowOnHomePage,
                    strIsAvailable,
                    strPriority
                    );
                string strFullPath = "~/res/photoalbumcategory/" + strImageName;

                if (!string.IsNullOrEmpty(strImageName))
                {
                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 200, 200);
                }

                PhotoAlbumCategoryID = oPhotoAlbumCategory.PhotoAlbumCategoryID;

                //Insert Album's Images
                if (TempImage.Rows.Count > 0)
                {
                    var oPhotoAlbum = new PhotoAlbum();

                    foreach (DataRow dr in TempImage.Rows)
                        oPhotoAlbum.PhotoAlbumInsert(dr["ImageName"].ToString(), "", "", "", "", "", PhotoAlbumCategoryID, "True", "");
                }

                RadGrid1.Rebind();
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;
                var strPhotoAlbumCategoryID = row.GetDataKeyValue("PhotoAlbumCategoryID").ToString();
                var strOldImageName = ((HiddenField)row.FindControl("hdnImageName")).Value;
                var strOldImagePath = Server.MapPath("~/res/photoalbumcategory/" + strOldImageName);

                dsUpdateParam["PhotoAlbumCategoryName"].DefaultValue = strPhotoAlbumCategoryName;
                dsUpdateParam["ConvertedPhotoAlbumCategoryName"].DefaultValue = strConvertedPhotoAlbumCategoryName;
                dsUpdateParam["ImageName"].DefaultValue = strImageName;
                dsUpdateParam["IsShowOnMenu"].DefaultValue = strIsShowOnMenu;
                dsUpdateParam["IsShowOnHomePage"].DefaultValue = strIsShowOnHomePage;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;

                if (!string.IsNullOrEmpty(strImageName))
                {
                    var strFullPath = "~/res/photoalbumcategory/" + strConvertedPhotoAlbumCategoryName + "-" + strPhotoAlbumCategoryID + strImageName.Substring(strImageName.LastIndexOf('.'));

                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);

                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 200, 200);
                }
            }
        }
        else if (e.CommandName == "Cancel")
        {
            if (TempImage.Rows.Count > 0)
            {
                foreach (DataRow row in TempImage.Rows)
                {
                    DeletePhotoAlbum(row["ImageName"].ToString());
                }
                TempImage.Rows.Clear();
            }
        }
        else if (e.CommandName == "DeleteImage")
        {
            var oPhotoAlbumCategory = new PhotoAlbumCategory();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strPhotoAlbumCategoryID = s[0];
            var strImageName = s[1];

            oPhotoAlbumCategory.PhotoAlbumCategoryImageDelete(strPhotoAlbumCategoryID);
            DeleteImage(strImageName);
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

            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FileImageName.ClientID));
        }
    }

    protected void RadListView1_ItemCommand(object sender, RadListViewCommandEventArgs e)
    {
        try
        {
            var RadListView1 = (RadListView)sender;
            var Parent = RadListView1.NamingContainer;
            var OdsPhotoAlbum = (ObjectDataSource)Parent.FindControl("OdsPhotoAlbum");

            if (e.CommandName == "Update")
            {
                var item = e.ListViewItem;
                var dsUpdateParam = OdsPhotoAlbum.UpdateParameters;

                var strOldImageName = ((HiddenField)e.ListViewItem.FindControl("hdnImageName")).Value;
                var strIsAvailable = ((CheckBox)item.FindControl("chkAddIsAvailable")).Checked.ToString();

                dsUpdateParam["ImageName"].DefaultValue = strOldImageName;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;
            }
            else if (e.CommandName == "Delete")
            {
                var strOldImageName = ((HiddenField)e.ListViewItem.FindControl("hdnImageName")).Value;
                DeletePhotoAlbum(strOldImageName);
            }
        }
        catch (Exception ex)
        {
            lblError.Text = ex.Message;
        }
    }

    protected void RadListView2_ItemCommand(object sender, RadListViewCommandEventArgs e)
    {
        try
        {
            var RadListView2 = (RadListView)sender;
            if (e.CommandName == "Delete")
            {
                var Parent = RadListView2.NamingContainer;
                var strOldImageName = ((HiddenField)e.ListViewItem.FindControl("hdnImageName")).Value;
                DeletePhotoAlbum(strOldImageName);

                TempImage.Rows.Cast<DataRow>().Where(c => c["ImageName"].ToString() == strOldImageName).Single().Delete();
                RadListView2.DataSource = TempImage;
                RadListView2.DataBind();
            }
        }
        catch (Exception ex)
        {
            lblError.Text = ex.Message;
        }
    }

    protected void FileImageAlbum_FileUploaded(object sender, FileUploadedEventArgs e)
    {
        var FileImageAlbum = (RadAsyncUpload)sender;
        var Parent = FileImageAlbum.NamingContainer;
        var PhotoAlbumCategoryID = ((HiddenField)Parent.FindControl("hdnPhotoAlbumCategoryID")).Value;
        var RadListView1 = (RadListView)Parent.FindControl("RadListView1");
        var RadListView2 = (RadListView)Parent.FindControl("RadListView2");

        string targetFolder = "~/res/photoalbum/";
        string newName = Guid.NewGuid().GetHashCode().ToString("X") + e.File.GetExtension();
        e.File.SaveAs(Server.MapPath(targetFolder + newName));

        ResizeCropImage.ResizeByCondition(targetFolder + newName, 800, 800);

        ResizeCropImage.CreateThumbNailByCondition("~/res/photoalbum/", "~/res/photoalbum/thumbs/", newName, 120, 120);

        if (string.IsNullOrEmpty(PhotoAlbumCategoryID))
        {
            TempImage.Rows.Add(new object[] { newName });

            RadListView2.DataSource = TempImage;
            RadListView2.DataBind();
        }
        else
        {
            var oPhotoAlbum = new PhotoAlbum();

            oPhotoAlbum.PhotoAlbumInsert(newName, "", "", "", "", "", PhotoAlbumCategoryID, "True", "");
            RadListView1.Rebind();
        }
    }
    #endregion

    #region Properties

    private DataTable TempImage
    {
        get { return (DataTable)ViewState["TempImage"]; }
        set { ViewState["TempImage"] = value; }
    }

    #endregion
}