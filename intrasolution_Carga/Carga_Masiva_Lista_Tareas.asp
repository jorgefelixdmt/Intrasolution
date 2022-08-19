
<%Response.AddHeader "Content-Type", "text/html;charset=ISO-8859-1"%>

<%
Response.Expires = -3000
Response.Buffer = True
Server.ScriptTimeout=360

'Date dd/mm/yyyy
Session.lcid= 2057 '= UK English
'On Error Resume Next
wFechadoc = "" ' Variable para validar formato de fecha del documento
wFechaIng = "" ' Variable para validar formato de fecha de ingreso
wFechaCese = ""
wNumeroRegistro = ""
wHoraRegistro = ""
wUnidad = ""
wCantidad = ""

%>

<%
Acc = Request("Acc")
Modal = 0
if Acc = "New" then
    Id_Unidad = Request("Id_Unidad")
    wId_Usuario= Request("Id_Usuario")

    wEmpresa = Request("Empresa")
    wGrupo = Request("Grupo")
    'w_cm_CargaMasiva_id = 3 '- ID de Estructura de Carga Masiva 
else
	'Variables
	Dim mySmartUpload, wObj,MiFSO
	Dim file,wErrorFile

	'Object creation
	'***************
    Set mySmartUpload = Server.CreateObject("aspSmartUpload.SmartUpload")

	'Upload
	'******
	mySmartUpload.MaxFileSize=500000000
	mySmartUpload.Upload
	
    Id_Unidad = mySmartUpload.Form("Id_Unidad")		
    wId_Usuario = mySmartUpload.Form("Id_Usuario")	
    
    wEmpresa = mySmartUpload.Form("Empresa")	
    wGrupo =  mySmartUpload.Form("wGrupo")
    wcodigo_ticket = mySmartUpload.Form("Incidencia")	

end if

if not isObject(oConn) then
    Set oConn = Server.CreateObject("ADODB.Connection")		
    strConnQuery = Application(wEmpresa)
    oConn.Open(strConnQuery)		
end if  
   Set wRsIncidencia = Server.CreateObject("ADODB.recordset")
	wSQL = "SELECT "
	wSQL = wSQL + " inc_incidencia_id, "
	wSQL = wSQL + " codigo_ticket"
	wSQL = wSQL + " FROM inc_incidencia "
	wSQL = wSQL + " Where fb_empleado_id =(select fb_empleado_id from sc_user where "    
	wSQL = wSQL + " sc_user_id = " & wId_Usuario & ")"

	wRsIncidencia.Open wSQL, oConn
   
'-- VARIABLES IMPORTANTES
wIP_Address = Request.ServerVariables("remote_addr")
wSession_Id = Session.SessionID
wMensajeErrorStore =""
strMensajeOK = ""  
'CargaExito = "0"
wMensajeError = ""

if Acc <> "New" then

