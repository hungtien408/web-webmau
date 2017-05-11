<%@ Page Language="C#" AutoEventWireup="true" CodeFile="viewvideoxml.aspx.cs" Inherits="ad_single_viewvideoxml" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="min-height:400px;min-width:600px">
        <asp:FormView ID="FormView1" Width="100%" Height="100%" runat="server" DataSourceID="ObjectDataSource1"
            EnableModelValidation="True">
            <ItemTemplate>
                <object id="player" style="position: fixed; left: 0; top: 0" width="100%" height="100%"
                    name="player" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
                    <param value="../../player.swf" name="movie">
                    <param value="true" name="allowfullscreen">
                    <param value="never" name="allowscriptaccess">
                    <param value="opaque" name="wmode">
                    <param value="file=<%# Eval("ref") %>&image=../../<%# Eval("param") %>&backcolor=111111&frontcolor=FFFFFF"
                        name="flashvars">
                    <embed id="player2" width="100%" height="100%" flashvars="file=<%# Eval("ref") %>&image=../../<%# Eval("param") %>&backcolor=111111&frontcolor=FFFFFF"
                        wmode="opaque" allowfullscreen="false" allowscriptaccess="always" src="../../player.swf"
                        name="player2" type="application/x-shockwave-flash">
                </object>
            </ItemTemplate>
        </asp:FormView>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="VideoSelectOne"
            TypeName="TLLib.VideoXML">
            <SelectParameters>
                <asp:Parameter DefaultValue="~/playlist.xml" Name="xmlFilePath" Type="String" />
                <asp:QueryStringParameter DefaultValue="" Name="ide" QueryStringField="PI" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </div>
    </form>
</body>
</html>
