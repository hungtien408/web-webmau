<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/adminEn.master" AutoEventWireup="true"
    CodeFile="product1.aspx.cs" Inherits="ad_single_product" %>

<%@ Register TagPrefix="asp" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register Assembly="Spaanjaars.Toolkit" Namespace="Spaanjaars.Toolkit" TagPrefix="isp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="Server">
    <link href="../assets/styles/rating.css" rel="stylesheet" type="text/css" />
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

        //On insert and update buttons click temporarily disables ajax to perform upload actions
        function conditionalPostback(sender, eventArgs) {
            var theRegexp = new RegExp("\.lnkUpdate$|\.lnkUpdateTop$|\.PerformInsertButton$", "ig");
            if (eventArgs.get_eventTarget().match(theRegexp)) {
                var upload = $find(window['UploadId']);

                //AJAX is disabled only if file is selected for upload
                if (upload.getFileInputs()[0].value != "") {
                    eventArgs.set_enableAjax(false);
                }
            }
            else if (eventArgs.get_eventTarget().indexOf("ExportToExcelButton") >= 0 || eventArgs.get_eventTarget().indexOf("ExportToWordButton") >= 0 || eventArgs.get_eventTarget().indexOf("ExportToPdfButton") >= 0)
                eventArgs.set_enableAjax(false);
        }

        function validateRadUpload(source, e) {
            e.IsValid = false;

            var upload = $find(source.parentNode.getElementsByTagName('div')[0].id);
            var inputs = upload.getFileInputs();
            for (var i = 0; i < inputs.length; i++) {
                //check for empty string or invalid extension
                if (upload.isExtensionValid(inputs[i].value)) {
                    e.IsValid = true;
                    break;
                }
            }
        }

        function containerMouseover(sender) {
            sender.getElementsByTagName("div")[0].style.display = "";
        }
        function containerMouseout(sender) {
            sender.getElementsByTagName("div")[0].style.display = "none";
        }
    </script>
    <style type="text/css">
        .myClass:hover
        {
            background-color: #a1da29 !important;
        }
        .txt
        {
            border: 0px !important;
            background: #eeeeee !important;
            color: Black !important;
            margin-left: 25%;
            margin-right: auto;
            width: 100%;
            filter: alpha(opacity=50); /* IE's opacity*/
            opacity: 0.50;
            text-align: center;
            display: block;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <h3 class="mainTitle">
        <img alt="" src="../assets/images/product.png" class="vam" />
        Sản Phẩm
    </h3>
    <asp:RadAjaxPanel ID="RadAjaxPanel1" runat="server" ClientEvents-OnRequestStart="conditionalPostback">
        <asp:Panel ID="pnlSearch" DefaultButton="btnSearch" runat="server">
            <h4 class="searchTitle">
                Tìm kiếm
            </h4>
            <table class="search">
                <tr>
                    <td class="left">
                        Tên sản phẩm
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchProductName" runat="server" Width="130px" EmptyMessage="Tên sản phẩm...">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Mô tả
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchDescription" runat="server" Width="130px" EmptyMessage="Mô tả...">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Từ ngày
                    </td>
                    <td>
                        <asp:RadDatePicker ShowPopupOnFocus="True" ID="dpFromDate" runat="server" Culture="vi-VN"
                            Calendar-CultureInfo="vi-VN" Width="138px">
                            <Calendar runat="server">
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
                            <Calendar runat="server">
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
                        Danh mục
                    </td>
                    <td>
                        <asp:RadComboBox Filter="Contains" ID="ddlSearchCategory" runat="server" DataSourceID="ObjectDataSource2"
                            DataTextField="ProductCategoryName" DataValueField="ProductCategoryID" OnDataBound="DropDownList_DataBound"
                            Width="134px" EmptyMessage="- Tất cả -">
                        </asp:RadComboBox>
                    </td>
                    <td class="left">
                        Nhà sản xuất
                    </td>
                    <td>
                        <asp:RadComboBox Filter="Contains" ID="ddlSearchManufacturer" runat="server" DataSourceID="ObjectDataSource3"
                            DataTextField="ManufacturerName" DataValueField="ManufacturerID" OnDataBound="DropDownList_DataBound"
                            Width="134px" EmptyMessage="- Tất cả -">
                        </asp:RadComboBox>
                    </td>
                    <td class="left">
                        Xuất xứ
                    </td>
                    <td>
                        <asp:RadComboBox Filter="Contains" ID="ddlSearchOrigin" runat="server" DataSourceID="ObjectDataSource4"
                            DataTextField="OriginName" DataValueField="OriginID" OnDataBound="DropDownList_DataBound"
                            Width="134px" EmptyMessage="- Tất cả -">
                        </asp:RadComboBox>
                    </td>
                    <td class="left">
                        Tag
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchTag" runat="server" Width="130px" EmptyMessage="Tag...">
                        </asp:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td class="left">
                        Giá từ
                    </td>
                    <td>
                        <asp:RadNumericTextBox ID="txtSearchPriceFrom" runat="server" Width="130px" EmptyMessage="Giá từ..."
                            Type="Number">
                            <NumberFormat AllowRounding="false" />
                        </asp:RadNumericTextBox>
                    </td>
                    <td class="left">
                        Giá đến
                    </td>
                    <td>
                        <asp:RadNumericTextBox ID="txtSearchPriceTo" runat="server" Width="130px" EmptyMessage="Giá đến..."
                            Type="Number">
                            <NumberFormat AllowRounding="false" />
                        </asp:RadNumericTextBox>
                    </td>
                    <td class="left">
                        SP Hot
                    </td>
                    <td>
                        <asp:RadComboBox Filter="Contains" ID="ddlSearchIsHot" runat="server" Width="134px"
                            EmptyMessage="- Tất cả -">
                            <Items>
                                <asp:RadComboBoxItem Value="" />
                                <asp:RadComboBoxItem Value="True" Text="Có" />
                                <asp:RadComboBoxItem Value="False" Text="Không" />
                            </Items>
                        </asp:RadComboBox>
                    </td>
                    <td class="left">
                        SP mới
                    </td>
                    <td>
                        <asp:RadComboBox Filter="Contains" ID="ddlSearchIsNew" runat="server" Width="134px"
                            EmptyMessage="- Tất cả -">
                            <Items>
                                <asp:RadComboBoxItem Value="" />
                                <asp:RadComboBoxItem Value="True" Text="Có" />
                                <asp:RadComboBoxItem Value="False" Text="Không" />
                            </Items>
                        </asp:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td class="left">
                        Bán chạy
                    </td>
                    <td>
                        <asp:RadComboBox Filter="Contains" ID="ddlSearchIsBestSeller" runat="server" Width="134px"
                            EmptyMessage="- Tất cả -">
                            <Items>
                                <asp:RadComboBoxItem Value="" />
                                <asp:RadComboBoxItem Value="True" Text="Có" />
                                <asp:RadComboBoxItem Value="False" Text="Không" />
                            </Items>
                        </asp:RadComboBox>
                    </td>
                    <td class="left">
                        &nbsp;Giảm giá
                    </td>
                    <td>
                        <asp:RadComboBox ID="ddlSearchIsSaleOff" runat="server" Filter="Contains" Width="134px"
                            EmptyMessage="- Tất cả -">
                            <Items>
                                <asp:RadComboBoxItem Value="" />
                                <asp:RadComboBoxItem Text="Có" Value="True" />
                                <asp:RadComboBoxItem Text="Không" Value="False" />
                            </Items>
                        </asp:RadComboBox>
                    </td>
                    <td class="left">
                        Còn hàng
                    </td>
                    <td>
                        <asp:RadComboBox ID="ddlSearchIsInStock" runat="server" Filter="Contains" Width="134px"
                            EmptyMessage="- Tất cả -">
                            <Items>
                                <asp:RadComboBoxItem Value="" />
                                <asp:RadComboBoxItem Text="Có" Value="True" />
                                <asp:RadComboBoxItem Text="Không" Value="False" />
                            </Items>
                        </asp:RadComboBox>
                    </td>
                    <td class="left">
                        Xem trên trang chủ
                    </td>
                    <td>
                        <asp:RadComboBox ID="ddlSearchIsShowOnHomePage" runat="server" Filter="Contains"
                            Width="134px" EmptyMessage="- Tất cả -">
                            <Items>
                                <asp:RadComboBoxItem Value="" />
                                <asp:RadComboBoxItem Text="Có" Value="True" />
                                <asp:RadComboBoxItem Text="Không" Value="False" />
                            </Items>
                        </asp:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td class="left">
                        Hiển thị
                    </td>
                    <td>
                        <asp:RadComboBox ID="ddlSearchIsAvailable" runat="server" Filter="Contains" Width="134px"
                            EmptyMessage="- Tất cả -">
                            <Items>
                                <asp:RadComboBoxItem Value="" />
                                <asp:RadComboBoxItem Text="Có" Value="True" />
                                <asp:RadComboBoxItem Text="Không" Value="False" />
                            </Items>
                        </asp:RadComboBox>
                    </td>
                    <td class="left">
                        Thứ tự
                    </td>
                    <td>
                        <asp:RadComboBox ID="ddlSearchPriority" runat="server" Filter="Contains" Width="134px"
                            EmptyMessage="- Tất cả -">
                            <Items>
                                <asp:RadComboBoxItem Value="" />
                                <asp:RadComboBoxItem Text="Có" Value="True" />
                                <asp:RadComboBoxItem Text="Không" Value="False" />
                            </Items>
                        </asp:RadComboBox>
                    </td>
                    <td class="left">
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td class="left">
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
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
        <asp:RadGrid ID="RadGrid1" AllowMultiRowSelection="True" runat="server" Culture="vi-VN"
            AllowPaging="True" AllowSorting="True" DataSourceID="ObjectDataSource1" GridLines="Horizontal"
            AutoGenerateColumns="False" ShowStatusBar="True" OnItemCommand="RadGrid1_ItemCommand"
            OnItemDataBound="RadGrid1_ItemDataBound" OnPreRender="RadGrid1_PreRender" CssClass="grid"
            AllowAutomaticUpdates="True" CellSpacing="0">
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
                DataKeyNames="ProductID">
                <%--<CommandItemSettings ShowExportToExcelButton="True" ShowExportToPdfButton="True"
                    ShowExportToWordButton="True"></CommandItemSettings>--%>
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
                    <%--<asp:GridEditCommandColumn ButtonType="ImageButton" HeaderStyle-Width="1%" />
                    <asp:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" ConfirmText="Xóa dòng này ?"
                        ConfirmTitle="Xóa" ConfirmDialogType="RadWindow" HeaderStyle-Width="1%" />--%>
                    <asp:GridTemplateColumn HeaderStyle-Width="1%" HeaderText="STT">
                        <ItemTemplate>
                            <%# Container.DataSetIndex + 1 %>
                            <asp:HiddenField ID="hdnImageName" runat="server" Value='<%# Eval("ImageName") %>' />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridBoundColumn HeaderText="ID" DataField="ProductID" SortExpression="ProductID">
                    </asp:GridBoundColumn>
                    <asp:GridBoundColumn DataField="ProductName" HeaderText="Tên sản phẩm" SortExpression="ProductName" />
                    <asp:GridTemplateColumn DataField="SavePrice" HeaderText="Giá cũ" SortExpression="SavePrice">
                        <ItemTemplate>
                            <%# string.Format("{0:##,###.##}", Eval("SavePrice")) %>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="Price" HeaderText="Giá mới" SortExpression="Price">
                        <ItemTemplate>
                            <%# string.IsNullOrEmpty(Eval("Price").ToString()) ? Eval("OtherPrice") : string.Format("{0:##,###.##}", Eval("Price")) %>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridBoundColumn DataField="ProductCategoryName" HeaderText="Danh mục" SortExpression="ProductCategoryName" />
                    <asp:GridBoundColumn DataField="ManufacturerName" HeaderText="Nhà sản xuất" SortExpression="ManufacturerName" />
                    <asp:GridTemplateColumn DataField="Priority" HeaderStyle-Width="1%" HeaderText="Thứ tự"
                        SortExpression="Priority">
                        <ItemTemplate>
                            <asp:RadNumericTextBox ID="txtPriority" runat="server" Width="70px" Text='<%# Bind("Priority") %>'
                                ShowSpinButtons="true" MinValue="0" EmptyMessage="Thứ tự..." Type="Number">
                                <NumberFormat AllowRounding="false" DecimalDigits="0" GroupSeparator="." />
                            </asp:RadNumericTextBox>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="IsNew" HeaderStyle-Width="1%" HeaderText="Mới"
                        SortExpression="IsNew">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsNew" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("IsNew").ToString()) ? false : Eval("IsNew") %>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="IsHot" HeaderText="Hot" SortExpression="IsHot">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsHot" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("IsHot").ToString()) ? false : Eval("IsHot") %>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="IsBestSeller" HeaderText="Bán chạy" SortExpression="IsBestSeller">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsBestSeller" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("IsBestSeller").ToString()) ? false : Eval("IsBestSeller") %>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="IsSaleOff" HeaderText="Giảm giá" SortExpression="IsSaleOff">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsSaleOff" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("IsSaleOff").ToString()) ? false : Eval("IsSaleOff") %>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="InStock" HeaderText="Còn hàng" SortExpression="InStock">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkInStock" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("InStock").ToString()) ? false : Eval("InStock") %>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="IsShowOnHomePage" HeaderText="Xem trên trang chủ"
                        SortExpression="IsShowOnHomePage">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsShowOnHomePage" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("IsShowOnHomePage").ToString()) ? false : Eval("IsShowOnHomePage") %>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="IsAvailable" HeaderText="Hiển thị" SortExpression="IsAvailable">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsAvailable" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("IsAvailable").ToString()) ? false : Eval("IsAvailable") %>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Ngày tạo" SortExpression="CreateDate" HeaderStyle-Width="1%">
                        <ItemTemplate>
                            <%# string.Format("{0:dd/MM/yyyy hh:mm tt}", Eval("CreateDate"))%>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Đánh giá" SortExpression="Rating" HeaderStyle-Width="1%">
                        <ItemTemplate>
                            <isp:ContentRating ID="ContentRating1" runat="server" Enabled="false" CssClass="rating"
                                LegendText="{0} rates"></isp:ContentRating>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderStyle-Width="1%">
                        <ItemTemplate>
                            <div style="width: 36px">
                                <img alt="Thư viện ảnh" title="Thư viện ảnh" src="../assets/images/PhotoAlbum.png"
                                    onclick="openWindow('productphotoalbum.aspx?PI=<%# Eval("ProductID") %>','Thư viện ảnh')"
                                    style="cursor: pointer" />
                                <img alt="File Download" title="File Download" src="../assets/images/filedownload.png"
                                    onclick="openWindow('productdownload.aspx?PI=<%# Eval("ProductID") %>','File Download')"
                                    style="cursor: pointer" />
                            </div>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn DataField="ImageName" HeaderText="Ảnh" SortExpression="ImageName">
                        <ItemTemplate>
                            <asp:Panel ID="Panel1" runat="server" Visible='<%# string.IsNullOrEmpty( Eval("ImageName").ToString()) ? false : true %>'
                                Width="95">
                                <img alt="" src='<%# "~/res/product/thumbs/" + Eval("ImageName") %>' width="80" runat="server"
                                    visible='<%# string.IsNullOrEmpty(Eval("ImageName").ToString()) ? false : true %>' />
                                <asp:LinkButton ID="lnkDeleteImage" runat="server" rel='<%#  Eval("ProductID") + "#" + Eval("ImageName") %>'
                                    CommandName="DeleteImage" OnClientClick="return confirm('Xóa ảnh này ?')">
                                <img alt="Xóa ảnh" title="Xóa ảnh" src="../assets/images/delete-icon.png" />
                                </asp:LinkButton>
                            </asp:Panel>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                </Columns>
                <EditFormSettings EditFormType="Template">
                    <FormTemplate>
                        <asp:Panel ID="Panel1" runat="server" DefaultButton="lnkUpdate">
                            <table width="100%">
                                <tr>
                                    <td valign="top" style="width: 500px">
                                        <div class="sub_box">
                                            <div class="head">
                                                Thông Tin Sản Phẩm
                                            </div>
                                            <div class="cont">
                                                <asp:HiddenField ID="hdnProductID" runat="server" Value='<%# Eval("ProductID") %>' />
                                                <asp:HiddenField ID="hdnOldImageName" runat="server" Value='<%# Eval("ImageName") %>' />
                                                <div class="edit">
                                                    <hr />
                                                    <asp:RadButton ID="lnkUpdateTop" runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>'
                                                        Text='<%# (Container is GridEditFormInsertItem) ? "Thêm" : "Cập nhật" %>'>
                                                        <Icon PrimaryIconUrl="~/ad/assets/images/ok.png" />
                                                    </asp:RadButton>
                                                    &nbsp;&nbsp;
                                                    <asp:RadButton ID="btnCancel" runat="server" CommandName='Cancel' Text='Hủy'>
                                                        <Icon PrimaryIconUrl="~/ad/assets/images/cancel.png" />
                                                    </asp:RadButton>
                                                </div>
                                                <table class="search">
                                                    <tr>
                                                        <td class="left" valign="top">
                                                            Ảnh đại diện
                                                        </td>
                                                        <td runat="server">
                                                            <asp:RadUpload ID="FileImageName" runat="server" ControlObjectsVisibility="None"
                                                                Culture="vi-VN" Language="vi-VN" InputSize="69" AllowedFileExtensions=".jpg,.jpeg,.gif,.png" />
                                                            <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="Sai định dạng ảnh (*.jpg, *.jpeg, *.gif, *.png)"
                                                                ClientValidationFunction="validateRadUpload" Display="Dynamic"></asp:CustomValidator>
                                                            <%--<asp:RadAsyncUpload ID="FileImageName" runat="server"
                                                                TargetFolder="~/res/product/album/" TemporaryFolder="~/res/TempAsync" Width="100%"
                                                                AllowedFileExtensions="jpg,jpeg,gif,png" Localization-Select="Chọn" Localization-Cancel="Hủy"
                                                                Localization-Remove="Xóa" OnFileUploaded="FileImageAlbum_FileUploaded">
                                                            </asp:RadAsyncUpload>--%>
                                                            <asp:HiddenField ID="hdnNewImageName" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left" colspan="2">
                                                            <asp:CheckBox ID="chkIsNew" runat="server" CssClass="checkbox" Text=" Mới" Checked='<%# (Container is GridEditFormInsertItem) ? false : (string.IsNullOrEmpty(Eval("IsNew").ToString()) ? false : Eval("IsNew"))%>' />
                                                            &nbsp;&nbsp;
                                                            <asp:CheckBox ID="chkIsHot" runat="server" CssClass="checkbox" Text=" Hot" Checked='<%# (Container is GridEditFormInsertItem) ? false : (string.IsNullOrEmpty(Eval("IsHot").ToString()) ? false : Eval("IsHot"))%>' />
                                                            &nbsp;&nbsp;
                                                            <asp:CheckBox ID="chkIsBestSeller" runat="server" CssClass="checkbox" Text=" Bán chạy"
                                                                Checked='<%# (Container is GridEditFormInsertItem) ? false : Eval("IsBestSeller") %>' />
                                                            &nbsp;&nbsp;
                                                            <asp:CheckBox ID="chkIsSaleOff" runat="server" CssClass="checkbox" Text=" Giảm giá"
                                                                Checked='<%# (Container is GridEditFormInsertItem) ? false : Eval("IsSaleOff") %>' />
                                                            &nbsp;&nbsp;
                                                            <asp:CheckBox ID="chkInStock" runat="server" CssClass="checkbox" Text=" Còn hàng"
                                                                Checked='<%# (Container is GridEditFormInsertItem) ? true : Eval("InStock") %>' />
                                                            &nbsp;&nbsp;
                                                            <asp:CheckBox ID="chkIsShowOnHomePage" runat="server" CssClass="checkbox" Text=" Xem trên trang chủ"
                                                                Checked='<%# (Container is GridEditFormInsertItem) ? true : (string.IsNullOrEmpty(Eval("IsShowOnHomePage").ToString()) ? false : Eval("IsShowOnHomePage"))%>' />
                                                            &nbsp;&nbsp;
                                                            <asp:CheckBox ID="chkIsAvailable" runat="server" CssClass="checkbox" Text=" Hiển thị"
                                                                Checked='<%# (Container is GridEditFormInsertItem) ? true : (string.IsNullOrEmpty(Eval("IsAvailable").ToString()) ? false : Eval("IsAvailable")) %>' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Danh mục
                                                        </td>
                                                        <td>
                                                            <asp:RadComboBox Filter="Contains" ID="ddlCategory" runat="server" DataSourceID="ObjectDataSource2"
                                                                DataTextField="ProductCategoryName" DataValueField="ProductCategoryID" Width="504px"
                                                                OnDataBound="DropDownList_DataBound" EmptyMessage="- Chọn -">
                                                            </asp:RadComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Nhà sản xuất
                                                        </td>
                                                        <td>
                                                            <asp:RadComboBox Filter="Contains" ID="ddlManufacturer" runat="server" DataSourceID="ObjectDataSource3"
                                                                DataTextField="ManufacturerName" DataValueField="ManufacturerID" Width="504px"
                                                                OnDataBound="DropDownList_DataBound" EmptyMessage="- Chọn -">
                                                            </asp:RadComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Xuất xứ
                                                        </td>
                                                        <td>
                                                            <asp:RadComboBox Filter="Contains" ID="ddlOrigin" runat="server" DataSourceID="ObjectDataSource4"
                                                                DataTextField="OriginName" DataValueField="OriginID" Width="504px" OnDataBound="DropDownList_DataBound"
                                                                EmptyMessage="- Chọn -">
                                                            </asp:RadComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Thứ tự
                                                        </td>
                                                        <td>
                                                            <asp:RadNumericTextBox ID="txtPriority" runat="server" Width="500px" Text='<%# Bind("Priority") %>'
                                                                EmptyMessage="Thứ tự..." Type="Number">
                                                                <NumberFormat AllowRounding="false" DecimalDigits="0" GroupSeparator="." />
                                                            </asp:RadNumericTextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Giá cũ
                                                        </td>
                                                        <td>
                                                            <asp:RadNumericTextBox ID="txtSavePrice" runat="server" Width="500px" Text='<%# Bind("SavePrice") %>'
                                                                EmptyMessage="Giá cũ..." Type="Number">
                                                                <NumberFormat AllowRounding="false" />
                                                            </asp:RadNumericTextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Giá mới
                                                        </td>
                                                        <td>
                                                            <div id="pnlprice" class='<%# string.IsNullOrEmpty(Eval("OtherPrice").ToString()) ? "visible" : "invisible" %>'>
                                                                <asp:RadNumericTextBox ID="txtPrice" runat="server" Width="500px" rel="price" Text='<%# Bind("Price") %>'
                                                                    EmptyMessage="Giá mới..." Type="Number">
                                                                    <NumberFormat AllowRounding="false" />
                                                                </asp:RadNumericTextBox>
                                                                <a id="lnkother" onclick="$('input[rel=price]').attr('disabled','disabled').val('');$('#pnlotherprice').show();$('#pnlprice').hide();"
                                                                    style="cursor: pointer">»Khác</a>
                                                            </div>
                                                            <div id="pnlotherprice" class='<%# string.IsNullOrEmpty(Eval("OtherPrice").ToString()) ? "invisible" : "visible" %>'>
                                                                <asp:RadTextBox ID="txtOtherPrice" runat="server" rel='otherprice' Width="500px"
                                                                    Text='<%# Bind("OtherPrice") %>' EmptyMessage="Giá khác... VD: Call">
                                                                </asp:RadTextBox>
                                                                <a onclick="$('input[rel=price]').removeAttr('disabled');$('input[rel=otherprice]').val('');$('#pnlotherprice').hide();$('#pnlprice').show();"
                                                                    style="cursor: pointer">Quay lại«</a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Giảm
                                                        </td>
                                                        <td>
                                                            <asp:RadNumericTextBox ID="txtDiscount" runat="server" Width="500px" Text='<%# Bind("Discount") %>'
                                                                EmptyMessage="Giảm(%)..." Type="Percent">
                                                                <NumberFormat AllowRounding="false" />
                                                            </asp:RadNumericTextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Tag
                                                        </td>
                                                        <td>
                                                            <asp:RadTextBox ID="txtTag" runat="server" Width="500px" Text='<%# Bind("Tag") %>'
                                                                EmptyMessage="Tag...">
                                                            </asp:RadTextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Meta Title
                                                        </td>
                                                        <td>
                                                            <asp:RadTextBox ID="txtMetaTittle" runat="server" Width="500px" Text='<%# Bind("MetaTittle") %>'
                                                                EmptyMessage="Title...">
                                                            </asp:RadTextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Meta Description
                                                        </td>
                                                        <td>
                                                            <asp:RadTextBox ID="txtMetaDescription" runat="server" Width="500px" Text='<%# Bind("MetaDescription") %>'
                                                                EmptyMessage="Meta Description...">
                                                            </asp:RadTextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Tên sản phẩm
                                                        </td>
                                                        <td>
                                                            <asp:RadTextBox ID="txtProductName" runat="server" Text='<%# Bind("ProductName") %>'
                                                                Width="500px" EmptyMessage="Tên sản phẩm...">
                                                            </asp:RadTextBox>
                                                            <%--<asp:RadTextBox runat="server" Width="500px" ID="RadTextBox1" Text='<%# Bind("ProductName") %>' />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtProductName"
                                            Display="Dynamic" ErrorMessage="Nhập tên sản phẩm" SetFocusOnError="true">*</asp:RequiredFieldValidator>--%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left" valign="top">
                                                            Mô tả
                                                        </td>
                                                        <td>
                                                            <asp:RadEditor ID="txtDescription" StripFormattingOptions="MSWordRemoveAll,ConvertWordLists,MSWordNoFonts,Font,Css,Span" ContentFilters="ConvertCharactersToEntities,ConvertToXhtml,OptimizeSpans,IndentHTMLContent,ConvertFontToSpan,IECleanAnchors,FixUlBoldItalic,RemoveScripts,FixEnclosingP" runat="server" Height="200" Language="vi-VN" Skin="Office2007"
                                                                Width="503px" Content='<%# Bind("Description") %>'>
                                                                <ImageManager DeletePaths="~/Uploads/Image/" UploadPaths="~/Uploads/Image/" ViewPaths="~/Uploads/Image/" MaxUploadFileSize="1024000" />
                                                                <FlashManager DeletePaths="~/Uploads/Video/" UploadPaths="~/Uploads/Video/" ViewPaths="~/Uploads/Video/" />
                                                                <DocumentManager DeletePaths="~/Uploads/File/" UploadPaths="~/Uploads/File/" ViewPaths="~/Uploads/File/" MaxUploadFileSize="1024000" />
                                                                <MediaManager DeletePaths="~/Uploads/Media/" UploadPaths="~/Uploads/Media/" ViewPaths="~/Uploads/Media/" />
                                                                <TemplateManager DeletePaths="~/Uploads/Template/" UploadPaths="~/Uploads/Template/"
                                                                    ViewPaths="~/Uploads/Template/" />
                                                                <Tools>
                                                                    <asp:EditorToolGroup>
                                                                        <asp:EditorTool Name="Copy" />
                                                                        <asp:EditorTool Name="Cut" />
                                                                        <asp:EditorTool Name="Paste" />
                                                                        <asp:EditorTool Name="Bold" />
                                                                        <asp:EditorTool Name="Italic" />
                                                                        <asp:EditorTool Name="Underline" />
                                                                        <asp:EditorTool Name="InsertLink" />
                                                                        <asp:EditorTool Name="ForeColor" />
                                                                    </asp:EditorToolGroup>
                                                                </Tools>
                                                            </asp:RadEditor>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left" valign="top">
                                                            Nội dung
                                                        </td>
                                                        <td>
                                                            <asp:RadEditor ID="txtContent" ContentFilters="ConvertCharactersToEntities,ConvertToXhtml,OptimizeSpans,IndentHTMLContent,ConvertFontToSpan,IECleanAnchors,FixUlBoldItalic,RemoveScripts,FixEnclosingP" runat="server" Language="vi-VN" Skin="Office2007"
                                                                Width="503px" Content='<%# Bind("Content") %>'>
                                                                <ImageManager DeletePaths="~/Uploads/Image/" UploadPaths="~/Uploads/Image/" ViewPaths="~/Uploads/Image/" MaxUploadFileSize="1024000" />
                                                                <FlashManager DeletePaths="~/Uploads/Video/" UploadPaths="~/Uploads/Video/" ViewPaths="~/Uploads/Video/" />
                                                                <DocumentManager DeletePaths="~/Uploads/File/" UploadPaths="~/Uploads/File/" ViewPaths="~/Uploads/File/" MaxUploadFileSize="1024000" />
                                                                <MediaManager DeletePaths="~/Uploads/Media/" UploadPaths="~/Uploads/Media/" ViewPaths="~/Uploads/Media/" />
                                                                <TemplateManager DeletePaths="~/Uploads/Template/" UploadPaths="~/Uploads/Template/"
                                                                    ViewPaths="~/Uploads/Template/" />
                                                            </asp:RadEditor>
                                                        </td>
                                                    </tr>
                                                    <%-- Tiếng Anh--%>
                                                    <tr>
                                                        <td colspan="2">
                                                            <h3>
                                                                (Ngôn Ngữ Tiếng Anh)</h3>
                                                            <hr />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Tag(En)
                                                        </td>
                                                        <td>
                                                            <asp:RadTextBox ID="txtTagEn" runat="server" Width="500px" Text='<%# Bind("TagEn") %>'
                                                                EmptyMessage="Tag(En)...">
                                                            </asp:RadTextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Meta Title
                                                        </td>
                                                        <td>
                                                            <asp:RadTextBox ID="txtMetaTittleEn" runat="server" Width="500px" Text='<%# Bind("MetaTittleEn") %>'
                                                                EmptyMessage="Meta Title(En)...">
                                                            </asp:RadTextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Meta Description
                                                        </td>
                                                        <td>
                                                            <asp:RadTextBox ID="txtMetaDescriptionEn" runat="server" Width="500px" Text='<%# Bind("MetaDescriptionEn") %>'
                                                                EmptyMessage="Meta Description...">
                                                            </asp:RadTextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left">
                                                            Tên sản phẩm
                                                        </td>
                                                        <td>
                                                            <asp:RadTextBox ID="txtProductNameEn" runat="server" Text='<%# Bind("ProductNameEn") %>'
                                                                EmptyMessage="Tên sản phẩm..." Width="500px">
                                                            </asp:RadTextBox>
                                                            <%--<asp:RadTextBox runat="server" Width="500px" ID="RadTextBox1" Text='<%# Bind("ProductName") %>' />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtProductName"
                                            Display="Dynamic" ErrorMessage="Nhập tên sản phẩm" SetFocusOnError="true">*</asp:RequiredFieldValidator>--%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left" valign="top">
                                                            Mô tả
                                                        </td>
                                                        <td>
                                                            <asp:RadEditor ID="txtDescriptionEn" ContentFilters="ConvertCharactersToEntities,ConvertToXhtml,OptimizeSpans,IndentHTMLContent,ConvertFontToSpan,IECleanAnchors,FixUlBoldItalic,RemoveScripts,FixEnclosingP" runat="server" Height="200" Language="vi-VN"
                                                                Skin="Office2007" Width="503px" Content='<%# Bind("DescriptionEn") %>'>
                                                                <ImageManager DeletePaths="~/Uploads/Image/" UploadPaths="~/Uploads/Image/" ViewPaths="~/Uploads/Image/" MaxUploadFileSize="1024000" />
                                                                <FlashManager DeletePaths="~/Uploads/Video/" UploadPaths="~/Uploads/Video/" ViewPaths="~/Uploads/Video/" />
                                                                <DocumentManager DeletePaths="~/Uploads/File/" UploadPaths="~/Uploads/File/" ViewPaths="~/Uploads/File/" MaxUploadFileSize="1024000" />
                                                                <MediaManager DeletePaths="~/Uploads/Media/" UploadPaths="~/Uploads/Media/" ViewPaths="~/Uploads/Media/" />
                                                                <TemplateManager DeletePaths="~/Uploads/Template/" UploadPaths="~/Uploads/Template/"
                                                                    ViewPaths="~/Uploads/Template/" />
                                                                <Tools>
                                                                    <asp:EditorToolGroup>
                                                                        <asp:EditorTool Name="Copy" />
                                                                        <asp:EditorTool Name="Cut" />
                                                                        <asp:EditorTool Name="Paste" />
                                                                        <asp:EditorTool Name="Bold" />
                                                                        <asp:EditorTool Name="Italic" />
                                                                        <asp:EditorTool Name="Underline" />
                                                                        <asp:EditorTool Name="InsertLink" />
                                                                        <asp:EditorTool Name="ForeColor" />
                                                                    </asp:EditorToolGroup>
                                                                </Tools>
                                                            </asp:RadEditor>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left" valign="top">
                                                            Nội dung
                                                        </td>
                                                        <td>
                                                            <asp:RadEditor ID="txtContentEn" ContentFilters="ConvertCharactersToEntities,ConvertToXhtml,OptimizeSpans,IndentHTMLContent,ConvertFontToSpan,IECleanAnchors,FixUlBoldItalic,RemoveScripts,FixEnclosingP" runat="server" Language="vi-VN" Skin="Office2007"
                                                                Width="503px" Content='<%# Bind("ContentEn") %>'>
                                                                <ImageManager DeletePaths="~/Uploads/Image/" UploadPaths="~/Uploads/Image/" ViewPaths="~/Uploads/Image/" MaxUploadFileSize="1024000" />
                                                                <FlashManager DeletePaths="~/Uploads/Video/" UploadPaths="~/Uploads/Video/" ViewPaths="~/Uploads/Video/" />
                                                                <DocumentManager DeletePaths="~/Uploads/File/" UploadPaths="~/Uploads/File/" ViewPaths="~/Uploads/File/" MaxUploadFileSize="1024000" />
                                                                <MediaManager DeletePaths="~/Uploads/Media/" UploadPaths="~/Uploads/Media/" ViewPaths="~/Uploads/Media/" />
                                                                <TemplateManager DeletePaths="~/Uploads/Template/" UploadPaths="~/Uploads/Template/"
                                                                    ViewPaths="~/Uploads/Template/" />
                                                            </asp:RadEditor>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <div class="edit">
                                                    <hr />
                                                    <asp:RadButton ID="lnkUpdate" runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>'
                                                        Text='<%# (Container is GridEditFormInsertItem) ? "Thêm" : "Cập nhật" %>'>
                                                        <Icon PrimaryIconUrl="~/ad/assets/images/ok.png" />
                                                    </asp:RadButton>
                                                    &nbsp;&nbsp;
                                                    <asp:RadButton ID="RadButton1" runat="server" CommandName='Cancel' Text='Hủy'>
                                                        <Icon PrimaryIconUrl="~/ad/assets/images/cancel.png" />
                                                    </asp:RadButton>
                                                </div>
                                            </div>
                                        </div>
                                        </div>
                                    </td>
                                    <td valign="top">
                                        <div class="sub_box">
                                            <div class="head">
                                                Ảnh sản phẩm</div>
                                            <div class="cont">
                                                <asp:RadAjaxPanel ID="RadAjaxPanel2" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
                                                    <asp:RadAsyncUpload ID="FileImageAlbum" runat="server" MultipleFileSelection="Automatic"
                                                        TargetFolder="~/res/product/album/" TemporaryFolder="~/res/TempAsync" Width="100%"
                                                        AllowedFileExtensions="jpg,jpeg,gif,png" Localization-Select="Chọn" Localization-Cancel="Hủy"
                                                        Localization-Remove="Xóa" OnFileUploaded="FileImageAlbum_FileUploaded">
                                                    </asp:RadAsyncUpload>
                                                    <asp:RadButton ID="btnUpload" runat="server" Text="Tải lên" ShowPostBackMask="False">
                                                        <Icon PrimaryIconUrl="~/ad/assets/images/up.png" />
                                                    </asp:RadButton>
                                                    <asp:RadAjaxPanel ID="RadAjaxPanel3" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
                                                        <asp:RadListView runat="server" ID="RadListView1" DataSourceID="OdsProductPhotoAlbum"
                                                            DataKeyNames="ProductImageID" OverrideDataSourceControlSorting="True" OnItemCommand="RadListView1_ItemCommand"
                                                            PageSize="100" Width="100%" Visible='<%# (Container is GridEditFormInsertItem) ? false : true %>'
                                                            ShowPostBackMask="false">
                                                            <LayoutTemplate>
                                                                <div runat="server" id="itemPlaceholder" />
                                                                <div class="clear">
                                                                </div>
                                                            </LayoutTemplate>
                                                            <ItemTemplate>
                                                                <asp:HiddenField ID="hdnImageName" runat="server" Value='<%# Eval("ImageName") %>' />
                                                                <fieldset style="float: left; margin: 5px; padding: 2px 2px 2px 2px; position: relative;
                                                                    background: #eeeeee;" class="myClass">
                                                                    <a href='<%# "~/res/product/album/" + Eval("ImageName") %>' runat="server" class="lightbox">
                                                                        <img alt="" src='<%# "~/res/product/album/thumbs/" + Eval("ImageName") %>' runat="server"
                                                                            width="100" height="100" />
                                                                    </a>
                                                                    <div align="right">
                                                                        <asp:LinkButton ID="btnEditSelected" runat="server" CommandName="Edit" CssClass="item"><img width="14px" class="vam" alt="" title="Sửa" src="../assets/images/tools.png" /></asp:LinkButton>
                                                                        <asp:LinkButton ID="LinkButton1" OnClientClick="return confirm('Xóa ảnh?')" runat="server"
                                                                            CommandName="Delete" CssClass="item"><img width="14px" class="vam" alt="" title="Xóa ảnh" src="../assets/images/trash.png" /></asp:LinkButton>
                                                                    </div>
                                                                </fieldset>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:HiddenField ID="hdnProductImageID" runat="server" Value='<%# Eval("ProductImageID") %>' />
                                                                <asp:HiddenField ID="hdnImageName" runat="server" Value='<%# Eval("ImageName") %>' />
                                                                <asp:Panel ID="Panel2" runat="server" DefaultButton="lnkUpdate">
                                                                    <h3 class="searchTitle clear">
                                                                        Cập Nhật Ảnh</h3>
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td valign="top" style="padding-right: 10px">
                                                                                <table class="search" width="100%">
                                                                                    <tr>
                                                                                        <td class="left" style="width: 70px">
                                                                                            Tiêu đề ảnh
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:RadTextBox ID="txtTitle" Width="100%" runat="server" Text='<%# Bind("Title") %>'
                                                                                                EmptyMessage="Tiêu đề ảnh...">
                                                                                            </asp:RadTextBox>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="left" valign="top">
                                                                                            Mô tả
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:RadTextBox ID="txtDescription" runat="server" Width="100%" Text='<%# Bind("Descripttion")%>'
                                                                                                EmptyMessage="Mô tả...">
                                                                                            </asp:RadTextBox>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="left">
                                                                                            Thứ tự
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:RadNumericTextBox ID="txtPriority" runat="server" Width="100%" Text='<%# Bind("Priority") %>'
                                                                                                EmptyMessage="Thứ tự..." Type="Number">
                                                                                                <NumberFormat AllowRounding="false" DecimalDigits="0" GroupSeparator="." />
                                                                                            </asp:RadNumericTextBox>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="left" colspan="2">
                                                                                            <asp:CheckBox ID="chkAddIsAvailable" runat="server" Checked='<%# (Container is RadListViewInsertItem) ? true : Eval("IsAvailable")%>'
                                                                                                Text="Hiển thị" CssClass="checkbox" />
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                            <td valign="top">
                                                                                <img alt="" src='<%# "~/res/product/album/thumbs/" + Eval("ImageName") %>' runat="server"
                                                                                    width="100" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                    <div class="edit">
                                                                        <hr />
                                                                        <asp:RadButton ID="lnkUpdate" runat="server" CommandName='Update' Text='Cập nhật'>
                                                                            <Icon PrimaryIconUrl="~/ad/assets/images/ok.png" />
                                                                        </asp:RadButton>
                                                                        &nbsp;&nbsp;
                                                                        <asp:RadButton ID="btnCancel" runat="server" CommandName='Cancel' Text='Hủy'>
                                                                            <Icon PrimaryIconUrl="~/ad/assets/images/cancel.png" />
                                                                        </asp:RadButton>
                                                                    </div>
                                                                    <div class="clear">
                                                                    </div>
                                                                </asp:Panel>
                                                            </EditItemTemplate>
                                                        </asp:RadListView>
                                                        <asp:ObjectDataSource ID="OdsProductPhotoAlbum" runat="server" DeleteMethod="ProductImageDelete"
                                                            SelectMethod="ProductImageSelectAll" TypeName="TLLib.ProductImage" UpdateMethod="ProductImageUpdate">
                                                            <DeleteParameters>
                                                                <asp:Parameter Name="ProductImageID" Type="String" />
                                                            </DeleteParameters>
                                                            <SelectParameters>
                                                                <asp:ControlParameter Name="ProductID" ControlID="hdnProductID" PropertyName="Value"
                                                                    Type="String" />
                                                                <asp:Parameter Name="IsAvailable" Type="String" />
                                                                <asp:Parameter Name="Priority" Type="String" />
                                                                <asp:Parameter DefaultValue="True" Name="SortByPriority" Type="String" />
                                                            </SelectParameters>
                                                            <UpdateParameters>
                                                                <asp:Parameter Name="ProductImageID" Type="String" />
                                                                <asp:Parameter Name="ImageName" Type="String" />
                                                                <asp:Parameter Name="ConvertedProductName" Type="String" />
                                                                <asp:Parameter Name="Title" Type="String" />
                                                                <asp:Parameter Name="Descripttion" Type="String" />
                                                                <asp:Parameter Name="TitleEn" Type="String" />
                                                                <asp:Parameter Name="DescripttionEn" Type="String" />
                                                                <asp:ControlParameter Name="ProductID" ControlID="hdnProductID" PropertyName="Value"
                                                                    Type="String" />
                                                                <asp:Parameter Name="IsAvailable" Type="String" />
                                                                <asp:Parameter Name="Priority" Type="String" />
                                                            </UpdateParameters>
                                                        </asp:ObjectDataSource>
                                                        <asp:RadListView runat="server" ID="RadListView2" PageSize="100" Width="100%" Visible='<%# (Container is GridEditFormInsertItem) ? true : false %>'
                                                            OnItemCommand="RadListView2_ItemCommand">
                                                            <LayoutTemplate>
                                                                <div runat="server" id="itemPlaceholder" />
                                                                <div class="clear">
                                                                </div>
                                                            </LayoutTemplate>
                                                            <ItemTemplate>
                                                                <asp:HiddenField ID="hdnImageName" runat="server" Value='<%# Eval("ImageName") %>' />
                                                                <fieldset style="float: left; margin: 5px; padding: 2px 2px 2px 2px; position: relative;
                                                                    background: #eeeeee;" class="myClass">
                                                                    <a href='<%# "~/res/product/album/" + Eval("ImageName") %>' runat="server" class="lightbox">
                                                                        <img id="Img1" alt="" src='<%# "~/res/product/album/thumbs/" + Eval("ImageName") %>'
                                                                            runat="server" width="100" height="100" />
                                                                    </a>
                                                                    <div align="right">
                                                                        <asp:LinkButton ID="btnEditSelected" runat="server" CommandName="Edit" CssClass="item"><img width="14px" class="vam" alt="" title="Sửa" src="../assets/images/tools.png" /></asp:LinkButton>
                                                                        <asp:LinkButton ID="LinkButton1" OnClientClick="return confirm('Xóa ảnh?')" runat="server"
                                                                            CommandName="Delete" CssClass="item"><img width="14px" class="vam" alt="" title="Xóa ảnh" src="../assets/images/trash.png" /></asp:LinkButton>
                                                                    </div>
                                                                </fieldset>
                                                            </ItemTemplate>
                                                        </asp:RadListView>
                                                    </asp:RadAjaxPanel>
                                                </asp:RadAjaxPanel>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </FormTemplate>
                </EditFormSettings>
                <%--<EditFormSettings ColumnNumber="2" CaptionDataField="ProductName" CaptionFormatString="Thông Tin Sản Phẩm: {0}"
                    InsertCaption="Sản Phẩm Mới">
                    <FormCaptionStyle Font-Bold="true" Font-Size="12pt" ForeColor="#555555" Height="30" />
                    <FormTableItemStyle Wrap="False" Width="100%"></FormTableItemStyle>
                    <FormMainTableStyle GridLines="Horizontal" CellSpacing="0" CellPadding="3" BackColor="White"
                        Width="100%" />
                    <FormTableStyle GridLines="None" CellSpacing="0" CellPadding="2" CssClass="module"
                        Height="50px" BackColor="White" Width="100%" />
                    <FormTableAlternatingItemStyle Wrap="False"></FormTableAlternatingItemStyle>
                    <FormStyle Width="100%"></FormStyle>
                    <EditColumn ButtonType="ImageButton" />
                    <FormTableButtonRowStyle CssClass="EditFormButtonRow" />
                </EditFormSettings>--%>
            </MasterTableView>
            <HeaderStyle Font-Bold="True" />
            <HeaderContextMenu EnableImageSprites="True" CssClass="GridContextMenu GridContextMenu_Default">
            </HeaderContextMenu>
        </asp:RadGrid>
    </asp:RadAjaxPanel>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="ProductSelectAll"
        TypeName="TLLib.Product" DeleteMethod="ProductDelete" InsertMethod="ProductInsert"
        UpdateMethod="ProductUpdate">
        <DeleteParameters>
            <asp:Parameter Name="ProductID" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="ImageName" Type="String" />
            <asp:Parameter Name="MetaTittle" Type="String" />
            <asp:Parameter Name="MetaDescription" Type="String" />
            <asp:Parameter Name="ProductName" Type="String" />
            <asp:Parameter Name="ConvertedProductName" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Content" Type="String" />
            <asp:Parameter Name="Tag" Type="String" />
            <asp:Parameter Name="MetaTittleEn" Type="String" />
            <asp:Parameter Name="MetaDescriptionEn" Type="String" />
            <asp:Parameter Name="ProductNameEn" Type="String" />
            <asp:Parameter Name="DescriptionEn" Type="String" />
            <asp:Parameter Name="ContentEn" Type="String" />
            <asp:Parameter Name="TagEn" Type="String" />
            <asp:Parameter Name="Price" Type="String" />
            <asp:Parameter Name="OtherPrice" Type="String" />
            <asp:Parameter Name="SavePrice" Type="String" />
            <asp:Parameter Name="Discount" Type="String" />
            <asp:Parameter Name="CategoryID" Type="String" />
            <asp:Parameter Name="ManufacturerID" Type="String" />
            <asp:Parameter Name="OriginID" Type="String" />
            <asp:Parameter Name="InStock" Type="String" />
            <asp:Parameter Name="IsHot" Type="String" />
            <asp:Parameter Name="IsNew" Type="String" />
            <asp:Parameter Name="IsBestSeller" Type="String" />
            <asp:Parameter Name="IsSaleOff" Type="String" />
            <asp:Parameter Name="IsShowOnHomePage" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:Parameter Name="StartRowIndex" Type="String" />
            <asp:Parameter Name="EndRowIndex" Type="String" />
            <asp:Parameter Name="Keyword" Type="String" />
            <asp:ControlParameter ControlID="txtSearchProductName" Name="ProductName" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchDescription" Name="Description" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchPriceFrom" Name="PriceFrom" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchPriceTo" Name="PriceTo" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchCategory" Name="CategoryID" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchManufacturer" Name="ManufacturerID" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchOrigin" Name="OriginID" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchTag" Name="Tag" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="ddlSearchIsInStock" Name="InStock" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchIsHot" Name="IsHot" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchIsNew" Name="IsNew" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchIsBestSeller" Name="IsBestSeller" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchIsSaleOff" Name="IsSaleOff" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchIsShowOnHomePage" Name="IsShowOnHomePage"
                PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter ControlID="dpFromDate" Name="FromDate" PropertyName="SelectedDate"
                Type="String" />
            <asp:ControlParameter ControlID="dpToDate" Name="ToDate" PropertyName="SelectedDate"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchPriority" Name="Priority" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchIsAvailable" Name="IsAvailable" PropertyName="SelectedValue"
                Type="String" />
            <asp:Parameter Name="SortByPriority" Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="ProductID" Type="String" />
            <asp:Parameter Name="ImageName" Type="String" />
            <asp:Parameter Name="MetaTittle" Type="String" />
            <asp:Parameter Name="MetaDescription" Type="String" />
            <asp:Parameter Name="ProductName" Type="String" />
            <asp:Parameter Name="ConvertedProductName" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Content" Type="String" />
            <asp:Parameter Name="Tag" Type="String" />
            <asp:Parameter Name="MetaTittleEn" Type="String" />
            <asp:Parameter Name="MetaDescriptionEn" Type="String" />
            <asp:Parameter Name="ProductNameEn" Type="String" />
            <asp:Parameter Name="DescriptionEn" Type="String" />
            <asp:Parameter Name="ContentEn" Type="String" />
            <asp:Parameter Name="TagEn" Type="String" />
            <asp:Parameter Name="Price" Type="String" />
            <asp:Parameter Name="OtherPrice" Type="String" />
            <asp:Parameter Name="SavePrice" Type="String" />
            <asp:Parameter Name="Discount" Type="String" />
            <asp:Parameter Name="CategoryID" Type="String" />
            <asp:Parameter Name="ManufacturerID" Type="String" />
            <asp:Parameter Name="OriginID" Type="String" />
            <asp:Parameter Name="InStock" Type="String" />
            <asp:Parameter Name="IsHot" Type="String" />
            <asp:Parameter Name="IsNew" Type="String" />
            <asp:Parameter Name="IsBestSeller" Type="String" />
            <asp:Parameter Name="IsSaleOff" Type="String" />
            <asp:Parameter Name="IsShowOnHomePage" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="ProductCategorySelectAll"
        TypeName="TLLib.ProductCategory"></asp:ObjectDataSource>
    <asp:ObjectDataSource ID="ObjectDataSource3" runat="server" SelectMethod="ManufacturerSelectAll"
        TypeName="TLLib.Manufacturer">
        <SelectParameters>
            <asp:Parameter Name="ManufacturerName" Type="String" DefaultValue="" />
            <asp:Parameter Name="IsAvailable" Type="String" DefaultValue="" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter Name="SortByPriority" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="ObjectDataSource4" runat="server" SelectMethod="OriginSelectAll"
        TypeName="TLLib.Origin">
        <SelectParameters>
            <asp:Parameter Name="OriginName" Type="String" DefaultValue="" />
            <asp:Parameter Name="IsAvailable" Type="String" DefaultValue="" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter Name="SortByPriority" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:RadProgressManager ID="RadProgressManager1" runat="server" />
    <asp:RadProgressArea ID="ProgressArea1" runat="server" Culture="vi-VN" DisplayCancelButton="True"
        HeaderText="Đang tải" Skin="Office2007" Style="position: fixed; top: 50% !important;
        left: 50% !important; margin: -93px 0 0 -188px;" />
</asp:Content>
