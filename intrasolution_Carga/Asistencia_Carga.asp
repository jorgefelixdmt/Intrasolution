
<%
Response.Expires = -3000
Response.Buffer = True
Server.ScriptTimeout=360

%>

<%


Acc = Request("Acc")

if Acc = "New" then
    Code = Request("Code")
    Id_Unidad = Request("Id_Unidad")
    wId_Usuario= Request("Id_Usuario")
    wEmpresa = Request("Empresa")
else
	'Variables
	Dim mySmartUpload, wObj,MiFSO
	Dim file,wErrorFile
		
	'Object creation
	'***************
    Set mySmartUpload = Server.CreateObject("aspSmartUpload.SmartUpload")

	'Upload
	'******
	mySmartUpload.MaxFileSize=50000000
	mySmartUpload.Upload
    Code = mySmartUpload.Form("Code")		
    Acc = mySmartUpload.Form("Acc")		
    Id_Unidad = mySmartUpload.Form("Id_Unidad")		
    wId_Usuario = mySmartUpload.Form("Id_Usuario")	
    wEmpresa = mySmartUpload.Form("Empresa")	
    wcap_curso_id = mySmartUpload.Form("cap_curso_id")	
    
end if

if not isObject(oConn) then
    Set oConn = Server.CreateObject("ADODB.Connection")		
    strConnQuery = Application(wEmpresa)
    oConn.Open(strConnQuery)		
end if  


Set wRsCurso = Server.CreateObject("ADODB.RecordSet") 
strSQL = "pr_Curso_En_Ejecucion_List " &  Id_Unidad
wRsCurso.Open strSQL, oConn



'Elimina el archivo excel 
NameFile1 ="ASISTENCIA-" & Id_Unidad & ".xls"

StrFile= Request.servervariables("APPL_PHYSICAL_PATH")  & "safe2biz_Carga\Files\" & wEmpresa & "\" & NameFile1

set fso = Server.CreateObject("Scripting.FileSystemObject")
if fso.FileExists(strFile) then
	fso.DeleteFile StrFile
end if

'Elimina Tabla Temporal y Tabla de Errores
Set oConn = Server.CreateObject("ADODB.Connection")		
strConnQuery = Application(wEmpresa)
oConn.Open(strConnQuery)
strSQL = "pr_Borra_Tmp_Carga_Asistencia " & Id_Unidad
oConn.Execute strSQL

strMensajeOK = ""            

if Acc <> "New" then
    Select Case Acc
    
        Case "Load"
            wErrorFile = ""
	        'Carga de Datos de Asp de Ingreso		
	        wtxtArchivoExcel = ""
        	
	        if mySmartUpload.Files.TotalBytes > 0 Then
		        wtxtNameExcel = mySmartUpload.Files.Item(1).FileName	
		        wtxtTamanoExcel = mySmartUpload.Files.Item(1).Size 
	        end if	
        	 
            NameFile1 ="ASISTENCIA-" & Id_Unidad & ".xls"
           
            StrFile= Request.servervariables("APPL_PHYSICAL_PATH")  & "safe2biz_Carga\Files\" & wEmpresa & "\" & NameFile1
           
	        if (mySmartUpload.Files.TotalBytes <= 50000000) and ucase(right(wtxtNameExcel,3)) = "XLS" Then
	            set MiFSO = Server.CreateObject("Scripting.FileSystemObject")
	            i = 0
	            For each file In mySmartUpload.Files
		            i = i + 1 
		            If file.size > 0 Then
			               file.SaveAs(StrFile)						
		            End If 
	            Next
	        Else
		        wErrorFile="EXCEL_ERROR"
	        End if
	        
	        if wErrorFile = "" then
	        
                Set mySmartUpload=Nothing
                set MiFSO =Nothing
                
                'copia del case SAVE
                NameFile1 ="ASISTENCIA-" & Id_Unidad & ".xls" 
                StrFile= Request.servervariables("APPL_PHYSICAL_PATH")  & "safe2biz_Carga\Files\" & wEmpresa & "\" & NameFile1

                'Crea una conexion al Excel y recupera la data en un Recordset
                Set cnADODBConnection = Server.CreateObject("ADODB.Connection")
                cnADODBConnection.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & StrFile & ";" & "Extended Properties=""Excel 8.0;IMEX=1;HDR=YES;"""

                Set objRS = Server.CreateObject("ADODB.Recordset")
                objRS.ActiveConnection = cnADODBConnection
                objRS.CursorType = 3 'Static cursor.
                objRS.LockType = 2 'Pessimistic Lock.

                sql = "Select * from [A1:G3000]" 
                objRS.Source = sql
                objRS.Open

                'Crea Conexion a la Base de Datos SQL
                if not isObject(oConn) then
                    Set oConn = Server.CreateObject("ADODB.Connection")		
                    strConnQuery = Application(wEmpresa)
                    oConn.Open(strConnQuery)		
                end if  
                                 
                wId_Carga = 0
                
                'Carga data del excel a tabla temporal
                 
                    Call CargaData()
                    
                    'Valida Data Cargada
                    Set wRsValida = Server.CreateObject("ADODB.Recordset")
                    strSQL = "pr_valida_carga_asistencia " & Id_Unidad & "," & wId_Carga

    	            wRsValida.Open strSQL, oConn

                    w_NumErrores = wRsValida("Numero_Errores")
                    
                    wFlagErrores = "0"
                    'Muestra Errores
                    if cint(w_NumErrores) > 0 then
                        wFlagErrores = "1"
                    else    
                        Set wRsCarga = Server.CreateObject("ADODB.Recordset")
                        strSQL = "pr_inserta_carga_asistencia " & Id_Unidad & "," & wId_Carga
            	        
    	                wRsCarga.Open strSQL, oConn
                        w_NumRegistros = wRsCarga("numero_registros")

                        strMensajeOK = "Archivo Grabado Correctamente: " & w_NumRegistros & " registros"
          
                    end if 
                 
                
                ObjRs.Close
                Set ObjRs = Nothing
                Set cnADODBConnection = Nothing
                set fso = Server.CreateObject("Scripting.FileSystemObject")
                
                if fso.FileExists(strFile) then
			        fso.DeleteFile StrFile
			    end if            
                Acc = "New"
            End if 
    End Select

