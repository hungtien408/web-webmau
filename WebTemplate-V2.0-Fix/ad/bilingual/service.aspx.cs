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
            var strImagePath = Server.MapPath("~/res/service/" + strImageName);
            var strThumbImagePath = Server.MapPath("~/res/service/thumbs/" + strImageName);

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
            ObjectDataSource1.SelectParameters["ServiceTitle"].DefaultValue = value;
            ObjectDataSource1.DataBind();
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "QuickUpdate")
        {
            string ServiceID, Priority, IsShowOnHomePage, IsHot, IsNew, IsAvailable;
            var oService = new Service();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                ServiceID = item.GetDataKeyValue("ServiceID").ToString();
                Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                IsShowOnHomePage = ((CheckBox)item.FindControl("chkIsShowOnHomePage")).Checked.ToString();
                IsHot = ((CheckBox)item.FindControl("chkIsHot")).Checked.ToString();
                IsNew = ((CheckBox)item.FindControl("chkIsNew")).Checked.ToString();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oService.ServiceQuickUpdate(
                    ServiceID,
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
            var oService = new Service();

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
            var oService = new Service();

            string strServiceID = ((HiddenField)row.FindControl("hdnServiceID")).Value;
            string strOldImageName = ((HiddenField)row.FindControl("hdnOldImageName")).Value;
            string strImageName = FileImageName.UploadedFiles.Count > 0 ? FileImageName.UploadedFiles[0].GetName() : "";
            string strPriority = ((RadNumericTextBox)row.FindControl("txtPriority")).Text.Trim();
            string strMetaTittle = ((RadTextBox)row.FindControl("txtMetaTittle")).Text.Trim();
            string strMetaDescription = ((RadTextBox)row.FindControl("txtMetaDescription")).Text.Trim();
            string strServiceTitle = ((RadTextBox)row.FindControl("txtServiceTitle")).Text.Trim();
            string strConvertedServiceTitle = Common.ConvertTitle(strServiceTitle);
            string strDescription = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtDescription")).Content.Trim()));
            string strContent = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtContent")).Content.Trim()));
            string strTag = ((RadTextBox)row.FindControl("txtTag")).Text.Trim();
            string strServiceCategoryID = ((RadComboBox)row.FindControl("ddlCategory")).SelectedValue;
            string strIsShowOnHomePage = ((CheckBox)row.FindControl("chkIsShowOnHomePage")).Checked.ToString();
            string strIsHot = ((CheckBox)row.FindControl("chkIsHot")).Checked.ToString();
            string strIsNew = ((CheckBox)row.FindControl("chkIsNew")).Checked.ToString();
            string strIsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();
            string strMetaTittleEn = ((RadTextBox)row.FindControl("txtMetaTittleEn")).Text.Trim();
            string strMetaDescriptionEn = ((RadTextBox)row.FindControl("txtMetaDescriptionEn")).Text.Trim();
            string strServiceTitleEn = ((RadTextBox)row.FindControl("txtServiceTitleEn")).Text.Trim();
            string strDescriptionEn = ((RadEditor)row.FindControl("txtDescriptionEn")).Content.Trim();
            string strContentEn = ((RadEditor)row.FindControl("txtContentEn")).Content.Trim();
            string strTagEn = ((RadTextBox)row.FindControl("txtTagEn")).Text.Trim();

            if (e.CommandName == "PerformInsert")
            {
                strImageName = oService.ServiceInsert(
                    strImageName,
                    strMetaTittle,
                    strMetaDescription,
                    strServiceTitle,
                    strConvertedServiceTitle,
                    strDescription,
                    strContent,
                    strTag,
                    strMetaTittleEn,
                    strMetaDescriptionEn,
                    strServiceTitleEn,
                    strDescriptionEn,
                    strContentEn,
                    strTagEn,
                    strServiceCategoryID,
                    strIsShowOnHomePage,
                    strIsHot,
                    strIsNew,
                    strIsAvailable,
                    strPriority
                    );

                string strFullPath = "~/res/service/" + strImageName;
                if (!string.IsNullOrEmpty(strImageName))
                {
                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 800, 800);
                    ResizeCropImage.CreateThumbNailByCondition("~/res/service/", "~/res/service/thumbs/", strImageName, 120, 120);
                }
                RadGrid1.Rebind();
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;
                var strOldImagePath = Server.MapPath("~/res/service/" + strOldImageName);
                var strOldThumbImagePath = Server.MapPath("~/res/service/thumbs/" + strOldImageName);

                dsUpdateParam["ServiceTitle"].DefaultValue = strServiceTitle;
                dsUpdateParam["ConvertedServiceTitle"].DefaultValue = strConvertedServiceTitle;
                dsUpdateParam["ImageName"].DefaultValue = strImageName;
                dsUpdateParam["ServiceCategoryID"].DefaultValue = strServiceCategoryID;
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

                    strImageName = (string.IsNullOrEmpty(strConvertedServiceTitle) ? "" : strConvertedServiceTitle + "-") + strServiceID + strImageName.Substring(strImageName.LastIndexOf('.'));

                    string strFullPath = "~/res/service/" + strImageName;

                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 800, 800);
                    ResizeCropImage.CreateThumbNailByCondition("~/res/service/", "~/res/service/thumbs/", strImageName, 120, 120);
                }
            }
        }
        if (e.CommandName == "DeleteImage")
        {
            var oService = new Service();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strServiceID = s[0];
            var strImageName = s[1];

            oService.ServiceImageDelete(strServiceID);
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
            var ServiceID = ((HiddenField)row.FindControl("hdnServiceID")).Value;
            var ddlCategory = (RadComboBox)row.FindControl("ddlCategory");

            if (!string.IsNullOrEmpty(ServiceID))
            {
                dv.RowFilter = "ServiceID = " + ServiceID;

                if (!string.IsNullOrEmpty(dv[0]["ServiceCategoryID"].ToString()))
                    ddlCategory.SelectedValue = dv[0]["ServiceCategoryID"].ToString();
            }
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FileImageName.ClientID));
        }
    }

    #endregion

}