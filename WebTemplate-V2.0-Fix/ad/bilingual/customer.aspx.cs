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
using System.Web.Security;


public partial class ad_single_addressbook : System.Web.UI.Page
{
    #region Common Method

    protected void DropDownList_DataBound(object sender, EventArgs e)
    {
        var cbo = (RadComboBox)sender;
        cbo.Items.Insert(0, new RadComboBoxItem(""));
    }

    #endregion

    #region Event

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //if (!HttpContext.Current.User.IsInRole("Khách Hàng"))
            //    Response.Redirect("~/ad/bilingual/");
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
            linkButtonAll.Text = "All";
            linkButtonAll.CommandName = "NoFilter";
            container.Controls.Add(linkButtonAll);
        }
        else if (e.Item is GridPagerItem)
        {
            GridPagerItem gridPager = e.Item as GridPagerItem;
            Control numericPagerControl = gridPager.GetNumericPager();

            Control placeHolder = gridPager.FindControl("NumericPagerPlaceHolder");
            placeHolder.Controls.Add(numericPagerControl);
        }
        else if (e.Item is GridNestedViewItem)
        {
            var nestedItem = (GridNestedViewItem)e.Item;
            var hdnEmail = (HiddenField)nestedItem.FindControl("hdnEmail");
            hdnEmail.Value = nestedItem.ParentItem["Email"].Text;

            var lvOrder = (RadListView)nestedItem.FindControl("lvOrder");
            var OdsOrder = (ObjectDataSource)nestedItem.FindControl("OdsOrder");
            lvOrder.DataSourceID = OdsOrder.ID;
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
            ObjectDataSource1.SelectParameters["LastName"].DefaultValue = value;
            ObjectDataSource1.DataBind();
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "QuickUpdate")
        {
            string UserName, Role;
            var oUser = new User();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                UserName = item.GetDataKeyValue("UserName").ToString();
                Role = ((RadComboBox)item.FindControl("ddlRole")).SelectedValue;

                oUser.ChangeRole(UserName, Role);
            }
        }
        else if (e.CommandName == "DeleteSelected")
        {
            var oAddressBook = new AddressBook();
            var oUser = new User();

            string errorList = "", UserName = "";

            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                try
                {
                    var AddressBookID = item.GetDataKeyValue("AddressBookID").ToString();
                    UserName = item["UserName"].Text;
                    oAddressBook.AddressBookDelete(AddressBookID);
                    oUser.UserDelete(UserName);
                }
                catch (Exception ex)
                {
                    lblError.Text = ex.Message;
                    if (ex.Message == ((int)ErrorNumber.ConstraintConflicted).ToString())
                        errorList += ", " + UserName;
                }
            }
            if (!string.IsNullOrEmpty(errorList))
            {
                e.Canceled = true;
                string strAlertMessage = "Tài khoản <b>\"" + errorList.Remove(0, 1).Trim() + " \"</b> đang có đơn hàng .<br /> Xin xóa đơn hàng hoặc sử dụng chức năng khoá tài khoản.";
                lblError.Text = strAlertMessage;
            }
            RadGrid1.Rebind();
        }
        else if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            try
            {
                var command = e.CommandName;
                var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;

                var DistrictID = ((RadComboBox)row.FindControl("ddlDistrict")).SelectedValue;
                var ProvinceID = ((RadComboBox)row.FindControl("ddlProvince")).SelectedValue;
                var RoleName = ((RadComboBox)row.FindControl("ddlRole")).SelectedValue;
                var UserName = ((RadTextBox)row.FindControl("txtUserName")).Text;
                var IsPrimary = "True";
                var CountryID = "1";

                var oUser = new User();


                if (e.CommandName == "PerformInsert")
                {
                    var insertParams = ObjectDataSource1.InsertParameters;

                    insertParams["CountryID"].DefaultValue = CountryID;
                    insertParams["ProvinceID"].DefaultValue = ProvinceID;
                    insertParams["DistrictID"].DefaultValue = DistrictID;
                    insertParams["RoleName"].DefaultValue = RoleName;
                    insertParams["IsPrimary"].DefaultValue = IsPrimary;
                    oUser.ChangeRole(UserName, RoleName);
                }
                else
                {
                    var updateParams = ObjectDataSource1.UpdateParameters;

                    updateParams["CountryID"].DefaultValue = CountryID;
                    updateParams["ProvinceID"].DefaultValue = ProvinceID;
                    updateParams["DistrictID"].DefaultValue = DistrictID;
                    updateParams["RoleName"].DefaultValue = RoleName;
                    updateParams["IsPrimary"].DefaultValue = IsPrimary;
                    oUser.ChangeRole(UserName, RoleName);
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
        }
    }

    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            var itemtype = e.Item.ItemType;
            var row = itemtype == GridItemType.EditFormItem ? (GridEditFormItem)e.Item : (GridEditFormInsertItem)e.Item;

            var DistrictID = ((HiddenField)row.FindControl("hdnDistrictID")).Value;
            var ProvinceID = ((HiddenField)row.FindControl("hdnProvinceID")).Value;
            var RoleName = ((HiddenField)row.FindControl("hdnRole")).Value;
            var ddlDistrict = (RadComboBox)row.FindControl("ddlDistrict");
            var ddlProvince = (RadComboBox)row.FindControl("ddlProvince");
            var ddlRole = (RadComboBox)row.FindControl("ddlRole");

            if (!string.IsNullOrEmpty(DistrictID))
                ddlDistrict.SelectedValue = DistrictID;
            if (!string.IsNullOrEmpty(ProvinceID))
                ddlProvince.SelectedValue = ProvinceID;
            if (!string.IsNullOrEmpty(RoleName))
                ddlRole.SelectedValue = RoleName;
        }
    }

    protected void DropDownList_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        var ddl = (RadComboBox)sender;
        var RadAjaxPanel = (RadAjaxPanel)ddl.Parent;
        var UpdatePanelID = ddl.Attributes["UpdatePanelID"];

        RadAjaxPanel.ResponseScripts.Add(String.Format("window['{0}'].ajaxRequest();", UpdatePanelID));
    }

    protected void btnChangePassword_Click(object sender, EventArgs e)
    {
        try
        {
            var oUser = new User();
            var btnChangePassword = sender as RadButton;
            var row = btnChangePassword.Parent;

            var UserName = (row.FindControl("txtUserName") as RadTextBox).Text;
            var Password = (row.FindControl("txtPassword") as RadTextBox).Text;

            if (Membership.FindUsersByName(UserName).Count == 0)
                oUser.UserInsert(UserName, UserName, Password, "");
            else
                oUser.ChangePassword(UserName, Password);
        }
        catch (Exception ex)
        {
            lblError.Text = ex.Message;
        }
    }
    #endregion

}