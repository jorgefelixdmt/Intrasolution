<%@ Language=VBScript %>
<!--#Include File="Includes/FuncionIdioma.asp"-->
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->

<%Response.AddHeader "Content-Type", "text/html;charset=ISO-8859-1"%>

<%
Response.Expires = -3000
Response.Buffer = True
Server.ScriptTimeout=30060

'Date dd/mm/yyyy
'Session.lcid= 2057 '= UK English
'On Error Resume Next
wFechadoc = "" ' Variable para validar formato de fecha del documento
wFechaIng = "" ' Variable para validar formato de fecha de ingreso
wFechaCese = ""
wNumeroRegistro = ""
wHoraRegistro = ""
wUnidad = ""
wCantidad = ""
Code =""
Acc =""
Id_Unidad =""
wEmpresa =""
wGrupo = ""
wcodigo_ticket =""

'Set mifichero = Server.CreateObject("Scripting.FileSystemObject")
''.OpenTextFile (fichero as String, modo as Integer)
'Set objFile = objFSO.OpenTextFile(Server.MapPath("texto.txt"),1)
''.ReadAll (mifichero)
'If Not objFile.AtEndOfStream Then
''  texto = CStr(objFile.ReadAll)
'End If

'Response.Write(texto)
'objFile.Close
'prj_Project_Save.asp' Nombre de Archivo 
'Parametros
    'titulo
    'id
    'contenido
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim fso, flee, JsonProjectFile, JsonProjectText
Set fso = Server.CreateObject("Scripting.FileSystemObject")
'Set fescribe = fso.OpenTextFile("X:\ASP_Intrasolution\intrasolution_Project\Ganttcon100tareas.txt", ForWriting, True)
'fescribe.Write "Hola se ha escrito el archivo3!"
'Cerrar e inicializar los objetos
Set fescribe = fso.OpenTextFile("E:\ASP\ASP_Intrasolution\intrasolution_Mobile\Ganttcon100tareas.txt", 1)
'response.write len(fescribe.ReadAll)
'response.write fescribe.ReadAll
datos = fescribe.ReadAll
datos = Replace(datos,"'","''")
'response.write datos
strSQL = "insert into pry_mpp_gantt_chart (titulo,json,fb_uea_pe_id,created,created_by,updated,updated_by,owner_id,is_deleted)"
strSQL = strSQL & " values ('test','" & datos & "',1,GETDATE(),1,GETDATE(),1,1,0)" 
        oConn.Execute strSQL
'response.write strSQL
'response.write datos
'response.write left(fescribe.ReadAll,40000)
'response.write "Segunda Cadena" & Mid(fescribe.ReadAll, 40000, len(fescribe.ReadAll))
  fescribe.Close
  Set fescribe = Nothing
  Set fso = Nothing

 'Cerrar e inicializar los objetos
 'Set fso2 = CreateObject("Scripting.FileSystemObject")
 'Set flee = objFSO.OpenTextFile("X:\ASP_Intrasolution\intrasolution_Project\miarchivo.txt", ForReading)
 'Response.Write flee.ReadAll
 'flee.Close
 'Set flee = Nothing
 'Set fso2 = Nothing
'If Not f.AtEndOfStream Then
 '' texto = CStr(f.ReadAll)
'End If
'Response.Write(texto)
'fso.Close
  
%>

<html>

<head>
<meta http-equiv="Content-Language" content="es-mx">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>eco2biz : Carga Datos Texto de Json</title>

</head>

<body bgcolor="#ffffff">
<!--
Modificado por Jorge Felix
Comentario: 'Se creo esta pagina para cargar en la base de datos un archivo texto en tres columnas
Fecha: 17/11/2021
-->

    <form Name="frmCargos" Action="Carga_datos_texto.asp" Method="POST"  ENCTYPE="multipart/form-data">
    <input type="Hidden" name="Code" value="<%=Code%>">
    <input type="Hidden" name="Acc" value="<%=Acc%>">
    <input type="Hidden" name="Id_Unidad" value="<%=Id_Unidad%>">
    <input type="Hidden" name="Id_Usuario" value="<%=wId_Usuario%>">
    <input type="Hidden" name="Empresa" value="<%=wEmpresa%>">
    <input type="Hidden" name="wGrupo" value="<%=wGrupo%>">
    <input type="Hidden" name="wcodigo_ticket" value="<%=wcodigo_ticket%>">
  
    <br>

 <table width=800 align=center>
    <tr>
    <td>
    <table border="0" cellspacing="0" cellpadding="0" width="600" bgcolor="#ffffff" class=dos>
					<tr>
				      <th colspan=2 height=30 align="Left" valign=middle class=Header>&nbsp;<b>CARGA ARCHIVO TEXTO : JSON</b></th>
					</tr>	
			    <tbody>   

			    <tr>
				      <td width="200" height=22 align="right" class=row1><b>Archivo Excel: </b></td>
				      <td class=row1 align=left>
				      <input TYPE="file" name="ArchivoFoto" SIZE="44%" class=txtcombo>
                      </td>
			    </tr>			   
	
			    <tr>
				    <td align=center Colspan="4" class=row1 height=30><input type="button" value="Cargar Archivo" id=button1 name=button1 onclick="javascript:EjecutaAccion('Load');"></td>
			    </tr>
                <tr>
				      <td colspan=2  height=22 align="center" class=row1>
                        <% 'If wRsCargas("Titulo_CargaMasiva") = "Punto_Monitoreo" Then %>
                            Plantilla de Ejemplo de Carga Masiva Temporal<a href="ayuda/plantilla_carga_masiva_objetos.xls" target="_blank" ><b> Descargar</b></a>
                        <% 'End If %>
				      </td>
			    </tr>
				<tbody>
	</table>
    </td>
    </tr>
</table>
</body>
</form>

</html>