<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/adminEn.master" AutoEventWireup="true"
    CodeFile="order2.aspx.cs" Inherits="ad_single_order" %>

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
        Đơn Đặt Hàng</h3>
    <br />
    <asp:RadAjaxPanel ID="RadAjaxPanel1" runat="server" ClientEvents-OnRequestStart="conditionalPostback">
        <asp:Panel ID="pnlSearch" DefaultButton="btnSearch" runat="server">
            <table class="search">
                <tr>
                    <td class="left">
                        Mã
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchOrderID" runat="server" Width="130px">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        User Name
                    </td>
                    <td>
                        <%--<asp:RadTextBox ID="txtSearchUserName" runat="server" Width="130px">
                        </asp:RadTextBox>--%>
                        <asp:RadComboBox Filter="Contains" ID="ddlSearchUserName" runat="server" CssClass="dropdownlist"
                            Width="134px" DataSourceID="ObjectDataSource3" DataTextField="UserName" DataValueField="UserName"
                            OnDataBound="DropDownList_DataBound">
                        </asp:RadComboBox>
                        <asp:ObjectDataSource ID="ObjectDataSource3" runat="server" SelectMethod="UserSelectAll"
                            TypeName="TLLib.User">
                            <SelectParameters>
                                <asp:Parameter Name="UserName" Type="String" />
                                <asp:Parameter Name="Email" Type="String" />
                                <asp:Parameter Name="Role" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                    <td class="left">
                        Từ ngày
                    </td>
                    <td>
                        <asp:RadDatePicker ShowPopupOnFocus="True" ID="dpFromDate" runat="server" Culture="vi-VN"
                            Calendar-CultureInfo="vi-VN" Width="138px">
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
                        <asp:RadDatePicker ShowPopupOnFocus="True" ID="dpToDate" runat="server" Culture="vi-VN"
                            Calendar-CultureInfo="vi-VN" Width="138px">
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
                        Tên công ty
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchCompanyName" runat="server" Width="130px">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Họ tên
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchFullName" runat="server" Width="130px">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Địa chỉ
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchAddress" runat="server" Width="130px">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Điện thoại
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchHomePhone" runat="server" Width="130px">
                        </asp:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td class="left">
                        Di động
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchCellPhone" runat="server" Width="130px">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Email
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchEmail" runat="server" Width="130px">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Tên sản phẩm
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchProductName" runat="server" Width="130px">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Tình trạng
                    </td>
                    <td>
                        <asp:RadComboBox Filter="Contains" ID="ddlSearchOrderStatus" runat="server" CssClass="dropdownlist"
                            Width="134px" DataSourceID="ObjectDataSource2" DataTextField="OrderStatusName"
                            DataValueField="OrderStatusID" OnDataBound="DropDownList_DataBound">
                        </asp:RadComboBox>
                    </td>
                </tr>
            </table>
            <div align="right" style="padding: 5px 0 5px 0; border-bottom: 1px solid #ccc; margin-bottom: 10px">
                <asp:RadButton ID="btnSearch" runat="server" Text="Tìm kiếm">
                    <Icon PrimaryIconUrl="~/ad/assets/images/find.png" />
                </asp:RadButton>
            </div>
        </asp:Panel>
        <asp:Label ID="lblError" ForeColor="Red" runat="server"></asp:Label>
        <asp:RadGrid ID="RadGrid1" runat="server" Culture="vi-VN" AllowMultiRowSelection="True"
            DataSourceID="ObjectDataSource1" GridLines="Horizontal" AutoGenerateColumns="False"
            AllowAutomaticDeletes="True" ShowStatusBar="True" OnItemCommand="RadGrid1_ItemCommand"
            OnItemDataBound="RadGrid1_ItemDataBound" CssClass="grid" AllowPaging="True" AllowSorting="True"
            AllowAutomaticInserts="True" AllowAutomaticUpdates="True" CellSpacing="0" OnItemCreated="RadGrid1_ItemCreated">
            <ClientSettings EnableRowHoverStyle="true">
                <Selecting AllowRowSelect="True" />
                <ClientEvents OnRowDblClick="RowDblClick" />
                <Resizing AllowColumnResize="true" ClipCellContentOnResize="False" />
            </ClientSettings>
            <ExportSettings IgnorePaging="true" OpenInNewWindow="true" ExportOnlyData="true"
                Excel-Format="ExcelML" Pdf-AllowCopy="true">
            </ExportSettings>
            <MasterTableView CommandItemDisplay="TopAndBottom" DataSourceID="ObjectDataSource1"
                InsertItemPageIndexAction="ShowItemOnCurrentPage" AllowMultiColumnSorting="True"
                DataKeyNames="Order2ID">
                <PagerStyle AlwaysVisible="true" Mode="NextPrevNumericAndAdvanced" PageButtonCount="10"
                    FirstPageToolTip="Trang đầu" LastPageToolTip="Trang cuối" NextPagesToolTip="Trang kế"
                    NextPageToolTip="Trang kế" PagerTextFormat="Đổi trang: {4} &nbsp;Trang <strong>{0}</strong> / <strong>{1}</strong>, Kết quả <strong>{2}</strong> - <strong>{3}</strong> trong <strong>{5}</strong>."
                    PageSizeLabelText="Kết quả mỗi trang:" PrevPagesToolTip="Trang trước" PrevPageToolTip="Trang trước" />
                <CommandItemTemplate>
                    <div class="command">
                        <div style="float: right">
                            <asp:Button ID="ExportToExcelButton" runat="server" CssClass="rgExpXLS" CommandName="ExportToExcel"
                                AlternateText="Excel" ToolTip="Xuất ra Excel" />
                            <asp:Button ID="ExportToPdfButton" runat="server" CssClass="rgExpPDF" CommandName="ExportToPdf"
                                AlternateText="PDF" ToolTip="Xuất ra PDF" />
                            <asp:Button ID="ExportToWordButton" runat="server" CssClass="rgExpDOC" CommandName="ExportToWord"
                                AlternateText="Word" ToolTip="Xuất ra Word" />
                        </div>
                        <asp:LinkButton ID="LinkButton2" runat="server" CommandName="InitInsert" Visible='<%# !RadGrid1.MasterTableView.IsItemInserted %>'
                            CssClass="item"><img class="vam" alt="" src="../assets/images/add.png" /> Thêm mới</asp:LinkButton>|
                        <%--<asp:LinkButton ID="LinkButton3" runat="server" CommandName="PerformInsert" Visible='<%# RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/accept.png" /> Thêm</asp:LinkButton>&nbsp;&nbsp;
                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="CancelAll" Visible='<%# RadGrid1.EditIndexes.Count > 0 || RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/delete-icon.png" /> Hủy</asp:LinkButton>&nbsp;&nbsp;--%>
                        <asp:LinkButton ID="btnEditSelected" runat="server" CommandName="EditSelected" Visible='<%# RadGrid1.EditIndexes.Count == 0 %>'
                            CssClass="item"><img width="12px" class="vam" alt="" src="../assets/images/tools.png" /> Sửa</asp:LinkButton>|
                        <%--<asp:LinkButton ID="btnUpdateEdited" runat="server" CommandName="UpdateEdited" Visible='<%# RadGrid1.EditIndexes.Count > 0 %>'><img class="vam" alt="" src="../assets/images/accept.png" /> Cập nhật</asp:LinkButton>&nbsp;&nbsp;--%>
                        <asp:LinkButton ID="LinkButton1" OnClientClick="javascript:return confirm('Xóa tất cả dòng đã chọn?')"
                            runat="server" CommandName="DeleteSelected" CssClass="item"><img class="vam" alt="" title="Xóa tất cả dòng được chọn" src="../assets/images/delete-icon.png" /> Xóa</asp:LinkButton>|
                        <asp:LinkButton ID="LinkButton6" runat="server" CommandName="QuickUpdate" Visible='<%# RadGrid1.EditIndexes.Count == 0 %>'
                            CssClass="item"><img class="vam" alt="" src="../assets/images/accept.png" /> Sửa nhanh</asp:LinkButton>|
                        <asp:LinkButton ID="LinkButton4" runat="server" CommandName="RebindGrid" CssClass="item"><img class="vam" alt="" src="../assets/images/reload.png" /> Làm mới</asp:LinkButton>
                    </div>
                    <div class="clear">
                    </div>
                    <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                </CommandItemTemplate>
                <Columns>
                    <asp:GridClientSelectColumn FooterText="CheckBoxSelect footer" HeaderStyle-Width="1%"
                        UniqueName="CheckboxSelectColumn" />
                    <asp:GridTemplateColumn HeaderStyle-Width="1%" HeaderText="STT">
                        <ItemTemplate>
                            <%# Container.DataSetIndex + 1 %>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderStyle-Width="1%">
                        <ItemTemplate>
                            <img id="Img1" alt="" src="~/ad/assets/images/new.gif" runat="server" visible='<%# string.IsNullOrEmpty(Eval("IsNew").ToString()) ? false : Eval("IsNew") %>' />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridBoundColumn HeaderText="Mã đặt hàng" DataField="Order2ID" SortExpression="Order2ID">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn HeaderText="Công ty" DataField="CompanyName" SortExpression="CompanyName">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn HeaderText="Họ tên" DataField="FullName" SortExpression="FullName">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn HeaderText="Địa chỉ" DataField="Address" SortExpression="Address">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn HeaderText="Điện thoại" DataField="HomePhone" SortExpression="HomePhone">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn HeaderText="Di động" DataField="CellPhone" SortExpression="CellPhone">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn HeaderText="Email" DataField="Email" SortExpression="Email">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn HeaderText="Tạo bởi" DataField="UserName" SortExpression="UserName">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn HeaderText="Ngày tạo" DataField="CreateDate" SortExpression="CreateDate"
                        DataFormatString="{0: dd/MM/yyyy hh:mm tt}">
                    </asp:GridBoundColumn>
                    <%--<asp:GridBoundColumn HeaderText="Tình trạng" DataField="OrderStatusName" SortExpression="OrderStatusName">
                </asp:GridBoundColumn>--%>
                    <asp:GridTemplateColumn HeaderStyle-Width="1%" HeaderText="Tình trạng" DataField="OrderStatusName"
                        SortExpression="OrderStatusName">
                        <ItemTemplate>
                            <asp:RadComboBox Filter="Contains" ID="ddlOrderStatus" runat="server" CssClass="dropdownlist"
                                Width="134px" DataSourceID="ObjectDataSource2" DataTextField="OrderStatusName"
                                DataValueField="OrderStatusID" SelectedID='<%# Eval("OrderStatusID") %>'>
                            </asp:RadComboBox>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                </Columns>
                <EditFormSettings EditFormType="Template">
                    <FormTemplate>
                        <asp:Panel ID="Panel1" runat="server" DefaultButton="lnkUpdate">
                            <h3 class="searchTitle">
                                Thông Tin Đơn Hàng
                            </h3>
                            <table class="search">
                                <tr>
                                    <td class="left" valign="top">
                                        Tên công ty
                                    </td>
                                    <td>
                                        <asp:HiddenField ID="hdnOrderID" runat="server" Value='<%# Bind("Order2ID") %>' />
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
                                            DataTextField="OrderStatusName" DataValueField="OrderStatusID" Width="504px"
                                            SelectedID='<%# Eval("OrderStatusID") %>'>
                                        </asp:RadComboBox>
                                    </td>
                                </tr>
                            </table>
                            <div style="padding-left: 10px">
                                <hr />
                                <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>'>
                                    <img alt="" title="Cập nhật" src="../assets/images/ok.png" class="vam" /> <%# (Container is GridEditFormInsertItem) ? "Thêm" : "Cập nhật" %>
                                </asp:LinkButton>
                                &nbsp;&nbsp;
                                <asp:LinkButton ID="LinkButton5" runat="server" CausesValidation="False" CommandName="Cancel">
                                    <img alt="" title="Hủy" src="../assets/images/cancel.png" class="vam" /> &nbsp;&nbsp;Hủy
                                </asp:LinkButton>
                            </div>
                        </asp:Panel>
                    </FormTemplate>
                </EditFormSettings>
                <NestedViewTemplate>
                    <asp:HiddenField ID="hdnOrderID" Value='<%# Eval("Order2ID") %>' runat="server" />
                    <asp:RadGrid ID="RadGrid2" runat="server" Culture="vi-VN" AllowMultiRowSelection="True"
                        GridLines="Horizontal" AutoGenerateColumns="False" AllowAutomaticDeletes="True"
                        ShowStatusBar="True" Skin="Office2007" OnItemCommand="RadGrid2_ItemCommand" OnItemDataBound="RadGrid2_ItemDataBound"
                        OnDataBound="RadGrid2_DataBound" CssClass="grid" AllowPaging="True" AllowSorting="True"
                        AllowAutomaticInserts="True" AllowAutomaticUpdates="True" Style="border: 0" ShowFooter="true">
                        <ClientSettings EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="True" />
                            <Resizing AllowColumnResize="true" ClipCellContentOnResize="False" />
                        </ClientSettings>
                        <ExportSettings IgnorePaging="true" OpenInNewWindow="true" ExportOnlyData="true"
                            Excel-Format="ExcelML" Pdf-AllowCopy="true">
                        </ExportSettings>
                        <MasterTableView CommandItemDisplay="Top" InsertItemPageIndexAction="ShowItemOnCurrentPage"
                            AllowMultiColumnSorting="True" DataKeyNames="OrderDetail2ID" Width="700px" Style="border: 1px solid #999;
                            margin-left: 50px">
                            <PagerStyle Mode="NextPrevAndNumeric" />
                            <CommandItemTemplate>
                                <div class="command">
                                    <div style="float: right">
                                        <asp:Button ID="ExportToExcelButton" runat="server" CssClass="rgExpXLS" CommandName="ExportToExcel"
                                            AlternateText="Excel" ToolTip="Xuất ra Excel" />
                                        <asp:Button ID="ExportToPdfButton" runat="server" CssClass="rgExpPDF" CommandName="ExportToPdf"
                                            AlternateText="PDF" ToolTip="Xuất ra PDF" />
                                        <asp:Button ID="ExportToWordButton" runat="server" CssClass="rgExpDOC" CommandName="ExportToWord"
                                            AlternateText="Word" ToolTip="Xuất ra Word" />
                                    </div>
                                    <asp:LinkButton ID="LinkButton2" runat="server" CommandName="InitInsert" Visible='<%# !RadGrid1.MasterTableView.IsItemInserted %>'
                                        CssClass="item"><img class="vam" alt="" src="../assets/images/add.png" /> Thêm mới</asp:LinkButton>|
                                    <%--<asp:LinkButton ID="LinkButton3" runat="server" CommandName="PerformInsert" Visible='<%# RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/accept.png" /> Thêm</asp:LinkButton>&nbsp;&nbsp;
                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="CancelAll" Visible='<%# RadGrid1.EditIndexes.Count > 0 || RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/delete-icon.png" /> Hủy</asp:LinkButton>&nbsp;&nbsp;--%>
                                    <asp:LinkButton ID="btnEditSelected" runat="server" CommandName="EditSelected" Visible='<%# RadGrid1.EditIndexes.Count == 0 %>'
                                        CssClass="item"><img width="12px" class="vam" alt="" src="../assets/images/tools.png" /> Sửa</asp:LinkButton>|
                                    <%--<asp:LinkButton ID="btnUpdateEdited" runat="server" CommandName="UpdateEdited" Visible='<%# RadGrid1.EditIndexes.Count > 0 %>'><img class="vam" alt="" src="../assets/images/accept.png" /> Cập nhật</asp:LinkButton>&nbsp;&nbsp;--%>
                                    <asp:LinkButton ID="LinkButton1" OnClientClick="javascript:return confirm('Xóa tất cả dòng đã chọn?')"
                                        runat="server" CommandName="DeleteSelected" CssClass="item"><img class="vam" alt="" title="Xóa tất cả dòng được chọn" src="../assets/images/delete-icon.png" /> Xóa</asp:LinkButton>|
                                    <%--<asp:LinkButton ID="LinkButton6" runat="server" CommandName="QuickUpdate" Visible='<%# RadGrid1.EditIndexes.Count == 0 %>'
                            CssClass="item"><img class="vam" alt="" src="../assets/images/accept.png" /> Sửa nhanh</asp:LinkButton>|--%>
                                    <asp:LinkButton ID="LinkButton4" runat="server" CommandName="RebindGrid" CssClass="item"><img class="vam" alt="" src="../assets/images/reload.png" /> Làm mới</asp:LinkButton>
                                </div>
                                <div class="clear">
                                </div>
                                <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                            </CommandItemTemplate>
                            <FooterStyle CssClass="grid-footer" />
                            <Columns>
                                <asp:GridClientSelectColumn HeaderStyle-Width="1%" UniqueName="CheckboxSelectColumn" />
                                <asp:GridTemplateColumn HeaderStyle-Width="1%" HeaderText="STT">
                                    <ItemTemplate>
                                        <%# Container.DataSetIndex + 1 %>
                                    </ItemTemplate>
                                </asp:GridTemplateColumn>
                                <asp:GridBoundColumn HeaderText="Tên sản phẩm" DataField="ProductName" SortExpression="ProductName">
                                </asp:GridBoundColumn>
                                <asp:GridBoundColumn HeaderText="Số lượng" DataField="Quantity" SortExpression="Quantity">
                                </asp:GridBoundColumn>
                                <asp:GridTemplateColumn HeaderText="Giá" DataField="TotalPrice" SortExpression="TotalPrice">
                                    <ItemTemplate>
                                        <%# Convert.ToInt32(Eval("TotalPrice")) == 0 ? "0" : (string.Format("{0:##,###.##}", Eval("TotalPrice"))) %>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblTotal" Font-Bold="true" runat="server"></asp:Label>
                                    </FooterTemplate>
                                </asp:GridTemplateColumn>
                            </Columns>
                            <EditFormSettings EditFormType="Template">
                                <FormTemplate>
                                    <asp:Panel ID="Panel1" runat="server" DefaultButton="lnkUpdate">
                                        <h3 class="searchTitle">
                                            Thông Tin Mặt Hàng
                                        </h3>
                                        <table class="search">
                                            <tr>
                                                <td class="left" valign="top">
                                                    Sản phẩm
                                                </td>
                                                <td>
                                                    <asp:HiddenField ID="hdnOrderDetailID" runat="server" Value='<%# Eval("OrderDetail2ID") %>' />
                                                    <asp:HiddenField ID="hdnOrderID" runat="server" Value='<%# Bind("Order2ID") %>' />
                                                    <asp:RadComboBox Filter="Contains" ID="ddlProduct" runat="server" DataSourceID="ObjectDataSource4"
                                                        DataTextField="ProductName" DataValueField="ProductID" Width="504px" SelectedID='<%# Eval("ProductID") %>'>
                                                    </asp:RadComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="left" valign="top">
                                                    Số lượng
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtQuantity" Text='<%# Bind("Quantity") %>' runat="server" Width="500px" />
                                                </td>
                                            </tr>
                                        </table>
                                        <div style="padding-left: 10px">
                                            <hr />
                                            <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>'>
                                                <img alt="" title="Cập nhật" src="../assets/images/ok.png" class="vam" /> <%# (Container is GridEditFormInsertItem) ? "Thêm" : "Cập nhật" %>
                                            </asp:LinkButton>
                                            &nbsp;&nbsp;
                                            <asp:LinkButton ID="LinkButton5" runat="server" CausesValidation="False" CommandName="Cancel">
                                                <img alt="" title="Hủy" src="../assets/images/cancel.png" class="vam" /> &nbsp;&nbsp;Hủy
                                            </asp:LinkButton>
                                        </div>
                                    </asp:Panel>
                                </FormTemplate>
                            </EditFormSettings>
                        </MasterTableView>
                        <HeaderStyle Font-Bold="True" />
                        <HeaderContextMenu EnableImageSprites="True" CssClass="GridContextMenu GridContextMenu_Default">
                        </HeaderContextMenu>
                    </asp:RadGrid>
                    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" DeleteMethod="OrderDetail2Delete"
                        InsertMethod="OrderDetail2Insert" SelectMethod="OrderDetail2SelectAll" TypeName="TLLib.OrderDetail2"
                        UpdateMethod="OrderDetail2Update">
                        <DeleteParameters>
                            <asp:Parameter Name="OrderDetail2ID" Type="String" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Order2ID" Type="String" />
                            <asp:Parameter Name="ProductID" Type="String" />
                            <asp:Parameter Name="Quantity" Type="String" />
                            <asp:Parameter Name="Price" Type="String" />
                            <asp:Parameter Name="CreateBy" Type="String" />
                        </InsertParameters>
                        <SelectParameters>
                            <%--<asp:Parameter Name="OrderID" />--%>
                            <asp:Parameter Name="Keyword" Type="String" />
                            <asp:Parameter Name="OrderDetail2ID" Type="String" />
                            <asp:ControlParameter ControlID="hdnOrderID" Name="Order2ID" PropertyName="Value" />
                            <asp:Parameter Name="ProductID" Type="String" />
                            <asp:Parameter Name="Quantity" Type="String" />
                            <asp:Parameter Name="Price" Type="String" />
                            <asp:Parameter Name="CreateBy" Type="String" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="OrderDetail2ID" Type="String" />
                            <asp:Parameter Name="Order2ID" Type="String" />
                            <asp:Parameter Name="ProductID" Type="String" />
                            <asp:Parameter Name="Quantity" Type="String" />
                            <asp:Parameter Name="Price" Type="String" />
                            <asp:Parameter Name="CreateBy" Type="String" />
                        </UpdateParameters>
                    </asp:ObjectDataSource>
                </NestedViewTemplate>
            </MasterTableView>
            <HeaderStyle Font-Bold="True" />
            <HeaderContextMenu EnableImageSprites="True" CssClass="GridContextMenu GridContextMenu_Default">
            </HeaderContextMenu>
        </asp:RadGrid>
        <asp:RadInputManager ID="RadInputManager1" runat="server">
            <asp:TextBoxSetting EmptyMessage="Tên công ty ...">
                <TargetControls>
                    <asp:TargetInput ControlID="txtCompanyName" />
                </TargetControls>
            </asp:TextBoxSetting>
            <asp:TextBoxSetting EmptyMessage="Họ tên ...">
                <TargetControls>
                    <asp:TargetInput ControlID="txtFullname" />
                </TargetControls>
            </asp:TextBoxSetting>
            <asp:TextBoxSetting EmptyMessage="Địa chỉ ...">
                <TargetControls>
                    <asp:TargetInput ControlID="txtAddress" />
                </TargetControls>
            </asp:TextBoxSetting>
            <asp:TextBoxSetting EmptyMessage="Điện thoại ...">
                <TargetControls>
                    <asp:TargetInput ControlID="txtHomePhone" />
                </TargetControls>
            </asp:TextBoxSetting>
            <asp:TextBoxSetting EmptyMessage="Di động ...">
                <TargetControls>
                    <asp:TargetInput ControlID="txtCellPhone" />
                </TargetControls>
            </asp:TextBoxSetting>
            <asp:TextBoxSetting EmptyMessage="Email ...">
                <TargetControls>
                    <asp:TargetInput ControlID="txtEmail" />
                </TargetControls>
            </asp:TextBoxSetting>
            <asp:NumericTextBoxSetting AllowRounding="False" Culture="vi-VN" EmptyMessage="Số lượng ..."
                Type="Number" DecimalDigits="0">
                <TargetControls>
                    <asp:TargetInput ControlID="txtQuantity" />
                </TargetControls>
            </asp:NumericTextBoxSetting>
        </asp:RadInputManager>
    </asp:RadAjaxPanel>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="Orders2SelectAll"
        TypeName="TLLib.Orders2" DeleteMethod="Orders2Delete" InsertMethod="Orders2Insert"
        UpdateMethod="Orders2Update">
        <DeleteParameters>
            <asp:Parameter Name="Order2ID" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Order2ID" Type="String" />
            <asp:Parameter Name="UserName" Type="String" />
            <asp:Parameter Name="CreateDate" Type="String" />
            <asp:Parameter Name="CompanyName" Type="String" />
            <asp:Parameter Name="FullName" Type="String" />
            <asp:Parameter Name="Address" Type="String" />
            <asp:Parameter Name="HomePhone" Type="String" />
            <asp:Parameter Name="CellPhone" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="OrderStatusID" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:Parameter Name="Keyword" Type="String" />
            <asp:ControlParameter ControlID="txtSearchOrderID" Name="Order2ID" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchUserName" Name="UserName" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="dpFromDate" Name="FromDate" PropertyName="SelectedDate"
                Type="String" />
            <asp:ControlParameter ControlID="dpToDate" Name="ToDate" PropertyName="SelectedDate"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchCompanyName" Name="CompanyName" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchFullName" Name="FullName" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchAddress" Name="Address" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchHomePhone" Name="HomePhone" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchCellPhone" Name="CellPhone" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchEmail" Name="Email" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchOrderStatus" Name="OrderStatusID" PropertyName="SelectedValue"
                Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="Order2ID" Type="String" />
            <asp:Parameter Name="UserName" Type="String" />
            <asp:Parameter Name="CreateDate" Type="String" />
            <asp:Parameter Name="CompanyName" Type="String" />
            <asp:Parameter Name="FullName" Type="String" />
            <asp:Parameter Name="Address" Type="String" />
            <asp:Parameter Name="HomePhone" Type="String" />
            <asp:Parameter Name="CellPhone" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="OrderStatusID" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>
    <%--<asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="OrderStatusSelectAll"
        TypeName="TLLib.OrderStatus"></asp:ObjectDataSource>--%>
    <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="OrderStatusSelectAll"
        TypeName="TLLib.OrderStatus">
        <SelectParameters>
            <asp:Parameter Name="OrderStatusID" Type="String" />
            <asp:Parameter Name="OrderStatusName" Type="String" />
            <asp:Parameter Name="OrderStatusNameEn" Type="String" />
            <asp:Parameter DefaultValue="True" Name="IsAvailable" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="ObjectDataSource4" runat="server" SelectMethod="ProductSelectAll"
        TypeName="TLLib.Product">
        <SelectParameters>
            <asp:Parameter Name="StartRowIndex" Type="String" />
            <asp:Parameter Name="EndRowIndex" Type="String" />
            <asp:Parameter Name="Keyword" Type="String" />
            <asp:Parameter Name="ProductName" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="PriceFrom" Type="String" />
            <asp:Parameter Name="PriceTo" Type="String" />
            <asp:Parameter Name="CategoryID" Type="String" />
            <asp:Parameter Name="ManufacturerID" Type="String" />
            <asp:Parameter Name="OriginID" Type="String" />
            <asp:Parameter Name="Tag" Type="String" />
            <asp:Parameter Name="InStock" Type="String" />
            <asp:Parameter Name="IsHot" Type="String" />
            <asp:Parameter Name="IsNew" Type="String" />
            <asp:Parameter Name="IsBestSeller" Type="String" />
            <asp:Parameter Name="IsSaleOff" Type="String" />
            <asp:Parameter Name="IsShowOnHomePage" Type="String" />
            <asp:Parameter Name="FromDate" Type="String" />
            <asp:Parameter Name="ToDate" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter DefaultValue="True" Name="IsAvailable" Type="String" />
            <asp:Parameter Name="SortByPriority" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:RadProgressManager ID="RadProgressManager1" runat="server" />
    <asp:RadProgressArea ID="ProgressArea1" runat="server" Culture="vi-VN" DisplayCancelButton="True"
        HeaderText="Đang tải" Skin="Office2007" Style="position: fixed; top: 50% !important;
        left: 50% !important; margin: -93px 0 0 -188px;" />
</asp:Content>
