<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/adminEn.master" AutoEventWireup="true"
    CodeFile="comment.aspx.cs" Inherits="ad_single_comment" %>

<%@ Register TagPrefix="asp" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
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
    </script>
    <style type="text/css">
        .RadPicker
        {
            vertical-align: middle;
        }
        
        .RadPicker .rcTable
        {
            table-layout: auto;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <h3 class="mainTitle">
        <img alt="" src="../assets/images/comment.png" class="vam" />
        Comment</h3>
    <br />
    <asp:Panel ID="pnlSearch" DefaultButton="btnSearch" runat="server">
        <table class="search">
            <tr>
                <td class="left">
                    Từ khóa
                </td>
                <td>
                    <asp:RadTextBox ID="txtSearchKeyword" runat="server" Width="130px" EmptyMessage="Từ khóa...">
                    </asp:RadTextBox>
                </td>
                <td class="left">
                    Link
                </td>
                <td>
                    <asp:RadTextBox ID="txtSearchLink" runat="server" Width="130px" EmptyMessage="Link...">
                    </asp:RadTextBox>
                </td>
                <td class="left">
                    User
                </td>
                <td>
                    <asp:RadComboBox Filter="Contains" ID="ddlSearchUser" CssClass="dropdownlist" Width="134px"
                        runat="server" DataSourceID="ObjectDataSource2" OnDataBound="DropDownList_DataBound"
                        EmptyMessage="- Tất cả -" DataTextField="UserName" DataValueField="UserName">
                    </asp:RadComboBox>
                    <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="UserSelectAll"
                        TypeName="TLLib.User">
                        <SelectParameters>
                            <asp:Parameter Name="UserName" Type="String" />
                            <asp:Parameter Name="Email" Type="String" />
                            <asp:Parameter Name="Role" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </td>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="left">
                    Từ ngày
                </td>
                <td>
                    <asp:RadDatePicker ID="dpFromDate" runat="server" Calendar-CultureInfo="vi-VN" Culture="vi-VN"
                        ShowPopupOnFocus="True" Width="138px">
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
                    <asp:RadDatePicker ID="dpToDate" runat="server" Calendar-CultureInfo="vi-VN" Culture="vi-VN"
                        ShowPopupOnFocus="True" Width="138px">
                        <Calendar ID="Calendar2" runat="server">
                            <SpecialDays>
                                <asp:RadCalendarDay Repeatable="Today">
                                    <ItemStyle CssClass="rcToday" />
                                </asp:RadCalendarDay>
                            </SpecialDays>
                        </Calendar>
                    </asp:RadDatePicker>
                </td>
                <td class="left">
                    Đã duyệt
                </td>
                <td>
                    <asp:RadComboBox ID="ddlSearchIsApproved" runat="server" EmptyMessage="- Tất cả -"
                        Filter="Contains" Width="134px">
                        <Items>
                            <asp:RadComboBoxItem Value="" />
                            <asp:RadComboBoxItem Text="Đã duyệt" Value="True" />
                            <asp:RadComboBoxItem Text="Chưa duyệt" Value="False" />
                        </Items>
                    </asp:RadComboBox>
                </td>
                <td class="left">
                    Hiển thị
                </td>
                <td>
                    <asp:RadComboBox ID="ddlSearchIsAvailable" runat="server" EmptyMessage="- Tất cả -"
                        Filter="Contains" Width="134px">
                        <Items>
                            <asp:RadComboBoxItem Value="" />
                            <asp:RadComboBoxItem Text="Có" Value="True" />
                            <asp:RadComboBoxItem Text="Không" Value="False" />
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
    <asp:RadGrid ID="RadGrid1" AllowMultiRowSelection="True" runat="server" Culture="vi-VN" 
        DataSourceID="ObjectDataSource1" GridLines="Horizontal" AutoGenerateColumns="False"
        AllowAutomaticDeletes="True" ShowStatusBar="True" OnItemCommand="RadGrid1_ItemCommand"
        CssClass="grid" AllowPaging="True" AllowSorting="True" AllowAutomaticInserts="True"
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
            DataKeyNames="CommentID">
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
                    <%--<asp:LinkButton ID="LinkButton2" runat="server" CommandName="InitInsert" Visible='<%# !RadGrid1.MasterTableView.IsItemInserted %>'
                            CssClass="item"><img class="vam" alt="" src="../assets/images/add.png" /> Thêm mới</asp:LinkButton>|--%>
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
                <asp:GridBoundColumn DataField="CommentID" SortExpression="CommentID" HeaderText="ID">
                </asp:GridBoundColumn>
                <asp:GridTemplateColumn HeaderText="Comment" DataField="Title,Content" SortExpression="Title"
                    ItemStyle-VerticalAlign="Top">
                    <ItemTemplate>
                        <a href='<%# Eval("Link")%>' target="_blank"><b>
                            <asp:Label ID="lblTitle" runat="server" Text='<%# !string.IsNullOrEmpty(Eval("Title").ToString()) ? Eval("Title") : Eval("Link")%>'></asp:Label>
                        </b></a>
                        <br />
                        <asp:Label ID="lblContent" runat="server" Text='<%# TLLib.Common.SplitSummary(Eval("Content").ToString().Replace(Environment.NewLine, "<br />"),500) %>'></asp:Label>
                    </ItemTemplate>
                </asp:GridTemplateColumn>
                <asp:GridTemplateColumn HeaderText="Date" DataField="CreateDate" SortExpression="CreateDate"
                    ItemStyle-VerticalAlign="Top">
                    <ItemTemplate>
                        <%# TLLib.Common.ChangeDate(Eval("CreateDate"))%>
                        bởi:
                        <br />
                        <a href='<%# Request.Url.AbsolutePath + "?usn=" + Eval("UserName")%>'>
                            <%# Eval("UserName")%></a>
                        <br />
                        <%# Membership.GetUser( Eval("UserName").ToString()).Email %>
                    </ItemTemplate>
                </asp:GridTemplateColumn>
                <asp:GridTemplateColumn HeaderText="Duyệt" DataField="IsApproved" SortExpression="IsApproved">
                    <ItemTemplate>
                        <asp:CheckBox ID="chkIsApproved" runat="server" Checked='<%# Eval("IsApproved") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsApproved"))%>'
                            CssClass="checkbox" />
                    </ItemTemplate>
                </asp:GridTemplateColumn>
                <asp:GridTemplateColumn HeaderText="Hiển thị" DataField="IsAvailable" SortExpression="IsAvailable">
                    <ItemTemplate>
                        <asp:CheckBox ID="chkIsAvailable" runat="server" Checked='<%# Eval("IsAvailable") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsAvailable"))%>'
                            CssClass="checkbox" />
                    </ItemTemplate>
                </asp:GridTemplateColumn>
            </Columns>
            <EditFormSettings EditFormType="Template">
                <FormTemplate>
                    <asp:Panel ID="Panel1" runat="server" DefaultButton="lnkUpdate">
                        <h3 class="searchTitle">
                            Thông Tin Comment
                        </h3>
                        <table class="search">
                            <tr>
                                <td>
                                    <a href='<%# Eval("Link").ToString().StartsWith("http://") ? Eval("Link") : "http://" + Eval("Link")%>'>
                                        <b>
                                            <asp:Label ID="lblTitle" runat="server" Text='<%# !string.IsNullOrEmpty(Eval("Title").ToString()) ? Eval("Title") : Eval("Link")%>'></asp:Label>
                                        </b></a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <a href='<%# Request.Url.AbsolutePath + "?usn=" + Eval("UserName")%>'>
                                        <%# Eval("UserName")%></a>
                                    <%# TLLib.Common.ChangeDate(Eval("CreateDate"))%>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Width="500" Height="200"
                                        Text='<%# Bind("Content")%>'></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                        <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Bind("UserName")%>' />
                        <asp:HiddenField ID="HiddenField2" runat="server" Value='<%# Bind("Link")%>' />
                        <asp:HiddenField ID="HiddenField3" runat="server" Value='<%# Bind("Title")%>' />
                        <asp:HiddenField ID="HiddenField4" runat="server" Value='<%# Bind("Priority")%>' />
                        <asp:HiddenField ID="HiddenField5" runat="server" Value='<%# Bind("IsApproved")%>' />
                        <asp:HiddenField ID="HiddenField6" runat="server" Value='<%# Bind("IsAvailable")%>' />
                        <div class="edit">
                            <hr />
                            <asp:RadButton ID="lnkUpdate" runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>'
                                Text='<%# (Container is GridEditFormInsertItem) ? "Thêm" : "Cập nhật" %>'>
                                <Icon PrimaryIconUrl="~/ad/assets/images/ok.png" />
                            </asp:RadButton>
                            &nbsp;&nbsp;
                            <asp:RadButton ID="btnCancel" runat="server" CommandName='Cancel' Text='Hủy'>
                                <Icon PrimaryIconUrl="~/ad/assets/images/cancel.png" />
                            </asp:RadButton>
                        </div>
                    </asp:Panel>
                </FormTemplate>
            </EditFormSettings>
        </MasterTableView>
        <HeaderStyle Font-Bold="True" />
        <HeaderContextMenu EnableImageSprites="True" CssClass="GridContextMenu GridContextMenu_Default">
        </HeaderContextMenu>
    </asp:RadGrid>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="CommentSelectAll"
        TypeName="TLLib.Comment" DeleteMethod="CommentDelete" UpdateMethod="CommentUpdate"
        InsertMethod="CommentInsert">
        <DeleteParameters>
            <asp:Parameter Name="CommentID" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="UserName" Type="String" />
            <asp:Parameter Name="Link" Type="String" />
            <asp:Parameter Name="Title" Type="String" />
            <asp:Parameter Name="Content" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter Name="IsApproved" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:Parameter Name="CommentID" Type="String" />
            <asp:ControlParameter ControlID="ddlSearchUser" Name="UserName" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchKeyword" Name="Keyword" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtSearchLink" Name="Link" PropertyName="Text" Type="String" />
            <asp:Parameter Name="Title" Type="String" />
            <asp:Parameter Name="Content" Type="String" />
            <asp:Parameter Name="CreateDate" Type="String" />
            <asp:Parameter Name="UpdateDate" Type="String" />
            <asp:ControlParameter ControlID="dpFromDate" Name="FromDate" PropertyName="SelectedDate"
                Type="String" />
            <asp:ControlParameter ControlID="dpToDate" Name="ToDate" PropertyName="SelectedDate"
                Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:ControlParameter ControlID="ddlSearchIsApproved" Name="IsApproved" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="ddlSearchIsAvailable" Name="IsAvailable" PropertyName="SelectedValue"
                Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="CommentID" Type="String" />
            <asp:Parameter Name="UserName" Type="String" />
            <asp:Parameter Name="Link" Type="String" />
            <asp:Parameter Name="Title" Type="String" />
            <asp:Parameter Name="Content" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter Name="IsApproved" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>
</asp:Content>