end if

%>

<html>

<head>
<meta http-equiv="Content-Language" content="es-mx">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">

<title>eco2biz : Carga Masiva Asistencia</title>
<link rel="stylesheet" type="text/css" href="Estilos/IntraStyles.css">

</head>

<body bgcolor="#ffffff">


<table border="0" cellspacing="0" cellpadding="0" width="100%" class=Uno>
<tr>
	<td width="85%" class="TxtCab"><b>&nbsp;Carga Masiva :	Asistencia
	
	</b>
	</td>
	<td width="15%" align=right>&nbsp;</td>
	</tr>
	<tr>
		<td width="100%" colspan=2><hr size="1" class=ColorLine></td>
	</tr>
</table>

    <form Name="frmAsistencias" Action="asistencia_carga.asp" Method="POST"  ENCTYPE="multipart/form-data">
    <input type="Hidden" name="Code" value="<%=Code%>">
    <input type="Hidden" name="Acc" value="<%=Acc%>">
    <input type="Hidden" name="Id_Unidad" value="<%=Id_Unidad%>">
    <input type="Hidden" name="Id_Usuario" value="<%=wId_Usuario%>">
    <input type="Hidden" name="Empresa" value="<%=wEmpresa%>">

    <br>
    <table width=800 align=center>
    <tr>
    <td>
          <table border="0" cellspacing="0" cellpadding="0" width="600" bgcolor="#ffffff" class=dos>
                <tr>
				      <td  colspan=2 height=30 align="Left" valign=middle class=Header>&nbsp;<b>Carga de Asistencia</b></td>
                </tr>
			    <tr>
				    <td align=center Colspan="4" class=row1 height=30>&nbsp;</td>
			    </tr>
			    
                <tr>
				    <td align="right" class=row1 height=25><font face="Arial" size="2">Curso :</font></td>
				    <td COLSPAN="3" class=row1>
				    <select name="cap_curso_id" style="HEIGHT: 22px; font-family:arial; font-size:11px;">
				    <%Do while not wRsCurso.Eof%>
				        <option value="<%=wRsCurso("cap_curso_id")%>" <% if cint(wcap_curso_id) = cint(wRsCurso("cap_curso_id")) then Response.write "Selected"%>>  <%=wRsCurso("detalle_curso")%></option>
				     <%  wRsCurso.MoveNext
				      Loop %> 
				    </select>
                    </td>
			    </tr>
               
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
				      (*) Especificaciones del Archivo (<a href="ayuda/Manual_Asistencia_Carga.pdf"  target="_blank" ><b>Descargar</b></a>)<br />
    				   Plantilla de Ejemplo (<a href="ayuda/Modelo_Resultado_Carga.xls" target="_blank" ><b>Descargar</b></a>)
				      </td>
			    </tr>


	    </table>
	    </td>
    	
    </tr>	
    	
    </table>

