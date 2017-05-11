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


public partial class ad_single_comment : System.Web.UI.Page
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
            RadGrid1.MasterTableView.SortExpressions.Clear();
            GridSortExpression sortExpr1 = new GridSortExpression();
            sortExpr1.FieldName = "CreateDate";
            sortExpr1.SortOrder = GridSortOrder.Descending;
            RadGrid1.MasterTableView.SortExpressions.AddSortExpression(sortExpr1);

            string strUserName = Request.QueryString["usn"];
            if (!string.IsNullOrEmpty(strUserName))
                ddlSearchUser.SelectedValue = strUserName;
        }
    }
    
    protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
    {
        if (e.CommandName == "QuickUpdate")
        {
            string CommentID, Priority = "", IsApproved, IsAvailable;
            var oComment = new Comment();

            foreach (GridDataItem item in RadGrid1.Items)
            {
                CommentID = item.GetDataKeyValue("CommentID").ToString();
                IsApproved = ((CheckBox)item.FindControl("chkIsApproved")).Checked.ToString();
                IsAvailable = ((CheckBox)item.FindControl("chkIsAvailable")).Checked.ToString();

                oComment.CommentQuickUpdate(
                    CommentID,
                    IsApproved,
                    IsAvailable,
                    Priority
                );
            }
        }
    }

    #endregion
}