using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for ShoppingCart
/// </summary>
public class ShoppingCart
{
    public void CreateCart(
        string ProductID,
        string ImageName,
        string ProductName,
        string ProductNameEn,
        string ProductCode,
        string ProductOrigin,
        double ProductPrice,
        double ProductSavePrice,
        string ProductOtherPrice,
        string Quantity
        )
    {
        var sessionCart = HttpContext.Current.Session["Cart"];
        DataTable dtCart;
        if (sessionCart == null)
        {
            dtCart = new DataTable();
            dtCart.Columns.Add("ProductID");
            dtCart.Columns.Add("ImageName");
            dtCart.Columns.Add("ProductName");
            dtCart.Columns.Add("ProductNameEn");
            dtCart.Columns.Add("ProductCode");
            dtCart.Columns.Add("ProductOrigin");
            dtCart.Columns.Add("ProductPrice", typeof(double));
            dtCart.Columns.Add("ProductSavePrice", typeof(double));
            dtCart.Columns.Add("ProductOtherPrice");
            dtCart.Columns.Add("Quantity");

            dtCart.Rows.Add(new object[] { ProductID, ImageName, ProductName, ProductNameEn, ProductCode, ProductOrigin, ProductPrice, ProductSavePrice,ProductOtherPrice, Quantity });
        }
        else
        {
            dtCart = sessionCart as DataTable;

            var existRow = (from DataRow dr in dtCart.Rows
                            where dr["ProductID"].ToString() == ProductID
                            select dr).FirstOrDefault();

            if (existRow == null)
            {
                dtCart.Rows.Add(new object[] { ProductID, ImageName, ProductName, ProductNameEn, ProductCode, ProductOrigin, ProductPrice, ProductSavePrice,ProductOtherPrice, Quantity });
            }
            else
            {

                var Quantiy1 = Convert.ToInt32(existRow["Quantity"]);
                existRow["Quantity"] = Quantiy1;
                (from DataRow dr in dtCart.Rows
                 where dr["ProductID"].ToString() == ProductID
                 select dr).FirstOrDefault()["Quantity"] = Convert.ToInt32(Quantity) + Quantiy1;
            }
        }

        HttpContext.Current.Session["Cart"] = dtCart;
    }

    public void DeleteItem(string ProductID)
    {
        if (HttpContext.Current.Session["Cart"] != null)
        {
            var dtCart = (HttpContext.Current.Session["Cart"] as DataTable).DefaultView;

            (from DataRowView dr in dtCart
             where dr["ProductID"].ToString() == ProductID
             select dr).FirstOrDefault().Delete();

            HttpContext.Current.Session["Cart"] = dtCart.ToTable();
        }
    }
    public void DeleteAllItem()
    {
        if (HttpContext.Current.Session["Cart"] != null)
        {
            var dtCart = (HttpContext.Current.Session["Cart"] as DataTable).DefaultView;
            foreach (DataRowView dr in dtCart)
            {
                string ProductID = dr.Row.ItemArray[0].ToString();
                DeleteItem(ProductID);
            }
        }
    }

    public void UpdateQuantity(string ProductID, string Quantity,double ProductPrice)
    {
        if (HttpContext.Current.Session["Cart"] != null)
        {
            var dtCart = HttpContext.Current.Session["Cart"] as DataTable;

            (from DataRow dr in dtCart.Rows
             where dr["ProductID"].ToString() == ProductID
             select dr).FirstOrDefault()["Quantity"] = Quantity;

            (from DataRow dr in dtCart.Rows
             where dr["ProductID"].ToString() == ProductID
             select dr).FirstOrDefault()["ProductPrice"] = ProductPrice;

            HttpContext.Current.Session["Cart"] = dtCart;
        }
    }
    public void UpdateQuantity(string ProductID, string Quantity)
    {
        if (HttpContext.Current.Session["Cart"] != null)
        {
            var dtCart = HttpContext.Current.Session["Cart"] as DataTable;

            (from DataRow dr in dtCart.Rows
             where dr["ProductID"].ToString() == ProductID
             select dr).FirstOrDefault()["Quantity"] = Quantity;

            HttpContext.Current.Session["Cart"] = dtCart;
        }
    }
    public DataTable Cart()
    {
        if (HttpContext.Current.Session["Cart"] != null)
        {
            return HttpContext.Current.Session["Cart"] as DataTable;
        }

        return null;
    }
    public void emptyCart()
    {
        var cart = HttpContext.Current.Session["Cart"] as DataTable;
        cart.Clear();


    }
}