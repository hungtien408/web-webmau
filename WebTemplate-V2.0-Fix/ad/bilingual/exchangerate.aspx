<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/adminEn.master" AutoEventWireup="true"
    CodeFile="exchangerate.aspx.cs" Inherits="ad_single_exchangerate" %>

<%@ Register TagPrefix="asp" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register Assembly="Spaanjaars.Toolkit" Namespace="Spaanjaars.Toolkit" TagPrefix="isp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <h3 class="mainTitle">
        <img alt="" src="../assets/images/coins.png" class="vam" />
        Tỷ Giá
    </h3>
    <asp:FormView ID="FormView1" DefaultMode="Edit" runat="server" DataSourceID="ObjectDataSource1"
        EnableModelValidation="True" OnItemUpdated="FormView1_ItemUpdated">
        <EditItemTemplate>
            <asp:Panel ID="Panel1" DefaultButton="btnUpdate" runat="server">
                <table class="search">
                    <tr class="display-none">
                        <td class="left">
                            1 lượng JSC =
                        </td>
                        <td>
                            <asp:RadNumericTextBox ID="txtGold" runat="server" Width="100px" Text='<%# Bind("gold") %>'
                                EmptyMessage="Nhập giá vàng..." Type="Number">
                                <NumberFormat AllowRounding="false" DecimalDigits="2" />
                            </asp:RadNumericTextBox>
                            VNĐ
                        </td>
                    </tr>
                    <tr>
                        <td class="left">
                            1 USD =
                        </td>
                        <td>
                            <asp:RadNumericTextBox ID="txtUSD" runat="server" Width="100px" Text='<%# Bind("usd") %>'
                                EmptyMessage="Nhập giá USD..." Type="Number">
                                <NumberFormat AllowRounding="false" DecimalDigits="2" />
                            </asp:RadNumericTextBox>
                            VNĐ
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right">
                            <asp:RadButton ID="btnUpdate" runat="server" CommandName="Update" CausesValidation="false"
                                Text="Cập nhật">
                            </asp:RadButton>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </EditItemTemplate>
    </asp:FormView>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="ExchangeRateSelectOne"
        TypeName="TLLib.ExchangeRate" UpdateMethod="ExchangeRateUpdate">
        <UpdateParameters>
            <asp:Parameter Name="gold" Type="String" />
            <asp:Parameter Name="usd" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>
</asp:Content>
