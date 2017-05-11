<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/inside.master" AutoEventWireup="true"
    CodeFile="productofsame.aspx.cs" Inherits="ad_single_productofsame" %>

<%@ Register TagPrefix="asp" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register Assembly="Spaanjaars.Toolkit" Namespace="Spaanjaars.Toolkit" TagPrefix="isp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="Server">
    <script type="text/javascript">
        var tableView = null;
        function RowDblClick(sender, eventArgs) {
            sender.get_masterTableView().editItem(eventArgs.get_itemIndexHierarchical());
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
            if (eventArgs.get_eventTarget().indexOf("ExportToExcelButton") >= 0 || eventArgs.get_eventTarget().indexOf("ExportToWordButton") >= 0 || eventArgs.get_eventTarget().indexOf("ExportToPdfButton") >= 0)
                eventArgs.set_enableAjax(false);
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
    <%--<asp:RadSkinManager ID="QsfSkinManager" runat="server" ShowChooser="false" />--%>
    <%--<asp:RadFormDecorator ID="QsfFromDecorator" runat="server" DecoratedControls="All"
        EnableRoundedCorners="false" />--%>
    <%--<h3 class="mainTitle">
        Sản Phẩm Liên Quan
    </h3>
    <div style="position: absolute; right: 10px; top: 15px">
        <a onclick="history.go(-1)" style="cursor: pointer">&laquo; Quay lại</a>
    </div>
    <br />--%>
    <fieldset>
        <h3 class="searchTitle">
            Thông Tin Sản Phẩm</h3>
        <asp:FormView ID="FormView1" runat="server" DataSourceID="ObjectDataSource3" EnableModelValidation="True"
            Width="100%">
            <ItemTemplate>
                <div class="mInfo" style="min-width: 800px">
                    <table class="search" style="border: 0">
                        <tr>
                            <td class="left">
                                Tên Sản Phẩm:
                            </td>
                            <td>
                                <asp:Label ID="lblProductName" runat="server" Text='<%# Eval("ProductName")%>'></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:ObjectDataSource ID="ObjectDataSource3" runat="server" SelectMethod="ProductSelectOne"
            TypeName="TLLib.Product">
            <SelectParameters>
                <asp:QueryStringParameter Name="ProductID" QueryStringField="pi" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </fieldset>
    <asp:RadAjaxManager ID="RadAjaxManager1" runat="server" UpdateInitiatorPanelsOnly="true">
        <AjaxSettings>
            <asp:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <asp:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1">
                    </asp:AjaxUpdatedControl>
                </UpdatedControls>
            </asp:AjaxSetting>
        </AjaxSettings>
    </asp:RadAjaxManager>
    <asp:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server">
    </asp:RadAjaxLoadingPanel>
    <asp:Label ID="lblError" ForeColor="Red" runat="server"></asp:Label>
    <asp:RadGrid ID="RadGrid1" DataSourceID="ObjectDataSource1" runat="server" PageSize="20"
        AllowSorting="True" AllowMultiRowSelection="True" AllowPaging="True" ShowGroupPanel="True"
        AutoGenerateColumns="False" GridLines="Horizontal" ShowStatusBar="True" OnItemCommand="RadGrid1_ItemCommand"
        OnItemDataBound="RadGrid1_ItemDataBound" CssClass="grid" AllowAutomaticUpdates="True"
        CellSpacing="0">
        <PagerStyle Mode="NextPrevNumericAndAdvanced"></PagerStyle>
        <MasterTableView Width="100%" CommandItemDisplay="TopAndBottom" DataSourceID="ObjectDataSource1"
            InsertItemPageIndexAction="ShowItemOnCurrentPage" AllowMultiColumnSorting="True"
            DataKeyNames="ProductOfSameID">
            <PagerTemplate>
                <asp:Panel ID="PagerPanel" Style="padding: 6px; line-height: 24px" runat="server">
                    <div style="float: left">
                        <span style="margin-right: 3px;" class="vam">Kích thước trang: </span>
                        <asp:RadComboBox ID="RadComboBox1" DataSource="<%# new object[]{ 10 , 20, 50, 100, 200} %>"
                            Style="margin-right: 20px;" Width="40px" SelectedValue='<%# DataBinder.Eval(Container, "Paging.PageSize") %>'
                            runat="server" OnClientSelectedIndexChanged="RadComboBox1_SelectedIndexChanged">
                        </asp:RadComboBox>
                    </div>
                    <div style="margin: 0px; float: right;">
                        <%--Hiển thị trang
              <%# (int)DataBinder.Eval(Container, "Paging.CurrentPageIndex") + 1 %>
              trong
              <%# DataBinder.Eval(Container, "Paging.PageCount")%>
              ,--%>
                        <%# (int)DataBinder.Eval(Container, "Paging.FirstIndexInPage") + 1 %>
                        -
                        <%# (int)DataBinder.Eval(Container, "Paging.LastIndexInPage") + 1 %>
                        trong
                        <%# DataBinder.Eval(Container, "Paging.DataSourceCount")%>
                        kết quả
                    </div>
                    <div style="width: 260px; margin: 0px; padding: 0px; float: left; margin-right: 10px;
                        white-space: nowrap;">
                        <asp:Button ID="Button1" runat="server" OnClientClick="changePage('first'); return false;"
                            CommandName="Page" CommandArgument="First" Text=" " CssClass="PagerButton FirstPage" />
                        <asp:Button ID="Button2" runat="server" OnClientClick="changePage('prev'); return false;"
                            CommandName="Page" CommandArgument="Prev" Text=" " CssClass="PagerButton PrevPage" />
                        <span style="vertical-align: middle;">Trang:</span>
                        <asp:RadNumericTextBox ID="RadNumericTextBox1" Width="25px" Value='<%# (int)DataBinder.Eval(Container, "Paging.CurrentPageIndex") + 1 %>'
                            runat="server">
                            <ClientEvents OnValueChanged="RadNumericTextBox1_ValueChanged" />
                            <NumberFormat DecimalDigits="0" />
                        </asp:RadNumericTextBox>
                        <span style="vertical-align: middle;">trong
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
                    <%--<div style="float: right">
                        <asp:Button ID="ExportToExcelButton" runat="server" CssClass="rgExpXLS" CommandName="ExportToExcel"
                            AlternateText="Excel" ToolTip="Xuất ra Excel" />
                        <asp:Button ID="ExportToPdfButton" runat="server" CssClass="rgExpPDF" CommandName="ExportToPdf"
                            AlternateText="PDF" ToolTip="Xuất ra PDF" />
                        <asp:Button ID="ExportToWordButton" runat="server" CssClass="rgExpDOC" CommandName="ExportToWord"
                            AlternateText="Word" ToolTip="Xuất ra Word" />
                    </div>--%>
                    <asp:LinkButton ID="LinkButton2" runat="server" CommandName="InitInsert" Visible='<%# !RadGrid1.MasterTableView.IsItemInserted %>'
                        CssClass="item">
              <img class="vam" alt="" src="../assets/images/add.png" /> Thêm mới
                    </asp:LinkButton>|
                    <%--<asp:LinkButton ID="LinkButton3" runat="server" CommandName="PerformInsert" Visible='<%# RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/accept.png" /> Thêm</asp:LinkButton>&nbsp;&nbsp;
            <asp:LinkButton ID="btnCancel" runat="server" CommandName="CancelAll" Visible='<%# RadGrid1.EditIndexes.Count > 0 || RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/delete-icon.png" /> Hủy</asp:LinkButton>&nbsp;&nbsp;--%>
                    <%--<asp:LinkButton ID="btnEditSelected" runat="server" CommandName="EditSelected" Visible='<%# RadGrid1.EditIndexes.Count == 0 %>'
                        CssClass="item">
              <img width="12px" class="vam" alt="" src="../assets/images/tools.png" /> Sửa
                    </asp:LinkButton>|--%>
                    <%--<asp:LinkButton ID="btnUpdateEdited" runat="server" CommandName="UpdateEdited" Visible='<%# RadGrid1.EditIndexes.Count > 0 %>'><img class="vam" alt="" src="../assets/images/accept.png" /> Cập nhật</asp:LinkButton>&nbsp;&nbsp;--%>
                    <asp:LinkButton ID="LinkButton1" OnClientClick="javascript:return confirm('Xóa tất cả dòng đã chọn?')"
                        runat="server" CommandName="DeleteSelected" CssClass="item">
              <img class="vam" alt="" title="Xóa tất cả dòng được chọn" src="../assets/images/delete-icon.png" /> Xóa
                    </asp:LinkButton>|
                    <asp:LinkButton ID="LinkButton6" runat="server" CommandName="QuickUpdate" Visible='<%# RadGrid1.EditIndexes.Count == 0 %>'
                        CssClass="item">
              <img class="vam" alt="" src="../assets/images/accept.png" /> Sửa nhanh
                    </asp:LinkButton>|
                    <asp:LinkButton ID="LinkButton4" runat="server" CommandName="RebindGrid" CssClass="item">
              <img class="vam" alt="" src="../assets/images/reload.png" /> Làm mới
                    </asp:LinkButton>
                </div>
                <div class="clear">
                </div>
                <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
            </CommandItemTemplate>
            <GroupByExpressions>
                <asp:GridGroupByExpression>
                    <SelectFields>
                        <asp:GridGroupByField HeaderText="Danh Mục " FieldName="ParentCategoryName"></asp:GridGroupByField>
                    </SelectFields>
                    <GroupByFields>
                        <asp:GridGroupByField FieldName="ParentCategoryName" SortOrder="Descending"></asp:GridGroupByField>
                    </GroupByFields>
                </asp:GridGroupByExpression>
                <asp:GridGroupByExpression>
                    <SelectFields>
                        <asp:GridGroupByField HeaderText="Nhóm " FieldName="ProductCategoryName"></asp:GridGroupByField>
                    </SelectFields>
                    <GroupByFields>
                        <asp:GridGroupByField FieldName="ProductCategoryName" SortOrder="Descending"></asp:GridGroupByField>
                    </GroupByFields>
                </asp:GridGroupByExpression>
                <asp:GridGroupByExpression>
                    <SelectFields>
                        <asp:GridGroupByField HeaderText="Sản Phẩm " FieldName="ParentName"></asp:GridGroupByField>
                    </SelectFields>
                    <GroupByFields>
                        <asp:GridGroupByField FieldName="ParentName" SortOrder="Descending"></asp:GridGroupByField>
                    </GroupByFields>
                </asp:GridGroupByExpression>
            </GroupByExpressions>
            <CommandItemSettings ExportToPdfText="Export to PDF"></CommandItemSettings>
            <RowIndicatorColumn Visible="True" FilterControlAltText="Filter RowIndicator column">
            </RowIndicatorColumn>
            <ExpandCollapseColumn Visible="True" FilterControlAltText="Filter ExpandColumn column">
            </ExpandCollapseColumn>
            <Columns>
                <asp:GridClientSelectColumn FooterText="CheckBoxSelect footer" HeaderStyle-Width="2%"
                    UniqueName="CheckboxSelectColumn">
                    <HeaderStyle Width="2%"></HeaderStyle>
                </asp:GridClientSelectColumn>
                <asp:GridBoundColumn HeaderText="ID" DataField="ProductID" HeaderStyle-Width="2%"
                    SortExpression="ProductID">
                </asp:GridBoundColumn>
                <asp:GridTemplateColumn DataField="ImageName" HeaderText="Ảnh">
                    <ItemTemplate>
                        <img id="Img1" style="border: 1px solid #cfcfcf;" alt="" src='<%# "~/res/product/thumbs/" + Eval("ImageName") %>'
                            width="70" runat="server" visible='<%# string.IsNullOrEmpty(Eval("ImageName").ToString()) ? false : true %>' />
                    </ItemTemplate>
                </asp:GridTemplateColumn>
                <asp:GridBoundColumn HeaderText="Mã Sản Phẩm" DataField="Tag" SortExpression="Tag">
                </asp:GridBoundColumn>
                <asp:GridBoundColumn SortExpression="ProductName" HeaderText="Sản Phẩm" HeaderButtonType="TextButton"
                    DataField="ProductName">
                </asp:GridBoundColumn>
                <asp:GridTemplateColumn DataField="Priority" HeaderStyle-Width="10%" HeaderText="Thứ tự"
                    SortExpression="Priority">
                    <ItemTemplate>
                        <asp:RadNumericTextBox ID="txtPriority" runat="server" Width="70px" Text='<%# Bind("Priority") %>'
                            ShowSpinButtons="true" MinValue="0" EmptyMessage="Thứ tự..." Type="Number">
                            <NumberFormat AllowRounding="false" DecimalDigits="0" GroupSeparator="." />
                        </asp:RadNumericTextBox>
                    </ItemTemplate>
                </asp:GridTemplateColumn>
                <asp:GridTemplateColumn HeaderText="Ngày tạo" SortExpression="CreateDate" HeaderStyle-Width="15%">
                    <ItemTemplate>
                        <%# string.Format("{0:dd/MM/yyyy hh:mm tt}", Eval("CreateDate"))%>
                    </ItemTemplate>
                    <HeaderStyle Width="15%"></HeaderStyle>
                </asp:GridTemplateColumn>
                <asp:GridTemplateColumn DataField="IsAvailable" HeaderText="Hiển thị" HeaderStyle-Width="5%"
                    SortExpression="IsAvailable">
                    <ItemTemplate>
                        <div align="center">
                            <asp:CheckBox ID="chkIsAvailable" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("IsAvailable").ToString()) ? false : Eval("IsAvailable") %>' />
                        </div>
                    </ItemTemplate>
                    <HeaderStyle Width="5%"></HeaderStyle>
                </asp:GridTemplateColumn>
                <%--<asp:GridBoundColumn SortExpression="CreateDate" HeaderText="Ngày tạo" HeaderButtonType="TextButton"
                    DataField="CreateDate" DataFormatString="{0:d}">
                </asp:GridBoundColumn>--%>
            </Columns>
            <EditFormSettings EditFormType="Template">
                <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                </EditColumn>
                <FormTemplate>
                    <asp:Panel ID="Panel1" runat="server">
                        <div class="sub_box">
                            <div class="head">
                                Thông Tin Sản Phẩm
                            </div>
                            <asp:RadGrid ID="RadGrid2" AutoGenerateColumns="False" DataSourceID="ObjectDataSource2"
                                ShowStatusBar="true" runat="server" AllowFilteringByColumn="true" AllowPaging="True"
                                AllowSorting="True" AllowMultiRowSelection="True" OnItemCommand="RadGrid2_ItemCommand">
                                <MasterTableView PageSize="20" DataKeyNames="ProductID" AllowFilteringByColumn="True">
                                    <Columns>
                                        <asp:GridClientSelectColumn FooterText="CheckBoxSelect footer" HeaderStyle-Width="2%"
                                            UniqueName="ClientSelectColumn" />
                                        <asp:GridBoundColumn FilterControlWidth="50px" HeaderText="ID" AllowFiltering="False"
                                            DataField="ProductID" SortExpression="ProductID">
                                        </asp:GridBoundColumn>
                                        <asp:GridTemplateColumn DataField="ImageName" ShowFilterIcon="False" AllowFiltering="False"
                                            HeaderText="Ảnh" SortExpression="ImageName">
                                            <ItemTemplate>
                                                <img id="Img1" style="border: 1px solid #cfcfcf;" alt="" src='<%# "~/res/product/thumbs/" + Eval("ImageName") %>'
                                                    width="70" runat="server" visible='<%# string.IsNullOrEmpty(Eval("ImageName").ToString()) ? false : true %>' />
                                            </ItemTemplate>
                                        </asp:GridTemplateColumn>
                                        <asp:GridBoundColumn FilterControlWidth="100px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"
                                            ShowFilterIcon="false" DataField="Tag" HeaderText="Mã Sản Phẩm" SortExpression="Tag" />
                                        <asp:GridBoundColumn FilterControlWidth="200px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"
                                            ShowFilterIcon="false" DataField="ProductName" HeaderText="Sản Phẩm" SortExpression="ProductName" />
                                        <asp:GridBoundColumn DataField="ParentCategoryName" HeaderText="Danh mục" SortExpression="ParentCategoryName">
                                            <FilterTemplate>
                                                <asp:RadComboBox ID="RadComboBoxTitle" DataSourceID="ObjectDataSource4" DataTextField="ProductCategoryName"
                                                    DataValueField="ProductCategoryName" Height="200px" AppendDataBoundItems="true"
                                                    SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("ParentCategoryName").CurrentFilterValue %>'
                                                    runat="server" OnClientSelectedIndexChanged="TitleIndexChanged">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="Tất Cả" />
                                                    </Items>
                                                </asp:RadComboBox>
                                                <asp:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                                    <script type="text/javascript">
                                                        function TitleIndexChanged(sender, args) {
                                                            var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                            tableView.filter("ParentCategoryName", args.get_item().get_value(), "EqualTo");
                                                        }
                                                    </script>
                                                </asp:RadScriptBlock>
                                            </FilterTemplate>
                                        </asp:GridBoundColumn>
                                        <%--<asp:GridBoundColumn FilterControlWidth="100px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"
                                            ShowFilterIcon="false" DataField="ParentCategoryName" HeaderText="Danh mục" SortExpression="ParentCategoryName" />--%>
                                        <asp:GridBoundColumn FilterControlWidth="100px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"
                                            ShowFilterIcon="false" DataField="ProductCategoryName" HeaderText="Nhóm" SortExpression="ProductCategoryName" />
                                    </Columns>
                                </MasterTableView>
                                <ClientSettings EnableRowHoverStyle="true">
                                    <Selecting AllowRowSelect="True" UseClientSelectColumnOnly="True" />
                                    <%--<ClientEvents OnRowDblClick="RowDblClick" />--%>
                                    <Resizing AllowColumnResize="true" ClipCellContentOnResize="False" />
                                </ClientSettings>
                                <PagerStyle Mode="NumericPages"></PagerStyle>
                                <HeaderStyle Font-Bold="True" />
                                <HeaderContextMenu EnableImageSprites="True" CssClass="GridContextMenu GridContextMenu_Default">
                                </HeaderContextMenu>
                            </asp:RadGrid>
                            <table width="100%">
                                <tr>
                                    <td colspan="2" style="padding-left: 10px">
                                        <hr />
                                        <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>'> <img alt="" title="Cập nhật" src="../assets/images/ok.png" class="vam" /> <%# (Container is GridEditFormInsertItem) ? "Thêm" : "Cập nhật" %></asp:LinkButton>
                                        &nbsp;&nbsp;
                                        <asp:LinkButton ID="LinkButton5" runat="server" CausesValidation="False" CommandName="Cancel"> <img alt="" title="Hủy" src="../assets/images/cancel.png" class="vam" />&nbsp;&nbsp;Hủy </asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                    </asp:Panel>
                </FormTemplate>
            </EditFormSettings>
        </MasterTableView>
        <ClientSettings ReorderColumnsOnClient="True" AllowDragToGroup="True" AllowColumnsReorder="True">
            <Selecting AllowRowSelect="True"></Selecting>
            <Resizing AllowRowResize="True" AllowColumnResize="True" EnableRealTimeResize="True"
                ResizeGridOnColumnResize="False"></Resizing>
        </ClientSettings>
        <GroupHeaderItemStyle Font-Bold="true" Font-Size="12px" />
        <GroupingSettings ShowUnGroupButton="true"></GroupingSettings>
        <HeaderStyle Font-Bold="True" />
        <FilterMenu EnableImageSprites="False">
        </FilterMenu>
        <HeaderContextMenu EnableImageSprites="True" CssClass="GridContextMenu GridContextMenu_Default">
        </HeaderContextMenu>
    </asp:RadGrid>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="ProductOfSameSelectAll"
        TypeName="TLLib.ProductOfSame" UpdateMethod="ProductOfSameUpdate" InsertMethod="ProductOfSameInsert"
        DeleteMethod="ProductOfSameDelete">
        <DeleteParameters>
            <asp:Parameter Name="ProductOfSameID" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="ProductID" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:QueryStringParameter Name="ProductParentID" QueryStringField="pi" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:Parameter Name="StartRowIndex" Type="String" />
            <asp:Parameter Name="EndRowIndex" Type="String" />
            <asp:Parameter Name="Keyword" Type="String" />
            <asp:Parameter Name="ProductOfSameID" Type="String" />
            <asp:Parameter Name="ProductID" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter Name="SortByPriority" Type="String" />
            <asp:QueryStringParameter Name="ProductParentID" QueryStringField="pi" Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="ProductOfSameID" Type="String" />
            <asp:Parameter Name="ProductID" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:QueryStringParameter Name="ProductParentID" QueryStringField="pi" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="ProductSelectAll"
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
            <asp:Parameter Name="IsAvailable" Type="String" DefaultValue="true" />
            <asp:Parameter Name="SortByPriority" Type="String" DefaultValue="true" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="ObjectDataSource4" runat="server" SelectMethod="ProductCategorySelectAll"
        TypeName="TLLib.ProductCategory">
        <SelectParameters>
            <asp:Parameter DefaultValue="0" Name="parentID" Type="Int32" />
            <asp:Parameter DefaultValue="1" Name="increaseLevelCount" Type="Int32" />
            <asp:Parameter DefaultValue="true" Name="IsShowOnMenu" Type="String" />
            <asp:Parameter Name="IsShowOnHomePage" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>
