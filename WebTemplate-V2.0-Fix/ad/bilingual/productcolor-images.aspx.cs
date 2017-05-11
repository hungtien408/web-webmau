using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.IO;
using TLLib;
using System.Data;

public partial class ad_single_productphotoalbum : System.Web.UI.Page
{
    #region Common Method

    void DeleteImage(string strOldImageName)
    {
        if (!string.IsNullOrEmpty(strOldImageName))
        {
            var strOldImagePath = Server.MapPath("~/res/productoption/" + strOldImageName);
            var strOldThumbImagePath = Server.MapPath("~/res/productoption/thumbs/" + strOldImageName);

            if (File.Exists(strOldImagePath))
                File.Delete(strOldImagePath);
            if (File.Exists(strOldThumbImagePath))
                File.Delete(strOldThumbImagePath);
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
            var FileImageName = (RadUpload)item.FindControl("FileImageName");
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FileImageName.ClientID));
        }
    }
    protected void RadListView1_ItemCommand(object sender, RadListViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "PerformInsert")
            {
                var item = e.ListViewItem;
                var FileImageName = (RadUpload)item.FindControl("FileImageName");

                var strProductName = ((Label)FormView1.FindControl("lblProductName")).Text.Trim();
                var strConvertedProductName = Common.ConvertTitle(strProductName);
                var strImageName = FileImageName.UploadedFiles.Count > 0 ? Guid.NewGuid().GetHashCode().ToString("X") + FileImageName.UploadedFiles[0].GetExtension() : "";
                var strTitle = ((RadTextBox)item.FindControl("txtTitle")).Text.Trim();
                var strDescription = ((RadTextBox)item.FindControl("txtDescription")).Text.Trim();
                var strTitleEn = ((RadTextBox)item.FindControl("txtTitleEn")).Text.Trim();
                var strDescriptionEn = ((RadTextBox)item.FindControl("txtDescriptionEn")).Text.Trim();
                var IsAvailable = ((CheckBox)item.FindControl("chkAddIsAvailable")).Checked.ToString();
                var Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                var oProductOption = new ProductOption();

                oProductOption.ProductOptionInsert(
                    strImageName,
                    "",
                    "",
                    strTitle,
                    strConvertedProductName,
                    strDescription,
                    "",
                    "",
                    "",
                    "",
                    strTitleEn,
                    strDescriptionEn,
                    "",
                    "",
                    Request.QueryString["poi"],
                    "1",
                    "0",
                    "0",
                    IsAvailable,
                    Priority);

                string strFullPath = "~/res/productoption/" + strImageName;

                if (!string.IsNullOrEmpty(strImageName))
                {
                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));

                    string bgColor = "#ffffff";
                    ResizeCropImage.CreateThumbNailWithBackGroundColor("~/res/productoption/", "~/res/productoption/thumbs/", strImageName, 70, 82, bgColor);
                    ResizeCropImage.ResizeWithBackGroundColor(strFullPath, 1000, 1182, bgColor);
                    //ResizeCropImage.ResizeByCondition(strFullPath, 600, 600);
                    //ResizeCropImage.CreateThumbNailByCondition("~/res/productoption/", "~/res/productoption/thumbs/", strImageName, 120, 120);
                }
                RadListView1.InsertItemPosition = RadListViewInsertItemPosition.None;
            }
            else if (e.CommandName == "Update")
            {
                var item = e.ListViewItem;
                var FileImageName = (RadUpload)item.FindControl("FileImageName");
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;

                var strProductOptionID = ((HiddenField)item.FindControl("hdnProductOptionID")).Value;
                //var strProductName = ((Label)FormView1.FindControl("lblProductName")).Text.Trim();
                //var strConvertedProductName = Common.ConvertTitle(strProductName);
                var strOldImageName = ((HiddenField)item.FindControl("hdnImageName")).Value;
                var strIsAvailable = ((CheckBox)item.FindControl("chkAddIsAvailable")).Checked.ToString();
                var strImageName = FileImageName.UploadedFiles.Count > 0 ? Guid.NewGuid().GetHashCode().ToString("X") + FileImageName.UploadedFiles[0].GetExtension() : "";
                var strProductOptionCategoryID = string.IsNullOrEmpty(Request.QueryString["poi"])
                                                    ? ""
                                                    : Request.QueryString["poi"];
                dsUpdateParam["ImageName"].DefaultValue = !string.IsNullOrEmpty(strImageName) ? strImageName : strOldImageName;
                //dsUpdateParam["ConvertedProductName"].DefaultValue = strConvertedProductName;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;
                dsUpdateParam["ProductOptionCategoryID"].DefaultValue = strProductOptionCategoryID;

                if (!string.IsNullOrEmpty(strImageName))
                {
                    var strOldImagePath = Server.MapPath("~/res/productoption/" + strOldImageName);
                    var strOldThumbImagePath = Server.MapPath("~/res/productoption/thumbs/" + strOldImageName);

                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);
                    if (File.Exists(strOldThumbImagePath))
                        File.Delete(strOldThumbImagePath);

                    //strImageName = (string.IsNullOrEmpty(strConvertedProductName) ? "" : strConvertedProductName + "-") + strProductOptionID + strImageName.Substring(strImageName.LastIndexOf('.'));
                    string strFullPath = "~/res/productoption/" + strImageName;

                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    string bgColor = "#ffffff";
                    ResizeCropImage.CreateThumbNailWithBackGroundColor("~/res/productoption/", "~/res/productoption/thumbs/", strImageName, 70, 82, bgColor);
                    ResizeCropImage.ResizeWithBackGroundColor(strFullPath, 1000, 1182, bgColor);
                    //ResizeCropImage.ResizeByCondition(strFullPath, 600, 600);
                    //ResizeCropImage.CreateThumbNailByCondition("~/res/productoption/", "~/res/productoption/thumbs/", strImageName, 120, 120);
                }
            }
            else if (e.CommandName == "Delete")
            {
                var strOldImageName = ((HiddenField)e.ListViewItem.FindControl("hdnImageName")).Value;
                DeleteImage(strOldImageName);
            }
            else if (e.CommandName == "QuickUpdate")
            {
                string ProductOptionID, Priority, IsAvailable;
                var oProductOption = new ProductOption();

                foreach (RadListViewDataItem item in RadListView1.Items)
                {
                    ProductOptionID = item.GetDataKeyValue("ProductOptionID").ToString();
                    Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                    IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                    oProductOption.ProductOptionQuickUpdate(
                        ProductOptionID,
                        "1",
                        "0",
                        "0",
                        IsAvailable,
                        Priority
                    );
                }
            }
            else if (e.CommandName == "DeleteSelected")
            {
                var oProductOption = new ProductOption();
                string ProductOptionID, OldImageName;

                foreach (RadListViewDataItem item in RadListView1.Items)
                {
                    var chkSelect = (CheckBox)item.FindControl("chkSelect");

                    if (chkSelect.Checked)
                    {
                        ProductOptionID = item.GetDataKeyValue("ProductOptionID").ToString();
                        OldImageName = ((HiddenField)item.FindControl("hdnImageName")).Value;

                        DeleteImage(OldImageName);
                        oProductOption.ProductOptionDelete(ProductOptionID);
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

            RadListView1.DataSource = TempImage;
            RadListView1.DataBind();
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
            RadListView1.DataBind();
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