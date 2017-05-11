<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/adminEn.master" AutoEventWireup="true"
    CodeFile="menu.aspx.cs" Inherits="ad_bilingual_menu" %>

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

        //On insert and update buttons click temporarily disables ajax to perform upload actions
        function conditionalPostback(sender, eventArgs) {
            var theRegexp = new RegExp("\.lnkUpdate$|\.lnkUpdateTop$|\.PerformInsertButton$", "ig");
            if (eventArgs.get_eventTarget().match(theRegexp)) {
                var upload1 = $find(window['UploadId1']);
                var upload2 = $find(window['UploadId2']);

                //AJAX is disabled only if file is selected for upload
                if (upload1.getFileInputs()[0].value != "" || upload2.getFileInputs()[0].value != "") {
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <h3 class="mainTitle">
        <img alt="" src="../assets/images/menu.png" class="vam" />
        Menu</h3>
    <br />
    <asp:RadAjaxPanel ID="RadAjaxPanel1" runat="server" ClientEvents-OnRequestStart="conditionalPostback">
        <h4 class="searchTitle">
            Tìm kiếm
        </h4>
        <table class="search">
            <tr>
                <td class="left">
                    Vị trí
                </td>
                <td class="left">
                    <asp:RadComboBox Filter="Contains" ID="ddlSearchMenuPosition" runat="server" DataTextField="MenuPositionName"
                        DataValueField="MenuPositionID" DataSourceID="ObjectDataSource3" OnDataBound="DropDownList_DataBound"
                        EmptyMessage="- Chọn vị trí -" AutoPostBack="True">
                    </asp:RadComboBox>
                    <asp:ObjectDataSource ID="ObjectDataSource3" runat="server" SelectMethod="MenuPositionSelectAll"
                        TypeName="TLLib.MenuPosition">
                        <SelectParameters>
                            <asp:Parameter Name="MenuPositionID" Type="String" />
                            <asp:Parameter Name="MenuPositionName" Type="String" />
                            <asp:Parameter Name="IsAvailable" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </td>
            </tr>
        </table>
        <asp:Label ID="lblError" ForeColor="Red" runat="server"></asp:Label>
        <asp:RadGrid ID="RadGrid1" AllowMultiRowSelection="True" runat="server" Culture="vi-VN" 
            DataSourceID="ObjectDataSource1" GridLines="Horizontal" AutoGenerateColumns="False"
            AllowAutomaticDeletes="True" ShowStatusBar="True" OnItemCommand="RadGrid1_ItemCommand"
            OnItemDataBound="RadGrid1_ItemDataBound" CssClass="grid" AllowAutomaticUpdates="True"
            AllowAutomaticInserts="True">
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
                DataKeyNames="MenuID">
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
                    <asp:GridTemplateColumn HeaderText="Tên danh mục" DataField="MenuTitle">
                        <ItemTemplate>
                            <div class='<%#"catlevel level" +  Eval("Level") %>' style='padding-left: <%# string.IsNullOrEmpty(Eval("Level").ToString()) ? 0 : Convert.ToInt32(Eval("Level")) * 10 %>px'>
                                <asp:Label ID="lblMenuTitle" runat="server" Text='<%# Eval("MenuTitle")%>' Font-Bold='<%# Eval("ParentID").ToString() == "0" ? true : false %>'></asp:Label>
                            </div>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Tên danh mục (Eng)" DataField="MenuTitleEn">
                        <ItemTemplate>
                            <div class='<%#"catlevel level" +  Eval("Level") %>' style='padding-left: <%# string.IsNullOrEmpty(Eval("Level").ToString()) ? 0 : Convert.ToInt32(Eval("Level")) * 10 %>px'>
                                <asp:Label ID="lblMenuTitleEn" runat="server" Text='<%# Eval("MenuTitleEn")%>' Font-Bold='<%# Eval("ParentID").ToString() == "0" ? true : false %>'></asp:Label>
                            </div>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridBoundColumn HeaderText="ID" DataField="MenuID" SortExpression="MenuID">
                    </asp:GridBoundColumn>
                    <asp:GridTemplateColumn>
                        <ItemTemplate>
                            <div style="line-height: 10px; padding: 0 10px 0 10px;">
                                <asp:LinkButton ID="lnkUpOrder" rel='<%# Eval("MenuID") %>' runat="server" OnClick="lnkUpOrder_Click">
                                    <img alt="" title="Lên 1 cấp" src="../assets/images/up-arrow.gif" />
                                </asp:LinkButton>
                                <asp:LinkButton ID="lnkDownOrder" rel='<%# Eval("MenuID") %>' runat="server" OnClick="lnkDownOrder_Click">
                                    <img alt="" title="Xuống 1 cấp" src="../assets/images/down-arrow.gif" />
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10px" />
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Cấp độ" DataField="Level">
                        <ItemTemplate>
                            <asp:Label ID="lblLevel" runat="server" Text='<%# Eval("Level") %>' Font-Bold='<%# Eval("ParentID").ToString() == "0" ? true : false %>'></asp:Label>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Danh mục cấp trên" DataField="ParentName">
                        <ItemTemplate>
                            <asp:Label ID="lblParentName" runat="server" Text='<%# Eval("ParentName")%>' Font-Bold='<%# Eval("ParentID").ToString() == "0" ? true : false %>'></asp:Label>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Hiển thị" DataField="IsAvailable">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsAvailable" runat="server" Checked='<%# Eval("IsAvailable") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsAvailable"))%>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Ảnh">
                        <ItemTemplate>
                            <span runat="server" visible='<%# string.IsNullOrEmpty( Eval("ImageName").ToString()) ? false : true %>'>
                                <a class="screenshot" rel='../../res/menu/<%# Eval("ImageName") %>'>
                                    <img alt="" src="../assets/images/photo.png" />
                                </a></span><span runat="server" visible='<%# string.IsNullOrEmpty( Eval("ImageNameEn").ToString()) ? false : true %>'>
                                    <a class="screenshot" rel='../../res/menu/<%# Eval("ImageNameEn") %>'>
                                        <img alt="" src="../assets/images/photo.png" />
                                    </a></span>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                </Columns>
                <EditFormSettings EditFormType="Template">
                    <FormTemplate>
                        <asp:Panel ID="Panel1" runat="server" DefaultButton="lnkUpdate">
                            <h3 class="searchTitle">
                                Thông Tin Menu</h3>
                            <table class="search">
                                <tr>
                                    <td class="left" valign="top">
                                        Ảnh đại diện
                                    </td>
                                    <td>
                                        <asp:HiddenField ID="hdnMenuID" runat="server" Value='<%# Eval("MenuID") %>' />
                                        <asp:HiddenField ID="hdnImageName" runat="server" Value='<%# Eval("ImageName") %>' />
                                        <asp:RadUpload ID="FileImageName" runat="server" ControlObjectsVisibility="None"
                                            Culture="vi-VN" Language="vi-VN" InputSize="69" AllowedFileExtensions=".jpg,.jpeg,.gif,.png" />
                                        <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="Sai định dạng ảnh (*.jpg, *.jpeg, *.gif, *.png)"
                                            ClientValidationFunction="validateRadUpload" Display="Dynamic"></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Vị trí
                                    </td>
                                    <td>
                                        <asp:RadComboBox Filter="Contains" ID="ddlMenuPosition" runat="server" DataSourceID="ObjectDataSource3"
                                            DataTextField="MenuPositionName" DataValueField="MenuPositionID" OnDataBound="DropDownList_DataBound"
                                            Width="504px" EmptyMessage="- Chọn -">
                                        </asp:RadComboBox>
                                        <asp:HiddenField ID="hdnMenuPositionID" runat="server" Value='<%# Eval("MenuPositionID") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Menu cấp trên
                                    </td>
                                    <td>
                                        <asp:RadComboBox Filter="Contains" ID="ddlParent" runat="server" DataSourceID='<%# (Container is GridEditFormInsertItem) ? "ObjectDataSource1" : "ObjectDataSource2" %>'
                                            DataTextField="MenuTitle" DataValueField="MenuID" OnDataBound="DropDownList_DataBound"
                                            Width="504px" EmptyMessage="- Chọn -">
                                        </asp:RadComboBox>
                                        <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="MenuForEditSelectAll"
                                            TypeName="TLLib.Menu">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hdnMenuID" Name="MenuID" PropertyName="Value" Type="String" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                        <asp:HiddenField ID="hdnParentID" runat="server" Value='<%# Eval("ParentID") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Tên menu
                                    </td>
                                    <td>
                                        <asp:RadTextBox ID="txtMenuTitle" runat="server" Text='<%# (Container is GridEditFormInsertItem) ? "" : Eval("MenuTitle").ToString().Remove(0, Convert.ToInt32(Eval("Level"))) %>'
                                            Width="500px" EmptyMessage="Tên menu...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Link
                                    </td>
                                    <td>
                                        <asp:RadTextBox ID="txtLink" runat="server" Text='<%# Bind("Link") %>' Width="500px"
                                            EmptyMessage="Link...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" colspan="2">
                                        <asp:CheckBox ID="chkIsAvailable" runat="server" CssClass="checkbox" Text=" Hiển thị"
                                            Checked='<%# (Container is GridEditFormInsertItem) ? true : (Eval("IsAvailable") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsAvailable"))) %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <h3>
                                            (Ngôn Ngữ Tiếng Anh)</h3>
                                        <hr />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Ảnh đại diện
                                    </td>
                                    <td>
                                        <asp:HiddenField ID="hdnImageNameEn" runat="server" Value='<%# Eval("ImageNameEn") %>' />
                                        <asp:RadUpload ID="FileImageNameEn" runat="server" ControlObjectsVisibility="None"
                                            Culture="vi-VN" Language="vi-VN" InputSize="69" AllowedFileExtensions=".jpg,.jpeg,.gif,.png" />
                                        <asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="Sai định dạng ảnh (*.jpg, *.jpeg, *.gif, *.png)"
                                            ClientValidationFunction="validateRadUpload" Display="Dynamic"></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Tên menu
                                    </td>
                                    <td>
                                        <asp:RadTextBox ID="txtMenuTitleEn" runat="server" Text='<%# Bind("MenuTitleEn") %>'
                                            Width="500px" EmptyMessage="Tên menu...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Link
                                    </td>
                                    <td>
                                        <asp:RadTextBox ID="txtLinkEn" runat="server" Text='<%# Bind("LinkEn") %>' Width="500px"
                                            EmptyMessage="Link...">
                                        </asp:RadTextBox>
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
    </asp:RadAjaxPanel>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" DeleteMethod="MenuDelete"
        SelectMethod="MenuSelectAll" TypeName="TLLib.Menu" UpdateMethod="MenuUpdate"
        InsertMethod="MenuInsert">
        <DeleteParameters>
            <asp:Parameter Name="MenuID" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="ImageName" Type="String" />
            <asp:Parameter Name="ImageNameEn" Type="String" />
            <asp:Parameter Name="MenuTitle" Type="String" />
            <asp:Parameter Name="MenuTitleEn" Type="String" />
            <asp:Parameter Name="Link" Type="String" />
            <asp:Parameter Name="LinkEn" Type="String" />
            <asp:Parameter Name="MenuPositionID" Type="String" />
            <asp:Parameter Name="ParentID" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlSearchMenuPosition" DefaultValue="-1" Name="MenuPositionID"
                PropertyName="SelectedValue" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
            <asp:Parameter DefaultValue="-" Name="SeparatorCharacter" Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="MenuID" Type="String" />
            <asp:Parameter Name="ImageName" Type="String" />
            <asp:Parameter Name="ImageNameEn" Type="String" />
            <asp:Parameter Name="MenuTitle" Type="String" />
            <asp:Parameter Name="MenuTitleEn" Type="String" />
            <asp:Parameter Name="Link" Type="String" />
            <asp:Parameter Name="LinkEn" Type="String" />
            <asp:Parameter Name="MenuPositionID" Type="String" />
            <asp:Parameter Name="ParentID" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>
    <asp:RadProgressManager ID="RadProgressManager1" runat="server" />
    <asp:RadProgressArea ID="ProgressArea1" runat="server" Culture="vi-VN" DisplayCancelButton="True"
        HeaderText="Đang tải" Skin="Office2007" Style="position: fixed; top: 50% !important;
        left: 50% !important; margin: -93px 0 0 -188px;" />
</asp:Content>
