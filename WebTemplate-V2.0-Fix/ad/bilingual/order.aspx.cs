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


public partial class ad_single_order : System.Web.UI.Page
{
    #region Common Method

    protected void DropDownList_DataBound(object sender, EventArgs e)
    {
        var cbo = (RadComboBox)sender;
        cbo.Items.Insert(0, new RadComboBoxItem(""));
    }

    #endregion

    #region Event

    protected void ddlSearchProvince_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        RadAjaxPanel2.ResponseScripts.Add(String.Format("window['{0}'].ajaxRequest();", RadAjaxPanel3.ClientID));
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //if (!HttpContext.Current.User.IsInRole("Đơn Hàng"))
            //    Response.Redirect("~/ad/bilingual/");
        }
    }

    protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridNestedViewItem)
        {
            var nestedItem = (GridNestedViewItem)e.Item;
            var hdnOrderID = (HiddenField)nestedItem.FindControl("hdnOrderID");
            var hdnBillingAddressID = (HiddenField)nestedItem.FindControl("hdnBillingAddressID");
            var hdnShippingAddressID = (HiddenField)nestedItem.FindControl("hdnShippingAddressID");

            hdnOrderID.Value = nestedItem.ParentItem["OrderID"].Text;
            hdnBillingAddressID.Value = nestedItem.ParentItem["BillingAddressID"].Text;
            hdnShippingAddressID.Value = nestedItem.ParentItem["ShippingAddressID"].Text;

            var lvOrderDetail = (RadListView)nestedItem.FindControl("lvOrderDetail");
            var OdsOrderDetail = (ObjectDataSource)nestedItem.FindControl("OdsOrderDetail");
            lvOrderDetail.DataSourceID = OdsOrderDetail.ID;

            var fvBillingAddress = (FormView)nestedItem.FindControl("fvBillingAddress");
            var OdsBillingAddress = (ObjectDataSource)nestedItem.FindControl("OdsBillingAddress");
            fvBillingAddress.DataSourceID = OdsBillingAddress.ID;

            var fvShippingAddress = (FormView)nestedItem.FindControl("fvShippingAddress");
            var OdsShippingAddress = (ObjectDataSource)nestedItem.FindControl("OdsShippingAddress");
            fvShippingAddress.DataSourceID = OdsShippingAddress.ID;
        }
    }
    protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
    {
        if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            try
            {
                var command = e.CommandName;
                var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
                var strOrderStatusID = ((RadComboBox)row.FindControl("ddlOrderStatus")).SelectedValue;

                if (e.CommandName == "PerformInsert")
                {
                    OdsOrder.InsertParameters["OrderStatusID"].DefaultValue = strOrderStatusID;
                    OdsOrder.InsertParameters["UserID"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
                }
                else
                {
                    OdsOrder.UpdateParameters["OrderStatusID"].DefaultValue = strOrderStatusID;
                    OdsOrder.UpdateParameters["UserID"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
        }
        else if (e.CommandName == "QuickUpdate")
        {
            //var lnkbQuickUpdate = (RadComboBox)RadGrid1.FindControl("lnkbQuickUpdate");
            foreach (GridDataItem item in RadGrid1.SelectedItems)
            {
                string OrderID = item["OrderID"].Text;
                string UserName = item["UserName"].Text;
                string Email = (item.FindControl("hdnEmail") as HiddenField).Value;
                string FullName = (item.FindControl("hdnFullName") as HiddenField).Value;
                string OrderStatusID = (item.FindControl("ddlOrderStatus") as RadComboBox).SelectedValue;
                string ShippingStatusID = (item.FindControl("ddlShippingStatus") as RadComboBox).SelectedValue;
                string PaymentMethodID = (item.FindControl("ddlPaymentMethod") as RadComboBox).SelectedValue;
                string PayStatusID = (item.FindControl("ddlPayStatus") as RadComboBox).SelectedValue;
                string BillingAddressID = item["BillingAddressID"].Text;
                string ShippingAddressID = item["ShippingAddressID"].Text;
                string Notes = (item.FindControl("txtNotes") as RadTextBox).Text;
                var oOrders = new Orders();
                //var oAddressBook = new AddressBook();

                oOrders.OrdersQuickUpdate1(
                    OrderID,
                    UserName,
                    OrderStatusID,
                    ShippingStatusID,
                    PaymentMethodID,
                    BillingAddressID,
                    ShippingAddressID,
                    Notes,
                    PayStatusID
                    );

                if (OrderStatusID == "3" && ShippingStatusID == "2" && PayStatusID == "1")
                {
                    //var dvAddressBook = oAddressBook.AddressBookSelectAll("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "").DefaultView;
                    //var dvOrder = (DataView)OdsOrder.Select();
                    var To = Email;
                    var CC = "info@pandemos.vn";
                    var Subject = "Hoàn tất đơn hàng";
                    var YourName = FullName;

                    //var OrderCode = OrderID;
                    string Host = "118.69.193.238";
                    int Port = 25;
                    string From = "webmaster@thietkewebhcm.com";
                    string Password = "web123master";
                    string Body = "<div style='width: 100%; font-size: 11px; font-family: Arial;'>";
                    Body += "<h3 style='color: rgb(204,102,0); font-size: 22px; border-bottom-color: gray; border-bottom-width: 1px;border-bottom-style: dashed; margin-bottom: 20px; font-family: Times New Roman;'>";
                    Body += "Đơn hàng đã được hoàn tất";
                    Body += "</h3>";
                    Body += "<div style='font-family: Verdana; font-size: 11px; margin-bottom: 20px;'>";
                    Body += "<p>Xin chào " + YourName + ",</p>";
                    Body += "<p>Đơn hàng bạn đặt trên website của chúng tôi đã giao tới người nhận bạn đã chỉ định.</p>";
                    Body += "<p>Trạng thái của đơn hàng số <strong>" + OrderID + "</strong> hiện tại là <b>Đã hoàn thành</b>.</p>";
                    Body += "<p>Xin vui lòng <a href='http://www.pandemos.vn/lien-he.aspx'>gọi điện</a> tới Pandemos nếu thông tin nói trên không chính xác.</p>";
                    Body += "<p>Cảm ơn Quý khách đã ủng hộ <strong>Pandemos</strong> và xin hân hạnh được tiếp tục phục vụ Quý khách trong thời gian tới.</p>";
                    Body += "</div>";
                    Body += "<div style='font-family:Verdana;font-size:12px;margin-top:10px;'>";
                    Body += "<div style='font-size:16px;font-weight:bold;'>=================</div>";
                    Body += "<h4 style='font-size:14px;font-family:Verdana;margin:0;padding:0;'>Pandemos</h4>";
                    Body += "<div style='font-size:11px;font-family:Verdana;margin-top:5px;padding:0;margin:0;'>";
                    Body += "<p>Add: 403, Hai Bà Trưng, Phường 8, Quận 3, Tp HCM.</p>";
                    Body += "<p>Tel: (08)3 820 8577 - Hotline: 0902 563 577</p>";

                    Body += "<p>W: <a href='http://www.pandemos.vn'>www.pandemos.vn</a></p>";
                    Body += "<p>E: <a href='mailto:info@pandemos.vn'>info@pandemos.vn</a></p>";
                    Body += "</div>";
                    Body += "</div>";
                    Body += "</div>";
                    Common.SendMail(Host, Port, From, Password, To, CC, Subject, Body, false);

                    //string Body = "<div style='width: 100%; font-size: 11px; font-family: Arial;'>";
                    //Body += "<h3 style='color: rgb(204,102,0); font-size: 22px; border-bottom-color: gray; border-bottom-width: 1px;border-bottom-style: dashed; margin-bottom: 20px; font-family: Times New Roman;'>";
                    //Body += "Đơn hàng đã được hoàn tất/Order Delivered";
                    //Body += "</h3>";
                    //Body += "<div style='font-family: Verdana; font-size: 11px; margin-bottom: 20px;'>";
                    //Body += "<p>Xin chào " + YourName + "/Hi " + YourName + ",</p>";
                    //Body += "<p>Đơn hàng bạn đặt trên website của chúng tôi đã giao tới người nhận bạn đã chỉ định/An order you recently placed on our website has delivered to nominated recipient.</p>";
                    //Body += "<p>Trạng thái của đơn hàng số <strong>" + OrderID + "</strong> hiện tại là <b>Đã hoàn thành</b>/The status of order " + OrderID + " is now <b>Completed</b>.</p>";
                    //Body += "<p>Xin vui lòng <a href='http://www.pandemos.vn/lien-he.aspx'>gọi điện</a> tới Pandemos nếu thông tin nói trên không chính xác/ Please <a href='http://www.pandemos.vn/lien-he.aspx'>call</a> <strong>Pandemos</strong> if above information is not correct.</p>";
                    //Body += "<p>Cảm ơn Quý khách đã ủng hộ <strong>Pandemos</strong> và xin hân hạnh được tiếp tục phục vụ Quý khách trong thời gian tới.</p>";
                    //Body += "</div>";
                    //Body += "<div style='font-family:Verdana;font-size:12px;margin-top:10px;'>";
                    //Body += "<div style='font-size:16px;font-weight:bold;'>=================</div>";
                    //Body += "<h4 style='font-size:14px;font-family:Verdana;margin:0;padding:0;'>Pandemos</h4>";
                    //Body += "<div style='font-size:11px;font-family:Verdana;margin-top:5px;padding:0;margin:0;'>";
                    //Body += "<p>Add: 403, Hai Bà Trưng, Phường 8, Quận 3, Tp HCM.</p>";
                    //Body += "<p>Tel: (08)3 820 8577 - Hotline: 0902 563 577</p>";

                    //Body += "<p>W: <a href='http://www.pandemos.vn'>www.pandemos.vn</a></p>";
                    //Body += "<p>E: <a href='mailto:info@pandemos.vn'>info@pandemos.vn</a></p>";
                    //Body += "</div>";
                    //Body += "</div>";
                    //Body += "</div>";

                    //if (bSendEmail)
                    //{
                    //Common.ShowAlert("Bạn đã gửi mail thành công");
                    //ScriptManager.RegisterClientScriptBlock(lnkbQuickUpdate, lnkbQuickUpdate.GetType(), "runtime", "alert('Bạn đã gửi mail thành công')", true);
                    //}
                }
            }
        }
    }
    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            var itemtype = e.Item.ItemType;
            var row = itemtype == GridItemType.EditFormItem ? (GridEditFormItem)e.Item : (GridEditFormInsertItem)e.Item;
            var dv = (DataView)OdsOrder.Select();
            var OrderID = ((HiddenField)row.FindControl("hdnOrderID")).Value;
            var ddlOrderStatus = (RadComboBox)row.FindControl("ddlOrderStatus");

            if (!string.IsNullOrEmpty(OrderID))
            {
                dv.RowFilter = "OrderID = " + OrderID;

                if (!string.IsNullOrEmpty(dv[0]["OrderStatusID"].ToString()))
                    ddlOrderStatus.SelectedValue = dv[0]["OrderStatusID"].ToString();
            }
        }
        else if (e.Item is GridDataItem)
        {
            try
            {
                var item = e.Item;
                string OrderStatusID = ((HiddenField)item.FindControl("hdnOrderStatusID")).Value;
                string ShippingStatusID = ((HiddenField)item.FindControl("hdnShippingStatusID")).Value;
                string PaymentMethodID = ((HiddenField)item.FindControl("hdnPaymentMethodID")).Value;
                string PayStatusID = ((HiddenField)item.FindControl("hdnPayStatusID")).Value;
                var ddlOrderStatus = (RadComboBox)item.FindControl("ddlOrderStatus");
                var ddlPaymentMethod = (RadComboBox)item.FindControl("ddlPaymentMethod");
                var ddlShippingStatus = (RadComboBox)item.FindControl("ddlShippingStatus");
                var ddlPayStatus = (RadComboBox)item.FindControl("ddlPayStatus");

                if (!string.IsNullOrEmpty(OrderStatusID))
                    ddlOrderStatus.SelectedValue = OrderStatusID;
                if (!string.IsNullOrEmpty(ShippingStatusID))
                    ddlShippingStatus.SelectedValue = ShippingStatusID;
                if (!string.IsNullOrEmpty(PaymentMethodID))
                    ddlPaymentMethod.SelectedValue = PaymentMethodID;
                if (!string.IsNullOrEmpty(PayStatusID))
                    ddlPayStatus.SelectedValue = PayStatusID;
            }
            catch { }
        }
    }

    protected void RadGrid2_ItemCommand(object sender, GridCommandEventArgs e)
    {
        if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            try
            {
                var command = e.CommandName;
                var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
                var strProductID = ((RadComboBox)row.FindControl("ddlProduct")).SelectedValue;

                var grid = (RadGrid)sender;
                var objParent = grid.Parent;
                var OrderID = ((HiddenField)objParent.FindControl("hdnOrderID")).Value;
                var ObjectDataSource1 = (ObjectDataSource)objParent.FindControl("ObjectDataSource1");

                if (e.CommandName == "PerformInsert")
                {
                    ObjectDataSource1.InsertParameters["ProductID"].DefaultValue = strProductID;
                    ObjectDataSource1.InsertParameters["OrderID"].DefaultValue = OrderID;
                    ObjectDataSource1.InsertParameters["CreateBy"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
                }
                else
                {
                    ObjectDataSource1.UpdateParameters["ProductID"].DefaultValue = strProductID;
                    ObjectDataSource1.UpdateParameters["CreateBy"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
        }
    }
    protected void RadGrid2_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            var itemtype = e.Item.ItemType;
            var row = itemtype == GridItemType.EditFormItem ? (GridEditFormItem)e.Item : (GridEditFormInsertItem)e.Item;

            var grid = (RadGrid)sender;
            var objParent = grid.Parent;
            var ObjectDataSource1 = (ObjectDataSource)objParent.FindControl("ObjectDataSource1");

            var dv = (DataView)ObjectDataSource1.Select();
            var OrderDetailID = ((HiddenField)row.FindControl("hdnOrderDetailID")).Value;
            var ddlProduct = (RadComboBox)row.FindControl("ddlProduct");

            if (!string.IsNullOrEmpty(OrderDetailID))
            {
                dv.RowFilter = "OrderDetailID = " + OrderDetailID;

                if (!string.IsNullOrEmpty(dv[0]["ProductID"].ToString()))
                    ddlProduct.SelectedValue = dv[0]["ProductID"].ToString();
            }
        }
    }
    protected void RadGrid2_DataBound(object sender, EventArgs e)
    {
        var RadGrid2 = (RadGrid)sender;
        var ObjectDataSource1 = (ObjectDataSource)RadGrid2.Parent.FindControl("ObjectDataSource1");
        var footerItem = (GridFooterItem)RadGrid2.MasterTableView.GetItems(GridItemType.Footer)[0];
        var lblTotal = (Label)footerItem.FindControl("lblTotal");
        var dt = ((DataView)ObjectDataSource1.Select()).Table;
        var totalPrice = string.Format("{0:##,###.##}", dt.Compute("SUM(TotalPrice)", ""));

        if (lblTotal != null)
            lblTotal.Text = string.IsNullOrEmpty(totalPrice.ToString()) ? "0" : totalPrice.ToString();
    }

    #endregion

}