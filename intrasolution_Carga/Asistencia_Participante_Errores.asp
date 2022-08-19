<%Response.AddHeader "Content-Type", "application/vnd.ms-excel;charset=ISO-8859-1"%>
<%Response.AddHeader "Content-Disposition", "attachment; filename=Asistencia_Error.xls"%>


<%

Id_Unidad = Request("Id_Unidad")
Id_Carga = Request("Id_Carga")
wEmpresa = Request("Empresa")

Set oConn = Server.CreateObject("ADODB.Connection")		
strConnQuery = Application(wEmpresa)
oConn.Open(strConnQuery)

Set wRsConsulta = Server.CreateObject("ADODB.Recordset")
strSQL = "Select * from cap_Asistencia_Temporal Where fb_uea_pe_id = " & Id_Unidad & " and Flag_Error = 1 and Id_Carga = " & Id_Carga

wRsConsulta.Open strSQL, oConn

Response.Write "<table border=1>"
Response.Write "<tr><td>Registro</td><td>dni_empleado</td><td>nombre_completo</td><td>Columnas con Errores</td></tr>"

Do While not wRsConsulta.EOF

    Response.Write "<tr><td>" &  wRsConsulta("num_row") & "</td>"
    Response.Write "<td>" &  wRsConsulta("dni_empleado") & "</td>"
    Response.Write "<td>" &  wRsConsulta("nombre_completo") & "</td>"
    Response.Write "<td>" &  wRsConsulta("descripcion_error") & "</td></tr>"
    wRsConsulta.MoveNext
    
Loop
Response.Write "</table>"

wRsConsulta.Close

Set OConn = Nothing

%>


