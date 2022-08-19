
<!--#Include File="Includes/FuncionIdioma.asp"-->
<!-- #INCLUDE FILE="Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="Includes/f_ValidaURL.asp" -->
<%
Function ReemplazaComilla(strTexto)
	ReemplazaComilla = replace(strTexto,"'","''")
End Function

Dim Accion,sCabezera,Id_MensajeIntranet
Dim wIdioma
  
'************************
' Request
'************************
Id_MensajeIntranet = Request("Code")
If Id_MensajeIntranet = "" then Id_MensajeIntranet = 0

Accion = Request("Acc")
wIdioma = Request.Cookies ("Usuario")("TipoIdioma")
FlagExist = "0"

Select Case Accion
	Case "Add"
		sCabezera = fIdioma("Txt_Nuevo")
		Accion = "Save"
	Case "Edit"

		Set objConn = server.CreateObject("IS_Forum_DB.Foro")
		Set ObjRs  = server.CreateObject("ADODB.Recordset")
		wSQL = "sp_MensajeIntranet_get '" & Id_MensajeIntranet & "'"
		Set ObjRs = objConn.ExecString(wSQL)	

		wtxtClave= ObjRs("Clave")	
		wtxtMensajeEsp = ObjRs("Mensaje_esp")	
		wtxtMensajePor = ObjRs("Mensaje_por")	
		wtxtMensajeIng = ObjRs("Mensaje_ing")	

		ObjRs.Close 
		set objConn = nothing	
		Set objRs = Nothing
		Accion = "Save"
	Case "Save"
		wtxtClave = request("txtClave")
		wtxtMensajeEsp = ReemplazaComilla(request("txtMensajeEsp"))		
		wtxtMensajeIng = ReemplazaComilla(request("txtMensajeIng"))
		wtxtMensajePor = ReemplazaComilla(request("txtMensajePor"))
		

		Set objConn = server.CreateObject("IS_Forum_DB.Foro")
		Set ObjRs  = server.CreateObject("ADODB.Recordset")

		Set Diccionario = Server.CreateObject("Scripting.Dictionary")
		Set Diccionario = Application("MessageManager")
		
			if Id_MensajeIntranet = 0 then
				wExiste = Diccionario.Exists(wTxtClave)


				if (wExiste And (Diccionario(wTxtClave) = "")) then 
					Diccionario.Remove(wTxtClave)
					
				end if

				if Diccionario.Exists(wTxtClave) then
					FlagExist = "1"
				else
					wMensaje = 	wtxtMensajeEsp & "|" & wtxtMensajeIng & "|" & wtxtMensajePor 
					Diccionario.Add wtxtClave,wMensaje		
					wSQL = "sp_MensajeIntranet_ins '" & wtxtClave & "','" & wtxtMensajeEsp & "','" & wtxtMensajePor & "','" & wtxtMensajeIng & "',0" 
					objConn.ExecStringsinRS(wSQL)		
				end if	
			else
				wMensaje = 	wtxtMensajeEsp & "|" & wtxtMensajeIng & "|" & wtxtMensajePor 		
				Application("MessageManager")(wtxtClave) = wMensaje 		
				wSQL = "sp_MensajeIntranet_upd " & Id_MensajeIntranet & ",'" & wtxtClave & "','" & wtxtMensajeEsp & "','" & wtxtMensajePor & "','" & wtxtMensajeIng & "'" 
				objConn.ExecStringsinRS(wSQL)						
			end if
		
			Set Application("MessageManager") = Diccionario
		
			Set Diccionario = Nothing
			set objConn = nothing	
			Set objRs = Nothing
			
			if FlagExist = "0" then
				Response.Redirect "admin_MensajesIntranet.asp?CallSource=Retorno"
			end if	
