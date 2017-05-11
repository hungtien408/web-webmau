<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/adminEn.master" AutoEventWireup="true"
    CodeFile="district.aspx.cs" Inherits="ad_single_district" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="asp" %>
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <h3 class="mainTitle">
        Quản Lý Quận/Huyện
    </h3>
    <div style="position: absolute; right: 10px; top: 15px">
        <a onclick="history.go(-1)" style="cursor: pointer">&laquo; Quay lại Tỉnh/Thành
        </a>
    </div>
    <fieldset>
        <h3 class="searchTitle">
            Thông Tin Tỉnh/Thành
        </h3>
        <asp:FormView ID="FormView1" runat="server" DataSourceID="ObjectDataSource2" EnableModelValidation="True"
            Width="100%">
            <ItemTemplate>
                <div class="mInfo" style="min-width: 800px">
                    <table class="search" style="border: 0">
                        <tr>
                            <td class="left">
                                Tên Tỉnh/Thành:
                            </td>
                            <td>
                                <asp:Label ID="lblProvinceName" runat="server" Text='<%# Eval("ProvinceName")%>'></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="ProvinceSelectOne"
            TypeName="TLLib.Province">
            <SelectParameters>
                <asp:QueryStringParameter Name="ProvinceID" QueryStringField="PI" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </fieldset>
    <asp:RadAjaxPanel ID="RadAjaxPanel1" runat="server" ClientEvents-OnRequestStart="conditionalPostback">
        <asp:Panel ID="pnlSearch" DefaultButton="btnSearch" runat="server">
            <h4 class="searchTitle">
                Tìm kiếm
            </h4>
            <table class="search">
                <tr>
                    <td class="left">
                        Tên quận huyện
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchDistrictName" runat="server" Width="500px" EmptyMessage="Tên Quận/Huyện ...">
                        </asp:RadTextBox>
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
            DataSourceID="ObjectDataSource1" GridLines="Horizontal" AutoGenerateColumns="False"
            ShowStatusBar="True" OnItemCommand="RadGrid1_ItemCommand" CssClass="grid"
            AllowAutomaticUpdates="True" OnItemCreated="RadGrid1_ItemCreated" AllowAutomaticInserts="True"
            AllowPaging="True" AllowSorting="True">
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
                DataKeyNames="DistrictID">
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
                        <div style="float: right">
                            <asp:Button ID="ExportToExcelButton" runat="server" CssClass="rgExpXLS" CommandName="ExportToExcel"
                                AlternateText="Excel" ToolTip="Xuất ra Excel" />
                            <asp:Button ID="ExportToPdfButton" runat="server" CssClass="rgExpPDF" CommandName="ExportToPdf"
                                AlternateText="PDF" ToolTip="Xuất ra PDF" />
                            <asp:Button ID="ExportToWordButton" runat="server" CssClass="rgExpDOC" CommandName="ExportToWord"
                                AlternateText="Word" ToolTip="Xuất ra Word" />
                        </div>
                        <asp:LinkButton ID="LinkButton2" runat="server" CommandName="InitInsert" Visible='<%# !RadGrid1.MasterTableView.IsItemInserted %>'
                            CssClass="item">
              <img class="vam" alt="" src="../assets/images/add.png" /> Thêm mới
                        </asp:LinkButton>|
                        <%--<asp:LinkButton ID="LinkButton3" runat="server" CommandName="PerformInsert" Visible='<%# RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/accept.png" /> Thêm</asp:LinkButton>&nbsp;&nbsp;
            <asp:LinkButton ID="btnCancel" runat="server" CommandName="CancelAll" Visible='<%# RadGrid1.EditIndexes.Count > 0 || RadGrid1.MasterTableView.IsItemInserted %>'><img class="vam" alt="" src="../assets/images/delete-icon.png" /> Hủy</asp:LinkButton>&nbsp;&nbsp;--%>
                        <asp:LinkButton ID="btnEditSelected" runat="server" CommandName="EditSelected" Visible='<%# RadGrid1.EditIndexes.Count == 0 %>'
                            CssClass="item">
              <img width="12px" class="vam" alt="" src="../assets/images/tools.png" /> Sửa
                        </asp:LinkButton>|
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
                <Columns>
                    <asp:GridClientSelectColumn FooterText="CheckBoxSelect footer" HeaderStyle-Width="1%"
                        UniqueName="CheckboxSelectColumn" />
                    <asp:GridTemplateColumn HeaderStyle-Width="1%" HeaderText="STT">
                        <ItemTemplate>
                            <%# Container.DataSetIndex + 1 %>
                            <asp:HiddenField ID="hdnDistrictID" runat="server" Value='<%# Eval("DistrictID") %>' />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridBoundColumn HeaderText="Tên quận huyện" DataField="DistrictName" SortExpression="DistrictName">
                    </asp:GridBoundColumn>
                    <asp:GridTemplateColumn DataField="ShippingPrice" HeaderText="Phí vận chuyển"
                        SortExpression="ShippingPrice">
                        <ItemTemplate>
                            <%# !string.IsNullOrEmpty(Eval("ShippingPrice").ToString()) ? string.Format("{0:##,###.##}", Eval("ShippingPrice")) : "0"%>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Thứ tự" DataField="Priority" SortExpression="Priority">
                        <ItemTemplate>
                            <asp:RadNumericTextBox ID="txtPriority" runat="server" Width="40px" Text='<%# Bind("Priority") %>'
                                EmptyMessage="Thứ tự..." Type="Number">
                                <NumberFormat AllowRounding="false" DecimalDigits="0" GroupSeparator="." />
                            </asp:RadNumericTextBox>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Hiển thị" DataField="IsAvailable" SortExpression="IsAvailable">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsAvailable" runat="server" Checked='<%# Eval("IsAvailable") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsAvailable"))%>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <%--<asp:GridTemplateColumn HeaderText="Phường/Xã">
                        <ItemTemplate>
                            <a href="ward.aspx?PI=<%# Eval("DistrictID") %>">Phường/Xã (<%# Eval("NumOfWard")%>)
                                &raquo; </a>
                            <asp:RadInputManager ID="RadInputManager1" runat="server">
                                <asp:NumericTextBoxSetting AllowRounding="False" Culture="vi-VN" EmptyMessage="Thứ tự ..."
                                    Type="Number" DecimalDigits="0">
                                    <TargetControls>
                                        <asp:TargetInput ControlID="txtPriority" />
                                    </TargetControls>
                                </asp:NumericTextBoxSetting>
                            </asp:RadInputManager>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>--%>
                </Columns>
                <EditFormSettings EditFormType="Template">
                    <FormTemplate>
                        <asp:Panel ID="Panel1" runat="server" DefaultButton="lnkUpdate">
                            <h3 class="searchTitle">
                                Thông Tin Quận/Huyện
                            </h3>
                            <table class="search">
                                <tr>
                                    <td class="left" valign="top">
                                        Tên quận huyện
                                    </td>
                                    <td>
                                        <asp:RadTextBox ID="txtDistrictName" runat="server" Text='<%# Bind("DistrictName") %>'
                                            Width="500px" EmptyMessage="Tên Quận/Huyện ...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left">
                                        Phí vận chuyển
                                    </td>
                                    <td>
                                        <asp:RadNumericTextBox ID="txtShippingPrice" runat="server" Width="500px" Text='<%# Bind("ShippingPrice") %>'
                                            EmptyMessage="Phí..." Type="Number">
                                            <NumberFormat AllowRounding="false" DecimalDigits="0" GroupSeparator="." />
                                        </asp:RadNumericTextBox>
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
                                    <td class="left" colspan="2">
                                        <asp:CheckBox ID="chkIsAvailable" runat="server" CssClass="checkbox" Text=" Hiển thị"
                                            Checked='<%# (Container is GridEditFormInsertItem) ? true : (Eval("IsAvailable") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsAvailable"))) %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="padding-left: 10px">
                                        <hr />
                                        <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>'>
                      <img alt="" title="Cập nhật" src="../assets/images/ok.png" class="vam" /> <%# (Container is GridEditFormInsertItem) ? "Thêm" : "Cập nhật" %>
                                        </asp:LinkButton>
                                        &nbsp; &nbsp;
                                        <asp:LinkButton ID="LinkButton5" runat="server" CausesValidation="False" CommandName="Cancel">
                      <img alt="" title="Hủy" src="../assets/images/cancel.png" class="vam" /> &nbsp;&nbsp;Hủy
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:RadInputManager ID="RadInputManager1" runat="server">
                            <asp:TextBoxSetting EmptyMessage="Tên quận huyện ...">
                                <TargetControls>
                                    <asp:TargetInput ControlID="txtDistrictName" />
                                </TargetControls>
                            </asp:TextBoxSetting>
                            <asp:NumericTextBoxSetting AllowRounding="False" Culture="vi-VN" EmptyMessage="Thứ tự ..."
                                Type="Number" DecimalDigits="0">
                                <TargetControls>
                                    <asp:TargetInput ControlID="txtPriority" />
                                </TargetControls>
                            </asp:NumericTextBoxSetting>
                        </asp:RadInputManager>
                    </FormTemplate>
                </EditFormSettings>
            </MasterTableView>
            <HeaderStyle Font-Bold="True" />
            <HeaderContextMenu EnableImageSprites="True" CssClass="GridContextMenu GridContextMenu_Default">
            </HeaderContextMenu>
        </asp:RadGrid>
    </asp:RadAjaxPanel>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" DeleteMethod="DistrictDelete"
        InsertMethod="DistrictInsert" SelectMethod="DistrictSelectAll" TypeName="TLLib.District"
        UpdateMethod="DistrictUpdate">
        <DeleteParameters>
            <asp:Parameter Name="DistrictID" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="DistrictName" Type="String" />
            <asp:QueryStringParameter Name="ProvinceID" QueryStringField="PI" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter Name="ShippingPrice" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearchDistrictName" Name="DistrictName" PropertyName="Text"
                Type="String" />
            <asp:QueryStringParameter Name="ProvinceIDs" QueryStringField="PI" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter Name="SortByPriority" Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="DistrictID" Type="String" />
            <asp:Parameter Name="DistrictName" Type="String" />
            <asp:QueryStringParameter Name="ProvinceID" QueryStringField="PI" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter Name="ShippingPrice" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>
</asp:Content>