wHoraArchivo = replace(mid(Time(),1,8),":","")+Id_Unidad
    '-- ARMA nombre del archivo que se grabara con el archivo UPLOAD
    NameFile = "" '"carga_almacenamiento_temporal.xls"
    wErrorFile = ""
    wtxtArchivoCSV = ""
	
    if mySmartUpload.Files.TotalBytes > 0 Then
        wtxtNameFile = mySmartUpload.Files.Item(1).FileName	
        wtxtTamanoFile = mySmartUpload.Files.Item(1).Size 
    end if	
    NameFile = wHoraArchivo & wtxtNameFile
   '-- Establece en una variable la ruta del archivo
    StrFile= Request.servervariables("APPL_PHYSICAL_PATH")  & "intrasolution_carga\Files\" & wEmpresa & "\" & NameFile

    ExtFile = ucase(right(wtxtNameFile,3))      
 
    If (mySmartUpload.Files.TotalBytes <= 500000000) and ExtFile = "XLS" Then
	    NameFile = wHoraArchivo & wtxtNameFile '"carga_almacenamiento_temporal.XLS"

	    StrFile= Request.servervariables("APPL_PHYSICAL_PATH")  & "intrasolution_carga\Files\" & wEmpresa & "\" & NameFile

        set MiFSO = Server.CreateObject("Scripting.FileSystemObject")
        i = 0
        For each file In mySmartUpload.Files
            i = i + 1
            If file.size > 0 Then
                   file.SaveAs(StrFile)                     
            End If 
        Next
    Else   
        wErrorFile="EXTENSION_ERROR"
    End if

    if wErrorFile = "" then
    
        Set mySmartUpload=Nothing
        set MiFSO =Nothing

        'Crea una conexion al Excel y recupera la data en un Recordset, dependiendo del caso replica el nombre del archivo guardado
        if ExtFile = "XLS" then
	        NameFile = wHoraArchivo & wtxtNameFile '"carga_almacenamiento_temporal.xls"
	        StrFile= Request.servervariables("APPL_PHYSICAL_PATH")  & "intrasolution_carga\Files\" & wEmpresa & "\" & NameFile
	        Set cnADODBConnection = Server.CreateObject("ADODB.Connection")
	        cnADODBConnection.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & StrFile & ";" & "Extended Properties=""Excel 8.0;IMEX=1;HDR=YES;"""
            'cnADODBConnection.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & StrFile & ";" & "Extended Properties=""Excel 12.0;IMEX=1;HDR=YES;"""
	        Set objRS = Server.CreateObject("ADODB.Recordset")
	         objRS.ActiveConnection = cnADODBConnection
	         objRS.CursorType = 3 'Static cursor.
	         objRS.LockType = 2 'Pessimistic Lock.
            
	         sql = "Select * from [A1:Y3000]" 
	         objRS.Source = sql
	         objRS.Open
          
        end if     

        'Crea Conexion a la Base de Datos SQL
        if not isObject(oConn) then
            Set oConn = Server.CreateObject("ADODB.Connection")		
            strConnQuery = Application(wEmpresa)
            oConn.Open(strConnQuery)		
        end if  
                       
        
        'Carga data del excel a tabla temporal
        CargaExito = "3"

        Call CargaTablaTemporal()
        
        'Si Carga data no tiene errores continua
        	
        Acc = "New"
    End if 
end if

%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" integrity="sha384-DyZ88mC6Up2uqS4h/KRgHuoeGwBcD4Ng9SiP4dIRy0EXTlnuz47vAwmeGwVChigm" crossorigin="anonymous">
    <!--link rel="stylesheet" href="css/estilo.css"-->
    <script src="js/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="style/estilo.css">
    <link rel="stylesheet" href="style/reducido.css">
    <!--script src="js/index.js"></script-->
    
</head>

<!-- 
    Autor: Jorge Felix
    Comentario: Nueva version de la entrega de objetos que muestra un nuevo diseño, se quitaron campos y se agregó campo fecha
    Fecha:          
-->

<body>
 <div class="container card-0 justify-content-center "> 
        <div style="position:absolute; top:500; left:50%;"><img id="waiting" width="50" height="50" src="cargando.gif" hidden /></div> 
            <div class="row justify-content-center round">
                <div class="col-lg-10 col-md-12 ">  
                    <form Name="frmCargos" Action="Carga_Masiva_Lista_Tareas.asp" Method="POST"  ENCTYPE="multipart/form-data">
                        <input type="Hidden" name="Code" value="<%=Code%>">
                        <input type="Hidden" name="Acc" value="<%=Acc%>">
                        <input type="Hidden" name="Id_Unidad" value="<%=Id_Unidad%>">
                        <input type="Hidden" name="Id_Usuario" value="<%=wId_Usuario%>">
                        <input type="Hidden" name="Empresa" value="<%=wEmpresa%>">
                        <input type="Hidden" name="wGrupo" value="<%=wGrupo%>">
                        <div class="card shadow card-1">
                            <div class="card-header titulo">
                                CARGA MASIVA: Lista Tareas
                            </div>
                            <div class="card-body inner-card">
                                
                                <div class="row justify-content-center">
                                    <div class="col-md-12 col-lg-12"> 
                                        <div class="form-group files" data-before="Arrastre y deje el archivo excel aqu&iacute; ">
                                            <label class="my-auto">Cargue su archivo </label> 
                                            <!--input id="entry_value" type="file" ref="fileInput" name="file" class="form-control" onchange="getFileName()"-->
                                            <input id="file" type="file" ref="fileInput" name="file" class="form-control" onchange="getFileName()">
                                        </div>
                                    </div>
                                </div>
                                <div class="row justify-content-center">
                                        <div class="form-group">
                                            <label for="Company-Name">Archivo</label> 
                                            <input class="form-control form-control-sm" id="fileName" type="text" placeholder="archivo excel" aria-label="Disabled input example" >
                                        </div>
                    
                                </div>
