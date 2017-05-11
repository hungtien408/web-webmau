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

public partial class ad_single_career : System.Web.UI.Page
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
            var strImagePath = Server.MapPath("~/res/career/" + strImageName);
            var strThumbImagePath = Server.MapPath("~/res/career/thumbs/" + strImageName);

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
            ObjectDataSource1.SelectParameters["CareerTitle"].DefaultValue = value;
            ObjectDataSource1.DataBind();
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "QuickUpdate")
        {
            string CareerID, Priority, IsShowOnHomePage, IsAvailable;
            var oCareer = new Career();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                CareerID = item.GetDataKeyValue("CareerID").ToString(); 
                Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                IsShowOnHomePage = ((CheckBox)item.FindControl("chkIsShowOnHomePage")).Checked.ToString();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oCareer.CareerQuickUpdate(
                    CareerID,
                    IsShowOnHomePage,
                    IsAvailable,
                    Priority
                );
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            string OldImageName;
            var oCareer = new Career();

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
            var oCareer = new Career();

            string strCareerID = ((HiddenField)row.FindControl("hdnCareerID")).Value;
            string strOldImageName = ((HiddenField)row.FindControl("hdnOldImageName")).Value;
            string strImageName = FileImageName.UploadedFiles.Count > 0 ? FileImageName.UploadedFiles[0].GetName() : "";
            string strPriority = ((RadNumericTextBox)row.FindControl("txtPriority")).Text.Trim();
            string strMetaTittle = ((TextBox)row.FindControl("txtMetaTittle")).Text.Trim();
            string strMetaDescription = ((TextBox)row.FindControl("txtMetaDescription")).Text.Trim();
            string strCareerTitle = ((TextBox)row.FindControl("txtCareerTitle")).Text.Trim();
            string strConvertedCareerTitle = Common.ConvertTitle(strCareerTitle);
            string strDescription = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtDescription")).Content.Trim()));
            string strContent = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtContent")).Content.Trim()));
            string strTag = ((TextBox)row.FindControl("txtTag")).Text.Trim();
            string strCareerCategoryID = ((RadComboBox)row.FindControl("ddlCategory")).SelectedValue;
            string strIsShowOnHomePage = ((CheckBox)row.FindControl("chkIsShowOnHomePage")).Checked.ToString();
            string strIsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();
            string strMetaTittleEn = ((TextBox)row.FindControl("txtMetaTittleEn")).Text.Trim();
            string strMetaDescriptionEn = ((TextBox)row.FindControl("txtMetaDescriptionEn")).Text.Trim();
            string strCareerTitleEn = ((TextBox)row.FindControl("txtCareerTitleEn")).Text.Trim();
            string strDescriptionEn = ((RadEditor)row.FindControl("txtDescriptionEn")).Content.Trim();
            string strContentEn = ((RadEditor)row.FindControl("txtContentEn")).Content.Trim();
            string strTagEn = ((TextBox)row.FindControl("txtTagEn")).Text.Trim();
            if (e.CommandName == "PerformInsert")
            {
                strImageName = oCareer.CareerInsert(
                strImageName,
                strMetaTittle,
                strMetaDescription,
                strCareerTitle,
                strConvertedCareerTitle,
                strDescription,
                strContent,
                strTag,
                strMetaTittleEn,
                strMetaDescriptionEn,
                strCareerTitleEn,
                strDescriptionEn,
                strContentEn,
                strTagEn,
                strCareerCategoryID,
                strIsShowOnHomePage,
                strIsAvailable,
                strPriority
                    );

                string strFullPath = "~/res/career/" + strImageName;
                if (!string.IsNullOrEmpty(strImageName))
                {
                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 800, 800);
                    ResizeCropImage.CreateThumbNailByCondition("~/res/career/", "~/res/career/thumbs/", strImageName, 120, 120);
                }
                RadGrid1.Rebind();
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;
                var strOldImagePath = Server.MapPath("~/res/career/" + strOldImageName);
                var strOldThumbImagePath = Server.MapPath("~/res/career/thumbs/" + strOldImageName);

                dsUpdateParam["CareerTitle"].DefaultValue = strCareerTitle;
                dsUpdateParam["ConvertedCareerTitle"].DefaultValue = strConvertedCareerTitle;
                dsUpdateParam["ImageName"].DefaultValue = strImageName;
                dsUpdateParam["CareerCategoryID"].DefaultValue = strCareerCategoryID;
                dsUpdateParam["IsShowOnHomePage"].DefaultValue = strIsShowOnHomePage;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;

                if (!string.IsNullOrEmpty(strImageName))
                {
                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);
                    if (File.Exists(strOldThumbImagePath))
                        File.Delete(strOldThumbImagePath);

                    strImageName = (string.IsNullOrEmpty(strConvertedCareerTitle) ? "" : strConvertedCareerTitle + "-") + strCareerID + strImageName.Substring(strImageName.LastIndexOf('.'));

                    string strFullPath = "~/res/career/" + strImageName;

                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 800, 800);
                    ResizeCropImage.CreateThumbNailByCondition("~/res/career/", "~/res/career/thumbs/", strImageName, 120, 120);
                }
            }
        }
        if (e.CommandName == "DeleteImage")
        {
            var oCareer = new Career();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strCareerID = s[0];
            var strImageName = s[1];

            oCareer.CareerImageDelete(strCareerID);
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
            var CareerID = ((HiddenField)row.FindControl("hdnCareerID")).Value;
            var ddlCategory = (RadComboBox)row.FindControl("ddlCategory");

            if (!string.IsNullOrEmpty(CareerID))
            {
                dv.RowFilter = "CareerID = " + CareerID;

                if (!string.IsNullOrEmpty(dv[0]["CareerCategoryID"].ToString()))
                    ddlCategory.SelectedValue = dv[0]["CareerCategoryID"].ToString();
            }
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FileImageName.ClientID));
        }
    }

    #endregion
    
}