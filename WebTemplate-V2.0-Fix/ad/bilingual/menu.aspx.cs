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


public partial class ad_bilingual_menu : System.Web.UI.Page
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
            string strOldImagePath = Server.MapPath("~/res/menu/" + strImageName);
            if (File.Exists(strOldImagePath))
                File.Delete(strOldImagePath);
        }
    }

    #endregion

    #region Event

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
    {
        if (e.CommandName == "QuickUpdate")
        {
            string MenuID, IsAvailable;
            var oMenu = new TLLib.Menu();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                MenuID = item.GetDataKeyValue("MenuID").ToString();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oMenu.MenuQuickUpdate(
                    MenuID,
                    IsAvailable
                );
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            var oMenu = new TLLib.Menu();
            var errorList = "";

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                var isChildCategoryExist = oMenu.MenuIsChildrenExist(item.GetDataKeyValue("MenuID").ToString());
                var MenuTitle = ((Label)item.FindControl("lblMenuTitle")).Text;
                if (isChildCategoryExist)
                {
                    errorList += ", " + MenuTitle;
                }
                else
                {
                    string strImageName = ((HiddenField)item.FindControl("hdnImageName")).Value;

                    if (!string.IsNullOrEmpty(strImageName))
                    {
                        string strSavePath = Server.MapPath("~/res/menu/" + strImageName);
                        if (File.Exists(strSavePath))
                            File.Delete(strSavePath);
                    }
                }
            }
            if (!string.IsNullOrEmpty(errorList))
            {
                e.Canceled = true;
                string strAlertMessage = "Menu <b>\"" + errorList.Remove(0, 1).Trim() + "\"</b> đang chứa menu con.<br /> Xin xóa menu con trong danh mục này hoặc thiết lập hiển thị = \"không\".";
                lblError.Text = strAlertMessage;
            }
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var FileImageName = (RadUpload)row.FindControl("FileImageName");
            var FileImageNameEn = (RadUpload)row.FindControl("FileImageNameEn");

            string strMenuTitle = ((RadTextBox)row.FindControl("txtMenuTitle")).Text.Trim();
            string strOldImageName = ((HiddenField)row.FindControl("hdnImageName")).Value;
            string strOldImageNameEn = ((HiddenField)row.FindControl("hdnImageNameEn")).Value;
            string strImageName = FileImageName.UploadedFiles.Count > 0 ? Guid.NewGuid().GetHashCode().ToString("X") + FileImageName.UploadedFiles[0].GetExtension() : "";
            string strImageNameEn = FileImageNameEn.UploadedFiles.Count > 0 ? Guid.NewGuid().GetHashCode().ToString("X") + FileImageNameEn.UploadedFiles[0].GetExtension() : "";
            string strParentID = ((RadComboBox)row.FindControl("ddlParent")).SelectedValue;
            string strMenuPositionID = ((RadComboBox)row.FindControl("ddlMenuPosition")).SelectedValue;
            string strIsAvailable = ((CheckBox)row.FindControl("chkIsAvailable")).Checked.ToString();

            if (e.CommandName == "PerformInsert")
            {
                var dsInsertParam = ObjectDataSource1.InsertParameters;

                dsInsertParam["MenuTitle"].DefaultValue = strMenuTitle;
                dsInsertParam["ImageName"].DefaultValue = strImageName;
                dsInsertParam["ImageNameEn"].DefaultValue = strImageNameEn;
                dsInsertParam["ParentID"].DefaultValue = strParentID;
                dsInsertParam["MenuPositionID"].DefaultValue = strMenuPositionID;
                dsInsertParam["IsAvailable"].DefaultValue = strIsAvailable;
            }
            else
            {
                var dsUpdateParam = ObjectDataSource1.UpdateParameters;

                dsUpdateParam["MenuTitle"].DefaultValue = strMenuTitle;
                dsUpdateParam["ImageName"].DefaultValue = !string.IsNullOrEmpty(strImageName) ? strImageName : strOldImageName;
                dsUpdateParam["ImageNameEn"].DefaultValue = !string.IsNullOrEmpty(strImageNameEn) ? strImageNameEn : strOldImageNameEn;
                dsUpdateParam["ParentID"].DefaultValue = strParentID;
                dsUpdateParam["MenuPositionID"].DefaultValue = strMenuPositionID;
                dsUpdateParam["IsAvailable"].DefaultValue = strIsAvailable;
            }

            if (!string.IsNullOrEmpty(strImageName))
            {
                var strOldImagePath = Server.MapPath("~/res/menu/" + strOldImageName);
                var strImagePath = "~/res/menu/" + strImageName;

                FileImageName.UploadedFiles[0].SaveAs(Server.MapPath(strImagePath));
                ResizeCropImage.ResizeByCondition(strImagePath, 200, 200);

                if (File.Exists(strOldImagePath))
                    File.Delete(strOldImagePath);
            }

            if (!string.IsNullOrEmpty(strImageNameEn))
            {
                var strOldImagePathEn = Server.MapPath("~/res/menu/" + strOldImageNameEn);
                
                var strImagePathEn = "~/res/menu/" + strImageNameEn;

                FileImageNameEn.UploadedFiles[0].SaveAs(Server.MapPath(strImagePathEn));
                ResizeCropImage.ResizeByCondition(strImagePathEn, 200, 200);

                if (File.Exists(strOldImagePathEn))
                    File.Delete(strOldImagePathEn);
            }
        }
        else if (e.CommandName == "DeleteImage")
        {
            var oMenu = new TLLib.Menu();
            var lnkDeleteImage = (LinkButton)e.CommandSource;
            var s = lnkDeleteImage.Attributes["rel"].ToString().Split('#');
            var strMenuID = s[0];
            var strImageName = s[1];

            oMenu.MenuImageDelete(strMenuID);
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
            var FileImageNameEn = (RadUpload)row.FindControl("FileImageNameEn");
            var MenuPositionID = ((HiddenField)row.FindControl("hdnMenuPositionID")).Value;
            var ParentID = ((HiddenField)row.FindControl("hdnParentID")).Value;
            var ddlParent = (RadComboBox)row.FindControl("ddlParent");
            var ddlMenuPosition = (RadComboBox)row.FindControl("ddlMenuPosition");

            if (!string.IsNullOrEmpty(ParentID))
                ddlParent.SelectedValue = ParentID;
            if (!string.IsNullOrEmpty(MenuPositionID))
                ddlMenuPosition.SelectedValue = MenuPositionID;

            if (e.Item is GridEditFormInsertItem)
                ddlMenuPosition.SelectedValue = ddlSearchMenuPosition.SelectedValue;

            RadAjaxPanel1.ResponseScripts.Add(string.Format("window['UploadId1'] = '{0}';window['UploadId2'] = '{1}';", FileImageName.ClientID, FileImageNameEn.ClientID));
        }
    }

    protected void lnkUpOrder_Click(object sender, EventArgs e)
    {
        var lnkUpOrder = (LinkButton)sender;
        var strMenuID = lnkUpOrder.Attributes["rel"];
        var oMenu = new TLLib.Menu();
        oMenu.MenuUpOrder(strMenuID);
        RadGrid1.Rebind();

    }
    protected void lnkDownOrder_Click(object sender, EventArgs e)
    {
        var lnkDownOrder = (LinkButton)sender;
        var strMenuID = lnkDownOrder.Attributes["rel"];
        var oMenu = new TLLib.Menu();
        oMenu.MenuDownOrder(strMenuID);
        RadGrid1.Rebind();
    }
    #endregion
}