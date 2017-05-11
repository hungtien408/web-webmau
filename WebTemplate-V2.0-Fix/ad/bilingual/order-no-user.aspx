<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/adminEn.master" AutoEventWireup="true"
    CodeFile="order-no-user.aspx.cs" Inherits="ad_single_order" %>

<%@ Register TagPrefix="asp" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="Server">
    <script type="text/javascript">
        var tableView = null;
        function RowDblClick(sender, eventArgs) {
            sender.get_masterTableView().editItem(eventArgs.get_itemIndexHierarchical());
        }

        function RowMouseOver(sender, eventArgs) {
            var selectedRows = sender.get_masterTableView().get_selectedItems();
            var elem = $get(eventArgs.get_id());
            if (selectedRows.length > 0)
                for (var i = 0; i < selectedRows.length; i++) {
                    var selectedID = selectedRows[i].get_id();

                    if (selectedID != eventArgs.get_id())
                        elem.className += (" rgSelectedRow");
                }
        else
            elem.className += (" rgSelectedRow");
    }

    function RowMouseOut(sender, eventArgs) {
        var className = "rgSelectedRow";
        var elem = $get(eventArgs.get_id());

        var selectedRows = sender.get_masterTableView().get_selectedItems();

        if (selectedRows.length > 0)
            for (var i = 0; i < selectedRows.length; i++) {
                var selectedID = selectedRows[i].get_id();
                if (selectedID != eventArgs.get_id())
                    removeCssClass(className, elem);
            }
    else
        removeCssClass(className, elem);
}

function removeCssClass(className, element) {
    element.className = element.className.replace(className, "").replace(/^\s+/, '').replace(/\s+$/, '');
}

function pageLoad(sender, args) {
    tableView = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
}

function RadComboBox1_SelectedIndexChanged(sender, args) {
    tableView.set_pageSize(sender.get_value());
}

function changePage(argument) {
    tableView.page(argument);
}

function RadNumericTextBox1_ValueChanged(sender, args) {
    tableView.page(sender.get_value());
}

