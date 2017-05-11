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

public partial class ad_single_project : System.Web.UI.Page
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
            var strImagePath = Server.MapPath("~/res/project/" + strImageName);
            var strThumbImagePath = Server.MapPath("~/res/project/thumbs/" + strImageName);

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
            ObjectDataSource1.SelectParameters["ProjectTitle"].DefaultValue = value;
            ObjectDataSource1.DataBind();
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "QuickUpdate")
        {
            string ProjectID, Priority, IsHot, IsNew, IsShowOnHomePage, IsAvailable;
            var oProject = new Project();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                ProjectID = item.GetDataKeyValue("ProjectID").ToString(); 
                Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
                IsHot = ((CheckBox)item.FindControl("chkIsHot")).Checked.ToString();
                IsNew = ((CheckBox)item.FindControl("chkIsNew")).Checked.ToString();
                IsShowOnHomePage = ((CheckBox)item.FindControl("chkIsShowOnHomePage")).Checked.ToString();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oProject.ProjectQuickUpdate(
                    ProjectID,
                    IsHot,
                    IsNew,
                    IsShowOnHomePage,
                    IsAvailable,
                    Priority
                );
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            string OldImageName;
            var oProject = new Project();

            string errorList = "", ProjectName = "";

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                try
                {
                    var ProjectID = item.GetDataKeyValue("ProjectID").ToString();
                    ProjectName = item["ProjectTitle"].Text;
                    oProject.ProjectDelete(ProjectID);

                    OldImageName = ((HiddenField)item.FindControl("hdnImageName")).Value;
                    DeleteImage(OldImageName);
                }
                catch (Exception ex)
                {
                    lblError.Text = ex.Message;
                    if (ex.Message == ((int)ErrorNumber.ConstraintConflicted).ToString())
                        errorList += ", " + ProjectName;
                }
            }
            if (!string.IsNullOrEmpty(errorList))
            {
                e.Canceled = true;
                string strAlertMessage = "Dự án <b>\"" + errorList.Remove(0, 1).Trim() + " \"</b> đang chứa thư viện ảnh, file download hoặc video .<br /> Xin xóa ảnh, file download hoặc video trong dự án này hoặc thiết lập hiển thị = \"không\".";
                lblError.Text = strAlertMessage;
            }
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var FileImageName = (RadUpload)row.FindControl("FileImageName");

            string ProjectID = ((HiddenField)row.FindControl("hdnProjectID")).Value;
            string OldImageName = ((HiddenField)row.FindControl("hdnOldImageName")).Value;
            string ImageName = FileImageName.UploadedFiles.Count > 0 ? FileImageName.UploadedFiles[0].GetName() : "";
            string Priority = ((RadNumericTextBox)row.FindControl("txtPriority")).Text.Trim();
            string MetaTittle = ((TextBox)row.FindControl("txtMetaTittle")).Text.Trim();
            string MetaDescription = ((TextBox)row.FindControl("txtMetaDescription")).Text.Trim();
            string ProjectTitle = ((TextBox)row.FindControl("txtProjectTitle")).Text.Trim();
            string ConvertedProjectTitle = Common.ConvertTitle(ProjectTitle);
            string Description = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtDescription")).Content.Trim()));
            string Content = HttpUtility.HtmlDecode(FCKEditorFix.Fix(((RadEditor)row.FindControl("txtContent")).Content.Trim()));
            string Tag = ((TextBox)row.FindControl("txtTag")).Text.Trim();
            string ProjectCategoryID = ((RadComboBox)row.FindControl("ddlProjectCategory")).SelectedValue;
            string IsHot = ((CheckBox)row.FindControl("chkIsHot")).Checked.ToString();
            string IsNew = ((CheckBox)row.FindControl("chkIsNew")).Checked.ToString();
            string IsShowOnHomePage = ((CheckBox)row.FindControl("chkIsShowOnHomePage")).Checked.ToString();
            string IsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();
            string MetaTittleEn = ((TextBox)row.FindControl("txtMetaTittleEn")).Text.Trim();
            string MetaDescriptionEn = ((TextBox)row.FindControl("txtMetaDescriptionEn")).Text.Trim();
            string ProjectTitleEn = ((TextBox)row.FindControl("txtProjectTitleEn")).Text.Trim();
            string DescriptionEn = ((RadEditor)row.FindControl("txtDescriptionEn")).Content.Trim();
            string ContentEn = ((RadEditor)row.FindControl("txtContentEn")).Content.Trim();
            string TagEn = ((TextBox)row.FindControl("txtTagEn")).Text.Trim();
            if (e.CommandName == "PerformInsert")
            {
                var oProject = new Project();

                ImageName = oProject.ProjectInsert(
                ImageName,
                MetaTittle,
                MetaDescription,
                ProjectTitle,
                ConvertedProjectTitle,
                Description,
                Content,
                Tag,
                MetaTittleEn,
                MetaDescriptionEn,
                ProjectTitleEn,
                DescriptionEn,
                ContentEn,
                TagEn,
                ProjectCategoryID,
                IsHot,
                IsNew,
                IsShowOnHomePage,
                IsAvailable,
                Priority
                );

                string strFullPath = "~/res/project/" + ImageName;
                if (!string.IsNullOrEmpty(ImageName))
                {
                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 800, 800);
                    ResizeCropImage.CreateThumbNailByCondition("~/res/project/", "~/res/project/thumbs/", ImageName, 120, 120);
                }
                RadGrid1.Rebind();
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;
                var strOldImagePath = Server.MapPath("~/res/project/" + OldImageName);
                var strOldThumbImagePath = Server.MapPath("~/res/project/thumbs/" + OldImageName);

                dsUpdateParam["ConvertedProjectTitle"].DefaultValue = ConvertedProjectTitle;
                dsUpdateParam["ImageName"].DefaultValue = ImageName;
                dsUpdateParam["ProjectCategoryID"].DefaultValue = ProjectCategoryID;
                dsUpdateParam["IsHot"].DefaultValue = IsHot;
                dsUpdateParam["IsNew"].DefaultValue = IsNew;
                dsUpdateParam["IsShowOnHomePage"].DefaultValue = IsShowOnHomePage;
                dsUpdateParam["IsAvailable"].DefaultValue = IsAvailable;

                if (!string.IsNullOrEmpty(ImageName))
                {
                    if (File.Exists(strOldImagePath))
                        File.Delete(strOldImagePath);
                    if (File.Exists(strOldThumbImagePath))
                        File.Delete(strOldThumbImagePath);

                    ImageName = (string.IsNullOrEmpty(ConvertedProjectTitle) ? "" : ConvertedProjectTitle + "-") + ProjectID + ImageName.Substring(ImageName.LastIndexOf('.'));

                    string strFullPath = "~/res/project/" + ImageName;

                    FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strFullPath));
                    ResizeCropImage.ResizeByCondition(strFullPath, 800, 800);
                    ResizeCropImage.CreateThumbNailByCondition("~/res/project/", "~/res/project/thumbs/", ImageName, 120, 120);
                }
            }
        }
        if (e.CommandName == "DeleteImage")
        {
            var oProject = new Project();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strProjectID = s[0];
            var ImageName = s[1];

            oProject.ProjectImageDelete(strProjectID);
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
            var ProjectID = ((HiddenField)row.FindControl("hdnProjectID")).Value;
            var ddlProjectCategory = (RadComboBox)row.FindControl("ddlProjectCategory");
            
            if (!string.IsNullOrEmpty(ProjectID))
            {
                dv.RowFilter = "ProjectID = " + ProjectID;

                if (!string.IsNullOrEmpty(dv[0]["ProjectCategoryID"].ToString()))
                    ddlProjectCategory.SelectedValue = dv[0]["ProjectCategoryID"].ToString();
            }
            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId'] = '{0}';", FileImageName.ClientID));
        }
    }

    #endregion
    
}