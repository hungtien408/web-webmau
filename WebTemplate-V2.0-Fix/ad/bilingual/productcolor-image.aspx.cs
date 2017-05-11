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

public partial class ad_single_service : System.Web.UI.Page
{

    #region Common Method

    protected void DropDownList_DataBound(object sender, EventArgs e)
    {
        var cbo = (RadComboBox)sender;
        cbo.Items.Insert(0, new RadComboBoxItem(""));
    }

    void DeletePhotoAlbum(string strImageName)
    {
        if (!string.IsNullOrEmpty(strImageName))
        {
            var strImagePath = Server.MapPath("~/res/productoption/" + strImageName);
            var strThumbImagePath = Server.MapPath("~/res/productoption/thumbs/" + strImageName);

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
    protected void RadListView1_ItemCommand(object sender, RadListViewCommandEventArgs e)
    {
        try
        {
            var RadListView1 = (RadListView)sender;
            //var Parent = RadListView1.NamingContainer;
            //var OdsProductPhotoAlbum = (ObjectDataSource)Parent.FindControl("OdsProductPhotoAlbum");

            if (e.CommandName == "Update")
            {
                var item = e.ListViewItem;
                var dsUpdateParam = OdsProductPhotoAlbum.UpdateParameters;

                var strOldImageName = ((HiddenField)item.FindControl("hdnImageName")).Value;
                //var strOldImagePath = Server.MapPath("~/res/productoption/" + strOldImageName);
                //var strOldThumbImagePath = Server.MapPath("~/res/productoption/thumbs/" + strOldImageName);

                //var FileImageName = (RadUpload)item.FindControl("FileImageName");
                //var strImageName = FileImageName.UploadedFiles.Count > 0 ? FileImageName.UploadedFiles[0].GetName() : "";
                //var strImageName = FileImageName.UploadedFiles.Count > 0 ? Guid.NewGuid().GetHashCode().ToString("X") + FileImageName.UploadedFiles[0].GetExtension() : strOldImageName;

                //var strProductOptionTitle = ((RadTextBox)item.FindControl("txtProductOptionTitle")).Text.Trim();
                //var strConvertedProductOptionTitle = Common.ConvertTitle(strProductOptionTitle);
                var strIsAvailable = ((CheckBox)item.FindControl("chkAddIsAvailable")).Checked.ToString();
                var strProductOptionCategoryID = string.IsNullOrEmpty(Request.QueryString["poi"])
                                                     ? ""
                                                     : Request.QueryString["poi"];

                dsUpdateParam["ImageName"].DefaultValue = strOldImageName;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;
                dsUpdateParam["ProductOptionCategoryID"].DefaultValue = strProductOptionCategoryID;

                //if (!string.IsNullOrEmpty(strImageName))
                //{
                //    if (File.Exists(strOldImagePath))
                //        File.Delete(strOldImagePath);
                //    if (File.Exists(strOldThumbImagePath))
                //        File.Delete(strOldThumbImagePath);

                //    //strImageName = (string.IsNullOrEmpty(strConvertedProductOptionTitle) ? "" : strConvertedProductOptionTitle + "-") + strProductOptionID + strImageName.Substring(strImageName.LastIndexOf('.'));
                //    //strImageName = Guid.NewGuid().GetHashCode().ToString("X") + FileImageName.UploadedFiles[0].GetExtension();
                //    string strFullPath = "~/res/productoption/" + strImageName;

                //    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                //    string bgColor = "#ffffff";
                //    ResizeCropImage.CreateThumbNailWithBackGroundColor("~/res/productoption/", "~/res/productoption/thumbs/", strImageName, 70, 82, bgColor);
                //    ResizeCropImage.ResizeWithBackGroundColor(strFullPath, 1000, 1182, bgColor);
                //}
                RadListView1.DataBind();
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
                //var Parent = RadListView2.NamingContainer;
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
        //var Parent = FileImageAlbum.NamingContainer;
        //var ProductID = ((HiddenField)Parent.FindControl("hdnProductID")).Value;
        var ProductOptionCategoryID = string.IsNullOrEmpty(Request.QueryString["poi"]) ? "" : Request.QueryString["poi"];
        //var RadListView1 = (RadListView)Parent.FindControl("RadListView1");
        //var RadListView2 = (RadListView)Parent.FindControl("RadListView2");


        string newName = Guid.NewGuid().GetHashCode().ToString("X") + e.File.GetExtension();
        string targetFolder = "~/res/productoption/" + newName;
        e.File.SaveAs(Server.MapPath(targetFolder));

        string bgColor = "#ffffff";
        ResizeCropImage.CreateThumbNailWithBackGroundColor("~/res/productoption/", "~/res/productoption/thumbs/", newName, 70, 82, bgColor);
        ResizeCropImage.ResizeWithBackGroundColor(targetFolder, 1000, 1182, bgColor);

        //ResizeCropImage.ResizeByCondition(targetFolder + newName, 800, 800);
        //ResizeCropImage.CreateThumbNailByCondition("~/res/productoption/", "~/res/productoption/thumbs/", newName, 120, 120);

        if (string.IsNullOrEmpty(ProductOptionCategoryID))
        {
            TempImage.Rows.Add(new object[] { newName });

            RadListView2.DataSource = TempImage;
            RadListView2.DataBind();
        }
        else
        {
            var oProductOption = new ProductOption();

            oProductOption.ProductOptionInsert(newName,
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                ProductOptionCategoryID,
                "1",
                "0",
                "0",
                "1",
                ""
                );
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
    //protected void RadListView1_ItemDataBound(object sender, RadListViewItemEventArgs e)
    //{
    //    if (e.Item is RadListViewEditableItem && e.Item.IsInEditMode)
    //    {
    //        var itemtype = e.Item.ItemType;
    //        var row = itemtype == RadListViewItemType.EditItem ? (RadListViewEditableItem)e.Item : (RadListViewInsertItem)e.Item;
    //        var FileImageName = (RadUpload)row.FindControl("FileImageName");
    //        //var dv = (DataView)OdsProductPhotoAlbum.Select();
    //        //var ProductOptionID = ((HiddenField)row.FindControl("hdnProductOptionID")).Value;
    //        //var ddlCategory = (RadComboBox)row.FindControl("ddlCategory");

    //        //if (!string.IsNullOrEmpty(ProductOptionID))
    //        //{
    //        //    dv.RowFilter = "ProductOptionID = " + ProductOptionID;

    //        //    if (!string.IsNullOrEmpty(dv[0]["ProductOptionCategoryID"].ToString()))
    //        //        ddlCategory.SelectedValue = dv[0]["ProductOptionCategoryID"].ToString();
    //        //}
    //        RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FileImageName.ClientID));
    //    }
    //}
}