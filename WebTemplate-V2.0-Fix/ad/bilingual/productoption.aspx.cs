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

    void DeleteImage(string strImageName)
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
            ObjectDataSource1.SelectParameters["ProductOptionTitle"].DefaultValue = value;
            ObjectDataSource1.DataBind();
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "QuickUpdate")
        {
            string ProductOptionID, Priority, IsShowOnHomePage, IsHot, IsNew, IsAvailable;
            var oProductOption = new ProductOption();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                ProductOptionID = item.GetDataKeyValue("ProductOptionID").ToString();
                Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                IsShowOnHomePage = ((CheckBox)item.FindControl("chkIsShowOnHomePage")).Checked.ToString();
                IsHot = ((CheckBox)item.FindControl("chkIsHot")).Checked.ToString();
                IsNew = ((CheckBox)item.FindControl("chkIsNew")).Checked.ToString();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oProductOption.ProductOptionQuickUpdate(
                    ProductOptionID,
                    IsShowOnHomePage,
                    IsHot,
                    IsNew,
                    IsAvailable,
                    Priority
                );
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            string OldImageName;
            var oProductOption = new ProductOption();

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                OldImageName = ((HiddenField)item.FindControl("hdnImageName")).Value;
                DeleteImage(OldImageName);
            }
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var FileImageName = (RadUpload)row.FindControl("FileImageName");
            var oProductOption = new ProductOption();

            string strProductOptionID = ((HiddenField)row.FindControl("hdnProductOptionID")).Value;
            string strOldImageName = ((HiddenField)row.FindControl("hdnOldImageName")).Value;
            string strImageName = FileImageName.UploadedFiles.Count > 0 ? FileImageName.UploadedFiles[0].GetName() : "";
            string strPriority = ((RadNumericTextBox)row.FindControl("txtPriority")).Text.Trim();
            string strMetaTittle = ((RadTextBox)row.FindControl("txtMetaTittle")).Text.Trim();
            string strMetaDescription = ((RadTextBox)row.FindControl("txtMetaDescription")).Text.Trim();
            string strProductOptionTitle = ((RadTextBox)row.FindControl("txtProductOptionTitle")).Text.Trim();
            string strConvertedProductOptionTitle = Common.ConvertTitle(strProductOptionTitle);
            string strDescription = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtDescription")).Content.Trim()));
            string strContent = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtContent")).Content.Trim()));
            string strTag = ((RadTextBox)row.FindControl("txtTag")).Text.Trim();
            //string strProductOptionCategoryID = ((RadComboBox)row.FindControl("ddlCategory")).SelectedValue;
            string strProductOptionCategoryID = string.IsNullOrEmpty(Request.QueryString["poi"])
                                                    ? ""
                                                    : Request.QueryString["poi"];
            string strIsShowOnHomePage = ((CheckBox)row.FindControl("chkIsShowOnHomePage")).Checked.ToString();
            string strIsHot = ((CheckBox)row.FindControl("chkIsHot")).Checked.ToString();
            string strIsNew = ((CheckBox)row.FindControl("chkIsNew")).Checked.ToString();
            string strIsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();


            if (e.CommandName == "PerformInsert")
            {
                strImageName = oProductOption.ProductOptionInsert(
                    strImageName,
                    strMetaTittle,
                    strMetaDescription,
                    strProductOptionTitle,
                    strConvertedProductOptionTitle,
                    strDescription,
                    strContent,
                    strTag,
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    strProductOptionCategoryID,
                    strIsShowOnHomePage,
                    strIsHot,
                    strIsNew,
                    strIsAvailable,
                    strPriority
                    );

                string strFullPath = "~/res/productoption/" + strImageName;
                if (!string.IsNullOrEmpty(strImageName))
                {
                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    string bgColor = "#ffffff";
                    ResizeCropImage.CreateThumbNailWithBackGroundColor("~/res/productoption/", "~/res/productoption/thumbs/", strImageName, 70, 82, bgColor);
                    ResizeCropImage.ResizeWithBackGroundColor(strFullPath, 550, 650, bgColor);
                    //ResizeCropImage.ResizeByCondition(strFullPath, 800, 800);
                    //ResizeCropImage.CreateThumbNailByCondition("~/res/productoption/", "~/res/productoption/thumbs/", strImageName, 120, 120);
                }
                RadGrid1.Rebind();
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;
                var strOldImagePath = Server.MapPath("~/res/productoption/" + strOldImageName);
                var strOldThumbImagePath = Server.MapPath("~/res/productoption/thumbs/" + strOldImageName);

                dsUpdateParam["ProductOptionTitle"].DefaultValue = strProductOptionTitle;
                dsUpdateParam["ConvertedProductOptionTitle"].DefaultValue = strConvertedProductOptionTitle;
                dsUpdateParam["ImageName"].DefaultValue = strImageName;
                dsUpdateParam["ProductOptionCategoryID"].DefaultValue = strProductOptionCategoryID;
                dsUpdateParam["IsShowOnHomePage"].DefaultValue = strIsShowOnHomePage;
                dsUpdateParam["IsHot"].DefaultValue = strIsHot;
                dsUpdateParam["IsNew"].DefaultValue = strIsNew;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;

                if (!string.IsNullOrEmpty(strImageName))
                {
                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);
                    if (File.Exists(strOldThumbImagePath))
                        File.Delete(strOldThumbImagePath);

                    strImageName = (string.IsNullOrEmpty(strConvertedProductOptionTitle) ? "" : strConvertedProductOptionTitle + "-") + strProductOptionID + strImageName.Substring(strImageName.LastIndexOf('.'));

                    string strFullPath = "~/res/productoption/" + strImageName;

                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    string bgColor = "#ffffff";
                    ResizeCropImage.CreateThumbNailWithBackGroundColor("~/res/productoption/", "~/res/productoption/thumbs/", strImageName, 70, 82, bgColor);
                    ResizeCropImage.ResizeWithBackGroundColor(strFullPath, 550, 650, bgColor);
                    //ResizeCropImage.ResizeByCondition(strFullPath, 800, 800);
                    //ResizeCropImage.CreateThumbNailByCondition("~/res/productoption/", "~/res/productoption/thumbs/", strImageName, 120, 120);
                }
            }
        }
        if (e.CommandName == "DeleteImage")
        {
            var oProductOption = new ProductOption();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strProductOptionID = s[0];
            var strImageName = s[1];

            oProductOption.ProductOptionImageDelete(strProductOptionID);
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
            var dv = (DataView)ObjectDataSource1.Select();
            var ProductOptionID = ((HiddenField)row.FindControl("hdnProductOptionID")).Value;
            var ddlCategory = (RadComboBox)row.FindControl("ddlCategory");

            if (!string.IsNullOrEmpty(ProductOptionID))
            {
                dv.RowFilter = "ProductOptionID = " + ProductOptionID;

                if (!string.IsNullOrEmpty(dv[0]["ProductOptionCategoryID"].ToString()))
                    ddlCategory.SelectedValue = dv[0]["ProductOptionCategoryID"].ToString();
            }
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FileImageName.ClientID));
        }
    }

    #endregion

}