End Select
%>
<html>
	<head>
		<title>IntraSolution</title>
		<script language="javascript">
		if ("<%=FlagExist%>" == "1") 
			alert("<%=fIdioma("Txt_MensajeIntranetExiste")%>");
		</script>
		<link rel="stylesheet" type="text/css" href="../Estilos/IntraStyles.css">
	</head>
	<body bgcolor="#FFFFFF">
		<center>
			<table border="0" width="100%" class="uno" ID="Table1">
				<tr>
					<td align="left" width="85%" class="txtcab">
						<b>
							<%=fIdioma("Txt_MensajeIntranet")%>
							:&nbsp;<font size="2"><%=sCabezera%></font></b>
					</td>
					<td width="15%" align="right">
						<a href="admin_MensajesIntranet.asp?CallSource=Retorno" class="TxtCab">
							<%=fIdioma("Txt_Regresar")%>
						</a>
					</td>
				</tr>
				<tr>
					<td align="center" colspan="2">
						<hr size="1" class="ColorLine">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<img src="../images/space.gif" width="10" height="10">
					</td>
				</tr>
			</table>
		</center>
		<center>
			<table border="0" cellspacing="0" cellpadding="1" width="95%" class="dos" align="center" ID="Table2">
				<tr>
					<td>
						<a href="JavaScript: Accion('Graba')"><img src="../images/<%=PrefijoIdioma(wIdioma)%>_btn_grabar.gif" name="Save" border="0" hspace="1"></a>
					</td>
					<td align="right">
						<a href="JavaScript: Accion('Cancela')"><img src="../images/<%=PrefijoIdioma(wIdioma)%>_btn_cancelar.gif" valign="center" name="Cancel" border="0" hspace="1"></a>
					</td>
				</tr>
			</table>
			<table border="0" cellspacing="0" cellpadding="0" width="95%" class="dos" align="center" ID="Table3">
				<form name="frmMensaje" method="post" action="Editar_MensajesIntranet.asp" ID="Form1">
					<input type="hidden" name="Acc" value="<%=Accion%>" ID="Hidden1"> <input type="hidden" name="AccAdic" value ID="Hidden2">
					<input type="hidden" name="Code" value="<%=Id_MensajeIntranet%>" ID="Hidden3">
					<tr>
						<td class="header" height="20" colSpan="2">
							<img src="../images/space.gif">
						</td>
					</tr>
					<tr>
						<td class="row1" height="22" align="right">
							<b class="asterisco">* </b><b>
								<%=fIdioma("Txt_ClaveMensaje")%>
								:</b>
						</td>
						<td class="row1" COLSPAN="2">
							<input name="txtClave" type="text" size="25" MAXLENGTH="250" value="<%=wTxtClave%>" class="txtcombo" ID="Text1"></td>

						</td>
						
					</tr>
					<tr>
						<td class="row1" height="22" align="right" width="25%">
							<b class="asterisco">* </b><b>
								<%=fIdioma("Txt_MensajeEspanol")%>&nbsp; :</b>
						</td>
						<td class="row1" width="75%">
							<TEXTAREA class="txtCombo" MAXLENGTH="255" rows=3 cols=50 name="txtMensajeEsp" ID="wtxtMensajeEsp"><%=wtxtMensajeEsp%></TEXTAREA>
						</td>
					</tr>
					<tr>
						<td class="row1" height="22" align="right" width="25%">
							<b class="asterisco">* </b><b>
								<%=fIdioma("Txt_MensajePortugues")%>&nbsp; :</b>
						</td>
						<td class="row1" width="75%">
							<TEXTAREA class="txtCombo" MAXLENGTH="255" rows=3 cols=50 name="txtMensajePor" ID="wtxtMensajePor"><%=wtxtMensajePor%></TEXTAREA>
						</td>
					</tr>
					<tr>
						<td class="row1" height="22" align="right" width="25%">
							<b class="asterisco">* </b><b>
								<%=fIdioma("Txt_MensajeIngles")%>&nbsp; :</b>
						</td>
						<td class="row1" width="75%">
							<TEXTAREA class="txtCombo" MAXLENGTH="255" rows=3 cols=50 name="txtMensajeIng" ID="wtxtMensajeIng"><%=wtxtMensajeIng%></TEXTAREA>
						</td>
					</tr>
					<tr>
						<td class="row1" height="30" align="right" colspan="2">
							<b class="asterisco">*</b><font class="textodetalle">&nbsp;<%=fIdioma("Txt_CampoObli")%></font>&nbsp;
						</td>
					</tr>
			</table>
		</center>
		</form>
	</body>

<script Language="JavaScript">
function Accion(Valor)
{
	if (Valor == "Cancela")
	{
		//'document.location.href = "../Administrador/Admin_MensajesIntranet.asp"
		document.location.href = "../Administrador/admin_MensajesIntranet.asp?CallSource=Retorno";
	}	
	else
	{
		if (document.frmMensaje.txtClave.value=="")
		{
			alert("<%=fIdioma("txt_DigiteClave")%>");
			document.frmMensaje.txtClave.focus();
		}
		else
		{
			document.frmMensaje.submit()
		}
	}
}
</script>
