using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.IO;
using TLLib;

public partial class ad_single_productphotoalbum : System.Web.UI.Page
{
    #region Common Method

    void DeleteImage(string strOldImageName)
    {
        if (!string.IsNullOrEmpty(strOldImageName))
        {
            var strOldImagePath = Server.MapPath("~/res/product/album/" + strOldImageName);
            var strOldThumbImagePath = Server.MapPath("~/res/product/album/thumbs/" + strOldImageName);

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
                var strTitle = ((TextBox)item.FindControl("txtTitle")).Text.Trim();
                var strDescription = ((TextBox)item.FindControl("txtDescription")).Text.Trim();
                var strTitleEn = ((TextBox)item.FindControl("txtTitleEn")).Text.Trim();
                var strDescriptionEn = ((TextBox)item.FindControl("txtDescriptionEn")).Text.Trim();
                var IsAvailable = ((CheckBox)item.FindControl("chkAddIsAvailable")).Checked.ToString();
                var Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                var oProductImage = new ProductImage();

                oProductImage.ProductImageInsert(
                    strImageName,
                    strConvertedProductName,
                    strTitle,
                    strDescription,
                    strTitleEn,
                    strDescriptionEn,
                    Request.QueryString["PI"],
                    IsAvailable,
                    Priority);

                string strFullPath = "~/res/product/album/" + strImageName;

                if (!string.IsNullOrEmpty(strImageName))
                {
                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 600, 600);
                    ResizeCropImage.CreateThumbNailByCondition("~/res/product/album/", "~/res/product/album/thumbs/", strImageName, 120, 120);
                }
                RadListView1.InsertItemPosition = RadListViewInsertItemPosition.None;
            }
            else if (e.CommandName == "Update")
            {
                var item = e.ListViewItem;
                var FileImageName = (RadUpload)item.FindControl("FileImageName");
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;

                var strProductImageID = ((HiddenField)e.ListViewItem.FindControl("hdnProductImageID")).Value;
                var strProductName = ((Label)FormView1.FindControl("lblProductName")).Text.Trim();
                var strConvertedProductName = Common.ConvertTitle(strProductName);
                var strOldImageName = ((HiddenField)e.ListViewItem.FindControl("hdnImageName")).Value;
                var strIsAvailable = ((CheckBox)item.FindControl("chkAddIsAvailable")).Checked.ToString();
                var strImageName = FileImageName.UploadedFiles.Count > 0 ? Guid.NewGuid().GetHashCode().ToString("X") + FileImageName.UploadedFiles[0].GetExtension() : "";

                dsUpdateParam["ImageName"].DefaultValue = !string.IsNullOrEmpty(strImageName) ? strImageName : strOldImageName;
                dsUpdateParam["ConvertedProductName"].DefaultValue = strConvertedProductName;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;
                
                if (!string.IsNullOrEmpty(strImageName))
                {
                    var strOldImagePath = Server.MapPath("~/res/product/album/" + strOldImageName);
                    var strOldThumbImagePath = Server.MapPath("~/res/product/album/thumbs/" + strOldImageName);

                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);
                    if (File.Exists(strOldThumbImagePath))
                        File.Delete(strOldThumbImagePath);

                    strImageName = (string.IsNullOrEmpty(strConvertedProductName) ? "" : strConvertedProductName + "-") + strProductImageID + strImageName.Substring(strImageName.LastIndexOf('.'));
                    string strFullPath = "~/res/product/album/" + strImageName;

                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 600, 600);
                    ResizeCropImage.CreateThumbNailByCondition("~/res/product/album/", "~/res/product/album/thumbs/", strImageName, 120, 120);
                }
            }
            else if (e.CommandName == "Delete")
            {
                var strOldImageName = ((HiddenField)e.ListViewItem.FindControl("hdnImageName")).Value;
                DeleteImage(strOldImageName);
            }
            else if (e.CommandName == "QuickUpdate")
            {
                string ProductImageID, Priority, IsAvailable;
                var oProductImage = new ProductImage();

                foreach (RadListViewDataItem item in RadListView1.Items)
                {
                    ProductImageID = item.GetDataKeyValue("ProductImageID").ToString();
                    Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                    IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                    oProductImage.ProductImageQuickUpdate(
                        ProductImageID,
                        IsAvailable,
                        Priority
                    );
                }
            }
            else if (e.CommandName == "DeleteSelected")
            {
                var oProductImage = new ProductImage();
                string ProductImageID, OldImageName;

                foreach (RadListViewDataItem item in RadListView1.Items)
                {
                    var chkSelect = (CheckBox)item.FindControl("chkSelect");

                    if (chkSelect.Checked)
                    {
                        ProductImageID = item.GetDataKeyValue("ProductImageID").ToString();
                        OldImageName = ((HiddenField)item.FindControl("hdnImageName")).Value;

                        DeleteImage(OldImageName);
                        oProductImage.ProductImageDelete(ProductImageID);
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