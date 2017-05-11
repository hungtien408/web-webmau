<%@ Page Title="" Language="C#" MasterPageFile="~/site.master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1" EnableModelValidation="True"
        DataKeyNames="VideoCategoryID">
        <InsertItemTemplate>
            <tr style="">
                <td>
                    <asp:Button ID="InsertButton" runat="server" CommandName="Insert" Text="Insert" />
                    <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Clear" />
                </td>
                <td>
                    &nbsp;
                </td>
                <td>
                    <asp:TextBox ID="ImageNameTextBox" runat="server" Text='<%# Bind("ImageName") %>' />
                </td>
                <td>
                    <asp:TextBox ID="VideoCategoryNameTextBox" runat="server" Text='<%# Bind("VideoCategoryName") %>' />
                </td>
                <td>
                    <asp:TextBox ID="VideoCategoryNameEnTextBox" runat="server" Text='<%# Bind("VideoCategoryNameEn") %>' />
                </td>
                <td>
                    <asp:CheckBox ID="IsShowOnMenuCheckBox" runat="server" Checked='<%# Bind("IsShowOnMenu") %>' />
                </td>
                <td>
                    <asp:CheckBox ID="IsAvailableCheckBox" runat="server" Checked='<%# Bind("IsAvailable") %>' />
                </td>
                <td>
                    <asp:TextBox ID="PriorityTextBox" runat="server" Text='<%# Bind("Priority") %>' />
                </td>
            </tr>
        </InsertItemTemplate>
        <ItemTemplate>
            <tr style="">
                <td>
                    <asp:Label ID="VideoCategoryIDLabel" runat="server" Text='<%# Eval("VideoCategoryID") %>' />
                </td>
                <td>
                    <asp:Label ID="ImageNameLabel" runat="server" Text='<%# Eval("ImageName") %>' />
                </td>
                <td>
                    <asp:Label ID="VideoCategoryNameLabel" runat="server" Text='<%# Eval("VideoCategoryName") %>' />
                </td>
                <td>
                    <asp:Label ID="VideoCategoryNameEnLabel" runat="server" Text='<%# Eval("VideoCategoryNameEn") %>' />
                </td>
                <td>
                    <asp:CheckBox ID="IsShowOnMenuCheckBox" runat="server" Checked='<%# Eval("IsShowOnMenu") %>'
                        Enabled="false" />
                </td>
                <td>
                    <asp:CheckBox ID="IsAvailableCheckBox" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("IsAvailable").ToString()) ? false : Eval("IsAvailable") %>'
                        Enabled="false" />
                </td>
                <td>
                    <asp:Label ID="PriorityLabel" runat="server" Text='<%# Eval("Priority") %>' />
                </td>
            </tr>
        </ItemTemplate>
        <AlternatingItemTemplate>
            <tr style="">
                <td>
                    <asp:Label ID="VideoCategoryIDLabel" runat="server" Text='<%# Eval("VideoCategoryID") %>' />
                </td>
                <td>
                    <asp:Label ID="ImageNameLabel" runat="server" Text='<%# Eval("ImageName") %>' />
                </td>
                <td>
                    <asp:Label ID="VideoCategoryNameLabel" runat="server" Text='<%# Eval("VideoCategoryName") %>' />
                </td>
                <td>
                    <asp:Label ID="VideoCategoryNameEnLabel" runat="server" Text='<%# Eval("VideoCategoryNameEn") %>' />
                </td>
                <td>
                    <asp:CheckBox ID="IsShowOnMenuCheckBox" runat="server" Checked='<%# Eval("IsShowOnMenu") %>'
                        Enabled="false" />
                </td>
                <td>
                    <asp:CheckBox ID="IsAvailableCheckBox" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("IsAvailable").ToString()) ? false : Eval("IsAvailable") %>'
                        Enabled="false" />
                </td>
                <td>
                    <asp:Label ID="PriorityLabel" runat="server" Text='<%# Eval("Priority") %>' />
                </td>
            </tr>
        </AlternatingItemTemplate>
        <EditItemTemplate>
            <tr style="">
                <td>
                    <asp:Button ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
                    <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
                </td>
                <td>
                    <asp:Label ID="VideoCategoryIDLabel1" runat="server" Text='<%# Eval("VideoCategoryID") %>' />
                </td>
                <td>
                    <asp:TextBox ID="ImageNameTextBox" runat="server" Text='<%# Bind("ImageName") %>' />
                </td>
                <td>
                    <asp:TextBox ID="VideoCategoryNameTextBox" runat="server" Text='<%# Bind("VideoCategoryName") %>' />
                </td>
                <td>
                    <asp:TextBox ID="VideoCategoryNameEnTextBox" runat="server" Text='<%# Bind("VideoCategoryNameEn") %>' />
                </td>
                <td>
                    <asp:CheckBox ID="IsShowOnMenuCheckBox" runat="server" Checked='<%# Bind("IsShowOnMenu") %>' />
                </td>
                <td>
                    <asp:CheckBox ID="IsAvailableCheckBox" runat="server" Checked='<%# Bind("IsAvailable") %>' />
                </td>
                <td>
                    <asp:TextBox ID="PriorityTextBox" runat="server" Text='<%# Bind("Priority") %>' />
                </td>
            </tr>
        </EditItemTemplate>
        <EmptyDataTemplate>
            <table runat="server" style="">
                <tr>
                    <td>
                        No data was returned.
                    </td>
                </tr>
            </table>
        </EmptyDataTemplate>
        <LayoutTemplate>
            <table runat="server">
                <tr runat="server">
                    <td runat="server">
                        <table id="itemPlaceholderContainer" runat="server" border="0" style="">
                            <tr runat="server" style="">
                                <th runat="server">
                                    VideoCategoryID
                                </th>
                                <th runat="server">
                                    ImageName
                                </th>
                                <th runat="server">
                                    VideoCategoryName
                                </th>
                                <th runat="server">
                                    VideoCategoryNameEn
                                </th>
                                <th runat="server">
                                    IsShowOnMenu
                                </th>
                                <th runat="server">
                                    IsAvailable
                                </th>
                                <th runat="server">
                                    Priority
                                </th>
                            </tr>
                            <tr id="itemPlaceholder" runat="server">
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr runat="server">
                    <td runat="server" style="">
                    </td>
                </tr>
            </table>
        </LayoutTemplate>
        <SelectedItemTemplate>
            <tr style="">
                <td>
                    <%# Eval("VideoCategoryID") %>
                </td>
                <td>
                    <%# Eval("ImageName") %>
                </td>
                <td>
                    <%# Eval("VideoCategoryName") %>
                </td>
                <td>
                    <%# Eval("VideoCategoryNameEn") %>
                </td>
                <td>
                    <asp:CheckBox ID="IsShowOnMenuCheckBox" runat="server" Checked='<%# Eval("IsShowOnMenu") %>'
                        Enabled="false" />
                    <%# Eval("IsShowOnMenu") %>
                </td>
                <td>
                    <asp:CheckBox ID="IsAvailableCheckBox" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("IsAvailable").ToString()) ? false : Eval("IsAvailable") %>'
                        Enabled="false" />
                    <%# string.IsNullOrEmpty(Eval("IsAvailable").ToString()) ? false : Eval("IsAvailable") %>
                </td>
                <td>
                    <%# Eval("Priority") %>
                </td>
            </tr>
        </SelectedItemTemplate>
    </asp:ListView>
    <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="ProductSelectAll"
        TypeName="TLLib.Product">
        <SelectParameters>
            <asp:Parameter DefaultValue="0" Name="StartRowIndex" Type="String" />
            <asp:Parameter DefaultValue="4" Name="EndRowIndex" Type="String" />
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
            <asp:Parameter DefaultValue="" Name="Priority" Type="String" />
            <asp:Parameter DefaultValue="true" Name="IsAvailable" Type="String" />
            <asp:Parameter DefaultValue="true" Name="SortByPriority" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT * FROM [VideoCategory]"></asp:SqlDataSource>
    <asp:GridView ID="GridView1" runat="server" DataSourceID="ObjectDataSource1" EnableModelValidation="True">
    </asp:GridView>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="VideoSelectAll"
        TypeName="TLLib.VideoXML">
        <SelectParameters>
            <asp:Parameter Name="xmlFilePath" Type="String" DefaultValue="~/playlist.xml" />
            <asp:Parameter Name="keyWord" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <object id="player" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" name="player"
        width="730" height="480">
        <param name="movie" value="player.swf" />
        <param name="autoplay" value="true" />
        <param name="allowfullscreen" value="true" />
        <param name="allowscriptaccess" value="always" />
        <param name="wmode" value="opaque" />
        <param name="flashvars" value="file=playlist.xml&playlist=bottom&playlistsize=120&backcolor=111111&frontcolor=FFFFFF" />
        <object type="application/x-shockwave-flash" data="player.swf" width="730" height="480">
            <param name="movie" value="player.swf" />
            <param name="autoplay" value="true" />
            <param name="allowfullscreen" value="true" />
            <param name="allowscriptaccess" value="always" />
            <param name="flashvars" value="file=playlist.xml&playlist=bottom&playlistsize=120&backcolor=111111&frontcolor=FFFFFF" />
            <param name="LOOP" value="false" />
            <param name="PLAY" value="false" />
            <param name="wmode" value="opaque" />
            <p>
                <a href="http://get.adobe.com/flashplayer">Get Flash</a> to see this player.</p>
        </object>
    </object>
</asp:Content>
