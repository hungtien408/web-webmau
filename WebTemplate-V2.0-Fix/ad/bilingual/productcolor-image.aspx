<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/inside.master" AutoEventWireup="true"
    CodeFile="productcolor-image.aspx.cs" Inherits="ad_single_service" %>

<%@ Register TagPrefix="asp" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
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
    <fieldset>
        <h3 class="searchTitle">
            Thông Tin Màu sắc</h3>
        <asp:FormView ID="FormView1" runat="server" DataSourceID="ObjectDataSource2" EnableModelValidation="True"
            Width="100%">
            <ItemTemplate>
                <div class="mInfo" style="min-width: 800px">
                    <table class="search" style="border: 0">
                        <tr>
                            <td class="left">
                                Mã Màu:
                            </td>
                            <td style="min-width: 100px">
                                <asp:Label ID="lblProductOptionCategoryName" runat="server" Text='<%# Eval("ProductOptionCategoryName")%>'></asp:Label>
                            </td>
                            <td>
                                <img alt="" src='<%# "~/res/productoptioncategory/" + Eval("ImageName") %>'
                                    runat="server" visible='<%# string.IsNullOrEmpty(Eval("ImageName").ToString()) ? false : true %>' />
                            </td>
                        </tr>
                    </table>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="ProductOptionCategorySelectOne"
            TypeName="TLLib.ProductOptionCategory">
            <SelectParameters>
                <asp:QueryStringParameter Name="ProductOptionCategoryID" QueryStringField="poi" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </fieldset>
    <asp:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
        <asp:Label ID="lblError" ForeColor="Red" runat="server"></asp:Label>
        <asp:Panel ID="pnlUploadMulti" runat="server" CssClass="panel-edit-form">
            <asp:RadAjaxPanel ID="RadAjaxPanel2" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
                <asp:RadAsyncUpload ID="FileImageAlbum" runat="server" MultipleFileSelection="Automatic"
                    TargetFolder="~/res/productoption/" TemporaryFolder="~/res/TempAsync/" Width="100%"
                    AllowedFileExtensions="jpg,jpeg,gif,png" Localization-Select="Chọn" Localization-Cancel="Hủy"
                    Localization-Remove="Xóa" OnFileUploaded="FileImageAlbum_FileUploaded">
                </asp:RadAsyncUpload>
                <asp:RadButton ID="btnUpload" runat="server" Text="Tải lên" ShowPostBackMask="False">
                    <Icon PrimaryIconUrl="~/ad/assets/images/up.png" />
                </asp:RadButton>
                <asp:RadAjaxPanel ID="RadAjaxPanel3" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
                    <asp:RadListView runat="server" ID="RadListView1" DataSourceID="OdsProductPhotoAlbum"
                        DataKeyNames="ProductOptionID" OverrideDataSourceControlSorting="True" OnItemCommand="RadListView1_ItemCommand"
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
                                <a href='<%# "~/res/productoption/" + Eval("ImageName") %>'
                                    runat="server" class="lightbox">
                                    <img id="Img1" alt="" src='<%# "~/res/productoption/" + Eval("ImageName") %>'
                                        runat="server" width="200" />
                                </a>
                                <div align="right">
                                    <asp:LinkButton ID="btnEditSelected" runat="server" CommandName="Edit"
                                        CssClass="item"><img width="14px" class="vam" alt="" title="Sửa" src="../assets/images/tools.png" /></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" OnClientClick="return confirm('Xóa ảnh?')" runat="server"
                                        CommandName="Delete" CssClass="item"><img width="14px" class="vam" alt="" title="Xóa ảnh" src="../assets/images/trash.png" /></asp:LinkButton>
                                </div>
                            </fieldset>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:HiddenField ID="hdnProductOptionID" runat="server" Value='<%# Eval("ProductOptionID") %>' />
                            <asp:HiddenField ID="hdnImageName" runat="server" Value='<%# Eval("ImageName") %>' />
                            <asp:Panel ID="Panel2" runat="server" DefaultButton="lnkUpdate">
                                <h3 class="searchTitle clear">
                                    Cập Nhật Ảnh</h3>
                                <table width="100%">
                                    <tr>
                                        <td valign="top" style="padding-right: 10px">
                                            <table class="search" width="100%">
                                                <tr>
                                                    <td class="left" valign="top">
                                                        Ảnh đại diện
                                                    </td>
                                                    <td runat="server">
                                                        <asp:RadUpload ID="FileImageName" runat="server" ControlObjectsVisibility="None"
                                                            Culture="vi-VN" Language="vi-VN" InputSize="69" AllowedFileExtensions=".jpg,.jpeg,.gif,.png" />
                                                        <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="Sai định dạng ảnh (*.jpg, *.jpeg, *.gif, *.png)"
                                                            ClientValidationFunction="validateRadUpload" Display="Dynamic"></asp:CustomValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="left" style="width: 70px">
                                                        Tiêu đề ảnh
                                                    </td>
                                                    <td>
                                                        <asp:RadTextBox ID="txtProductOptionTitle" Width="100%" runat="server" Text='<%# Bind("ProductOptionTitle") %>'
                                                            EmptyMessage="Tiêu đề ảnh...">
                                                        </asp:RadTextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="left" valign="top">
                                                        Mô tả
                                                    </td>
                                                    <td>
                                                        <asp:RadTextBox ID="txtDescription" runat="server" Width="100%" Text='<%# Bind("Description")%>'
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
                                            <img id="Img2" alt="" src='<%# "~/res/productoption/thumbs/" + Eval("ImageName") %>'
                                                runat="server" width="100" />
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName='Update'
                                    ForeColor="Green">
                                                                        <img alt="" title="Cập nhật" src="../assets/images/ok.png" class="vam" /> Cập nhật
                                </asp:LinkButton>
                                &nbsp;&nbsp;
                                <asp:LinkButton ID="LinkButton5" runat="server" CausesValidation="False" CommandName="Cancel"
                                    ForeColor="Green">
                                                                        <img alt="" title="Hủy" src="../assets/images/cancel.png" class="vam" /> &nbsp;&nbsp;Hủy
                                </asp:LinkButton>
                                <div class="clear">
                                </div>
                            </asp:Panel>
                        </EditItemTemplate>
                    </asp:RadListView>
                    <asp:ObjectDataSource ID="OdsProductPhotoAlbum" runat="server" DeleteMethod="ProductOptionDelete"
                        SelectMethod="ProductOptionSelectAll" TypeName="TLLib.ProductOption" UpdateMethod="ProductOptionUpdate">
                        <DeleteParameters>
                            <asp:Parameter Name="ProductOptionID" Type="String" />
                        </DeleteParameters>
                        <SelectParameters>
                            <asp:Parameter Name="StartRowIndex" Type="String" />
                            <asp:Parameter Name="EndRowIndex" Type="String" />
                            <asp:Parameter Name="Keyword" Type="String" />
                            <asp:Parameter Name="ProductOptionTitle" Type="String" />
                            <asp:Parameter Name="Description" Type="String" />
                            <asp:QueryStringParameter Name="ProductOptionCategoryID" QueryStringField="poi" Type="String" />
                            <asp:Parameter Name="Tag" Type="String" />
                            <asp:Parameter Name="IsShowOnHomePage" Type="String" />
                            <asp:Parameter Name="IsHot" Type="String" />
                            <asp:Parameter Name="IsNew" Type="String" />
                            <asp:Parameter Name="FromDate" Type="String" />
                            <asp:Parameter Name="ToDate" Type="String" />
                            <asp:Parameter Name="IsAvailable" Type="String" />
                            <asp:Parameter Name="Priority" Type="String" />
                            <asp:Parameter DefaultValue="" Name="SortByPriority" Type="String" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="ImageName" Type="String" />
                            <asp:Parameter Name="ProductOptionID" Type="String" />
                            <asp:Parameter Name="MetaTittle" Type="String" />
                            <asp:Parameter Name="MetaDescription" Type="String" />
                            <asp:Parameter Name="ProductOptionTitle" Type="String" />
                            <asp:Parameter Name="ConvertedProductOptionTitle" Type="String" />
                            <asp:Parameter Name="Description" Type="String" />
                            <asp:Parameter Name="Content" Type="String" />
                            <asp:Parameter Name="Tag" Type="String" />
                            <asp:Parameter Name="MetaTittleEn" Type="String" />
                            <asp:Parameter Name="MetaDescriptionEn" Type="String" />
                            <asp:Parameter Name="ProductOptionTitleEn" Type="String" />
                            <asp:Parameter Name="DescriptionEn" Type="String" />
                            <asp:Parameter Name="ContentEn" Type="String" />
                            <asp:Parameter Name="TagEn" Type="String" />
                            <asp:Parameter Name="ProductOptionCategoryID" Type="String" />
                            <asp:Parameter Name="IsShowOnHomePage" Type="String" />
                            <asp:Parameter Name="IsHot" Type="String" />
                            <asp:Parameter Name="IsNew" Type="String" />
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
                                <a id="A2" href='<%# "~/res/productoption/" + Eval("ImageName") %>' runat="server"
                                    class="lightbox">
                                    <img id="Img1" alt="" src='<%# "~/res/productoption/thumbs/" + Eval("ImageName") %>'
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
        </asp:Panel>
    </asp:RadAjaxPanel>
    <asp:RadProgressManager ID="RadProgressManager1" runat="server" />
    <asp:RadProgressArea ID="ProgressArea1" runat="server" Culture="vi-VN" DisplayCancelButton="True"
        HeaderText="Đang tải" Skin="Office2007" Style="position: fixed; top: 50% !important;
        left: 50% !important; margin: -93px 0 0 -188px;" />
</asp:Content>
