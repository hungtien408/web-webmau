<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/adminEn.master" AutoEventWireup="true"
    CodeFile="siteconfig.aspx.cs" Inherits="ad_bilingual_siteconfig" %>

<%@ Register TagPrefix="asp" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="Server">
    <script type="text/javascript">
        function txtEmail_OnBlur(source, e) {
            var host, port, useSSL;
            var email = source.get_value();
            var extend = email.substr(email.lastIndexOf("@") + 1, email.length).toLowerCase();
            var username = email.substr(0, email.lastIndexOf("@")).toLowerCase();

            host = extend.indexOf("gmail") == 0 ? "smtp.gmail.com" : (extend.indexOf("yahoo") == 0 ? "smtp.mail.yahoo.com" : (extend.indexOf("hotmail") == 0 ? "smtp.live.com" : extend));
            port = extend.indexOf("gmail") == 0 ? 587 : (extend.indexOf("yahoo") == 0 ? 587 : (extend.indexOf("hotmail") == 0 ? 25 : 25));
            useSSL = extend.indexOf("gmail") == 0 || extend.indexOf("yahoo") == 0 ? true : false;

            var txtHost = $find("<%= txtHost.ClientID %>");
            var txtPort = $find("<%= txtPort.ClientID %>");
            var txtUserName = $find("<%= txtUserName.ClientID %>");
            var chkUseSSL = $("#<%= chkUseSSL.ClientID %>");

            txtHost.set_value(host);
            txtPort.set_value(port);
            txtUserName.set_value(username);

            if (useSSL) chkUseSSL.attr("checked", "checked");
            else chkUseSSL.removeAttr("checked");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
        <asp:Panel ID="Panel1" runat="server" DefaultButton="btnSaveEmail" GroupingText="Cấu hình Email"
            Font-Bold="true">
            <table class="search" style="margin-top: 10px;">
                <tr>
                    <td class="left">
                        Email gởi
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtEmail" runat="server" Width="300" EmptyMessage="Email gởi..."
                            ClientEvents-OnBlur="txtEmail_OnBlur">
                        </asp:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td class="left">
                        UserName
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtUserName" runat="server" Width="300" EmptyMessage="UserName...">
                        </asp:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td class="left">
                        Mật khẩu
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtPassword" TextMode="Password" runat="server" Width="300" EmptyMessage="Mật khẩu...">
                        </asp:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td class="left">
                        SMTP Host
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtHost" runat="server" Width="300" EmptyMessage="SMTP host...">
                        </asp:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td class="left">
                        Port
                    </td>
                    <td>
                        <asp:RadNumericTextBox ID="txtPort" runat="server" Width="300" NumberFormat-DecimalDigits="0"
                            EmptyMessage="Port...">
                        </asp:RadNumericTextBox>
                    </td>
                </tr>
                <tr>
                    <td class="left">
                    </td>
                    <td class="left" style="padding-left: 0">
                        <asp:CheckBox ID="chkUseSSL" Text="Sử dụng SSL" runat="server" CssClass="checkbox" />
                    </td>
                </tr>
                <tr>
                    <td class="left">
                        Email nhận
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtReceivedEmails" runat="server" Width="300" EmptyMessage="Email nhận (VD: a@yahoo.com; b@yahoo.com...)">
                        </asp:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td class="left" colspan="2" align="right">
                        <asp:RadButton ID="btnSaveEmail" runat="server" Text="Lưu" OnClick="btnSaveEmail_Click">
                            <Icon PrimaryIconUrl="~/ad/assets/images/ok.png" />
                        </asp:RadButton>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblSaveEmail" runat="server" ForeColor="Green" Style="vertical-align: bottom"></asp:Label>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </asp:RadAjaxPanel>
</asp:Content>
