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

public partial class ad_single_product : System.Web.UI.Page
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
            var strImagePath = Server.MapPath("~/res/product/" + strImageName);
            var strThumbImagePath = Server.MapPath("~/res/product/thumbs/" + strImageName);

            if (File.Exists(strImagePath))
                File.Delete(strImagePath);
            if (File.Exists(strThumbImagePath))
                File.Delete(strThumbImagePath);
        }
    }

    void DeletePhotoAlbum(string strImageName)
    {
        if (!string.IsNullOrEmpty(strImageName))
        {
            var strImagePath = Server.MapPath("~/res/product/album/" + strImageName);
            var strThumbImagePath = Server.MapPath("~/res/product/album/thumbs/" + strImageName);

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
            ObjectDataSource1.SelectParameters["ProductName"].DefaultValue = value;
            ObjectDataSource1.DataBind();
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "QuickUpdate")
        {
            string ProductID, Priority, InStock, IsHot, IsNew, IsBestSeller, IsSaleOff, IsShowOnHomePage, IsAvailable;
            var oProduct = new Product();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                ProductID = item.GetDataKeyValue("ProductID").ToString();
                Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                InStock = ((CheckBox)item.FindControl("chkInStock")).Checked.ToString();
                IsHot = ((CheckBox)item.FindControl("chkIsHot")).Checked.ToString();
                IsNew = ((CheckBox)item.FindControl("chkIsNew")).Checked.ToString();
                IsBestSeller = ((CheckBox)item.FindControl("chkIsBestSeller")).Checked.ToString();
                IsSaleOff = ((CheckBox)item.FindControl("chkIsSaleOff")).Checked.ToString();
                IsShowOnHomePage = ((CheckBox)item.FindControl("chkIsShowOnHomePage")).Checked.ToString();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oProduct.ProductQuickUpdate(
                    ProductID,
                    InStock,
                    IsHot,
                    IsNew,
                    IsBestSeller,
                    IsSaleOff,
                    IsShowOnHomePage,
                    Priority,
                    IsAvailable
                );
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            string OldImageName;
            var oProduct = new Product();
            var oProductImage = new ProductImage();
            var oProductDownload = new ProductDownload();

            string errorList = "", ProductName = "";

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                try
                {
                    var ProductID = item.GetDataKeyValue("ProductID").ToString();
                    ProductName = item["ProductName"].Text;

                    oProductImage.ProductImageDeleteByProduct(ProductID);
                    oProductDownload.ProductDownloadDeleteByProduct(ProductID);
                    oProduct.ProductDelete(ProductID);

                    OldImageName = ((HiddenField)item.FindControl("hdnImageName")).Value;
                    DeleteImage(OldImageName);
                }
                catch (Exception ex)
                {
                    lblError.Text = ex.Message;
                    if (ex.Message == ((int)ErrorNumber.ConstraintConflicted).ToString())
                        errorList += ", " + ProductName;
                }
            }
            if (!string.IsNullOrEmpty(errorList))
            {
                e.Canceled = true;
                string strAlertMessage = "Sản phẩm <b>\"" + errorList.Remove(0, 1).Trim() + " \"</b> đang chứa thư viện ảnh hoặc file download .<br /> Xin xóa ảnh hoặc file trong sản phẩm này hoặc thiết lập hiển thị = \"không\".";
                lblError.Text = strAlertMessage;
            }
            RadGrid1.Rebind();
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

            string ProductID = ((HiddenField)row.FindControl("hdnProductID")).Value;
            string OldImageName = ((HiddenField)row.FindControl("hdnOldImageName")).Value;
            string ImageName = FileImageName.UploadedFiles.Count > 0 ? FileImageName.UploadedFiles[0].GetName() : "";
            string Priority = ((RadNumericTextBox)row.FindControl("txtPriority")).Text.Trim();
            string MetaTittle = ((RadTextBox)row.FindControl("txtMetaTittle")).Text.Trim();
            string MetaDescription = ((RadTextBox)row.FindControl("txtMetaDescription")).Text.Trim();
            string ProductName = ((RadTextBox)row.FindControl("txtProductName")).Text.Trim();
            string ConvertedProductName = Common.ConvertTitle(ProductName);
            string Description = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtDescription")).Content.Trim()));
            string Content = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtContent")).Content.Trim()));
            string Price = ((RadNumericTextBox)row.FindControl("txtPrice")).Text.Trim();
            string OtherPrice = ((RadTextBox)row.FindControl("txtOtherPrice")).Text.Trim();
            string SavePrice = ((RadNumericTextBox)row.FindControl("txtSavePrice")).Text.Trim();
            string Discount = ((RadNumericTextBox)row.FindControl("txtDiscount")).Text.Trim();
            string Tag = ((RadTextBox)row.FindControl("txtTag")).Text.Trim();
            string CategoryID = ((RadComboBox)row.FindControl("ddlCategory")).SelectedValue;
            string ManufacturerID = ((RadComboBox)row.FindControl("ddlManufacturer")).SelectedValue;
            string OriginID = ((RadComboBox)row.FindControl("ddlOrigin")).SelectedValue;
            string InStock = ((CheckBox)row.FindControl("chkInStock")).Checked.ToString();
            string IsHot = ((CheckBox)row.FindControl("chkIsHot")).Checked.ToString();
            string IsNew = ((CheckBox)row.FindControl("chkIsNew")).Checked.ToString();
            string IsBestSeller = ((CheckBox)row.FindControl("chkIsBestSeller")).Checked.ToString();
            string IsSaleOff = ((CheckBox)row.FindControl("chkIsSaleOff")).Checked.ToString();
            string IsShowOnHomePage = ((CheckBox)row.FindControl("chkIsShowOnHomePage")).Checked.ToString();
            string IsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();
            string MetaTittleEn = ((RadTextBox)row.FindControl("txtMetaTittleEn")).Text.Trim();
            string MetaDescriptionEn = ((RadTextBox)row.FindControl("txtMetaDescriptionEn")).Text.Trim();
            string ProductNameEn = ((RadTextBox)row.FindControl("txtProductNameEn")).Text.Trim();
            string DescriptionEn = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtDescriptionEn")).Content.Trim()));
            string ContentEn = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtContentEn")).Content.Trim()));
            string TagEn = ((RadTextBox)row.FindControl("txtTagEn")).Text.Trim();

            if (e.CommandName == "PerformInsert")
            {
                var oProduct = new Product();

                ImageName = oProduct.ProductInsert(
                    ImageName,
                    MetaTittle,
                    MetaDescription,
                    ProductName,
                    ConvertedProductName,
                    Description,
                    Content,
                    Tag,
                    MetaTittleEn,
                    MetaDescriptionEn,
                    ProductNameEn,
                    DescriptionEn,
                    ContentEn,
                    TagEn,
                    Price,
                    OtherPrice,
                    SavePrice,
                    Discount,
                    CategoryID,
                    ManufacturerID,
                    OriginID,
                    InStock,
                    IsHot,
                    IsNew,
                    IsBestSeller,
                    IsSaleOff,
                    IsShowOnHomePage,
                    Priority,
                    IsAvailable
                );

                ProductID = oProduct.ProductID;

                string strFullPath = "~/res/product/" + ImageName;
                if (!string.IsNullOrEmpty(ImageName))
                {
                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 800, 800);
                    ResizeCropImage.CreateThumbNailByCondition("~/res/product/", "~/res/product/thumbs/", ImageName, 120, 120);
                }

                if (TempImage.Rows.Count > 0)
                {
                    var oProductImage = new ProductImage();

                    foreach (DataRow dr in TempImage.Rows)
                    {
                        oProductImage.ProductImageInsert(dr["ImageName"].ToString(), "", "", "", "", "", ProductID, "True", "");
                    }
                }

                RadGrid1.Rebind();
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;
                var strOldImagePath = Server.MapPath("~/res/product/" + OldImageName);
                var strOldThumbImagePath = Server.MapPath("~/res/product/thumbs/" + OldImageName);

                dsUpdateParam["ConvertedProductName"].DefaultValue = ConvertedProductName;
                dsUpdateParam["ImageName"].DefaultValue = ImageName;
                dsUpdateParam["CategoryID"].DefaultValue = CategoryID;
                dsUpdateParam["ManufacturerID"].DefaultValue = ManufacturerID;
                dsUpdateParam["OriginID"].DefaultValue = OriginID;
                dsUpdateParam["InStock"].DefaultValue = InStock;
                dsUpdateParam["IsHot"].DefaultValue = IsHot;
                dsUpdateParam["IsNew"].DefaultValue = IsNew;
                dsUpdateParam["IsBestSeller"].DefaultValue = IsBestSeller;
                dsUpdateParam["IsSaleOff"].DefaultValue = IsSaleOff;

                dsUpdateParam["IsShowOnHomePage"].DefaultValue = IsShowOnHomePage;
                dsUpdateParam["IsAvailable"].DefaultValue = IsAvailable;

                if (!string.IsNullOrEmpty(ImageName))
                {
                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);
                    if (File.Exists(strOldThumbImagePath))
                        File.Delete(strOldThumbImagePath);

                    ImageName = (string.IsNullOrEmpty(ConvertedProductName) ? "" : ConvertedProductName + "-") + ProductID + ImageName.Substring(ImageName.LastIndexOf('.'));

                    string strFullPath = "~/res/product/" + ImageName;

                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 800, 800);
                    ResizeCropImage.CreateThumbNailByCondition("~/res/product/", "~/res/product/thumbs/", ImageName, 120, 120);
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
            var oProduct = new Product();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strProductID = s[0];
            var ImageName = s[1];

            oProduct.ProductImageDelete(strProductID);
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

            var dv = (DataView)ObjectDataSource1.Select();
            var ProductID = ((HiddenField)row.FindControl("hdnProductID")).Value;
            var ddlCategory = (RadComboBox)row.FindControl("ddlCategory");
            var ddlManufacturer = (RadComboBox)row.FindControl("ddlManufacturer");
            var ddlOrigin = (RadComboBox)row.FindControl("ddlOrigin");

            if (!string.IsNullOrEmpty(ProductID))
            {
                dv.RowFilter = "ProductID = " + ProductID;

                if (!string.IsNullOrEmpty(dv[0]["CategoryID"].ToString()))
                    ddlCategory.SelectedValue = dv[0]["CategoryID"].ToString();
                if (!string.IsNullOrEmpty(dv[0]["ManufacturerID"].ToString()))
                    ddlManufacturer.SelectedValue = dv[0]["ManufacturerID"].ToString();
                if (!string.IsNullOrEmpty(dv[0]["OriginID"].ToString()))
                    ddlOrigin.SelectedValue = dv[0]["OriginID"].ToString();
            }
            else
            {
                ddlCategory.SelectedValue = ddlSearchCategory.SelectedValue;
                ddlManufacturer.SelectedValue = ddlSearchManufacturer.SelectedValue;
                ddlOrigin.SelectedValue = ddlSearchOrigin.SelectedValue;
            }
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FileImageName.ClientID));
        }
        else if (e.Item is GridDataItem)
        {
            var ContentRating1 = (Spaanjaars.Toolkit.ContentRating)e.Item.FindControl("ContentRating1");
            var oRating = new Rating();
            var ProductID = ((GridDataItem)e.Item).GetDataKeyValue("ProductID").ToString();
            ContentRating1.ItemId = ProductID;
            ContentRating1.DataSource = oRating.RatingSelectAll(ProductID);
            ContentRating1.DataBind();
        }
    }

    protected void RadGrid1_PreRender(object sender, EventArgs e)
    {
        RadAjaxPanel1.ResponseScripts.Add("$('.rating td').css({padding:0});");
    }

    protected void RadListView1_ItemCommand(object sender, RadListViewCommandEventArgs e)
    {
        try
        {
            var RadListView1 = (RadListView)sender;
            var Parent = RadListView1.NamingContainer;
            var OdsProductPhotoAlbum = (ObjectDataSource)Parent.FindControl("OdsProductPhotoAlbum");

            if (e.CommandName == "Update")
            {
                var item = e.ListViewItem;
                var dsUpdateParam = OdsProductPhotoAlbum.UpdateParameters;

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

            //var RadListView1 = (RadListView)sender;
            //var Parent = RadListView1.NamingContainer;
            //var OdsProductPhotoAlbum = (ObjectDataSource)Parent.FindControl("OdsProductPhotoAlbum");

            //if (e.CommandName == "Update")
            //{
            //    var item = e.ListViewItem;
            //    var FileImageName = (RadUpload)item.FindControl("FileImageName");
            //    var dsUpdateParam = OdsProductPhotoAlbum.UpdateParameters;

            //    var strOldImageName = ((HiddenField)e.ListViewItem.FindControl("hdnImageName")).Value;
            //    var strIsAvailable = ((CheckBox)item.FindControl("chkAddIsAvailable")).Checked.ToString();
            //    string strImageName = FileImageName.UploadedFiles.Count > 0 ? Guid.NewGuid().GetHashCode().ToString("X") + "." + FileImageName.UploadedFiles[0].GetExtension() : strOldImageName;

            //    dsUpdateParam["ImageName"].DefaultValue = strImageName;
            //    dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;

            //    if (!string.IsNullOrEmpty(strImageName))
            //    {
            //        var strOldImagePath = Server.MapPath("~/res/product/album/" + strOldImageName);
            //        var strOldThumbImagePath = Server.MapPath("~/res/product/album/thumbs/" + strOldImageName);

            //        if (File.Exists(strOldImagePath))
            //            File.Delete(strOldImagePath);
            //        if (File.Exists(strOldThumbImagePath))
            //            File.Delete(strOldThumbImagePath);

            //        string strFullPath = "~/res/product/album/" + strImageName;

            //        FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
            //        ResizeCropImage.ResizeByCondition(strFullPath, 800, 800);
            //        ResizeCropImage.CreateThumbNailByCondition("~/res/product/album/", "~/res/product/album/thumbs/", strImageName, 120, 120);
            //    }
            //}
            //else if (e.CommandName == "Delete")
            //{
            //    var strOldImageName = ((HiddenField)e.ListViewItem.FindControl("hdnImageName")).Value;
            //    DeletePhotoAlbum(strOldImageName);
            //}


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
        var ProductID = ((HiddenField)Parent.FindControl("hdnProductID")).Value;
        var RadListView1 = (RadListView)Parent.FindControl("RadListView1");
        var RadListView2 = (RadListView)Parent.FindControl("RadListView2");

        string targetFolder = "~/res/product/album/";
        string newName = Guid.NewGuid().GetHashCode().ToString("X") + e.File.GetExtension();
        e.File.SaveAs(Server.MapPath(targetFolder + newName));

        ResizeCropImage.ResizeByCondition(targetFolder + newName, 800, 800);
        ResizeCropImage.CreateThumbNailByCondition("~/res/product/album/", "~/res/product/album/thumbs/", newName, 120, 120);

        if (string.IsNullOrEmpty(ProductID))
        {
            TempImage.Rows.Add(new object[] { newName });

            RadListView2.DataSource = TempImage;
            RadListView2.DataBind();
        }
        else
        {
            var oProductImage = new ProductImage();

            oProductImage.ProductImageInsert(newName, "", "", "", "", "", ProductID, "True", "");
            RadListView1.Rebind();
        }
    }

    protected void FileImageName_FileUploaded(object sender, FileUploadedEventArgs e)
    {
        var FileImageName = (RadAsyncUpload)sender;
        var Parent = FileImageName.NamingContainer;
        var hdnNewImageName = (HiddenField)Parent.FindControl("hdnNewImageName");

        string targetFolder = "~/res/product/";
        string newName = Guid.NewGuid().GetHashCode().ToString("X") + e.File.GetExtension();
        e.File.SaveAs(Server.MapPath(targetFolder + newName));
        
        ResizeCropImage.ResizeByCondition(targetFolder + newName, 800, 800);
        ResizeCropImage.CreateThumbNailByCondition("~/res/product/", "~/res/product/thumbs/", newName, 120, 120);

        hdnNewImageName.Value = newName;
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