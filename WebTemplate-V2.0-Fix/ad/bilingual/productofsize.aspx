<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/inside.master" AutoEventWireup="true"
    CodeFile="productofsize.aspx.cs" Inherits="ad_single_productofsize" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="Server">
    <script src="../assets/js/ajax-sizecolor.js" type="text/javascript"></script>
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
    <asp:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
        <div style="width: 100%; padding: 20px">
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
                OnTransferred="AllSize_Transferred" SelectionMode="Multiple" showPostBackMask="False"
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
            <asp:RadListBox ID="lstChoosedSize" runat="server" AllowTransferOnDoubleClick="False"
                EnableDragAndDrop="True" OnDataBound="ListBox_DataBound" DataSortField="ProductLengthName"
                DataTextField="ProductLengthName" DataValueField="ProductOfLengthID" EmptyMessage="Empty"
                Height="200" SelectionMode="Multiple" showPostBackMask="False" Width="385">
                <ItemTemplate>
                    <asp:HiddenField ID="hdnProductLengthID" runat="server" Value='<%# Eval("ProductLengthID") %>' />
                    <asp:Label ID="lblProductLengthName" Width="100" runat="server" Text='<%# Eval("ProductLengthName")%>'></asp:Label>
                    <asp:RadNumericTextBox MinValue="0" ID="txtPriority" Text='<%# Eval("Priority") %>'
                        runat="server" Type="Number" Width="60px" ToolTip="Thứ tự" EmptyMessage="Thứ tự..">
                        <NumberFormat AllowRounding="false" />
                    </asp:RadNumericTextBox>
                    <asp:CheckBox ID="chkIsAvailable" ToolTip="Hiển Thị" runat="server" CssClass="checkbox"
                        Text="Hiển thị" Checked='<%# string.IsNullOrEmpty(Eval("IsAvailable").ToString()) ? false : Eval("IsAvailable")%>' />
                </ItemTemplate>
            </asp:RadListBox>
            <asp:ObjectDataSource ID="ObjectDataSource3" runat="server" SelectMethod="ProductOfLengthSelectAll"
                TypeName="TLLib.ProductOfLength">
                <SelectParameters>
                    <asp:Parameter Name="IsAvailable" Type="String" />
                    <asp:Parameter Name="Priority" Type="String" />
                    <asp:Parameter DefaultValue="true" Name="SortByPriority" Type="String" />
                    <asp:QueryStringParameter Name="ProductID" QueryStringField="pi" Type="String" />
                    <asp:Parameter Name="ProductLengthID" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <div class="clr">
            </div>
            <br />
            <asp:RadButton ID="btnUpdate" runat="server" Text="Sửa nhanh" OnClick="btnUpdate_Click">
                <Icon PrimaryIconUrl="~/ad/assets/images/find.png" />
            </asp:RadButton>
        </div>
    </asp:RadAjaxPanel>
</asp:Content>
