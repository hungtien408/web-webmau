<%@ Page Title="" Language="C#" MasterPageFile="~/ad/template/inside.master" AutoEventWireup="true"
    CodeFile="projectvideo.aspx.cs" Inherits="ad_single_projectvideo" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="Server">
    <style type="text/css">
        .myClass:hover
        {
            background-color: #a1da29 !important;
        }
        .txt
        {
            border: 0px !important;
            background: #eeeeee !important;
            color: Black !important;
            margin-left: 25%;
            margin-right: auto;
            width: 100%;
            filter: alpha(opacity=50); /* IE's opacity*/
            opacity: 0.50;
            text-align: center;
            display: block;
        }
    </style>
    <script type="text/javascript">
        // <![CDATA[
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
        }

        function validateImage(source, e) {
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

        function validateVideo(source, e) {
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

        function containerMouseover(sender) {
            sender.getElementsByTagName("div")[0].style.display = "";
        }
        function containerMouseout(sender) {
            sender.getElementsByTagName("div")[0].style.display = "none";
        }
            // ]]>
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <fieldset>
        <h3 class="searchTitle">
            Thông Tin Dự Án</h3>
        <asp:FormView ID="FormView1" runat="server" DataSourceID="ObjectDataSource2" EnableModelValidation="True"
            Width="100%">
            <ItemTemplate>
                <div class="mInfo" style="min-width: 800px">
                    <table class="search" style="border: 0">
                        <tr>
                            <td class="left">
                                Tên dự án:
                            </td>
                            <td>
                                <asp:Label ID="lblProjectTitle" runat="server" Text='<%# Eval("ProjectTitle")%>'></asp:Label>
                            </td>
                            <td class="left">
                                Danh mục:
                            </td>
                            <td>
                                <%# Eval("ProjectCategoryName")%>
                            </td>
                        </tr>
                    </table>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="ProjectSelectOne"
            TypeName="TLLib.Project">
            <SelectParameters>
                <asp:QueryStringParameter Name="ProjectID" QueryStringField="PI" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </fieldset>
    <br />
    <asp:RadAjaxPanel runat="server" ID="RadAjaxPanel1" ClientEvents-OnRequestStart="conditionalPostback">
        <asp:Panel ID="Panel1" DefaultButton="btnSearch" runat="server">
            <h4 class="searchTitle">
                Tìm kiếm
            </h4>
            <table class="search">
                <tr>
                    <td class="left">
                        Tiêu đề video
                    </td>
                    <td class="left">
                        <asp:RadTextBox ID="txtSearchTitle" runat="server" Width="300px">
                        </asp:RadTextBox>
                    </td>
                    <td class="left">
                        Mô tả video
                    </td>
                    <td>
                        <asp:RadTextBox ID="txtSearchDescription" runat="server" Width="300px">
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
        <asp:RadListView runat="server" ID="RadListView1" DataSourceID="ObjectDataSource1"
            AllowPaging="True" DataKeyNames="ProjectVideoID" OverrideDataSourceControlSorting="True"
            OnItemCreated="RadListView1_ItemCreated" OnItemCommand="RadListView1_ItemCommand">
            <LayoutTemplate>
                <div id="list">
                    <asp:Panel runat="server" ID="Panel1" Style="float: left; margin-left: 160px" Visible="<%#Container.PageCount > 1 %>">
                        <asp:RadButton runat="server" ID="PrevButton" CommandName="Page" CommandArgument="Prev"
                            Text="Trang trước" Enabled="<%#Container.CurrentPageIndex > 0 %>" />
                        <asp:RadButton runat="server" ID="NextButton" CommandName="Page" CommandArgument="Next"
                            Text="Trang kế" Enabled="<%#Container.CurrentPageIndex < Container.PageCount - 1 %>" />
                    </asp:Panel>
                    <table width="100%" class="command" style="border-collapse: collapse">
                        <tr>
                            <td>
                                <asp:LinkButton ID="lnkAdd" runat="server" CommandName="InitInsert" CssClass="item"
                                    ForeColor="Green"><img class="vam" alt="" src="../assets/images/add.png" /> Thêm mới</asp:LinkButton>|
                                <asp:LinkButton ID="LinkButton6" runat="server" CommandName="QuickUpdate" CssClass="item"
                                    ForeColor="Green"><img class="vam" alt="" src="../assets/images/accept.png" /> Sửa nhanh</asp:LinkButton>|
                                <asp:LinkButton ID="LinkButton1" OnClientClick="return confirm('Xóa tất cả dòng đã chọn?')"
                                    runat="server" CommandName="DeleteSelected" CssClass="item" ForeColor="Green"><img class="vam" alt="" title="Xóa tất cả dòng được chọn" src="../assets/images/delete-icon.png" /> Xóa</asp:LinkButton>|
                                <input id="chkSelectAll" type="checkbox" class="checkbox selectall" onchange="if($(this).attr('checked') == true) $('.select > input:checkbox').attr('checked','checked');else $('.select > input:checkbox').removeAttr('checked');" />Chọn
                                tất cả
                            </td>
                            <td align="right">
                                <asp:RadSlider runat="server" ID="RadSlider1" MaximumValue="3" MinimumValue="1" Value="1"
                                    LiveDrag="false" SmallChange="1" AutoPostBack="true" OnValueChanged="RadSlider1_ValueChanged"
                                    Width="150px" CausesValidation="false" Skin="Office2007" />
                            </td>
                        </tr>
                    </table>
                    <div style="clear: both;">
                    </div>
                    <fieldset runat="server" id="itemPlaceholder" />
                    <div style="clear: both;">
                    </div>
                </div>
            </LayoutTemplate>
            <ItemTemplate>
                <asp:HiddenField ID="hdnImagePath" runat="server" Value='<%# Eval("ImagePath") %>' />
                <asp:HiddenField ID="hdnVideoPath" runat="server" Value='<%# Eval("ProjectVideoPath") %>' />
                <fieldset style="float: left; margin: 5px 5px 50px 5px; padding: 2px 2px 2px 2px;
                    position: relative; background: #eeeeee" class="myClass" onmouseover="containerMouseover(this)"
                    onmouseout="containerMouseout(this)">
                    <object id="player" width="<%#ImageWidth %>" height="<%#ImageHeight %>" name="player"
                        classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
                        <param value="../../player.swf" name="movie">
                        <param value="true" name="allowfullscreen">
                        <param value="never" name="allowscriptaccess">
                        <param value="opaque" name="wmode">
                        <param value="file=res/project/video/<%# Eval("ProjectVideoPath") %>&image=../../res/project/video/thumbs/<%# Eval("ImagePath") %>&backcolor=111111&frontcolor=FFFFFF&controlbar=none"
                            name="flashvars">
                        <embed id="player2" width="<%#ImageWidth %>" height="<%#ImageHeight %>" flashvars="file=res/project/video/<%# Eval("ProjectVideoPath") %>&image=../../res/project/video/thumbs/<%# Eval("ImagePath") %>&backcolor=111111&frontcolor=FFFFFF&controlbar=none"
                            wmode="opaque" allowfullscreen="false" allowscriptaccess="never" src="../../player.swf"
                            name="player2" type="application/x-shockwave-flash">
                    </object>
                    <div style="margin-top: -30px; position: absolute; display: none; width: <%#ImageHeight.Value/1.5 %>px;">
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("Title") %>' CssClass="txt"></asp:Label>
                    </div>
                    <table style="bottom: -25px; position: absolute; width: <%#ImageHeight.Value %>px;
                        border-collapse: collapse; font-size: 8pt" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>
                                <asp:CheckBox ID="chkSelect" runat="server" ToolTip="Chọn" CssClass="select vam"
                                    onchange="if($(this).find('input:checkbox').attr('checked') == false) $('.selectall').removeAttr('checked');" />
                                <asp:RadNumericTextBox ID="txtPriority" runat="server" Width="35px" Height="13px"
                                    Text='<%# Eval("Priority") %>' EmptyMessage="Thứ tự..." Type="Number" ToolTip="Thứ tự">
                                    <NumberFormat AllowRounding="false" DecimalDigits="0" GroupSeparator="." />
                                </asp:RadNumericTextBox>
                                <asp:CheckBox ID="chkIsAvailable" runat="server" Checked='<%# string.IsNullOrEmpty(Eval("IsAvailable").ToString()) ? false : Eval("IsAvailable") %>'
                                    ToolTip="Hiển thị" TextAlign="Left" CssClass="checkbox vam" />
                            </td>
                            <td align="right">
                                <asp:LinkButton ID="btnEditSelected" runat="server" CommandName="Edit" CssClass="item"><img width="14px" class="vam" alt="" title="Sửa" src="../assets/images/tools.png" /></asp:LinkButton>
                                <asp:LinkButton ID="LinkButton1" OnClientClick="return confirm('Xóa video?')" runat="server"
                                    CommandName="Delete" CssClass="item"><img width="14px" class="vam" alt="" title="Xóa video" src="../assets/images/trash.png" /></asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </ItemTemplate>
            <InsertItemTemplate>
                <asp:Panel ID="Panel2" runat="server" DefaultButton="lnkUpdate">
                    <h3 class="searchTitle clear">
                        Thêm Video Mới</h3>
                    <table class="search">
                        <tr>
                            <td class="left">
                                File ảnh
                            </td>
                            <td>
                                <asp:RadUpload ID="FileImagePath" runat="server" ControlObjectsVisibility="None"
                                    Culture="vi-VN" Language="vi-VN" InputSize="70" AllowedFileExtensions=".jpg,.jpeg,.gif,.png" />
                                <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="Sai định dạng ảnh (*.jpg, *.jpeg, *.gif, *.png)"
                                    ClientValidationFunction="validateImage" Display="Dynamic"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="left">
                                File video
                            </td>
                            <td>
                                <asp:RadUpload ID="FileVideoPath" runat="server" ControlObjectsVisibility="None"
                                    Culture="vi-VN" Language="vi-VN" InputSize="70" AllowedFileExtensions=".flv,.mp4" />
                                <asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="Sai định dạng video (*.flv, *.mp4)"
                                    ClientValidationFunction="validateVideo" Display="Dynamic"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="left">
                                Tiêu đề video
                            </td>
                            <td>
                                <asp:TextBox ID="txtTitle" Width="500px" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="left" valign="top">
                                Mô tả video
                            </td>
                            <td>
                                <asp:TextBox ID="txtDescription" runat="server" Width="500px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="left">
                                Tiêu đề video(En)
                            </td>
                            <td>
                                <asp:TextBox ID="txtTitleEn" Width="500px" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="left" valign="top">
                                Mô tả video(En)
                            </td>
                            <td>
                                <asp:TextBox ID="txtDescriptionEn" runat="server" Width="500px"></asp:TextBox>
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
                                <asp:CheckBox ID="chkIsAvailable" runat="server" Checked='<%# (Container is RadListViewInsertItem) ? true : Eval("IsAvailable")%>'
                                    Text="Hiển thị" CssClass="checkbox" />
                            </td>
                        </tr>
                    </table>
                    <div class="edit">
                        <hr />
                        <asp:RadButton ID="lnkUpdate" runat="server" CommandName='PerformInsert' Text='Thêm'>
                            <Icon PrimaryIconUrl="~/ad/assets/images/ok.png" />
                        </asp:RadButton>
                        &nbsp;&nbsp;
                        <asp:RadButton ID="btnCancel" runat="server" CommandName='Cancel' Text='Hủy'>
                            <Icon PrimaryIconUrl="~/ad/assets/images/cancel.png" />
                        </asp:RadButton>
                    </div>
                    <div class="clear">
                    </div>
                </asp:Panel>
                <asp:RadInputManager ID="RadInputManager1" runat="server">
                    <asp:NumericTextBoxSetting AllowRounding="false" Type="Number" DecimalDigits="0"
                        EmptyMessage="Thứ tự ...">
                        <TargetControls>
                            <asp:TargetInput ControlID="txtPriority" />
                        </TargetControls>
                    </asp:NumericTextBoxSetting>
                </asp:RadInputManager>
            </InsertItemTemplate>
            <EditItemTemplate>
                <asp:HiddenField ID="hdnProjectVideoID" runat="server" Value='<%# Eval("ProjectVideoID") %>' />
                <asp:HiddenField ID="hdnImagePath" runat="server" Value='<%# Eval("ImagePath") %>' />
                <asp:HiddenField ID="hdnProjectVideoPath" runat="server" Value='<%# Eval("ProjectVideoPath") %>' />
                <asp:Panel ID="Panel2" runat="server" DefaultButton="lnkUpdate">
                    <h3 class="searchTitle clear">
                        Cập Nhật Video</h3>
                    <table class="search">
                        <tr>
                            <td class="left">
                                File ảnh
                            </td>
                            <td>
                                <asp:RadUpload ID="FileImagePath" runat="server" ControlObjectsVisibility="None"
                                    Culture="vi-VN" Language="vi-VN" InputSize="70" AllowedFileExtensions=".jpg,.jpeg,.gif,.png" />
                                <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="Sai định dạng ảnh (*.jpg, *.jpeg, *.gif, *.png)"
                                    ClientValidationFunction="validateImage" Display="Dynamic"></asp:CustomValidator>
                            </td>
                            <td rowspan="5" valign="top">
                                <asp:RadBinaryImage Style="display: block;" runat="server" ID="RadBinaryImage1" ImageUrl='<%# "~/res/project/video/thumbs/" + Eval("ImagePath") %>'
                                    Height='150' Width="150" ResizeMode="Fit" />
                            </td>
                        </tr>
                        <tr>
                            <td class="left">
                                File video
                            </td>
                            <td>
                                <asp:RadUpload ID="FileVideoPath" runat="server" ControlObjectsVisibility="None"
                                    Culture="vi-VN" Language="vi-VN" InputSize="70" AllowedFileExtensions=".flv,.mp4" />
                                <asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="Sai định dạng video (*.flv, *.mp4)"
                                    ClientValidationFunction="validateVideo" Display="Dynamic"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="left">
                                Tiêu đề video
                            </td>
                            <td>
                                <asp:TextBox ID="txtTitle" Width="500px" runat="server" Text='<%# Bind("Title") %>'></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="left" valign="top">
                                Mô tả video
                            </td>
                            <td>
                                <asp:TextBox ID="txtDescription" runat="server" Width="500px" Text='<%# Bind("Description")%>'></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="left">
                                Tiêu đề video
                            </td>
                            <td>
                                <asp:TextBox ID="txtTitleEn" Width="500px" runat="server" Text='<%# Bind("TitleEn") %>'></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="left" valign="top">
                                Mô tả video
                            </td>
                            <td>
                                <asp:TextBox ID="txtDescriptionEn" runat="server" Width="500px" Text='<%# Bind("DescriptionEn")%>'></asp:TextBox>
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
                                <asp:CheckBox ID="chkIsAvailable" runat="server" Checked='<%# Bind("IsAvailable")%>'
                                    Text="Hiển thị" CssClass="checkbox" />
                            </td>
                        </tr>
                    </table>
                    <div class="edit">
                        <hr />
                        <asp:RadButton ID="lnkUpdate" runat="server" CommandName='Update' Text='Cập nhật'>
                            <Icon PrimaryIconUrl="~/ad/assets/images/ok.png" />
                        </asp:RadButton>
                        &nbsp;&nbsp;
                        <asp:RadButton ID="btnCancel" runat="server" CommandName='Cancel' Text='Hủy'>
                            <Icon PrimaryIconUrl="~/ad/assets/images/cancel.png" />
                        </asp:RadButton>
                    </div>
                    <div class="clear">
                    </div>
                </asp:Panel>
                <asp:RadInputManager ID="RadInputManager1" runat="server">
                    <asp:NumericTextBoxSetting AllowRounding="false" Type="Number" DecimalDigits="0"
                        EmptyMessage="Thứ tự ...">
                        <TargetControls>
                            <asp:TargetInput ControlID="txtPriority" />
                        </TargetControls>
                    </asp:NumericTextBoxSetting>
                </asp:RadInputManager>
            </EditItemTemplate>
        </asp:RadListView>
        <asp:RadInputManager ID="RadInputManager1" runat="server">
            <asp:TextBoxSetting EmptyMessage="Tiêu đề video ...">
                <TargetControls>
                    <asp:TargetInput ControlID="txtTitle" />
                </TargetControls>
            </asp:TextBoxSetting>
            <asp:TextBoxSetting EmptyMessage="Mô tả video ...">
                <TargetControls>
                    <asp:TargetInput ControlID="txtDescription" />
                </TargetControls>
            </asp:TextBoxSetting>
            <asp:TextBoxSetting EmptyMessage="Tiêu đề video(En) ...">
                <TargetControls>
                    <asp:TargetInput ControlID="txtTitleEn" />
                </TargetControls>
            </asp:TextBoxSetting>
            <asp:TextBoxSetting EmptyMessage="Mô tả video(En) ...">
                <TargetControls>
                    <asp:TargetInput ControlID="txtDescriptionEn" />
                </TargetControls>
            </asp:TextBoxSetting>
            <asp:NumericTextBoxSetting AllowRounding="false" Type="Number" DecimalDigits="0"
                EmptyMessage="Thứ tự ...">
                <TargetControls>
                    <asp:TargetInput ControlID="txtPriority" />
                </TargetControls>
            </asp:NumericTextBoxSetting>
        </asp:RadInputManager>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" DeleteMethod="ProjectVideoDelete"
            SelectMethod="ProjectVideoSelectAll" TypeName="TLLib.ProjectVideo" UpdateMethod="ProjectVideoUpdate">
            <DeleteParameters>
                <asp:Parameter Name="ProjectVideoID" Type="String" />
            </DeleteParameters>
            <SelectParameters>
                <asp:Parameter Name="Keyword" Type="String" />
                <asp:ControlParameter ControlID="txtSearchTitle" Name="Title" PropertyName="Text"
                    Type="String" />
                <asp:ControlParameter ControlID="txtSearchDescription" Name="Description" PropertyName="Text"
                    Type="String" />
                <asp:QueryStringParameter Name="ProjectID" QueryStringField="PI" Type="String" />
                <asp:Parameter Name="IsAvailable" Type="String" />
                <asp:Parameter Name="Priority" Type="String" />
                <asp:Parameter Name="SortByPriority" Type="String" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="ProjectVideoID" Type="String" />
                <asp:Parameter Name="Title" Type="String" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="TitleEn" Type="String" />
                <asp:Parameter Name="DescriptionEn" Type="String" />
                <asp:Parameter Name="ConvertedTitle" Type="String" />
                <asp:Parameter Name="ImagePath" Type="String" />
                <asp:Parameter Name="ProjectVideoPath" Type="String" />
                <asp:QueryStringParameter Name="ProjectID" QueryStringField="PI" Type="String" />
                <asp:Parameter Name="IsAvailable" Type="String" />
                <asp:Parameter Name="Priority" Type="String" />
            </UpdateParameters>
        </asp:ObjectDataSource>
    </asp:RadAjaxPanel>
    <asp:RadProgressManager ID="RadProgressManager1" runat="server" />
    <asp:RadProgressArea ID="ProgressArea1" runat="server" Culture="vi-VN" DisplayCancelButton="True"
        HeaderText="Đang tải" Skin="Office2007" Style="position: fixed; top: 50% !important;
        left: 50% !important; margin: -93px 0 0 -188px;" />
</asp:Content>
