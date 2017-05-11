<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/adminEn.master" AutoEventWireup="true"
    CodeFile="photoalbum.aspx.cs" Inherits="ad_single_photoalbum" %>

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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <h3 class="mainTitle">
        <img alt="" src="../assets/images/album.png" class="vam" />
        Thư Viện Ảnh</h3>
    <br />
    <asp:RadAjaxPanel ID="RadAjaxPanel1" runat="server" ClientEvents-OnRequestStart="conditionalPostback">
        <asp:Panel ID="pnlSearch" DefaultButton="btnSearch" runat="server">
            <h4 class="searchTitle">
                Tìm kiếm
            </h4>
            <table class="search">
                <tr>
                    <td class="left">
                        Tên Album
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchPhotoAlbumCategoryName" runat="server" Width="300px">
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
            ShowStatusBar="True" OnItemCommand="RadGrid1_ItemCommand" OnItemDataBound="RadGrid1_ItemDataBound"
            CssClass="grid" AllowAutomaticUpdates="True" CellSpacing="0" AllowAutomaticDeletes="True">
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
                DataKeyNames="PhotoAlbumCategoryID">
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
                            <asp:HiddenField ID="hdnImageName" runat="server" Value='<%# Eval("ImageName") %>' />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridBoundColumn HeaderText="ID" DataField="PhotoAlbumCategoryID" SortExpression="PhotoAlbumCategoryID">
                    </asp:GridBoundColumn>
                    <asp:GridTemplateColumn HeaderText="Tên Album" DataField="PhotoAlbumCategoryName"
                        SortExpression="PhotoAlbumCategoryName">
                        <ItemTemplate>
                            <asp:Label ID="lblPhotoAlbumCategoryName" runat="server" Text='<%# Eval("PhotoAlbumCategoryName")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Tên Album(Tiếng Anh)" DataField="PhotoAlbumCategoryNameEn"
                        SortExpression="PhotoAlbumCategoryNameEn">
                        <ItemTemplate>
                            <asp:Label ID="lblPhotoAlbumCategoryNameEn" runat="server" Text='<%# Eval("PhotoAlbumCategoryNameEn")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Thứ tự" DataField="Priority" SortExpression="Priority">
                        <ItemTemplate>
                            <asp:RadNumericTextBox ID="txtPriority" runat="server" Width="70px" Text='<%# Bind("Priority") %>'
                                ShowSpinButtons="true" MinValue="0" EmptyMessage="Thứ tự..." Type="Number">
                                <NumberFormat AllowRounding="false" DecimalDigits="0" GroupSeparator="." />
                            </asp:RadNumericTextBox>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Xem trên menu" DataField="IsShowOnMenu" SortExpression="IsShowOnMenu">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsShowOnMenu" runat="server" Checked='<%# Eval("IsShowOnMenu") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsShowOnMenu"))%>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Xem trên trang chủ" DataField="IsShowOnHomePage">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsShowOnHomePage" runat="server" Checked='<%# Eval("IsShowOnHomePage") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsShowOnHomePage"))%>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Hiển thị" DataField="IsAvailable" SortExpression="IsAvailable">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsAvailable" runat="server" Checked='<%# Eval("IsAvailable") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsAvailable"))%>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Ảnh">
                        <ItemTemplate>
                            <asp:Panel ID="Panel1" runat="server" Visible='<%# string.IsNullOrEmpty( Eval("ImageName").ToString()) ? false : true %>'>
                                <a class="screenshot" rel='../../res/photoalbumcategory/<%# Eval("ImageName") %>'>
                                    <img alt="" src="../assets/images/photo.png" />
                                </a>
                                <asp:LinkButton ID="lnkDeleteImage" runat="server" rel='<%#  Eval("PhotoAlbumCategoryID") + "#" + Eval("ImageName") %>'
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
                                                Thông Tin Thư Viện Ảnh
                                            </div>
                                            <div class="cont">
                                                <table class="search">
                                                    <tr>
                                                        <td class="left" valign="top">
                                                            Ảnh đại diện
                                                        </td>
                                                        <td>
                                                            <asp:HiddenField ID="hdnPhotoAlbumCategoryID" runat="server" Value='<%# Eval("PhotoAlbumCategoryID") %>' />
                                                            <asp:HiddenField ID="hdnImageName" runat="server" Value='<%# Eval("ImageName") %>' />
                                                            <asp:RadUpload ID="FileImageName" runat="server" ControlObjectsVisibility="None"
                                                                Culture="vi-VN" Language="vi-VN" InputSize="69" AllowedFileExtensions=".jpg,.jpeg,.gif,.png" />
                                                            <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="Sai định dạng ảnh (*.jpg, *.jpeg, *.gif, *.png)"
                                                                ClientValidationFunction="validateRadUpload" Display="Dynamic"></asp:CustomValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left" valign="top">
                                                            Tên Album
                                                        </td>
                                                        <td>
                                                            <asp:RadTextBox ID="txtPhotoAlbumCategoryName" runat="server" Text='<%# Bind("PhotoAlbumCategoryName") %>'
                                                                Width="500px" EmptyMessage="Tên Album...">
                                                            </asp:RadTextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left" valign="top">
                                                            Tên Album(En)
                                                        </td>
                                                        <td>
                                                            <asp:RadTextBox ID="txtPhotoAlbumCategoryNameEn" runat="server" Text='<%# Bind("PhotoAlbumCategoryNameEn") %>'
                                                                Width="500px" EmptyMessage="Tên Album(En)...">
                                                            </asp:RadTextBox>
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
                                                            <asp:CheckBox ID="chkIsShowOnMenu" runat="server" CssClass="checkbox" Text=" Xem trên menu"
                                                                Checked='<%# (Container is GridEditFormInsertItem) ? true : (Eval("IsShowOnMenu") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsShowOnMenu"))) %>' />
                                                            &nbsp;&nbsp;
                                                            <asp:CheckBox ID="chkIsShowOnHomePage" runat="server" CssClass="checkbox" Text=" Xem trên trang chủ"
                                                                Checked='<%# (Container is GridEditFormInsertItem) ? true : (Eval("IsShowOnHomePage") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsShowOnHomePage"))) %>' />
                                                            &nbsp;&nbsp;
                                                            <asp:CheckBox ID="chkIsAvailable" runat="server" CssClass="checkbox" Text=" Hiển thị"
                                                                Checked='<%# (Container is GridEditFormInsertItem) ? true : (Eval("IsAvailable") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsAvailable"))) %>' />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                    <td valign="top">
                                        <div class="sub_box">
                                            <div class="head">
                                                Ảnh</div>
                                            <div class="cont">
                                                <asp:RadAjaxPanel ID="RadAjaxPanel2" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
                                                    <asp:RadAsyncUpload ID="FileImageAlbum" runat="server" MultipleFileSelection="Automatic"
                                                        TargetFolder="~/res/photoalbum/" TemporaryFolder="~/res/TempAsync" Width="100%"
                                                        AllowedFileExtensions="jpg,jpeg,gif,png" Localization-Select="Chọn" Localization-Cancel="Hủy"
                                                        Localization-Remove="Xóa" OnFileUploaded="FileImageAlbum_FileUploaded">
                                                    </asp:RadAsyncUpload>
                                                    <asp:RadButton ID="btnUpload" runat="server" Text="Tải lên" ShowPostBackMask="False">
                                                        <Icon PrimaryIconUrl="~/ad/assets/images/up.png" />
                                                    </asp:RadButton>
                                                    <asp:RadAjaxPanel ID="RadAjaxPanel3" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
                                                        <asp:RadListView runat="server" ID="RadListView1" DataSourceID="OdsPhotoAlbum" DataKeyNames="PhotoAlbumID"
                                                            OverrideDataSourceControlSorting="True" OnItemCommand="RadListView1_ItemCommand"
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
                                                                    <a href='<%# "~/res/photoalbum/" + Eval("ImageName") %>' runat="server" class="lightbox">
                                                                        <img alt="" src='<%# "~/res/photoalbum/thumbs/" + Eval("ImageName") %>' runat="server"
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
                                                                <asp:HiddenField ID="hdnPhotoAlbumID" runat="server" Value='<%# Eval("PhotoAlbumID") %>' />
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
                                                                                        <td class="left" style="width: 70px">
                                                                                            Tiêu đề ảnh(En)
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:RadTextBox ID="txtTitleEn" Width="100%" runat="server" Text='<%# Bind("TitleEn") %>'
                                                                                                EmptyMessage="Tiêu đề ảnh(En)...">
                                                                                            </asp:RadTextBox>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="left" valign="top">
                                                                                            Mô tả(En)
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:RadTextBox ID="txtDescriptionEn" runat="server" Width="100%" Text='<%# Bind("DescripttionEn")%>'
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
                                                                                <img alt="" src='<%# "~/res/photoalbum/thumbs/" + Eval("ImageName") %>' runat="server"
                                                                                    width="100" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                    <hr />
                                                                    <asp:RadButton ID="lnkUpdate" runat="server" CommandName='Update'
                                                                        Text='Cập nhật'>
                                                                        <Icon PrimaryIconUrl="~/ad/assets/images/ok.png" />
                                                                    </asp:RadButton>
                                                                    &nbsp;&nbsp;
                                                                    <asp:RadButton ID="btnCancel" runat="server" CommandName='Cancel' Text='Hủy'>
                                                                        <Icon PrimaryIconUrl="~/ad/assets/images/cancel.png" />
                                                                    </asp:RadButton>
                                                                    <div class="clear">
                                                                    </div>
                                                                </asp:Panel>
                                                            </EditItemTemplate>
                                                        </asp:RadListView>
                                                        <asp:ObjectDataSource ID="OdsPhotoAlbum" runat="server" DeleteMethod="PhotoAlbumDelete"
                                                            SelectMethod="PhotoAlbumSelectAll" TypeName="TLLib.PhotoAlbum" UpdateMethod="PhotoAlbumUpdate"
                                                            InsertMethod="PhotoAlbumInsert">
                                                            <DeleteParameters>
                                                                <asp:Parameter Name="PhotoAlbumID" Type="String" />
                                                            </DeleteParameters>
                                                            <InsertParameters>
                                                                <asp:Parameter Name="ImageName" Type="String" />
                                                                <asp:Parameter Name="ConvertedTitle" Type="String" />
                                                                <asp:Parameter Name="Title" Type="String" />
                                                                <asp:Parameter Name="Descripttion" Type="String" />
                                                                <asp:Parameter Name="TitleEn" Type="String" />
                                                                <asp:Parameter Name="DescripttionEn" Type="String" />
                                                                <asp:Parameter Name="PhotoAlbumCategoryID" Type="String" />
                                                                <asp:Parameter Name="IsAvailable" Type="String" />
                                                                <asp:Parameter Name="Priority" Type="String" />
                                                            </InsertParameters>
                                                            <SelectParameters>
                                                                <asp:Parameter Name="Keyword" Type="String" />
                                                                <asp:Parameter Name="Title" Type="String" />
                                                                <asp:Parameter Name="Descripttion" Type="String" />
                                                                <asp:ControlParameter ControlID="hdnPhotoAlbumCategoryID" DefaultValue="-1" Name="PhotoAlbumCategoryID"
                                                                    PropertyName="Value" Type="String" />
                                                                <asp:Parameter Name="IsAvailable" Type="String" />
                                                                <asp:Parameter Name="Priority" Type="String" />
                                                                <asp:Parameter DefaultValue="True" Name="SortByPriority" Type="String" />
                                                            </SelectParameters>
                                                            <UpdateParameters>
                                                                <asp:Parameter Name="PhotoAlbumID" Type="String" />
                                                                <asp:Parameter Name="ImageName" Type="String" />
                                                                <asp:Parameter Name="ConvertedTitle" Type="String" />
                                                                <asp:Parameter Name="Title" Type="String" />
                                                                <asp:Parameter Name="Descripttion" Type="String" />
                                                                <asp:Parameter Name="TitleEn" Type="String" />
                                                                <asp:Parameter Name="DescripttionEn" Type="String" />
                                                                <asp:ControlParameter ControlID="hdnPhotoAlbumCategoryID" DefaultValue="-1" Name="PhotoAlbumCategoryID"
                                                                    PropertyName="Value" Type="String" />
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
                                                                    <a href='<%# "~/res/photoalbum/" + Eval("ImageName") %>' runat="server" class="lightbox">
                                                                        <img alt="" src='<%# "~/res/photoalbum/thumbs/" + Eval("ImageName") %>' runat="server"
                                                                            width="100" height="100" />
                                                                    </a>
                                                                    <div align="right">
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
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" DeleteMethod="PhotoAlbumCategoryDelete"
        InsertMethod="PhotoAlbumCategoryInsert" SelectMethod="PhotoAlbumCategorySelectAll"
        TypeName="TLLib.PhotoAlbumCategory" UpdateMethod="PhotoAlbumCategoryUpdate">
        <DeleteParameters>
            <asp:Parameter Name="PhotoAlbumCategoryID" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="ImageName" Type="String" />
            <asp:Parameter Name="PhotoAlbumCategoryName" Type="String" />
            <asp:Parameter Name="PhotoAlbumCategoryNameEn" Type="String" />
            <asp:Parameter Name="ConvertedPhotoAlbumCategoryName" Type="String" />
            <asp:Parameter Name="IsShowOnMenu" Type="String" />
            <asp:Parameter Name="IsShowOnHomePage" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearchPhotoAlbumCategoryName" Name="PhotoAlbumCategoryName"
                PropertyName="Text" Type="String" />
            <asp:Parameter Name="IsShowOnMenu" Type="String" />
            <asp:Parameter Name="IsShowOnHomePage" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
            <asp:Parameter Name="SortByPriority" Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="PhotoAlbumCategoryID" Type="String" />
            <asp:Parameter Name="ImageName" Type="String" />
            <asp:Parameter Name="PhotoAlbumCategoryName" Type="String" />
            <asp:Parameter Name="PhotoAlbumCategoryNameEn" Type="String" />
            <asp:Parameter Name="ConvertedPhotoAlbumCategoryName" Type="String" />
            <asp:Parameter Name="IsShowOnMenu" Type="String" />
            <asp:Parameter Name="IsShowOnHomePage" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
            <asp:Parameter Name="Priority" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>
    <asp:RadProgressManager ID="RadProgressManager1" runat="server" />
    <asp:RadProgressArea ID="ProgressArea1" runat="server" Culture="vi-VN" DisplayCancelButton="True"
        HeaderText="Đang tải" Skin="Office2007" Style="position: fixed; top: 50% !important;
        left: 50% !important; margin: -93px 0 0 -188px;" />
</asp:Content>