</form>

<%if wFlagErrores="1" then%>

    <table align="center"><tr><td><a href="javascript:OpenWindowError();" >Se han encontrado errores en <%=w_NumErrores%> registros (Haga click para ver detalle).</a></td></tr></table>
<%end if%>

<p>&nbsp;</p>

</body>

</html>

<script LANGUAGE="JavaScript">


	function EjecutaAccion(Acc)
	{
        if (Acc=="Load" || (Acc=="Save" && "<%=wFlagError%>" == "" ))
        {
		    frmAsistencias.Acc.value=Acc; 
		    frmAsistencias.submit();
		 }
		 else{
		    alert("No se puede grabar el archivo por que tiene errores. Corrijalos y vuelva a cargarlo.");
		 }   
	}

<%if strMensajeOK <> "" then %> 
        alert("<%=strMensajeOK%>" );
<%end if%>    


</script>
<%
Sub CargaData()

        Set wRsConsulta = Server.CreateObject("ADODB.Recordset")
       
        '*** DATOS DE UEA para BV ****
        strSQL = "Select * from fb_uea_pe where fb_uea_pe_id=" & Id_Unidad
        wRsConsulta.Open strSQL, oConn
        
        w_Unidad = wRsConsulta("codigo")
        w_NombreUnidad = wRsConsulta("nombre")
        w_cdccia = wRsConsulta("compania")
        w_cnccco = wRsConsulta("centro_costo")
        w_tipevt = wRsConsulta("localidad")
        w_codevt = wRsConsulta("agi")

        wRsConsulta.Close

        '/*** Crea Registro de Carga ***/

        strSQL = "insert into cap_carga (descripcion,fecha_hora,fb_usuario_id,tipo_carga) values ("
        strSQL = strSQL + "'ASISTENCIA - Unidad:" & Id_Unidad & "' "
        strSQL = strSQL + ", getdate()"
        strSQL = strSQL + ", " & wId_Usuario & ""
        strSQL = strSQL + ", " & 1 & ")"
        oConn.Execute strSQL
      
	    Set wRsCarga = Server.CreateObject("ADODB.Recordset")
  	    strSQL = "Select Id_Carga from cap_carga order by Id_Carga desc"
	    wRsCarga.Open strSQL, oConn
	    wId_Carga = wRsCarga("Id_Carga")
	    wRsCarga.Close
	    
	    w_num_row = 1

        Do While Not objRS.Eof
          
              
              
                    w_num_row = w_num_row + 1    
                '**** carga a tabla temporal
                    strSQL = "set dateformat ymd insert into cap_asistencia_temporal (fb_uea_pe_id,cap_curso_id,dni_empleado,nombre_completo,nota,condicion,num_row,id_carga,fb_usuario_id,tipo_carga)"
                    strSQL = strSQL & " values ("
                    strSQL = strSQL &  "" & Id_Unidad & ","
                    strSQL = strSQL &  "" & wcap_curso_id & ","
                    strSQL = strSQL &  "'" & objRS(0) & "',"   'DNI Empleado
                    strSQL = strSQL &  "'" & objRS(1) & "',"   'Nombre Completo
                    if isNumeric(objRS(2))=true then
                        strSQL = strSQL &  "" & objRS(2) & ","     'Nota 
                        else
                        strSQL = strSQL & "NULL,"
                    end if
                    strSQL = strSQL &  "'" & objRS(3)  & "'," 'Condicion
                    strSQL = strSQL &  "" & w_num_row & ","
                    strSQL = strSQL &  "" & wId_Carga & ","
                    strSQL = strSQL &  "" & wId_Usuario & ","
                    strSQL = strSQL &  "" & 1 & ")"
		       
		            oConn.Execute strSQL
		            objRS.MoveNext        
		     
        Loop  
End Sub

 %>
 
<%
	Set wRsConsulta = Nothing
%>
<script type="text/javascript">
    if ("<%=wErrorFile%>" == "EXCEL_ERROR") { 
        alert("Archivo incorrecto. Por favor cargue un archivo de extension XLS")
    }

function OpenWindowError()
{
    ret = window.open("Asistencia_Carga_Errores.asp?EMPRESA=<%=wEmpresa%>&Id_Unidad=<%=Id_Unidad%>&Id_Carga=<%=wId_Carga%>", "Nombre", "width=750,height=420,top=100,left=180,scrollbars=1");
    
 }   
</script>