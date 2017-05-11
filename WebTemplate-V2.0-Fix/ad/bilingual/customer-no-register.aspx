<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/adminEn.master" AutoEventWireup="true"
    CodeFile="customer-no-register.aspx.cs" Inherits="ad_single_customer_no_register" %>

<%@ Register TagPrefix="asp" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="Server">
    <link href="../assets/styles/sreenshort.css" rel="stylesheet" type="text/css" />
    <script src="../assets/js/sreenshort.js" type="text/javascript"></script>
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
    </script>
    <style type="text/css">
        .container
        {
            display: none;
            border: 2px solid #894614;
            padding: 10px;
            background-color: #fff;
            width: 240px;
        }
    </style>
    <script type="text/javascript">
        function ShowRenew(trigger) {
            var triggerElem = $(trigger);
            var content = $(triggerElem).parent().find('.container');

            content.css({
                'z-index': '99999',
                top: triggerElem.outerHeight() + 2 + "px",
                right: '0px'
            });

            if (content.is(":visible"))
                content.hide();
            else
                content.show();

            $(document).click(function (event) {
                if ($(event.target).parents().index($(triggerElem).parent()) == -1) {
                    if (content.is(":visible"))
                        content.hide();
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <h3 class="mainTitle">
        <img alt="" src="../assets/images/user.png" class="vam" />
        Khách Hàng</h3>
    <br />
    <asp:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
        <asp:Panel ID="pnlSearch" DefaultButton="btnSearch" runat="server">
            <table class="search">
                <tr>
                    <td class="left">
                        Họ Tên
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchFirstName" runat="server" Width="130px" EmptyMessage="Tên...">
                        </asp:RadTextBox>
                    </td>
                    <td class="left invisible">
                        Họ
                    </td>
                    <td class="invisible">
                        <asp:RadTextBox ID="txtSearchLastName" runat="server" Width="130px" EmptyMessage="Họ...">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Email
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchEmail" runat="server" Width="130px" EmptyMessage="Email...">
                        </asp:RadTextBox>
                    </td>
                    <td class="left invisible">
                        Công ty
                    </td>
                    <td class="invisible">
                        <asp:RadTextBox ID="txtSearchCompany" runat="server" Width="130px" EmptyMessage="Công ty...">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Địa chỉ
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchAddress" runat="server" Width="130px" EmptyMessage="Địa chỉ...">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Điện thoại
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchHomePhone" runat="server" Width="130px" EmptyMessage="Điện thoại...">
                        </asp:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td class="left invisible">
                        Điện thoại DĐ
                    </td>
                    <td class="invisible">
                        <asp:RadTextBox ID="txtSearchCellPhone" runat="server" Width="130px" EmptyMessage="Điện thoại DĐ...">
                        </asp:RadTextBox>
                    </td>
                    <td class="left invisible">
                        Tài khoản
                    </td>
                    <td class="invisible">
                        <asp:RadTextBox ID="txtSearchUserName" runat="server" EmptyMessage="Tài khoản..."
                            Width="130px">
                        </asp:RadTextBox>
                    </td>
                    <td class="left invisible">
                        Quyền
                    </td>
                    <td class="invisible">
                        <asp:RadComboBox Filter="Contains" ID="ddlRole" runat="server" EmptyMessage="- Chọn -"
                            DataSourceID="ObjectDataSource2" Width="134px" OnDataBound="DropDownList_DataBound">
                        </asp:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td class="left invisible">
                        Địa chỉ chính
                    </td>
                    <td class="invisible">
                        <asp:RadComboBox ID="ddlSearchIsPrimary" runat="server" CssClass="dropdownlist" EmptyMessage="- Chọn -"
                            Filter="Contains" Width="134px">
                            <Items>
                                <asp:RadComboBoxItem Value="" />
                                <asp:RadComboBoxItem Text="Yes" Value="True" />
                                <asp:RadComboBoxItem Text="No" Value="False" />
                            </Items>
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
        <asp:RadGrid ID="RadGrid1" AllowMultiRowSelection="True" runat="server" Culture="vi-VN"  DataSourceID="ObjectDataSource1"
            GridLines="Horizontal" AutoGenerateColumns="False" ShowStatusBar="True" OnItemCommand="RadGrid1_ItemCommand"
            OnItemDataBound="RadGrid1_ItemDataBound" OnItemCreated="RadGrid1_ItemCreated"
            CssClass="grid" AllowAutomaticUpdates="True" AllowAutomaticInserts="True" CellSpacing="0">
            <ClientSettings EnableRowHoverStyle="true">
                <Selecting AllowRowSelect="True" UseClientSelectColumnOnly="True" />
                <ClientEvents OnRowDblClick="RowDblClick" />
                <Resizing AllowColumnResize="true" ClipCellContentOnResize="False" />
            </ClientSettings>
            <ExportSettings IgnorePaging="true" OpenInNewWindow="true" ExportOnlyData="true"
                Excel-Format="ExcelML" Pdf-AllowCopy="true">
            </ExportSettings>
            <MasterTableView CommandItemDisplay="TopAndBottom" DataSourceID="ObjectDataSource1"
                InsertItemPageIndexAction="ShowItemOnCurrentPage" AllowMultiColumnSorting="True"
                DataKeyNames="AddressBookID">
                <PagerTemplate>
                    <asp:Panel ID="PagerPanel" Style="padding: 6px; line-height: 24px" runat="server">
                        <div style="float: left">
                            <span style="margin-right: 3px;" class="vam">Trang:</span>
                            <asp:RadComboBox ID="RadComboBox1" DataSource="<%# new object[]{ 10 , 20, 50, 100, 200} %>"
                                Style="margin-right: 20px;" Width="40px" SelectedValue='<%# DataBinder.Eval(Container, "Paging.PageSize") %>'
                                runat="server" OnClientSelectedIndexChanged="RadComboBox1_SelectedIndexChanged">
                            </asp:RadComboBox>
                        </div>
                        <div style="margin: 0px; float: right;">
                            <%--Available trang
                            <%# (int)DataBinder.Eval(Container, "Paging.CurrentPageIndex") + 1 %>
                            trong
                            <%# DataBinder.Eval(Container, "Paging.PageCount")%>
                            ,--%>
                            <%# (int)DataBinder.Eval(Container, "Paging.FirstIndexInPage") + 1 %>
                            -
                            <%# (int)DataBinder.Eval(Container, "Paging.LastIndexInPage") + 1 %>
                            of
                            <%# DataBinder.Eval(Container, "Paging.DataSourceCount")%>
                            results
                        </div>
                        <div style="width: 260px; margin: 0px; padding: 0px; float: left; margin-right: 10px;
                            white-space: nowrap;">
                            <asp:Button ID="Button1" runat="server" OnClientClick="changePage('first'); return false;"
                                CommandName="Page" CommandArgument="First" Text=" " CssClass="PagerButton FirstPage" />
                            <asp:Button ID="Button2" runat="server" OnClientClick="changePage('prev'); return false;"
                                CommandName="Page" CommandArgument="Prev" Text=" " CssClass="PagerButton PrevPage" />
                            <span style="vertical-align: middle;">Page:</span>
                            <asp:RadNumericTextBox ID="RadNumericTextBox1" Width="25px" Value='<%# (int)DataBinder.Eval(Container, "Paging.CurrentPageIndex") + 1 %>'
                                runat="server">
                                <ClientEvents OnValueChanged="RadNumericTextBox1_ValueChanged" />
                                <NumberFormat DecimalDigits="0" />
                            </asp:RadNumericTextBox>
                            <span style="vertical-align: middle;">of
                                <%# DataBinder.Eval(Container, "Paging.PageCount")%>
                            </span>
                            <asp:Button ID="Button3" runat="server" OnClientClick="changePage('next'); return false;"
                                CommandName="Page" CommandArgument="Next" Text=" " CssClass="PagerButton NextPage" />
                            <asp:Button ID="Button4" runat="server" OnClientClick="changePage('last'); return false;"
                                CommandName="Page" CommandArgument="Last" Text=" " CssClass="PagerButton LastPage" />
                        </div>
                        <asp:Panel runat="server" ID="NumericPagerPlaceHolder" />
                    </asp:Panel>
                </PagerTemplate>
                <PagerStyle Mode="NumericPages" PageButtonCount="10" AlwaysVisible="true" />
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
                        <asp:LinkButton ID="LinkButton2" runat="server" CommandName="InitInsert" Visible="False"
                            CssClass="item"><img class="vam" alt="" src="../assets/images/add.png" /> Thêm mới</asp:LinkButton>|
                        <%--<asp:LinkButton ID="LinkButton3" runat="server" CommandName="PerformInsert" Visible='<%# RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/accept.png" /> Add</asp:LinkButton>&nbsp;&nbsp;
                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="CancelAll" Visible='<%# RadGrid1.EditIndexes.Count > 0 || RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/delete-icon.png" /> Cancel</asp:LinkButton>&nbsp;&nbsp;--%>
                        <asp:LinkButton ID="btnEditSelected" runat="server" CommandName="EditSelected" Visible="False"
                            CssClass="item"><img width="12px" class="vam" alt="" src="../assets/images/tools.png" /> Sửa</asp:LinkButton>|
                        <%--<asp:LinkButton ID="btnUpdateEdited" runat="server" CommandName="UpdateEdited" Visible='<%# RadGrid1.EditIndexes.Count > 0 %>'><img class="vam" alt="" src="../assets/images/accept.png" /> Update</asp:LinkButton>&nbsp;&nbsp;--%>
                        <asp:LinkButton ID="LinkButton1" OnClientClick="javascript:return confirm('Delete seleted rows?')"
                            runat="server" CommandName="DeleteSelected" CssClass="item"><img class="vam" alt="" title="Delete seleted rows" src="../assets/images/delete-icon.png" /> Xóa</asp:LinkButton>|
                        <asp:LinkButton ID="LinkButton6" runat="server" CommandName="QuickUpdate" Visible="False"
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
                            <asp:HiddenField ID="hdnAddressBookID" Value='<%# Eval("AddressBookID") %>' runat="server" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="MKH" DataField="AddressBookID" SortExpression="AddressBookID">
                        <ItemTemplate>
                            <%# Eval("AddressBookID")%>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Họ tên" DataField="LastName,FirstName" SortExpression="LastName,FirstName">
                        <ItemTemplate>
                            <asp:Label ID="lblFullName" runat="server" Text='<%# Eval("LastName") + "&nbsp;" + Eval("FirstName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Công ty" DataField="Company" Visible="false"
                        SortExpression="Company">
                        <ItemTemplate>
                            <%# Eval("Company")%>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridBoundColumn DataField="Email" HeaderText="Email" Visible="False" SortExpression="Email">
                    </asp:GridBoundColumn>
                    <asp:GridTemplateColumn HeaderText="Email" DataField="Email" SortExpression="Email">
                        <ItemTemplate>
                            <%# Eval("Email")%>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Điện thoại" DataField="HomePhone,CellPhone" SortExpression="HomePhone,CellPhone">
                        <ItemTemplate>
                            <%# Eval("HomePhone") %>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Địa chỉ">
                        <ItemTemplate>
                            <%# Eval("Address1") + ", " + Eval("DistrictName") + ", " + Eval("ProvinceName") + ", " + Eval("CountryName")%>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridBoundColumn DataField="UserName" HeaderText="Tài khoản" Visible="False" SortExpression="UserName" />
                    <asp:GridTemplateColumn HeaderText="Quyền" DataField="RoleName" Visible="false" SortExpression="RoleName">
                        <ItemTemplate>
                            <%# Eval("RoleName").ToString() == "admin" ? "Admin" : (Eval("RoleName").ToString() == "member" ? "Staff" : "Customer" )%>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <%--<asp:GridTemplateColumn HeaderText="Ngày đăng ký" DataField="CreateDate" SortExpression="CreateDate">
                        <ItemTemplate>
                            <%# string.Format("{0:dd/MM/yyyy}", Eval("CreateDate"))%>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>--%>
                </Columns>
                <EditFormSettings EditFormType="Template">
                    <FormTemplate>
                        <asp:Panel ID="Panel1" runat="server" DefaultButton="lnkUpdate">
                            <h3 class="searchTitle">
                                Thông tin đăng nhập
                            </h3>
                            <table class="search">
                                <tr>
                                    <td class="left">
                                        Email
                                    </td>
                                    <td>
                                        <asp:RadTextBox ID="txtUserName" runat="server" Width="365px" Text='<%# Bind("UserName") %>'
                                            EmptyMessage="Email...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left">
                                        Mật khẩu
                                    </td>
                                    <td>
                                        ****** <a class="trigger" onclick="ShowRenew(this);" style="display: inline; cursor: pointer;">
                                            <img alt="" src="../assets/images/datagrid_editing_edit.png" /></a>
                                        <div class="container">
                                            <table class="search">
                                                <tr>
                                                    <td class="left">
                                                        Mật khẩu mới
                                                    </td>
                                                    <td>
                                                        <asp:RadTextBox ID="txtPassword" runat="server" Width="100px" TextMode="Password">
                                                        </asp:RadTextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="left">
                                                    </td>
                                                    <td>
                                                        <asp:RadButton ID="btnChangePassword" Text="Save" runat="server" OnClick="btnChangePassword_Click"
                                                            ShowPostBackMask="False">
                                                        </asp:RadButton>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <h3 class="searchTitle">
                                Thông tin khách hàng
                            </h3>
                            <table class="search">
                                <tr class="invisible">
                                    <td class="left">
                                        Công ty
                                    </td>
                                    <td colspan="3">
                                        <asp:RadTextBox ID="txtCompany" runat="server" Width="365px" Text='<%# Bind("Company") %>'
                                            EmptyMessage="Company...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Tên
                                    </td>
                                    <td>
                                        <asp:RadTextBox ID="txtFirstName" runat="server" Width="388px" Text='<%# Bind("FirstName") %>'
                                            EmptyMessage="Tên...">
                                        </asp:RadTextBox>
                                    </td>
                                    <td class="left invisible" valign="top">
                                        Họ
                                    </td>
                                    <td class="invisible">
                                        <asp:RadTextBox ID="txtLastName" runat="server" Width="130px" Text='<%# Bind("LastName") %>'
                                            EmptyMessage="Họ...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Điện thoại
                                    </td>
                                    <td>
                                        <asp:RadTextBox ID="txtHomePhone" runat="server" Width="388px" Text='<%# Bind("HomePhone") %>'
                                            EmptyMessage="Điện thoại...">
                                        </asp:RadTextBox>
                                    </td>
                                    <td class="left invisible" valign="top">
                                        Điện thoại DĐ
                                    </td>
                                    <td class="invisible">
                                        <asp:RadTextBox ID="txtCellPhone" runat="server" Width="130px" Text='<%# Bind("CellPhone") %>'
                                            EmptyMessage="Điện thoại DĐ...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr class="invisible">
                                    <td class="left" valign="top">
                                        Fax
                                    </td>
                                    <td colspan="3">
                                        <asp:RadTextBox ID="txtFax" runat="server" Width="365px" Text='<%# Bind("Fax") %>'
                                            EmptyMessage="Fax...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Email
                                    </td>
                                    <td colspan="3">
                                        <asp:RadTextBox ID="txtEmail" runat="server" Width="388px" Text='<%# Bind("Email") %>'
                                            EmptyMessage="Email...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Địa chỉ
                                    </td>
                                    <td colspan="3">
                                        <asp:RadTextBox ID="txtAddress1" runat="server" Width="388px" Text='<%# Bind("Address1") %>'
                                            EmptyMessage="Địa chỉ...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Tỉnh/Thành
                                    </td>
                                    <td>
                                        <asp:RadAjaxPanel ID="RadAjaxPanel2" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
                                            <asp:RadComboBox ID="ddlProvince" runat="server" Width="388px" AutoPostBack="True"
                                                DataSourceID="OdsProvince" DataTextField="ProvinceName" DataValueField="ProvinceID"
                                                OnSelectedIndexChanged="DropDownList_SelectedIndexChanged" UpdatePanelID='<%# Container.FindControl("RadAjaxPanel3").ClientID %>'
                                                Filter="Contains" Height="300">
                                            </asp:RadComboBox>
                                            <asp:HiddenField ID="hdnProvinceID" runat="server" Value='<%# Eval("ProvinceID") %>' />
                                        </asp:RadAjaxPanel>
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
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Quận/Huyện
                                    </td>
                                    <td>
                                        <asp:RadAjaxPanel ID="RadAjaxPanel3" runat="server" LoadingPanelID="RadAjaxLoadingPanel1"
                                            ShowPostBackMask="False">
                                            <asp:RadComboBox ID="ddlDistrict" runat="server" Width="388px" DataSourceID="odsDistrict"
                                                DataTextField="DistrictName" EmptyMessage="- Chọn -" DataValueField="DistrictID"
                                                Filter="Contains" Height="300">
                                            </asp:RadComboBox>
                                            <asp:HiddenField ID="hdnDistrictID" runat="server" Value='<%# Eval("DistrictID") %>' />
                                        </asp:RadAjaxPanel>
                                        <asp:ObjectDataSource ID="odsDistrict" runat="server" SelectMethod="DistrictSelectAll"
                                            TypeName="TLLib.District">
                                            <SelectParameters>
                                                <asp:Parameter Name="DistrictName" Type="String" />
                                                <asp:ControlParameter ControlID="ddlProvince" Name="ProvinceIDs" PropertyName="SelectedValue"
                                                    Type="String" />
                                                <asp:Parameter DefaultValue="True" Name="IsAvailable" Type="String" />
                                                <asp:Parameter Name="Priority" Type="String" />
                                                <asp:Parameter DefaultValue="True" Name="SortByPriority" Type="String" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                        <%--<asp:HiddenField ID="hdnIsPrimary" runat="server" Value='<%# Bind("IsPrimary") %>' />
                                        <asp:HiddenField ID="hdnUserName" runat="server" Value='<%# Bind("UserName") %>' />
                                        <asp:HiddenField ID="hdnReceiveEmail" runat="server" Value='<%# Bind("ReceiveEmail") %>' />--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left invisible" valign="top">
                                        Mã vùng
                                    </td>
                                    <td class="invisible">
                                        <asp:RadTextBox ID="txtZipCode" runat="server" Width="130px" Text='<%# Bind("ZipCode") %>'
                                            EmptyMessage="Mã vùng...">
                                        </asp:RadTextBox>
                                    </td>
                                    <td class="left invisible" valign="top">
                                        City
                                    </td>
                                    <td class="invisible">
                                        <asp:RadTextBox ID="txtCity" runat="server" Width="130px" Text='<%# Bind("City") %>'
                                            EmptyMessage="City...">
                                        </asp:RadTextBox>
                                    </td>
                                    <td class="left invisible">
                                        Role
                                    </td>
                                    <td class="invisible">
                                        <asp:RadComboBox Filter="Contains" ID="ddlRole" runat="server" DataSourceID="ObjectDataSource2"
                                            Width="134px" OnDataBound="DropDownList_DataBound">
                                        </asp:RadComboBox>
                                        <asp:HiddenField ID="hdnRole" runat="server" Value='<%# Eval("RoleName") %>' />
                                    </td>
                                </tr>
                            </table>
                            <div style="padding-left: 10px">
                                <hr />
                                <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>'>
                                    <img alt="" title="Update" src="../assets/images/ok.png" class="vam" /> <%# (Container is GridEditFormInsertItem) ? "Thêm" : "Cập nhật" %>
                                </asp:LinkButton>
                                &nbsp;&nbsp;
                                <asp:LinkButton ID="LinkButton5" runat="server" CausesValidation="False" CommandName="Cancel">
                                    <img alt="" title="Cancel" src="../assets/images/cancel.png" class="vam" /> &nbsp;&nbsp;Hủy
                                </asp:LinkButton>
                            </div>
                        </asp:Panel>
                    </FormTemplate>
                </EditFormSettings>
                <NestedViewTemplate>
                    <asp:HiddenField ID="hdnEmail" runat="server" Value='<%# Eval("Email") %>' />
                    <asp:RadListView ID="lvOrder" runat="server" EnableModelValidation="True">
                        <LayoutTemplate>
                            <fieldset class="box-order">
                                <legend>Đơn hàng</legend>
                                <div>
                                    <span id="itemPlaceholder" runat="server" />
                                </div>
                            </fieldset>
                        </LayoutTemplate>
                        <ItemTemplate>
                            <fieldset style="float: left; width: 40%">
                                <legend>Mã đơn hàng: <strong>
                                    <%# Eval("OrderID")%></strong></legend>
                                <ul class="ul-order">
                                    <li>
                                        <label>
                                            Tổng tiền:
                                        </label>
                                        <%# string.Format("{0:##,###.##}", Eval("OrderTotal")) + " VNĐ"%>
                                    </li>
                                    <li>
                                        <label>
                                            Ngày tạo:
                                        </label>
                                        <%# string.Format("{0:dd/MM/yyyy hh:mm tt}", Eval("CreateDate"))%>
                                    </li>
                                    <li>
                                        <label>
                                            Hình thức thanh toán:
                                        </label>
                                        <%# Eval("PaymentMethodName")%>
                                    </li>
                                    <li>
                                        <label>
                                            Tình trạng đơn hàng:
                                        </label>
                                        <%# Eval("OrderStatusName")%>
                                    </li>
                                    <li>
                                        <label>
                                            Tình trạng thanh toán:
                                        </label>
                                        <%# Eval("PayStatusName")%>
                                    </li>
                                    <li>
                                        <label>
                                            Tình trạng vận chuyển:
                                        </label>
                                        <%# Eval("ShippingStatusName")%>
                                    </li>
                                    <li>
                                        <label>
                                            Ghi chú:
                                        </label>
                                        <%# Eval("Notes")%>
                                    </li>
                                </ul>
                            </fieldset>
                            <fieldset style="float: right; width: 55%">
                                <legend><strong>Chi tiết đơn hàng</strong></legend>
                                <asp:HiddenField ID="hdnOrderID" runat="server" Value='<%# Eval("OrderID") %>' />
                                <asp:RadListView ID="lvOrderDetail" runat="server" DataSourceID="OdsOrderDetail"
                                    EnableModelValidation="True">
                                    <ItemTemplate>
                                        <div style="float: left; width: 500px">
                                            &diams;
                                            <%# Eval("Quantity") %>
                                            x
                                            <%# Eval("ProductName") %>
                                            -
                                            <%# Eval("Tag") %>
                                            -
                                            <%# Eval("ProductColorName") %>
                                            -
                                            <%# Eval("ProductColorNameEn") %>
                                            :
                                        </div>
                                        <div style="float: left;">
                                            <%# string.Format("{0:##,###.##}", Convert.ToInt32(Eval("Quantity")) * Convert.ToDouble(string.IsNullOrEmpty(Eval("Price").ToString()) ? 0 : Eval("Price"))) + " VNĐ"%>
                                        </div>
                                        <div class="clr">
                                        </div>
                                    </ItemTemplate>
                                    <LayoutTemplate>
                                        <span runat="server" id="itemPlaceholder" />
                                    </LayoutTemplate>
                                </asp:RadListView>
                                <asp:ObjectDataSource ID="OdsOrderDetail" runat="server" SelectMethod="OrderDetailSelectAll1"
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
                                        <asp:Parameter Name="Email" Type="String" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                            </fieldset>
                            <div class="clr">
                            </div>
                        </ItemTemplate>
                    </asp:RadListView>
                    <asp:ObjectDataSource ID="OdsOrder" runat="server" SelectMethod="OrdersSelectAllNoUser"
                        TypeName="TLLib.Orders">
                        <SelectParameters>
                            <asp:Parameter Name="OrderID" Type="String" />
                            <asp:Parameter Name="UserName" Type="String" />
                            <asp:Parameter Name="OrderStatusID" Type="String" />
                            <asp:Parameter Name="ShippingStatusID" Type="String" />
                            <asp:Parameter Name="PaymentMethodID" Type="String" />
                            <asp:Parameter Name="BillingAddressID" Type="String" />
                            <asp:Parameter Name="ShippingAddressID" Type="String" />
                            <asp:Parameter Name="Notes" Type="String" />
                            <asp:Parameter Name="FromDate" Type="String" />
                            <asp:Parameter Name="ToDate" Type="String" />
                            <asp:Parameter Name="ProvinceID" Type="String" />
                            <asp:Parameter Name="DistrictID" Type="String" />
                            <asp:ControlParameter ControlID="hdnEmail" Name="Email" PropertyName="Value" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </NestedViewTemplate>
            </MasterTableView>
            <HeaderStyle Font-Bold="True" />
            <HeaderContextMenu EnableImageSprites="True" CssClass="GridContextMenu GridContextMenu_Default">
            </HeaderContextMenu>
        </asp:RadGrid>
    </asp:RadAjaxPanel>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="AddressBook1SelectAll"
        TypeName="TLLib.AddressBook1" DeleteMethod="AddressBook1Delete" UpdateMethod="AddressBook1Update"
        InsertMethod="AddressBook1Insert1">
        <DeleteParameters>
            <asp:Parameter Name="AddressBookID" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="FirstName" Type="String" />
            <asp:Parameter Name="LastName" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="HomePhone" Type="String" />
            <asp:Parameter Name="CellPhone" Type="String" />
            <asp:Parameter Name="Fax" Type="String" />
            <asp:Parameter Name="UserName" Type="String" />
            <asp:Parameter Name="Company" Type="String" />
            <asp:Parameter Name="Address1" Type="String" />
            <asp:Parameter Name="Address2" Type="String" />
            <asp:Parameter Name="ZipCode" Type="String" />
            <asp:Parameter Name="City" Type="String" />
            <asp:Parameter Name="CountryID" Type="String" />
            <asp:Parameter Name="ProvinceID" Type="String" />
            <asp:Parameter Name="DistrictID" Type="String" />
            <asp:Parameter Name="IsPrimary" Type="String" />
            <asp:Parameter Name="IsPrimaryBilling" Type="String" />
            <asp:Parameter Name="IsPrimaryShipping" Type="String" />
            <asp:Parameter Name="RoleName" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:Parameter Name="AddressBookID" Type="String" />
            <asp:ControlParameter ControlID="txtSearchFirstName" Name="FirstName" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchLastName" Name="LastName" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchEmail" Name="Email" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchHomePhone" Name="HomePhone" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchCellPhone" Name="CellPhone" PropertyName="Text"
                Type="String" />
            <asp:Parameter Name="Fax" Type="String" />
            <asp:ControlParameter ControlID="txtSearchUserName" Name="UserName" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchCompany" Name="Company" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchAddress" Name="Address1" PropertyName="Text"
                Type="String" />
            <asp:Parameter Name="Address2" Type="String" />
            <asp:Parameter Name="ZipCode" Type="String" />
            <asp:Parameter Name="City" Type="String" />
            <asp:Parameter Name="CountryID" Type="String" />
            <asp:Parameter Name="ProvinceID" Type="String" />
            <asp:Parameter Name="DistrictID" Type="String" />
            <asp:ControlParameter ControlID="ddlSearchIsPrimary" Name="IsPrimary" PropertyName="SelectedValue"
                Type="String" />
            <asp:Parameter Name="IsPrimaryBilling" Type="String" />
            <asp:Parameter Name="IsPrimaryShipping" Type="String" />
            <asp:ControlParameter ControlID="ddlRole" Name="RoleName" PropertyName="SelectedValue"
                Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="AddressBookID" Type="String" />
            <asp:Parameter Name="FirstName" Type="String" />
            <asp:Parameter Name="LastName" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="HomePhone" Type="String" />
            <asp:Parameter Name="CellPhone" Type="String" />
            <asp:Parameter Name="Fax" Type="String" />
            <asp:Parameter Name="UserName" Type="String" />
            <asp:Parameter Name="Company" Type="String" />
            <asp:Parameter Name="Address1" Type="String" />
            <asp:Parameter Name="Address2" Type="String" />
            <asp:Parameter Name="ZipCode" Type="String" />
            <asp:Parameter Name="City" Type="String" />
            <asp:Parameter Name="CountryID" Type="String" />
            <asp:Parameter Name="ProvinceID" Type="String" />
            <asp:Parameter Name="DistrictID" Type="String" />
            <asp:Parameter Name="IsPrimary" Type="String" />
            <asp:Parameter Name="IsPrimaryBilling" Type="String" />
            <asp:Parameter Name="IsPrimaryShipping" Type="String" />
            <asp:Parameter Name="RoleName" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="RoleSelectAll"
        TypeName="TLLib.User"></asp:ObjectDataSource>
    <asp:RadProgressManager ID="RadProgressManager1" runat="server" />
    <asp:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" Skin="Default">
    </asp:RadAjaxLoadingPanel>
</asp:Content>