<br>
                                <div class="row justify-content-center">
                                        <div class="col-lg-12">
                                            <p class="text-center">Archivo de Ayuda de Carga Masiva (<a href="ayuda/plantilla_carga_masiva_objetos.xls" target="_blank"><b>Descargar Ayuda</b></a>)</p>
                                            <p class="text-center">Plantilla de Ejemplo de Carga Masiva (<a href="ayuda/plantilla_carga_masiva_objetos.xls" target="_blank"><b>Descargar Plantilla</b></a>)</p>
                                        </div> 
                                </div>
                                <div class="row justify-content-center">
                                        <div class="col-lg-12 col-md-12 ">
                                            <div class="d-grid gap-4 d-md-flex justify-content-md-center">
                                                <button class="btn btn-danger me-md-2" type="button" value="Cargar Archivo" id=button1 name=button1 onclick="javascript:EjecutaAccion('Load');">Carga de datos</button>
                                                <button class="btn btn-outline-danger button1 abs-center" type="button"> <small class="font-weight-bold">Cancelar</small> </button>

                                            </div> 
                                        </div>              
                                </div>
                            
                            </div>
                        </div>
                    </form>

                </div>
            </div>        
    </div>

</body>


</html>

<%

Sub CargaTablaTemporal()

    NumCampos = 11

    'Recupero datos de usuario
    Set wRsUsuario = Server.CreateObject("ADODB.Recordset")
    wSQL = "select name, email from sc_user where is_deleted = 0 and sc_user_id = " & wId_Usuario
    wRsUsuario.Open wSQL, oConn
    
    'Codigo Autogenerado
    Set wRsCodigo = Server.CreateObject("ADODB.Recordset")
    wSQL = "select count(*) as contador, max(codigo) as codigo from ta_carga_lista_tareas where is_deleted = 0"
    wRsCodigo.Open wSQL, oConn   

    If  wRsCodigo("contador") > 0 Then
        wCodigo = cint(Right(wRsCodigo("codigo"),4))
        wCodigo = wCodigo + 1
        wCodigoAudit = "CM-" +  Right("0000" + cstr(wCodigo),4)
    Else 
        wCodigoAudit = "CM-0001"
    End if
    
    filename = StrFile
    colDato = ""

    wOperador = wRsUsuario("name")
    wEmail = wRsUsuario("email")
    wFecha = cstr(day(Now)) +"/"+ cstr(Month(Now)) +"/"+ cstr(year(Now))
    wHora = mid(Time(),1,5)
              
    if ExtFile = "XLS" then
        ' Cargo la tabla cabecera
        strSQL = "set dateformat dmy insert into ta_carga_lista_tareas(codigo,fecha,hora,operador,correo_operador,nombre_archivo,ruta_archivo,estado,fb_uea_pe_id,created,created_by, is_deleted)values('" & wCodigoAudit & "','" & wFecha & "','" & wHora & "','" &  wOperador & "','" & wEmail & "','" & NameFile & "','" & StrFile & "',1," & Id_Unidad & ",'" & wFecha & "'," & wId_Usuario & ",0)" 
        oConn.Execute strSQL

        ' Obtengo Id del ultimo Registro
        Set wRsUltimo = Server.CreateObject("ADODB.Recordset")
        wSQL = "select max(ta_carga_lista_tareas_id) as ultimo_id from ta_carga_lista_tareas where is_deleted = 0"
        wRsUltimo.Open wSQL, oConn
        wIdUltimo = wRsUltimo("ultimo_id")
        wSQL1 = "set dateformat dmy insert into ta_carga_lista_tareas_detalle(codigo_tipo_tarea,codigo_subtipo_tarea,codigo_ticket_incidencia,codigo_cliente,codigo_proyecto,codigo_pase,fecha_hora_incio,horas_trabajo,titulo_tarea,descripcion_tarea,observaciones,fb_uea_pe_id,estado,created,created_by,is_deleted, ta_carga_lista_tareas_id)"
        'Lee cada registro del excel para insertarlo en la tabla temporal
        NumRegistro = 0
        
        objRS.MoveFirst
        Do While Not objRS.Eof
	        ' Arma la cadena con los valores que se van a grabar en la tabla temporal
	        wSQL2 = ""
            wSQL = ""

            If not isNull(objRs(8)) Then
                wFechaObjeto = objRs(8)
            Else
                wFechaObjeto = Null
            End If

            IF not isNull(objRs(0)) Then
                wNumeroRegistro = objRs(0)
            Else 
                 wNumeroRegistro = ""
            End If

            IF not esValidoFecha(wFechaObjeto) then
                'wMensajeError = "El dato Fecha no es válido " '& wZona
                'CargaExito = "0"
                'exit do 
            End If


            If IsNull(wNumeroRegistro) or wNumeroRegistro = "" Then 
                CargaExito = "1"
                exit do 
            End If

	            For i = 1 to NumCampos 'Cargo cada columna en la variable
                        If Not isNull(objRs(i-1))  Then
                            If i = 11 Then 'Se agrego replace para evitar comillas simples en comentario
                                colDato =  "'" + replace(cstr(objRS(i-1)),"'","''")+ "'" 
                            Else
                                colDato =  "'" + cstr(objRS(i-1)) + "'" 
                            End if
                        Else
                                colDato = "Null"
     
                        End If

                        If i = 11 Then
                            wSQL2 = wSQL2 + colDato 
                        Else
                            wSQL2 = wSQL2 + colDato + ","
                        End If
	            Next  
              wSQL = wSQL1 + "values(" + wSQL2 + "," + cstr(Id_Unidad) + ",1,'" + cstr(wFecha) + "'," + wId_Usuario + ",0," + CStr(wIdUltimo) + ")"
	            oConn.Execute wSQL
                objRS.MoveNext 

                CargaExito = "1"
            'End If
        Loop
        objRS.close  
        set objRS = nothing
        cnADODBConnection.close
        set cnADODBConnection = nothing
    End if

    If CargaExito="0" Then
        strSQL = "set dateformat dmy Delete from pa_carga_lista_objetos where pa_carga_lista_objetos_id =" & wIdUltimo
        oConn.Execute strSQL

        strSQL1 = "set dateformat dmy Delete from pa_carga_lista_objetos_detalle where pa_carga_lista_objetos_id =" & wIdUltimo
        oConn.Execute strSQL1
    End If
    If CargaExito = "1" Then 
        ' Recupero si hay error en data para cargar
        'wValidaError = 1 ' momentaneo
        Set wRsProcesaCarga = Server.CreateObject("ADODB.RecordSet") 

        strSQL = "pr_pa_Procesa_Carga_Masiva_objetos " &  wIdUltimo & "," & wId_Usuario & "," & Id_Unidad

        wRsProcesaCarga.Open strSQL, oConn

        wValidaError = wRsProcesaCarga("valida_error")

            If wValidaError = 1 Then
                CargaExito = "0"
                wMensajeError = "Errores encontrados se han registrado en tabla revision"
                Response.Write wMensajeError
                wError = "1"
            Else
                CargaExito = "1"
                filename = StrFile 

                Set fso = Server.CreateObject("Scripting.FileSystemObject")
                if (fso.FileExists(filename)) then
                    fso.DeleteFile filename,true
                    'Response.Write "<font size=2 color=blue>Borrado el fichero " & filename & " </font>"
                    Response.Write "<font size=2 color=black>Se ha registrado con exito </font>"
                else
                    Response.Write "<font size=2 color=blue>No existe el fichero " & filename & " </font>"
                end if

            End If
        wRsProcesaCarga.close
    End If
End Sub

function esValidoFecha(cadena) 
      set expReg = New RegExp
      expReg.Pattern = "^(0?[1-9]|[12][0-9]|3[01])[\/](0?[1-9]|1[012])[/\\/](19|20)\d{2}$"
      esValidoFecha = expReg.Test(cadena) and len(cadena) = 10
      set expReg = nothing
end function
function esValidoHora(cadena) 
      set expReg = New RegExp
      expReg.Pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$"
      'expReg.Pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])\s?(?:[aApP](\.?)[mM]\1)?$"
      esValidoHora = expReg.Test(cadena) and len(cadena) = 8
      set expReg = nothing
end function
function esValidoNumero(cadena) 
      set expReg = New RegExp
      expReg.Pattern = "^[1-9]\d*(\.\d+)?$"
      esValidoNumero = expReg.Test(cadena) and len(cadena) > 0
      set expReg = nothing
end function

%>
<script>
    var wError = "<%= wError %>"
    var wMensajeError = "<%= wMensajeError %>"
    var wCargaExito = "<%= CargaExito %>"
    var wValidaError = "<%= wValidaError %>"
</script>

<script src="js/index.js"></script>