<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/inside.master" AutoEventWireup="true"
    CodeFile="productcolorsize.aspx.cs" Inherits="ad_single_servicecategory" %>

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
    <script type="text/javascript">
        var listbox;
        var filterTextBox;
        function filterAdditionnalItems() {
            listbox = $find(window['AllSize']);
            filterTextBox = $(".AdditionnalFilter")[0];
            DoFilter();
        }
        function DoFilter() {
            //listbox._getGroupElement().focus();
            clearListEmphasis();
            createMatchingList();
        }

        // clear emphasis from matching characters for entire list
        function clearListEmphasis() {
            var re = new RegExp("</{0,1}em>", "gi");
            var items = listbox.get_items();
            var itemText;

            items.forEach(
                function (item) {
                    itemText = item.get_text();
                    item.set_text(clearTextEmphasis(itemText));
                }
            );
        }

        // clear emphasis from matching characters for given text
        function clearTextEmphasis(text) {
            var re = new RegExp("</{0,1}em>", "gi");
            return text.replace(re, "");
        }

        // hide listboxitems without matching characters
        function createMatchingList() {
            var items = listbox.get_items();
            var filterText = filterTextBox.value;
            var re = new RegExp(filterText, "i");

            items.forEach(
                function (item) {
                    var itemText = item.get_text();

                    if (itemText.toLowerCase().indexOf(filterText.toLowerCase()) != -1) {
                        item.set_text(itemText.replace(re, "<em>" + itemText.match(re) + "</em>"));
                        item.set_visible(true);
                    } else
                        item.set_visible(false);
                }
            );
        }
    </script>
    <style type="text/css">
        .rlbCheck
        {
            float: left;
        }
        .vat
        {
            vertical-align: top;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <fieldset>
        <h3 class="searchTitle">
            Thông Tin Sản Phẩm</h3>
        <asp:FormView ID="FormView1" runat="server" DataSourceID="ObjectDataSource2" EnableModelValidation="True"
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
        <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="ProductSelectOne"
            TypeName="TLLib.Product">
            <SelectParameters>
                <asp:QueryStringParameter Name="ProductID" QueryStringField="pi" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </fieldset>
    <asp:RadAjaxPanel ID="RadAjaxPanel1" runat="server" ClientEvents-OnRequestStart="conditionalPostback"
        Width="100%">
        <asp:Label ID="lblError" ForeColor="Red" runat="server"></asp:Label>
        <asp:RadGrid ID="RadGrid1" AllowMultiRowSelection="True" runat="server" Culture="vi-VN" 
            DataSourceID="ObjectDataSource1" GridLines="Horizontal" AutoGenerateColumns="False"
            AllowAutomaticDeletes="True" ShowStatusBar="True" OnItemCommand="RadGrid1_ItemCommand"
            OnItemDataBound="RadGrid1_ItemDataBound" CssClass="grid" AllowAutomaticUpdates="True"
            CellSpacing="0">
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
                DataKeyNames="ProductOptionCategoryID">
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
                    <asp:GridBoundColumn HeaderText="ID" DataField="ProductOptionCategoryID" SortExpression="ProductOptionCategoryID">
                    </asp:GridBoundColumn>
                    <asp:GridTemplateColumn HeaderText="Mã Màu" DataField="ProductOptionCategoryName">
                        <ItemTemplate>
                            <div class='<%#"catlevel level" +  Eval("Level") %>' style='padding-left: <%# string.IsNullOrEmpty(Eval("Level").ToString()) ? 0 : Convert.ToInt32(Eval("Level")) * 10 %>px'>
                                <asp:Label ID="lblProductOptionCategoryName" runat="server" Text='<%# Eval("ProductOptionCategoryName")%>'
                                    Font-Bold='<%# Eval("ParentID").ToString() == "0" ? true : false %>'></asp:Label>
                            </div>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn>
                        <ItemTemplate>
                            <div style="line-height: 10px; padding: 0 10px 0 10px;">
                                <asp:LinkButton ID="lnkUpOrder" rel='<%# Eval("ProductOptionCategoryID") %>' runat="server"
                                    OnClick="lnkUpOrder_Click">
                                    <img alt="" title="Lên 1 cấp" src="../assets/images/up-arrow.gif" />
                                </asp:LinkButton>
                                <br />
                                <br />
                                <asp:LinkButton ID="lnkDownOrder" rel='<%# Eval("ProductOptionCategoryID") %>' runat="server"
                                    OnClick="lnkDownOrder_Click">
                                    <img alt="" title="Xuống 1 cấp" src="../assets/images/down-arrow.gif" />
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="10px" />
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Cấp độ" DataField="Level" Visible="False">
                        <ItemTemplate>
                            <asp:Label ID="lblLevel" runat="server" Text='<%# Eval("Level") %>' Font-Bold='<%# Eval("ParentID").ToString() == "0" ? true : false %>'></asp:Label>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Danh mục cấp trên" Visible="False" DataField="ParentCategoryName">
                        <ItemTemplate>
                            <asp:Label ID="lblParentCategoryName" runat="server" Text='<%# Eval("ParentCategoryName")%>'
                                Font-Bold='<%# Eval("ParentID").ToString() == "0" ? true : false %>'></asp:Label>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Xem trên menu" Visible="False" DataField="IsShowOnMenu">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsShowOnMenu" runat="server" Checked='<%# Eval("IsShowOnMenu") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsShowOnMenu"))%>'
                                CssClass="checkbox" />
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderText="Xem trên trang chủ" Visible="False" DataField="IsShowOnHomePage">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsShowOnHomePage" runat="server" Checked='<%# Eval("IsShowOnHomePage") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsShowOnHomePage"))%>'
                                CssClass="checkbox" />
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
                            <asp:Panel ID="Panel1" runat="server" Visible='<%# string.IsNullOrEmpty( Eval("ImageName").ToString()) ? false : true %>'>
                                <%--<a class="screenshot" rel='../../res/productoptioncategory/<%# Eval("ImageName") %>'>
                                    <img alt="" src="../assets/images/photo.png" />
                                </a>--%>
                                <img id="Img1" alt="" src='<%# "~/res/productoptioncategory/" + Eval("ImageName") %>'
                                    runat="server" visible='<%# string.IsNullOrEmpty(Eval("ImageName").ToString()) ? false : true %>' />
                                <asp:LinkButton ID="lnkDeleteImage" runat="server" rel='<%#  Eval("ProductOptionCategoryID") + "#" + Eval("ImageName") %>'
                                    CommandName="DeleteImage" OnClientClick="return confirm('Xóa ảnh này ?')">
                            <img alt="Xóa ảnh" title="Xóa ảnh" src="../assets/images/delete-icon.png" />
                                </asp:LinkButton>
                                <asp:HiddenField ID="hdnImageName" runat="server" Value='<%# Eval("ImageName") %>' />
                            </asp:Panel>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                    <asp:GridTemplateColumn HeaderStyle-Width="1%">
                        <ItemTemplate>
                            <div style="width: 36px">
                                <img alt="Thư viện ảnh" title="Thư viện ảnh" src="../assets/images/PhotoAlbum.png"
                                    onclick="openWindow('productcolor-images.aspx?poi=<%# Eval("ProductOptionCategoryID") %>','Thư viện ảnh')"
                                    style="cursor: pointer" />
                            </div>
                        </ItemTemplate>
                    </asp:GridTemplateColumn>
                </Columns>
                <EditFormSettings EditFormType="Template">
                    <FormTemplate>
                        <asp:Panel ID="Panel1" runat="server" DefaultButton="lnkUpdate">
                            <h3 class="searchTitle">
                                Thông Tin Màu Sắc</h3>
                            <table class="search">
                                <tr>
                                    <td class="left" valign="top">
                                        Ảnh đại diện
                                    </td>
                                    <td>
                                        <asp:HiddenField ID="hdnProductOptionCategoryID" runat="server" Value='<%# Eval("ProductOptionCategoryID") %>' />
                                        <asp:HiddenField ID="hdnImageName" runat="server" Value='<%# Eval("ImageName") %>' />
                                        <asp:RadUpload ID="FileImageName" runat="server" ControlObjectsVisibility="None"
                                            Culture="vi-VN" Language="vi-VN" InputSize="69" AllowedFileExtensions=".jpg,.jpeg,.gif,.png" />
                                        <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="Sai định dạng ảnh (*.jpg, *.jpeg, *.gif, *.png)"
                                            ClientValidationFunction="validateRadUpload" Display="Dynamic"></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr class="invisible">
                                    <td class="left" valign="top">
                                        Danh mục cấp trên
                                    </td>
                                    <td>
                                        <asp:RadComboBox Filter="Contains" ID="ddlParent" runat="server" DataSourceID='<%# (Container is GridEditFormInsertItem) ? "ObjectDataSource1" : "ObjectDataSource2" %>'
                                            DataTextField="ProductOptionCategoryName" DataValueField="ProductOptionCategoryID"
                                            OnDataBound="DropDownList_DataBound" Width="504px">
                                        </asp:RadComboBox>
                                        <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="ProductOptionCategoryForEditSelectAll"
                                            TypeName="TLLib.ProductOptionCategory">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hdnProductOptionCategoryID" Name="ProductOptionCategoryID"
                                                    PropertyName="Value" Type="String" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                    </td>
                                </tr>
                                <tr class="invisible">
                                    <td class="left" valign="top">
                                        Meta Title
                                    </td>
                                    <td>
                                        <asp:RadTextBox ID="txtMetaTitle" runat="server" Text='<%# Bind("MetaTitle") %>'
                                            Width="500px" EmptyMessage="Meta Title...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr class="invisible">
                                    <td class="left" valign="top">
                                        Meta Description
                                    </td>
                                    <td>
                                        <asp:RadTextBox ID="txtMetaDescription" runat="server" Text='<%# Bind("MetaDescription") %>'
                                            Width="500px" EmptyMessage="Meta Description...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" valign="top">
                                        Mã Màu
                                    </td>
                                    <td>
                                        <asp:RadTextBox ID="txtProductOptionCategoryName" runat="server" Text='<%# (Container is GridEditFormInsertItem) ? "" : Eval("ProductOptionCategoryName").ToString().Remove(0, Convert.ToInt32(Eval("Level"))) %>'
                                            Width="500px" EmptyMessage="Mã Màu...">
                                        </asp:RadTextBox>
                                    </td>
                                </tr>
                                <tr class="invisible">
                                    <td class="left" valign="top">
                                        Mô tả
                                    </td>
                                    <td>
                                        <asp:RadEditor ID="txtDescription" StripFormattingOptions="MSWordRemoveAll,ConvertWordLists,MSWordNoFonts,Font,Css,Span" ContentFilters="ConvertCharactersToEntities,ConvertToXhtml,OptimizeSpans,IndentHTMLContent,ConvertFontToSpan,IECleanAnchors,FixUlBoldItalic,RemoveScripts,FixEnclosingP" runat="server" Height="200" Language="vi-VN" Skin="Office2007"
                                            Width="98%" Content='<%# Bind("Description") %>'>
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
                                <tr class="invisible">
                                    <td class="left" valign="top">
                                        Nội dung
                                    </td>
                                    <td>
                                        <asp:RadEditor ID="txtContent" ContentFilters="ConvertCharactersToEntities,ConvertToXhtml,OptimizeSpans,IndentHTMLContent,ConvertFontToSpan,IECleanAnchors,FixUlBoldItalic,RemoveScripts,FixEnclosingP" runat="server" Language="vi-VN" Skin="Office2007"
                                            Width="98%" Content='<%# Bind("Content") %>'>
                                            <ImageManager DeletePaths="~/Uploads/Image/" UploadPaths="~/Uploads/Image/" ViewPaths="~/Uploads/Image/" MaxUploadFileSize="1024000" />
                                            <FlashManager DeletePaths="~/Uploads/Video/" UploadPaths="~/Uploads/Video/" ViewPaths="~/Uploads/Video/" />
                                            <DocumentManager DeletePaths="~/Uploads/File/" UploadPaths="~/Uploads/File/" ViewPaths="~/Uploads/File/" MaxUploadFileSize="1024000" />
                                            <MediaManager DeletePaths="~/Uploads/Media/" UploadPaths="~/Uploads/Media/" ViewPaths="~/Uploads/Media/" />
                                            <TemplateManager DeletePaths="~/Uploads/Template/" UploadPaths="~/Uploads/Template/"
                                                ViewPaths="~/Uploads/Template/" />
                                        </asp:RadEditor>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left" colspan="2">
                                        <asp:CheckBox ID="chkIsShowOnMenu" runat="server" Visible="False" CssClass="checkbox"
                                            Text=" Xem trên menu" Checked='<%# (Container is GridEditFormInsertItem) ? true : (Eval("IsShowOnMenu") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsShowOnMenu"))) %>' />
                                        <asp:CheckBox ID="chkIsShowOnHomePage" runat="server" Visible="False" CssClass="checkbox"
                                            Text=" Xem trên trang chủ" Checked='<%# (Container is GridEditFormInsertItem) ? true : (Eval("IsShowOnHomePage") == DBNull.Value ? false : Convert.ToBoolean(Eval("IsShowOnHomePage"))) %>' />
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
                                        &nbsp;&nbsp;
                                        <asp:LinkButton ID="LinkButton5" runat="server" CausesValidation="False" CommandName="Cancel">
                                            <img alt="" title="Hủy" src="../assets/images/cancel.png" class="vam" /> &nbsp;&nbsp;Hủy
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:RadInputManager ID="RadInputManager2" runat="server">
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
        <br />
        <br />
        <fieldset>
            <h3 class="searchTitle">
                Cập nhật kích thước</h3>
            <div style="float: left; width: 350px; padding: 10px">
                <table class="search" style="margin-bottom: 20px; display: inline-block">
                    <tr>
                        <td class="left">
                            Chọn Màu
                        </td>
                    </tr>
                </table>
                <asp:RadListBox ID="lstChoosedColor" runat="server"
                    DataSourceID="ObjectDataSource1" AllowTransferOnDoubleClick="False" EnableDragAndDrop="True"
                    OnDataBound="ListBox_DataBound" DataSortField="ProductOptionCategoryName" DataTextField="ProductOptionCategoryName"
                    DataValueField="ProductOptionCategoryID" EmptyMessage="Empty" Height="200" SelectionMode="Multiple"
                    showPostBackMask="False" Width="350">
                    <ItemTemplate>
                        <asp:HiddenField ID="hdnProductOptionCategoryID" runat="server" Value='<%# Eval("ProductOptionCategoryID") %>' />
                        <img id="Img1" alt="" src='<%# "~/res/productoptioncategory/" + Eval("ImageName") %>'
                            runat="server" visible='<%# string.IsNullOrEmpty(Eval("ImageName").ToString()) ? false : true %>' />
                        <asp:Label ID="lblColorName" CssClass="vat" Text='<%# Eval("ProductOptionCategoryName")%>'
                            Width="100" runat="server" Produc_ColorID='<%# Eval("ProductOptionCategoryID") %>' />
                    </ItemTemplate>
                </asp:RadListBox>
            </div>
            <div style="float: left; width: 540px; padding: 10px">
                <asp:RadTextBox ID="txtFilterAdditionalItem" EmptyMessage="Tìm kiếm kích thước ..."
                    onkeyup="filterAdditionnalItems();return false;" runat="server" CssClass="AdditionnalFilter"
                    Width="281px">
                </asp:RadTextBox>
                <br />
                <br />
                <asp:RadListBox ID="lstAllSize" runat="server" AllowTransfer="True" AllowTransferDuplicates="false"
                    ButtonSettings-ShowTransferAll="false" EmptyMessage="Empty" AutoPostBackOnTransfer="True"
                    CausesValidation="False" DataSortField="ProductLengthName" DataTextField="ProductLengthName"
                    DataValueField="ProductLengthID" EnableDragAndDrop="True" Height="200" OnDataBound="ListBox_DataBound"
                    OnTransferred="AllSize_Transferred" TransferMode="Copy" SelectionMode="Multiple" showPostBackMask="False"
                    Sort="Ascending" TransferToID="lstChoosedSize" Width="150" OnItemDataBound="lstAllSize_ItemDataBound">
                    <ItemTemplate>
                        <asp:HiddenField ID="hdnProductLengthID" runat="server" Value='<%# Eval("ProductLengthID") %>' />
                        <asp:Label ID="lblProductLengthName" Width="100" runat="server" Text='<%# Eval("ProductLengthName")%>'></asp:Label>
                    </ItemTemplate>
                </asp:RadListBox>
                <asp:ObjectDataSource ID="ObjectDataSource4" runat="server" SelectMethod="ProductLengthSelectAll"
                    TypeName="TLLib.ProductLength">
                    <SelectParameters>
                        <asp:Parameter Name="ProductLengthName" Type="String" />
                        <asp:Parameter Name="ProductLengthNameEn" Type="String" />
                        <asp:Parameter Name="IsAvailable" Type="String" DefaultValue="true" />
                        <asp:Parameter Name="Priority" Type="String" />
                        <asp:Parameter Name="SortByPriority" Type="String" />
                        <asp:Parameter DefaultValue="" Name="ProductID" Type="String" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <asp:RadListBox ID="lstChoosedSize" TransferMode="Copy" runat="server" AllowTransferOnDoubleClick="False"
                    EnableDragAndDrop="True" OnDataBound="ListBox_DataBound" DataSortField="ProductLengthName"
                    DataTextField="ProductLengthName" DataValueField="ProductSizeColorID" EmptyMessage="Empty"
                    Height="200" SelectionMode="Multiple" showPostBackMask="False" Width="385">
                    <ItemTemplate>
                        <span style="width: 50px; display: inline-block">
                            <img id="Img1" alt="" src='<%# "~/res/productoptioncategory/" + Eval("ImageNameColor") %>'
                                runat="server" class="vam" visible='<%# string.IsNullOrEmpty(Eval("ImageNameColor").ToString()) ? false : true %>' />
                            <asp:Label ID="lblColorName" CssClass="vam" Text='<%# Eval("ProductOptionCategoryName")%>'
                                runat="server" />
                        </span><span style="width: 50px; display: inline-block">
                            <asp:HiddenField ID="hdnProductLengthID" runat="server" Value='<%# Eval("ProductLengthID") %>' />
                            <asp:Label ID="lblProductLengthName" CssClass="vam" runat="server" Text='<%# Eval("ProductLengthName")%>'></asp:Label>
                        </span><span style="width: 70px; display: inline-block">
                            <asp:RadNumericTextBox MinValue="0" ID="txtPriority" CssClass="vam" Text='<%# Eval("Priority") %>'
                                runat="server" Type="Number" Width="60px" ToolTip="Thứ tự" EmptyMessage="Thứ tự..">
                                <NumberFormat AllowRounding="false" />
                            </asp:RadNumericTextBox>
                        </span><span style="width: 70px; display: inline-block">
                            <asp:RadNumericTextBox MinValue="0" ID="txtQuantity" CssClass="vam" Text='<%# Eval("Quantity") %>'
                                runat="server" Type="Number" Width="60px" ToolTip="Số lượng" EmptyMessage="Số lượng..">
                                <NumberFormat AllowRounding="false" />
                            </asp:RadNumericTextBox>
                        </span><span style="width: 70px; display: inline-block">
                            <asp:CheckBox ID="chkIsAvailable" ToolTip="Hiển Thị" runat="server" CssClass="checkbox vam"
                                Text="Hiển thị" Checked='<%# string.IsNullOrEmpty(Eval("IsAvailable").ToString()) ? false : Eval("IsAvailable")%>' />
                        </span>
                    </ItemTemplate>
                </asp:RadListBox>
                <asp:ObjectDataSource ID="ObjectDataSource3" runat="server" SelectMethod="ProductSizeColorSelectAll"
                    TypeName="TLLib.ProductSizeColor">
                    <SelectParameters>
                        <asp:Parameter Name="ProductLengthID" Type="String" />
                        <asp:Parameter Name="ProductOptionCategoryID" Type="String" />
                        <asp:QueryStringParameter Name="ProductID" QueryStringField="pi" Type="String" />
                        <asp:Parameter Name="InStock" Type="String" />
                        <asp:Parameter Name="IsAvailable" DefaultValue="True" Type="String" />
                        <asp:Parameter Name="Priority" Type="String" />
                        <asp:Parameter Name="SortByPriority" Type="String" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <div class="clr">
                </div>
                <br />
                <asp:RadButton ID="btnUpdate" runat="server" Text="Sửa nhanh" OnClick="btnUpdate_Click">
                    <Icon PrimaryIconUrl="~/ad/assets/images/accept.png" />
                </asp:RadButton>
            </div>
        </fieldset>
    </asp:RadAjaxPanel>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" DeleteMethod="ProductOptionCategoryDelete"
        SelectMethod="ProductOptionCategorySelectAll" TypeName="TLLib.ProductOptionCategory"
        UpdateMethod="ProductOptionCategoryUpdate">
        <DeleteParameters>
            <asp:Parameter Name="ProductOptionCategoryID" Type="String" />
        </DeleteParameters>
        <SelectParameters>
            <asp:Parameter Name="parentID" DefaultValue="0" Type="Int32" />
            <asp:Parameter DefaultValue="1" Name="increaseLevelCount" Type="Int32" />
            <asp:Parameter Name="IsShowOnMenu" Type="String" />
            <asp:Parameter Name="IsShowOnHomePage" Type="String" />
            <asp:QueryStringParameter Name="ProductID" DefaultValue="-1" QueryStringField="pi"
                Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="ProductOptionCategoryID" Type="String" />
            <asp:Parameter Name="ProductOptionCategoryName" Type="String" />
            <asp:Parameter Name="ProductOptionCategoryNameEn" Type="String" />
            <asp:Parameter Name="ConvertedProductOptionCategoryName" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="DescriptionEn" Type="String" />
            <asp:Parameter Name="Content" Type="String" />
            <asp:Parameter Name="ContentEn" Type="String" />
            <asp:Parameter Name="MetaTitle" Type="String" />
            <asp:Parameter Name="MetaTitleEn" Type="String" />
            <asp:Parameter Name="MetaDescription" Type="String" />
            <asp:Parameter Name="MetaDescriptionEn" Type="String" />
            <asp:Parameter Name="ImageName" Type="String" />
            <asp:Parameter Name="ParentID" Type="String" />
            <asp:Parameter Name="IsShowOnMenu" Type="String" />
            <asp:Parameter Name="IsShowOnHomePage" Type="String" />
            <asp:Parameter Name="IsAvailable" Type="String" />
            <asp:Parameter Name="ProductID" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>
    <asp:RadProgressManager ID="RadProgressManager1" runat="server" />
    <asp:RadProgressArea ID="ProgressArea1" runat="server" Culture="vi-VN" DisplayCancelButton="True"
        HeaderText="Đang tải" Skin="Office2007" Style="position: fixed; top: 50% !important;
        left: 50% !important; margin: -93px 0 0 -188px;" />
</asp:Content>
