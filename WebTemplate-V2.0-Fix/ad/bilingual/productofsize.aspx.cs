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
using System.Web.Services;

public partial class ad_single_productofsize : System.Web.UI.Page
{
    #region Event

    protected void DropDownList_DataBound(object sender, EventArgs e)
    {
        var cbo = (RadComboBox)sender;
        cbo.Items.Insert(0, new RadComboBoxItem("--Chọn--"));
    }
    protected void ListBox_DataBound(object sender, EventArgs e)
    {
        var listBox = (RadListBox)sender;
        listBox.SortItems();
    }

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

        var DuplicateSize = from RadListBoxItem item in lstAllSize.Items
                            join RadListBoxItem item1 in lstChoosedSize.Items
                               on item.Text equals item1.Text
                            select item.Index;

        while (DuplicateSize.Count() > 0)
            lstAllSize.Items[DuplicateSize.First()].Remove();
    }

    protected void AllSize_Transferred(object sender, RadListBoxTransferredEventArgs e)
    {
        var DestinationListBox = e.DestinationListBox;
        string ProductID;
        ProductID = Request.QueryString["pi"];
        var oProductOfLength = new ProductOfLength();
        foreach (RadListBoxItem item in e.Items)
        {
            if (DestinationListBox.ID == "lstAllSize")
            {
                string ProSizeID;
                ProSizeID = item.Value.ToString();
                //Update ProductFormSize Status
                //var dv = new Product_Size().Product_SizeSelectAll(ProductID, SizeID, "", "", "", "", "").DefaultView;
                var dv = oProductOfLength.ProductOfLengthSelectOne(ProSizeID).DefaultView;
                if (dv.Table.Rows.Count > 0)
                {
                    oProductOfLength.ProductOfLengthDelete(ProSizeID);
                }
            }
            else if (DestinationListBox.ID == "lstChoosedSize")
            {
                //Insert ProductFormSize 
                var selectedItem = e.DestinationListBox.FindItemByValue(item.Value);
                string ProductSizeID = item.Value;
                var dv = oProductOfLength.ProductOfLengthSelectAll("", "", "True", ProductID, ProductSizeID).DefaultView;
                var lblName = (Label)selectedItem.FindControl("lblName");
                var txtPriority = (RadNumericTextBox)selectedItem.FindControl("txtPriority");

                if (dv.Table.Rows.Count > 0)
                {
                    //if (dv[0]["IsAvailable"].ToString() != "True")
                    //{
                    //    oProductOfLength.ProductOfLengthQuickUpdate(dv[0]["ProductOfLengthID"].ToString(), "true", "");
                    //}
                    if (lblName != null)
                        lblName.Text = item.Text;
                    if (dv[0]["Priority"] != DBNull.Value)
                        txtPriority.Value = Convert.ToInt32(dv[0]["Priority"]);
                }
                else
                    oProductOfLength.ProductOfLengthInsert("True", txtPriority.Text, ProductID.ToString(), ProductSizeID.ToString());
            }
        }
        DataBindListBoxSize();
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        string Priority, ProductOfLengthID, IsAvailable;
        var oProductOfLength = new ProductOfLength();
        RadListBoxItemCollection choosesizes = lstChoosedSize.Items;

        foreach (RadListBoxItem item in choosesizes)
        {
            ProductOfLengthID = item.Value.ToString();
            Priority = ((RadNumericTextBox)item.FindControl("txtPriority")).Text.Trim();
            IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

            oProductOfLength.ProductOfLengthQuickUpdate(
                ProductOfLengthID,
                IsAvailable,
                Priority
            );
        }
    }
    #endregion
    #region ajax
    //[WebMethod]
    //public static void UpdatePriorityOfSize(string ProductOfLengthID, string Priority)
    //{
    //    if (ProductOfLengthID != "null")
    //    {
    //        try
    //        {
    //            new TLLib.ProductOfLength().ProductOfLengthUpdate(ProductOfLengthID, "True", Priority, "", "");
    //        }
    //        catch (Exception ex)
    //        {

    //        }
    //    }
    //}
    //[WebMethod]
    //public static void UpdateIsShowOfSizer(string ProductOfLengthID, string IsAvailable)
    //{
    //    if (ProductOfLengthID != "null")
    //    {
    //        try
    //        {
    //            new TLLib.ProductOfLength().ProductOfLengthUpdate(ProductOfLengthID, IsAvailable, "", "", "");
    //        }
    //        catch (Exception ex)
    //        {

    //        }
    //    }
    //}
    #endregion

    protected void lstAllSize_ItemDataBound(object sender, RadListBoxItemEventArgs e)
    {
        RadAjaxPanel1.ResponseScripts.Add(string.Format("window['AllSize'] = '{0}';",lstAllSize.ClientID));
    }
}