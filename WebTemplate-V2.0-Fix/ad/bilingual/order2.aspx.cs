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

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridNestedViewItem)
        {
            var oOrderDetail = new OrderDetail();
            var nestedItem = (GridNestedViewItem)e.Item;
            var hdnOrderID = (HiddenField)nestedItem.FindControl("hdnOrderID");
            var RadGrid2 = (RadGrid)nestedItem.FindControl("RadGrid2");
            var ObjectDataSource1 = (ObjectDataSource)nestedItem.FindControl("ObjectDataSource1");
            hdnOrderID.Value = nestedItem.ParentItem["Order2ID"].Text;
            ((RadGrid)nestedItem.FindControl("RadGrid2")).DataSourceID = ObjectDataSource1.ID;
        }
    }
    protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
    {
        if (e.CommandName == "PerformInsert" || e.CommandName == "Update")
        {
            var command = e.CommandName;
            var row = command == "PerformInsert" ? (GridEditFormInsertItem)e.Item : (GridEditFormItem)e.Item;
            var strOrderStatusID = ((RadComboBox)row.FindControl("ddlOrderStatus")).SelectedValue;

            if (e.CommandName == "PerformInsert")
            {
                var strOrderID = Guid.NewGuid().GetHashCode().ToString("X");
                ObjectDataSource1.InsertParameters["Order2ID"].DefaultValue = strOrderID;
                ObjectDataSource1.InsertParameters["OrderStatusID"].DefaultValue = strOrderStatusID;
                ObjectDataSource1.InsertParameters["UserName"].DefaultValue = User.Identity.Name;
            }
            else
            {
                ObjectDataSource1.UpdateParameters["OrderStatusID"].DefaultValue = strOrderStatusID;
                ObjectDataSource1.UpdateParameters["UserName"].DefaultValue = User.Identity.Name;
            }
        }
        else if (e.CommandName == "QuickUpdate")
        {
            string OrderID, OrderStatusID;
            var oOrder = new Orders2();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                OrderID = item.GetDataKeyValue("Order2ID").ToString();
                OrderStatusID = ((RadComboBox)item.FindControl("ddlOrderStatus")).SelectedValue;

                oOrder.Order2QuickUpdate(
                    OrderID,
                    OrderStatusID
                );
            }
        }
    }
    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            var itemtype = e.Item.ItemType;
            var row = itemtype == GridItemType.EditFormItem ? (GridEditFormItem)e.Item : (GridEditFormInsertItem)e.Item;
            var ddlOrderStatus = (RadComboBox)row.FindControl("ddlOrderStatus");
            var OrderStatusID = ddlOrderStatus.Attributes["SelectedID"];

            if (!string.IsNullOrEmpty(OrderStatusID))
                ddlOrderStatus.SelectedValue = OrderStatusID;
        }
        else if (e.Item is GridDataItem)
        {
            var ddlOrderStatus = (RadComboBox)e.Item.FindControl("ddlOrderStatus");
            var OrderStatusID = ddlOrderStatus.Attributes["SelectedID"];

            if (!string.IsNullOrEmpty(OrderStatusID))
                ddlOrderStatus.SelectedValue = OrderStatusID;
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
                    ObjectDataSource1.InsertParameters["Order2ID"].DefaultValue = OrderID;
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
                dv.RowFilter = "OrderDetail2ID = " + OrderDetailID;

                if (!string.IsNullOrEmpty(dv[0]["ProductID"].ToString()))
                    ddlProduct.SelectedValue = dv[0]["ProductID"].ToString();
            }
        }
    }
    protected void RadGrid2_DataBound(object sender, EventArgs e)
    {
        try
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
        catch { }
    }

    #endregion
}