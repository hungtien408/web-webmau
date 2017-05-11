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


public partial class ad_single_servicecategory : System.Web.UI.Page
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
            string strOldImagePath = Server.MapPath("~/res/productoptioncategory/" + strImageName);
            if (File.Exists(strOldImagePath))
                File.Delete(strOldImagePath);
        }
    }

    protected void ListBox_DataBound(object sender, EventArgs e)
    {
        var listBox = (RadListBox)sender;
        listBox.SortItems();
    }

    #endregion

    #region Event

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataBindListBoxSize();
        }
    }


    private void DataBindListBoxSize()
    {
        lstAllSize.DataSource = ObjectDataSource4;
        lstAllSize.DataBind();
        lstChoosedSize.DataSource = ObjectDataSource3;
        lstChoosedSize.DataBind();

        //var DuplicateSize = from RadListBoxItem item in lstAllSize.Items
        //                    join RadListBoxItem item1 in lstChoosedSize.Items
        //                       on item.Text equals item1.Text
        //                    select item.Index;

        //while (DuplicateSize.Count() > 0)
        //    lstAllSize.Items[DuplicateSize.First()].Remove();
    }

    protected void AllColor_Transferred(object sender, RadListBoxTransferredEventArgs e)
    {
        //var DestinationListBox = e.DestinationListBox;
        //string ProductID;
        //ProductID = Request.QueryString["PI"].ToString();
        //var dv1 = new Product_Color();
        //foreach (RadListBoxItem item in e.Items)
        //{
        //    if (DestinationListBox.ID == "lstAllColor")
        //    {
        //        string ProColorID;
        //        ProColorID = item.Value.ToString();
        //        //Update ProductFormSize Status
        //        var dv = new Product_Color().Product_ColorSelectOne(ProColorID).DefaultView;
        //        if (dv.Table.Rows.Count > 0)
        //        {
        //            dv1.Product_ColorDelete(ProColorID, "", "", "false");
        //        }
        //    }
        //    else if (DestinationListBox.ID == "lstChoosedColor")
        //    {
        //        //Insert ProductFormSize 
        //        var selectedItem = e.DestinationListBox.FindItemByValue(item.Value);
        //        string ProductColorID = item.Value.ToString();
        //        var dv = new Product_Color().Product_ColorSelectAll(ProductID, ProductColorID, "", "", "").DefaultView;
        //        var lblColorCode = (Label)selectedItem.FindControl("lblColorCode");
        //        var lblColorName = (Label)selectedItem.FindControl("lblColorName");
        //        var chkIsShow = (CheckBox)selectedItem.FindControl("chkIsShow");
        //        var txtPriority = (RadNumericTextBox)selectedItem.FindControl("txtPriority");

        //        if (dv.Table.Rows.Count > 0)
        //        {
        //            if (dv[0]["IsAvailable"].ToString() != "True")
        //            {
        //                dv1.Product_ColorDelete(dv[0]["ProColorID"].ToString(), "", "", "true");
        //            }
        //            if (lblColorName != null)
        //            {
        //                lblColorName.Text = item.Text;
        //            }
        //            if (dv[0]["ProductColorCode"] != "")
        //            {
        //                lblColorCode.Text = dv[0]["ProductColorCode"].ToString();
        //            }
        //            if (dv[0]["ProductColorName"] != "")
        //            {
        //                lblColorName.Text = dv[0]["ProductColorName"].ToString();
        //            }
        //            if (dv[0]["Priority"] != DBNull.Value)
        //            {
        //                txtPriority.Value = Convert.ToInt32(dv[0]["Priority"]);
        //            }
        //        }
        //        else
        //        {
        //            dv1.Product_ColorInsert(ProductID.ToString(), ProductColorID.ToString(), "false", "0", "true");
        //        }
        //    }
        //}
        //DataBindListBoxColor();
    }

    protected void AllSize_Transferred(object sender, RadListBoxTransferredEventArgs e)
    {
        var DestinationListBox = e.DestinationListBox;
        string ProductID;
        ProductID = Request.QueryString["pi"];
        var oProductSizeColor = new ProductSizeColor();
        IList<RadListBoxItem> rlbicProductColor = lstChoosedColor.SelectedItems;

        foreach (RadListBoxItem item in e.Items)
        {
            if (DestinationListBox.ID == "lstAllSize")
            {
                string ProSizeID;
                ProSizeID = item.Value.ToString();
                //Update ProductFormSize Status
                var dv = oProductSizeColor.ProductSizeColorSelectOne(ProSizeID).DefaultView;
                if (dv.Table.Rows.Count > 0)
                {
                    oProductSizeColor.ProductSizeColorDelete1(ProSizeID, "False");
                }
            }
            else if (DestinationListBox.ID == "lstChoosedSize")
            {
                //Insert ProductFormSize 
                var selectedItem = e.DestinationListBox.FindItemByValue(item.Value);
                string ProductSizeID = item.Value.ToString();
                var dv = oProductSizeColor.ProductSizeColorSelectAll("", ProductSizeID, ProductID, "", "True", "", "").DefaultView;
                var lblName = (Label)selectedItem.FindControl("lblName");
                var txtPriority = (RadNumericTextBox)selectedItem.FindControl("txtPriority");

                if (dv.Table.Rows.Count > 0)
                {
                    if (dv[0]["IsAvailable"].ToString() != "True")
                        oProductSizeColor.ProductSizeColorDelete1(ProductSizeID, "True");
                    if (lblName != null)
                        lblName.Text = item.Text;
                    if (dv[0]["Priority"] != DBNull.Value)
                        txtPriority.Value = Convert.ToInt32(dv[0]["Priority"]);
                }
                else
                {
                    foreach (RadListBoxItem item1 in rlbicProductColor)
                    {
                        var ProductOptionCategoryID = item1.Value.ToString();
                        oProductSizeColor.ProductSizeColorInsert(ProductSizeID, ProductOptionCategoryID,
                                                                 ProductID, "True", "True", "");
                    }
                }
            }

        }
        DataBindListBoxSize();
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        string Priority, ProductSizeColorID, IsAvailable, Quantity, QuantitySale;
        var oProductSizeColor = new ProductSizeColor();
        RadListBoxItemCollection choosesizes = lstChoosedSize.Items;

        foreach (RadListBoxItem item in choosesizes)
        {
            ProductSizeColorID = item.Value.ToString();
            Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
            Quantity = ((RadNumericTextBox)item.FindControl("txtQuantity")).Text.Trim();
            IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();
            //QuantitySale = "0";

            oProductSizeColor.ProductSizeColorQuickUpdate(
                ProductSizeColorID,
                "True",
                IsAvailable,
                Priority,
                Quantity
                //QuantitySale
            );
        }
    }

    protected void lstAllSize_ItemDataBound(object sender, RadListBoxItemEventArgs e)
    {
        RadAjaxPanel1.ResponseScripts.Add(string.Format("window['AllSize'] = '{0}';", lstAllSize.ClientID));
    }

    protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
    {
        if (e.CommandName == "QuickUpdate")
        {
            string ProductOptionCategoryID, IsShowOnMenu, IsShowOnHomePage, IsAvailable;
            var oProductOptionCategory = new ProductOptionCategory();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                ProductOptionCategoryID = item.GetDataKeyValue("ProductOptionCategoryID").ToString();
                IsShowOnMenu = ((CheckBox)item.FindControl("chkIsShowOnMenu")).Checked.ToString();
                IsShowOnHomePage = ((CheckBox)item.FindControl("chkIsShowOnHomePage")).Checked.ToString();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oProductOptionCategory.ProductOptionCategoryQuickUpdate(
                    ProductOptionCategoryID,
                    IsShowOnMenu,
                    IsShowOnHomePage,
                    IsAvailable
                );
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            var oProductOptionCategory = new ProductOptionCategory();
            var errorList = "";

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                var isChildCategoryExist = oProductOptionCategory.ProductOptionCategoryIsChildrenExist(item.GetDataKeyValue("ProductOptionCategoryID").ToString());
                var ProductOptionCategoryName = ((Label)item.FindControl("lblProductOptionCategoryName")).Text;
                if (isChildCategoryExist)
                {
                    errorList += ", " + ProductOptionCategoryName;
                }
                else
                {
                    string strImageName = ((HiddenField)item.FindControl("hdnImageName")).Value;

                    if (!string.IsNullOrEmpty(strImageName))
                    {
                        string strSavePath = Server.MapPath("~/res/productoptioncategory/" + strImageName);
                        if (File.Exists(strSavePath))
                            File.Delete(strSavePath);
                    }
                }
            }
            if (!string.IsNullOrEmpty(errorList))
            {
                e.Canceled = true;
                string strAlertMessage = "Danh mục <b>\"" + errorList.Remove(0, 1).Trim() + "\"</b> đang có danh mục con.<br /> Xin xóa danh mục con trong danh mục này hoặc thiết lập hiển thị = \"không\".";
                lblError.Text = strAlertMessage;
            }
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var FileImageName = (RadUpload)row.FindControl("FileImageName");

            string strProductOptionCategoryName = ((RadTextBox)row.FindControl("txtProductOptionCategoryName")).Text.Trim();
            string strProductOptionCategoryNameEn = "";
            string strConvertedProductOptionCategoryName = Common.ConvertTitle(strProductOptionCategoryName);
            string strDescription = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtDescription")).Content.Trim()));
            string strDescriptionEn = "";
            string strContent = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtContent")).Content.Trim()));
            string strContentEn = "";
            string strMetaTitle = ((RadTextBox)row.FindControl("txtMetaTitle")).Text.Trim();
            string strMetaTitleEn = "";
            string strMetaDescription = ((RadTextBox)row.FindControl("txtMetaDescription")).Text.Trim();
            string strMetaDescriptionEn = "";
            string strImageName = FileImageName.UploadedFiles.Count > 0 ? FileImageName.UploadedFiles[0].GetName() : "";
            string strParentID = ((RadComboBox)row.FindControl("ddlParent")).SelectedValue;
            string strIsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();
            string strIsShowOnMenu = ((CheckBox)row.FindControl("chkIsShowOnMenu")).Checked.ToString();
            string strIsShowOnHomePage = ((CheckBox)row.FindControl("chkIsShowOnHomePage")).Checked.ToString();
            string strProductID = string.IsNullOrEmpty(Request.QueryString["pi"]) ? "" : Request.QueryString["pi"].ToString();

            var oProductOptionCategory = new ProductOptionCategory();

            if (e.CommandName == "PerformInsert")
            {
                strImageName = oProductOptionCategory.ProductOptionCategoryInsert(
                    strProductOptionCategoryName,
                    strProductOptionCategoryNameEn,
                    strConvertedProductOptionCategoryName,
                    strDescription,
                    strDescriptionEn,
                    strContent,
                    strContentEn,
                    strMetaTitle,
                    strMetaTitleEn,
                    strMetaDescription,
                    strMetaDescriptionEn,
                    strImageName,
                    strParentID,
                    strIsShowOnMenu,
                    strIsShowOnHomePage,
                    strIsAvailable,
                    strProductID
                );

                string strFullPath = "~/res/productoptioncategory/" + strImageName;

                if (!string.IsNullOrEmpty(strImageName))
                {
                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 21, 21);
                }
                RadGrid1.Rebind();
                lstChoosedColor.DataBind();
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;
                var strProductOptionCategoryID = row.GetDataKeyValue("ProductOptionCategoryID").ToString();
                var strOldImageName = ((HiddenField)row.FindControl("hdnImageName")).Value;
                var strOldImagePath = Server.MapPath("~/res/productoptioncategory/" + strOldImageName);

                dsUpdateParam["ProductOptionCategoryName"].DefaultValue = strProductOptionCategoryName;
                dsUpdateParam["ConvertedProductOptionCategoryName"].DefaultValue = strConvertedProductOptionCategoryName;
                dsUpdateParam["Description"].DefaultValue = strDescription;
                dsUpdateParam["Content"].DefaultValue = strContent;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;
                dsUpdateParam["ImageName"].DefaultValue = strImageName;
                dsUpdateParam["ParentID"].DefaultValue = strParentID;
                dsUpdateParam["IsShowOnMenu"].DefaultValue = strIsShowOnMenu;
                dsUpdateParam["IsShowOnHomePage"].DefaultValue = strIsShowOnHomePage;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;
                dsUpdateParam["ProductID"].DefaultValue = strProductID;

                if (!string.IsNullOrEmpty(strImageName))
                {
                    var strFullPath = "~/res/productoptioncategory/" + strConvertedProductOptionCategoryName + "-" + strProductOptionCategoryID + strImageName.Substring(strImageName.LastIndexOf('.'));

                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);

                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 21, 21);
                }
                RadGrid1.Rebind();
                lstChoosedColor.DataBind();
            }
        }
        if (e.CommandName == "DeleteImage")
        {
            var oProductOptionCategory = new ProductOptionCategory();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strProductOptionCategoryID = s[0];
            var strImageName = s[1];

            oProductOptionCategory.ProductOptionCategoryImageDelete(strProductOptionCategoryID);
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
            var ProductOptionCategoryID = ((HiddenField)row.FindControl("hdnProductOptionCategoryID")).Value;
            var dv = (DataView)ObjectDataSource1.Select();
            var ddlParent = (RadComboBox)row.FindControl("ddlParent");

            if (!string.IsNullOrEmpty(ProductOptionCategoryID))
            {
                dv.RowFilter = "ProductOptionCategoryID = " + ProductOptionCategoryID;

                if (!string.IsNullOrEmpty(dv[0]["ParentID"].ToString()))
                    ddlParent.SelectedValue = dv[0]["ParentID"].ToString();
            }

            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FileImageName.ClientID));
        }
    }

    protected void lnkUpOrder_Click(object sender, EventArgs e)
    {
        var lnkUpOrder = (LinkButton)sender;
        var strProductOptionCategoryID = lnkUpOrder.Attributes["rel"];
        var oProductOptionCategory = new ProductOptionCategory();
        oProductOptionCategory.ProductOptionCategoryUpOrder(strProductOptionCategoryID);
        RadGrid1.Rebind();

    }
    protected void lnkDownOrder_Click(object sender, EventArgs e)
    {
        var lnkDownOrder = (LinkButton)sender;
        var strProductOptionCategoryID = lnkDownOrder.Attributes["rel"];
        var oProductOptionCategory = new ProductOptionCategory();
        oProductOptionCategory.ProductOptionCategoryDownOrder(strProductOptionCategoryID);
        RadGrid1.Rebind();
    }
    #endregion
}