function conditionalPostback(sender, eventArgs) {
    if (eventArgs.get_eventTarget().indexOf("ExportToExcelButton") >= 0 || eventArgs.get_eventTarget().indexOf("ExportToWordButton") >= 0 || eventArgs.get_eventTarget().indexOf("ExportToPdfButton") >= 0)
        eventArgs.set_enableAjax(false);
}
    </script>
    <style type="text/css">
        .viewWrap
        {
            padding: 15px;
            background: #2291b5 0 0 url(../assets/images/bluegradient.gif) repeat-x;
        }
        .contactWrap
        {
            padding: 10px 15px 15px 15px;
            background: #fff;
            color: #333;
        }
        .grid-footer td
        {
            background-color: #fff;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <h3 class="mainTitle">
        <img alt="" src="../assets/images/order.png" class="vam" />
        Đơn Hàng</h3>
    <br />
    <asp:RadAjaxPanel ID="RadAjaxPanel1" runat="server" ClientEvents-OnRequestStart="conditionalPostback">
        <asp:Panel ID="pnlSearch" DefaultButton="btnSearch" runat="server">
            <table class="search">
                <tr>
                    <td class="left">
                        Mã Đơn Hàng
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchOrderID" runat="server" Width="130px" EmptyMessage="Mã đơn hàng">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Email
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchUserName" runat="server" Width="130px" EmptyMessage="Email...">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Từ Ngày
                    </td>
                    <td>
                        <asp:RadDatePicker ShowPopupOnFocus="True" ID="dpFromDate" runat="server" Calendar-CultureInfo="vi-VN"
                            Width="138px">
                            <Calendar ID="Calendar1" runat="server">
                                <SpecialDays>
                                    <asp:RadCalendarDay Repeatable="Today">
                                        <ItemStyle CssClass="rcToday" />
                                    </asp:RadCalendarDay>
                                </SpecialDays>
                            </Calendar>
                        </asp:RadDatePicker>
                    </td>
                    <td class="left">
                        Đến ngày
                    </td>
                    <td>
                        <asp:RadDatePicker ShowPopupOnFocus="True" ID="dpToDate" runat="server" Calendar-CultureInfo="vi-VN"
                            Width="138px">
                            <Calendar ID="Calendar2" runat="server">
                                <SpecialDays>
                                    <asp:RadCalendarDay Repeatable="Today">
                                        <ItemStyle CssClass="rcToday" />
                                    </asp:RadCalendarDay>
                                </SpecialDays>
                            </Calendar>
                        </asp:RadDatePicker>
                    </td>
                </tr>
                <tr>
                    <td class="left">
                        Tình trạng đơn hàng
                    </td>
                    <td>
                        <asp:RadComboBox ID="ddlSearchOrderStatus" runat="server" CssClass="dropdownlist"
                            DataSourceID="OdsOrderStatus" DataTextField="OrderStatusName" DataValueField="OrderStatusID"
                            Filter="Contains" OnDataBound="DropDownList_DataBound" Width="130px" EmptyMessage="- Chọn -">
                        </asp:RadComboBox>
                        <asp:ObjectDataSource ID="OdsOrderStatus" runat="server" SelectMethod="OrderStatusSelectAll"
                            TypeName="TLLib.OrderStatus">
                            <SelectParameters>
                                <asp:Parameter Name="OrderStatusID" Type="String" />
                                <asp:Parameter Name="OrderStatusName" Type="String" />
                                <asp:Parameter Name="OrderStatusNameEn" Type="String" />
                                <asp:Parameter DefaultValue="True" Name="IsAvailable" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                    <td class="left">
                        Tình trạng vận chuyển
                    </td>
                    <td>
                        <asp:RadComboBox ID="ddlSearchShippingStatus" runat="server" CssClass="dropdownlist"
                            DataSourceID="OdsShippingStatus" DataTextField="ShippingStatusName" DataValueField="ShippingStatusID"
                            Filter="Contains" OnDataBound="DropDownList_DataBound" Width="130px" EmptyMessage="- Chọn -">
                        </asp:RadComboBox>
                        <asp:ObjectDataSource ID="OdsShippingStatus" runat="server" SelectMethod="ShippingStatusSelectAll"
                            TypeName="TLLib.ShippingStatus">
                            <SelectParameters>
                                <asp:Parameter Name="ShippingStatusID" Type="String" />
                                <asp:Parameter Name="ShippingStatusName" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                    <td class="left">
                        Hình thức thanh toán
                    </td>
                    <td>
                        <asp:RadComboBox ID="ddlSearchPaymentMethod" runat="server" CssClass="dropdownlist"
                            DataSourceID="OdsPaymentMethod" DataTextField="PaymentMethodName" DataValueField="PaymentMethodID"
                            Filter="Contains" OnDataBound="DropDownList_DataBound" Width="130px" EmptyMessage="- Chọn -">
                        </asp:RadComboBox>
                        <asp:ObjectDataSource ID="OdsPaymentMethod" runat="server" SelectMethod="PaymentMethodSelectAll"
                            TypeName="TLLib.PaymentMethod">
                            <SelectParameters>
                                <asp:Parameter Name="PaymentMethodID" Type="String" />
                                <asp:Parameter Name="PaymentMethodName" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                    <td class="left">
                        Ghi chú
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchNote" runat="server" EmptyMessage="Ghi Chú..." Width="130px">
                        </asp:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td class="left" valign="top">
                        Tỉnh/Thành
                    </td>
                    <td>
                        <asp:RadAjaxPanel ID="RadAjaxPanel2" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
                            <asp:RadComboBox ID="ddlProvince" EmptyMessage="- Chọn -" runat="server" Width="130px"
                                AutoPostBack="True" DataSourceID="OdsProvince" DataTextField="ProvinceName" OnDataBound="DropDownList_DataBound"
                                ShowPostBackMask="False" OnSelectedIndexChanged="ddlSearchProvince_SelectedIndexChanged"
                                DataValueField="ProvinceID" Filter="Contains" Height="300">
                            </asp:RadComboBox>
                            <asp:ObjectDataSource ID="OdsProvince" runat="server" SelectMethod="ProvinceSelectAll"
                                TypeName="TLLib.Province">
                                <SelectParameters>
                                    <asp:Parameter Name="ProvinceID" Type="String" />
                                    <asp:Parameter Name="ProvinceName" Type="String" />
                                    <asp:Parameter Name="ShortName" Type="String" />
                                    <asp:Parameter Name="CountryID" Type="String" DefaultValue="1" />
                                    <asp:Parameter Name="Priority" Type="String" />
                                    <asp:Parameter DefaultValue="True" Name="IsAvailable" Type="String" />
                                    <asp:Parameter DefaultValue="True" Name="SortByPriority" Type="String" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </asp:RadAjaxPanel>
                    </td>
                    <td class="left" valign="top">
                        Quận/Huyện
                    </td>
                    <td>
                        <asp:RadAjaxPanel ID="RadAjaxPanel3" runat="server" ShowPostBackMask="False" LoadingPanelID="RadAjaxLoadingPanel1">
                            <asp:RadComboBox ID="ddlDistrict" OnDataBound="DropDownList_DataBound" runat="server"
                                Width="130px" DataSourceID="odsDistrict" DataTextField="DistrictName" EmptyMessage="- Chọn -"
                                DataValueField="DistrictID" Filter="Contains" Height="300">
                            </asp:RadComboBox>
                            <asp:ObjectDataSource ID="odsDistrict" runat="server" SelectMethod="DistrictSelectAll"
                                TypeName="TLLib.District">
                                <SelectParameters>
                                    <asp:Parameter Name="DistrictName" Type="String" />
                                    <asp:ControlParameter ControlID="ddlProvince" Name="ProvinceIDs" DefaultValue="0"
                                        PropertyName="SelectedValue" Type="String" />
                                    <asp:Parameter DefaultValue="True" Name="IsAvailable" Type="String" />
                                    <asp:Parameter Name="Priority" Type="String" />
                                    <asp:Parameter DefaultValue="True" Name="SortByPriority" Type="String" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </asp:RadAjaxPanel>
                    </td>
                </tr>
                <%--<tr class="invisible">
                    <td class="left">
                        Khu vực
                    </td>
                    <td>
                        <asp:RadComboBox ID="ddlServiceCategory" runat="server" AutoPostBack="true" CssClass="dropdownlist"
                            DataSourceID="OdsServiceCategory" DataTextField="ServiceCategoryName" DataValueField="ServiceCategoryID"
                            Filter="Contains" OnDataBound="DropDownList_DataBound" Width="130px" EmptyMessage="- Chọn -">
                        </asp:RadComboBox>
                        <asp:ObjectDataSource ID="OdsServiceCategory" runat="server" SelectMethod="ServiceCategorySelectAll"
                            TypeName="TLLib.ServiceCategory">
                            <SelectParameters>
                                <asp:Parameter Name="parentID" Type="Int32" DefaultValue="0" />
                                <asp:Parameter Name="increaseLevelCount" Type="Int32" DefaultValue="1" />
                                <asp:Parameter Name="IsShowOnMenu" Type="String" DefaultValue="true" />
                                <asp:Parameter Name="IsShowOnHomePage" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                    <td class="left">
                        Nhân viên tư vấn
                    </td>
                    <td>
                        <asp:RadComboBox ID="ddlService" runat="server" CssClass="dropdownlist" DataSourceID="OdsService"
                            DataTextField="ServiceTitle" DataValueField="ServiceID" Filter="Contains" OnDataBound="DropDownList_DataBound"
                            Width="130px" EmptyMessage="- Chọn -">
                        </asp:RadComboBox>
                        <asp:ObjectDataSource ID="OdsService" runat="server" SelectMethod="ServiceSelectAll"
                            TypeName="TLLib.Service">
                            <SelectParameters>
                                <asp:Parameter Name="StartRowIndex" Type="String" />
                                <asp:Parameter Name="EndRowIndex" Type="String" />
                                <asp:Parameter Name="ServiceTitle" Type="String" />
                                <asp:Parameter Name="Description" Type="String" />
                                <asp:ControlParameter ControlID="ddlServiceCategory" DefaultValue="0" Name="ServiceCategoryID"
                                    PropertyName="SelectedValue" Type="String" />
                                <asp:Parameter Name="Tag" Type="String" />
                                <asp:Parameter Name="IsShowOnHomePage" Type="String" />
                                <asp:Parameter Name="IsHot" Type="String" />
                                <asp:Parameter Name="IsNew" Type="String" />
                                <asp:Parameter Name="FromDate" Type="String" />
                                <asp:Parameter Name="ToDate" Type="String" />
                                <asp:Parameter DefaultValue="true" Name="IsAvailable" Type="String" />
                                <asp:Parameter Name="Priority" Type="String" />
                                <asp:Parameter DefaultValue="true" Name="SortByPriority" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                </tr>--%>
            </table>
            <div align="right" style="padding: 5px 0 5px 0; border-bottom: 1px solid #ccc; margin-bottom: 10px">
                <asp:RadButton ID="btnSearch" runat="server" Text="Tìm kiếm">
                    <Icon PrimaryIconUrl="~/ad/assets/images/find.png" />
                </asp:RadButton>
            </div>
        </asp:Panel>
        <asp:Label ID="lblError" ForeColor="Red" runat="server"></asp:Label>
        <asp:RadGrid ID="RadGrid1" AllowMultiRowSelection="True" runat="server" Culture="vi-VN"  PageSize="20"
            DataSourceID="OdsOrder" GridLines="Horizontal" AutoGenerateColumns="False" AllowAutomaticDeletes="True"
            ShowStatusBar="True" OnItemCommand="RadGrid1_ItemCommand" OnItemDataBound="RadGrid1_ItemDataBound"
            CssClass="grid" AllowPaging="True" AllowSorting="True" OnItemCreated="RadGrid1_ItemCreated"
            CellSpacing="0">
            <ClientSettings EnableRowHoverStyle="true">
                <Selecting AllowRowSelect="True" UseClientSelectColumnOnly="True" />
                <Resizing AllowColumnResize="true" ClipCellContentOnResize="False" />
            </ClientSettings>
            <ExportSettings IgnorePaging="true" OpenInNewWindow="true" ExportOnlyData="true"
                Excel-Format="ExcelML" Pdf-AllowCopy="true">
                <Pdf AllowCopy="True" />
                <Excel Format="ExcelML" />
            </ExportSettings>
            <MasterTableView CommandItemDisplay="TopAndBottom" DataSourceID="OdsOrder" InsertItemPageIndexAction="ShowItemOnCurrentPage"
                AllowMultiColumnSorting="True" DataKeyNames="OrderID">
                <PagerStyle AlwaysVisible="true" Mode="NextPrevNumericAndAdvanced" PageButtonCount="10"
                    FirstPageToolTip="Trang đầu" LastPageToolTip="Trang cuối" NextPagesToolTip="Trang kế"
                    NextPageToolTip="Trang kế" PagerTextFormat="Đổi trang: {4} &nbsp;Trang <strong>{0}</strong> / <strong>{1}</strong>, Kết quả <strong>{2}</strong> - <strong>{3}</strong> trong <strong>{5}</strong>."
                    PageSizeLabelText="Kết quả mỗi trang:" PrevPagesToolTip="Trang trước" PrevPageToolTip="Trang trước" />
                <CommandItemTemplate>
                    <div class="command">
                        <div style="float: right">
                            <asp:Button ID="ExportToExcelButton" runat="server" CssClass="rgExpXLS" CommandName="ExportToExcel"
                                AlternateText="Excel" ToolTip="Export to Excel" />
                            <asp:Button ID="ExportToPdfButton" runat="server" CssClass="rgExpPDF" CommandName="ExportToPdf"
                                AlternateText="PDF" ToolTip="Export to PDF" />
                            <asp:Button ID="ExportToWordButton" runat="server" CssClass="rgExpDOC" CommandName="ExportToWord"
                                AlternateText="Word" ToolTip="Export to Word" />
                        </div>
                        <%--<asp:LinkButton ID="LinkButton2" runat="server" CommandName="InitInsert" Visible='<%# !RadGrid1.MasterTableView.IsItemInserted %>'
                            CssClass="item"><img class="vam" alt="" src="../assets/images/add.png" /> Add</asp:LinkButton>|--%>
                        <%--<asp:LinkButton ID="LinkButton3" runat="server" CommandName="PerformInsert" Visible='<%# RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/accept.png" /> Add</asp:LinkButton>&nbsp;&nbsp;
                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="CancelAll" Visible='<%# RadGrid1.EditIndexes.Count > 0 || RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/delete-icon.png" /> Cancel</asp:LinkButton>&nbsp;&nbsp;--%>
                        <%--<asp:LinkButton ID="btnEditSelected" runat="server" CommandName="EditSelected" Visible='<%# RadGrid1.EditIndexes.Count == 0 %>'
                            CssClass="item"><img width="12px" class="vam" alt="" src="../assets/images/tools.png" /> Edit</asp:LinkButton>|--%>
                        <%--<asp:LinkButton ID="btnUpdateEdited" runat="server" CommandName="UpdateEdited" Visible='<%# RadGrid1.EditIndexes.Count > 0 %>'><img class="vam" alt="" src="../assets/images/accept.png" /> Update</asp:LinkButton>&nbsp;&nbsp;--%>
                        <asp:LinkButton ID="lnkbQuickUpdate" runat="server" CommandName="QuickUpdate" Visible='<%# RadGrid1.EditIndexes.Count == 0 %>'
                            CssClass="item"><img class="vam" alt="" src="../assets/images/accept.png" /> Sửa nhanh</asp:LinkButton>|
                        <asp:LinkButton ID="LinkButton1" OnClientClick="javascript:return confirm('Delete seleted rows?')"
                            runat="server" CommandName="DeleteSelected" CssClass="item"><img class="vam" alt="" title="Delete seleted rows" src="../assets/images/delete-icon.png" /> Xóa</asp:LinkButton>|
                        <asp:LinkButton ID="LinkButton4" runat="server" CommandName="RebindGrid" CssClass="item"><img class="vam" alt="" src="../assets/images/reload.png" /> Làm mới</asp:LinkButton>
                    </div>
                    <div class="clear">
                    </div>
                    <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                </CommandItemTemplate>
                <CommandItemSettings ExportToPdfText="Export to Pdf" />
                <Columns>
                    <asp:GridClientSelectColumn FooterText="CheckBoxSelect footer" HeaderStyle-Width="1%"
                        UniqueName="CheckboxSelectColumn">
                    </asp:GridClientSelectColumn>
                    <asp:GridTemplateColumn HeaderStyle-Width="1%" Visible="False" HeaderText="STT.">
                        <ItemTemplate>
                            <%# Container.DataSetIndex + 1 %>
                            <asp:HiddenField ID="hdnEmail" Value='<%# Eval("Email") %>' runat="server" />
                            <asp:HiddenField ID="hdnFullName" Value='<%# Eval("FirstName") %>' runat="server" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridBoundColumn DataField="OrderID" HeaderText="Mã đơn hàng" SortExpression="OrderID">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn DataField="UserName" HeaderText="Tài khoản" SortExpression="UserName"
                        Visible="false">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn DataField="BillingAddressID" SortExpression="BillingAddressID"
                        Visible="false">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn DataField="ShippingAddressID" SortExpression="ShippingAddressID"
                        Visible="false">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn DataField="CreateDate" DataFormatString="{0: MM/dd/yyyy hh:mm tt}"
                        HeaderText="Ngày tạo" SortExpression="CreateDate">
                    </asp:GridBoundColumn>
                    <asp:GridTemplateColumn HeaderStyle-Width="1%" HeaderText="Tình trạng đơn hàng" DataField="OrderStatusID"
                        SortExpression="OrderStatusID">
                        <ItemTemplate>
                            <asp:RadComboBox ID="ddlOrderStatus" runat="server" CssClass="dropdownlist" DataSourceID="OdsOrderStatus"
                                DataTextField="OrderStatusName" DataValueField="OrderStatusID" Filter="Contains"
                                OnDataBound="DropDownList_DataBound" Width="100px" EmptyMessage="- Chọn -">
                            </asp:RadComboBox>
                            <asp:HiddenField ID="hdnOrderStatusID" runat="server" Value='<%# Eval("OrderStatusID") %>' />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderStyle-Width="1%" HeaderText="Hình thức thanh toán"
                        DataField="PaymentMethodID" SortExpression="PaymentMethodID">
                        <ItemTemplate>
                            <asp:RadComboBox ID="ddlPaymentMethod" runat="server" CssClass="dropdownlist" DataSourceID="OdsPaymentMethod"
                                DataTextField="PaymentMethodName" DataValueField="PaymentMethodID" Filter="Contains"
                                OnDataBound="DropDownList_DataBound" Width="100px" EmptyMessage="- Chọn -">
                            </asp:RadComboBox>
                            <asp:HiddenField ID="hdnPaymentMethodID" runat="server" Value='<%# Eval("PaymentMethodID") %>' />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderStyle-Width="1%" HeaderText="Tình trạng thanh toán"
                        DataField="PayStatusID" SortExpression="PayStatusID">
                        <ItemTemplate>
                            <asp:RadComboBox ID="ddlPayStatus" runat="server" CssClass="dropdownlist" DataSourceID="odsPayStatus"
                                DataTextField="PayStatusName" DataValueField="PayStatusID" Filter="Contains"
                                OnDataBound="DropDownList_DataBound" Width="100px" EmptyMessage="- Chọn -">
                            </asp:RadComboBox>
                            <asp:HiddenField ID="hdnPayStatusID" runat="server" Value='<%# Eval("PayStatusID") %>' />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderStyle-Width="1%" HeaderText="Tình trạng vận chuyển"
                        DataField="ShippingStatusID" SortExpression="ShippingStatusID">
                        <ItemTemplate>
                            <asp:RadComboBox ID="ddlShippingStatus" runat="server" CssClass="dropdownlist" DataSourceID="OdsShippingStatus"
                                DataTextField="ShippingStatusName" DataValueField="ShippingStatusID" Filter="Contains"
                                OnDataBound="DropDownList_DataBound" Width="100px" EmptyMessage="- Chọn -">
                            </asp:RadComboBox>
                            <asp:HiddenField ID="hdnShippingStatusID" runat="server" Value='<%# Eval("ShippingStatusID") %>' />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="OrderTotal" HeaderText="Tổng tiền" SortExpression="OrderTotal">
                        <ItemTemplate>
                            <%# string.Format("{0:##,###.##}", Eval("OrderTotal")) + " VNĐ"%>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <%--<asp:GridBoundColumn DataField="ShippingAddress" HeaderText="Địa chỉ chuyển hàng" SortExpression="ShippingAddress">
                    </asp:GridBoundColumn>--%>
                    <%--<asp:GridBoundColumn DataField="BillingAddress" HeaderText="Billing Address" SortExpression="BillingAddress">
                    </asp:GridBoundColumn>--%>
                    <asp:GridTemplateColumn DataField="Notes" HeaderText="Ghi chú" SortExpression="Notes">
                        <ItemTemplate>
                            <div align="center">
                                <asp:RadTextBox ID="txtNotes" runat="server" EmptyMessage="Ghi chú..." Width="150px"
                                    TextMode="MultiLine" Text='<%# Eval("Notes") %>'>
                                </asp:RadTextBox>
                            </div>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="Email" HeaderText="Email" SortExpression="Email">
                        <ItemTemplate>
                            <div align="left">
                                <asp:Label ID="lblEmail" runat="server" Text='<%# Eval("Email").ToString()%>'></asp:Label>
                            </div>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridBoundColumn DataField="UserName" Visible="False" HeaderText="UserName" SortExpression="UserName">
                    </asp:GridBoundColumn>
                    <asp:GridTemplateColumn DataField="ServiceID" Visible="False" HeaderText="Thanh toán"
                        SortExpression="Notes">
                        <ItemTemplate>
                            <div align="center">
                                <asp:Label ID="lblCheckOut" runat="server" Text='<%# Eval("ServiceID").ToString() == "2" ? "Thanh toán trước 50%" : "Thanh toán toàn bộ" %>'></asp:Label>
                            </div>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="ProvinceName,DistrictName" HeaderText="Tỉnh/Thành - Quận/Huyện" SortExpression="ProvinceName,DistrictName">
                        <ItemTemplate>
                            <div align="center">
                                <%# Eval("ProvinceName") + "<br/>" + Eval("DistrictName") %>
                            </div>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                </Columns>
                <EditFormSettings EditFormType="Template">
                    <FormTemplate>
                        <asp:Panel ID="Panel1" runat="server" DefaultButton="lnkUpdate">
                            <h3 class="searchTitle">
                                Thông tin đơn hàng
                            </h3>
                            <table class="search">
                                <tr>
                                    <td class="left" valign="top">
                                        Company
                                    </td>
                                    <td>
                                        <asp:HiddenField ID="hdnOrderID" runat="server" Value='<%# Eval("OrderID") %>' />
                                        <asp:HiddenField ID="hdnOrderStatusID" runat="server" Value='<%# Eval("OrderStatusID") %>' />
                                        <asp:TextBox ID="txtCompanyName" Text='<%# Bind("CompanyName") %>' runat="server"
                                            Width="500px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Họ tên
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtFullname" Text='<%# Bind("FullName") %>' runat="server" Width="500px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left">
                                        Địa chỉ
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtAddress" Text='<%# Bind("Address") %>' runat="server" Width="500px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left">
                                        Điện thoại
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtHomePhone" Text='<%# Bind("HomePhone") %>' runat="server" Width="500px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left">
                                        Di động
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCellPhone" Text='<%# Bind("CellPhone") %>' runat="server" Width="500px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left">
                                        Email
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtEmail" Text='<%# Bind("Email") %>' runat="server" Width="500px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left">
                                        Tình trạng
                                    </td>
                                    <td>
                                        <asp:RadComboBox Filter="Contains" ID="ddlOrderStatus" runat="server" DataSourceID="ObjectDataSource2"
                                            DataTextField="OrderStatusName" DataValueField="OrderStatusID" OnDataBound="DropDownList_DataBound"
                                            Width="504px">
                                        </asp:RadComboBox>
                                    </td>
                                </tr>
                            </table>
                            <div style="padding-left: 10px">
                                <hr />
                                <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>'>
                                    <img alt="" title="Update" src="../assets/images/ok.png" class="vam" /> <%# (Container is GridEditFormInsertItem) ? "Add" : "Update" %>
                                </asp:LinkButton>
                                &nbsp;&nbsp;
                                <asp:LinkButton ID="LinkButton5" runat="server" CausesValidation="False" CommandName="Cancel">
                                    <img alt="" title="Cancel" src="../assets/images/cancel.png" class="vam" /> &nbsp;&nbsp;Cancel
                                </asp:LinkButton>
                            </div>
                        </asp:Panel>
                    </FormTemplate>
                </EditFormSettings>
                <NestedViewTemplate>
                    <asp:HiddenField ID="hdnOrderID" runat="server" Value='<%# Eval("OrderID") %>' />
                    <asp:HiddenField ID="hdnBillingAddressID" runat="server" Value='<%# Eval("BillingAddressID") %>' />
                    <asp:HiddenField ID="hdnShippingAddressID" runat="server" Value='<%# Eval("ShippingAddressID") %>' />
                    <table cellspacing="5" cellpadding="5">
                        <tr>
                            <td style="border: 1px solid #ccc" valign="top">
                                <strong>Item:</strong>
                                <br />
                                <asp:RadListView ID="lvOrderDetail" runat="server" EnableModelValidation="True" DataKeyNames="ProductID">
                                    <ItemTemplate>
                                        <tr>
                                            <td valign="top" style="border: 0; text-align: left">
                                                <%# Eval("Quantity") %>
                                                x
                                                <%# Eval("ProductName") %>
                                                :
                                            </td>
                                            <td style="border: 0; text-align: left">
                                                <%# string.Format("{0:##,###.##}", Convert.ToInt32(Eval("Quantity")) * Convert.ToDouble(string.IsNullOrEmpty(Eval("Price").ToString()) ? 0 : Eval("Price"))) + " VNĐ"%>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <LayoutTemplate>
                                        <table>
                                            <tr runat="server" id="itemPlaceholder">
                                            </tr>
                                        </table>
                                    </LayoutTemplate>
                                </asp:RadListView>
                                <asp:ObjectDataSource ID="OdsOrderDetail" runat="server" SelectMethod="OrderDetailSelectAll"
                                    TypeName="TLLib.OrderDetail">
                                    <SelectParameters>
                                        <asp:Parameter Name="OrderDetailID" Type="String" />
                                        <asp:ControlParameter ControlID="hdnOrderID" Name="OrderID" PropertyName="Value"
                                            Type="String" DefaultValue="-1" />
                                        <asp:Parameter Name="ProductID" Type="String" />
                                        <asp:Parameter Name="ProductName" Type="String" />
                                        <asp:Parameter Name="Description" Type="String" />
                                        <asp:Parameter Name="Quantity" Type="String" />
                                        <asp:Parameter Name="Price" Type="String" />
                                        <asp:Parameter Name="CreateBy" Type="String" />
                                        <asp:Parameter Name="CreateDate" Type="String" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                            </td>
                            <td style="border: 1px solid #ccc" valign="top" class="invisible">
                                <strong>Địa chỉ chuyển hàng:</strong>
                                <br />
                                <br />
                                <asp:FormView ID="fvShippingAddress" runat="server" EnableModelValidation="True">
                                    <ItemTemplate>
                                        <strong>
                                            <%# Eval("FirstName") + " " + Eval("LastName")%></strong>
                                        <br />
                                        <div style="padding-left: 20px;">
                                            <%# Eval("FirstName") + " " + Eval("LastName")%>
                                            <br />
                                            <%# Eval("Address1") %>
                                            <br />
                                            <%# Eval("DistrictName") %>
                                            <br />
                                            <%# Eval("ProvinceName") %>
                                            <br />
                                            <%# Eval("CountryName") %>
                                            <br />
                                            <%# Eval("HomePhone") %>
                                            <%---
                                            <%# Eval("CellPhone") %>--%>
                                        </div>
                                    </ItemTemplate>
                                </asp:FormView>
                                <asp:ObjectDataSource ID="OdsShippingAddress" runat="server" SelectMethod="AddressBook1SelectOne"
                                    TypeName="TLLib.AddressBook1">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hdnShippingAddressID" DefaultValue="-1" Name="AddressBookID"
                                            PropertyName="Value" Type="String" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                            </td>
                            <td style="border: 1px solid #ccc" valign="top">
                                <strong>Địa chỉ thanh toán:</strong>
                                <br />
                                <br />
                                <asp:FormView ID="fvBillingAddress" runat="server" EnableModelValidation="True">
                                    <ItemTemplate>
                                        <strong>
                                            <%# Eval("FirstName") + " " + Eval("LastName")%></strong>
                                        <br />
                                        <div style="padding-left: 20px;">
                                            <%# Eval("FirstName") + " " + Eval("LastName")%>
                                            <br />
                                            <%# Eval("Address1") %>
                                            <br />
                                            <%# Eval("DistrictName") %>
                                            <br />
                                            <%# Eval("ProvinceName") %>
                                            <br />
                                            <%# Eval("CountryName") %>
                                            <br />
                                            <%# Eval("HomePhone") %>
                                        </div>
                                    </ItemTemplate>
                                </asp:FormView>
                                <asp:ObjectDataSource ID="OdsBillingAddress" runat="server" SelectMethod="AddressBook1SelectOne"
                                    TypeName="TLLib.AddressBook1">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hdnShippingAddressID" DefaultValue="-1" Name="AddressBookID"
                                            PropertyName="Value" Type="String" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                    </table>
                </NestedViewTemplate>
            </MasterTableView>
            <HeaderStyle Font-Bold="True" />
            <HeaderContextMenu EnableImageSprites="True" CssClass="GridContextMenu GridContextMenu_Default">
            </HeaderContextMenu>
        </asp:RadGrid>
    </asp:RadAjaxPanel>
    <asp:ObjectDataSource ID="OdsOrder" runat="server" SelectMethod="OrdersSelectAllNoUser"
        TypeName="TLLib.Orders" DeleteMethod="OrdersDelete" InsertMethod="OrdersInsert"
        UpdateMethod="OrdersUpdate">
        <DeleteParameters>
            <asp:Parameter Name="OrderID" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="OrderID" Type="String" />
            <asp:Parameter Name="UserName" Type="String" />
            <asp:Parameter Name="OrderStatusID" Type="String" />
            <asp:Parameter Name="ShippingStatusID" Type="String" />
            <asp:Parameter Name="PaymentMethodID" Type="String" />
            <asp:Parameter Name="BillingAddressID" Type="String" />
            <asp:Parameter Name="ShippingAddressID" Type="String" />
            <asp:Parameter Name="Notes" Type="String" />
            <asp:Parameter Name="Commission" Type="String" />
            <asp:Parameter Name="DeliveryMethodsID" Type="String" />
            <asp:Parameter Name="DeliveryDate" Type="String" />
            <asp:Parameter Name="DeliveryAddress" Type="String" />
            <asp:Parameter Name="ServiceID" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearchOrderID" Name="OrderID" PropertyName="Text"
                Type="String" />
            <asp:Parameter Name="UserName" Type="String" />
            <asp:ControlParameter ControlID="ddlSearchOrderStatus" Name="OrderStatusID" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchShippingStatus" Name="ShippingStatusID"
                PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter ControlID="ddlSearchPaymentMethod" Name="PaymentMethodID" PropertyName="SelectedValue"
                Type="String" />
            <asp:Parameter Name="BillingAddressID" Type="String" />
            <asp:Parameter Name="ShippingAddressID" Type="String" />
            <asp:ControlParameter ControlID="txtSearchNote" Name="Notes" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="dpFromDate" Name="FromDate" PropertyName="SelectedDate"
                Type="String" />
            <asp:ControlParameter ControlID="dpToDate" Name="ToDate" PropertyName="SelectedDate"
                Type="String" />
            <asp:ControlParameter ControlID="ddlProvince" Name="ProvinceID" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="ddlDistrict" Name="DistrictID" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchUserName" Name="Email" PropertyName="Text"
                Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="OrderID" Type="String" />
            <asp:Parameter Name="UserName" Type="String" />
            <asp:Parameter Name="OrderStatusID" Type="String" />
            <asp:Parameter Name="ShippingStatusID" Type="String" />
            <asp:Parameter Name="PaymentMethodID" Type="String" />
            <asp:Parameter Name="BillingAddressID" Type="String" />
            <asp:Parameter Name="ShippingAddressID" Type="String" />
            <asp:Parameter Name="Notes" Type="String" />
            <asp:Parameter Name="DeliveryMethodsID" Type="String" />
            <asp:Parameter Name="DeliveryDate" Type="String" />
            <asp:Parameter Name="DeliveryAddress" Type="String" />
            <asp:Parameter Name="ServiceID" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsPayStatus" runat="server" SelectMethod="PayStatusSelectAll"
        TypeName="TLLib.PayStatus">
        <SelectParameters>
            <asp:Parameter Name="PayStatusID" Type="String" />
            <asp:Parameter Name="PayStatusName" Type="String" />
            <asp:Parameter Name="PayStatusNameEn" Type="String" />
            <asp:Parameter DefaultValue="true" Name="IsAvailable" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:RadProgressManager ID="RadProgressManager1" runat="server" />
    <asp:RadProgressArea ID="ProgressArea1" runat="server" Culture="vi-VN" DisplayCancelButton="True"
        HeaderText="Đang tải" Style="position: fixed; top: 50% !important; left: 50% !important;
        margin: -93px 0 0 -188px;" />
    <asp:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" Skin="Default">
    </asp:RadAjaxLoadingPanel>
</asp:Content>
