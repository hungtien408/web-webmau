using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Threading;
using System.Globalization;

public partial class site : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture("vi-VN");
        Thread.CurrentThread.CurrentUICulture = new CultureInfo("vi-VN");
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        //Page.RegisterStartupScript("onLoad", "<script type='text/javascript'>DisplaySessionTimeout()</script>");
    }
}
