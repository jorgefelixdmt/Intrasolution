<!--#INCLUDE FILE="../Includes/Connection_inc.asp"-->
<%
 
'Server.ScriptTimeout = 360

'wUEA = Request("Id_Unidad") 'Request("UEA")
'wEmpresa = Request("Empresa")
'wId_Usuario = Request("Id_Usuario")
'wAnno = Request("Anno")

'strSQL = "select USER_LOGIN, PASSWORD from SC_USER where SC_USER_ID = " & wId_Usuario
'Set oRsUser = Server.CreateObject("ADODB.Recordset")
'oRsUser.Open strSQL, oConn
'wUser = oRsUser("USER_LOGIN")
'wPassword = oRsUser("PASSWORD")

'strSQL = "select VALUE from PM_PARAMETER where CODE = 'URL_APP'"
'Set oRsURL = Server.CreateObject("ADODB.Recordset")
'oRsURL.Open strSQL, oConn
'wURL_APP = oRsURL("VALUE")

'If wAnno = "" Then
'wAnno = 2016
'End If

'/* Lista de Años */
'strSQL = ""
'strSQL = strSQL & "Select distinct "
'strSQL = strSQL & "    Year(fecha_realizada) as Anno "
'strSQL = strSQL & " from exa_examen_medico em "
'strSQL = strSQL & " Where fb_uea_pe_id = " & wUEA
'strSQL = strSQL & "      and is_deleted = 0"
'strSQL = strSQL & " Order by Anno desc"
'Set oRsAnno = Server.CreateObject("ADODB.Recordset")
'oRsAnno.Open strSQL, oConn
'if oRsAnno.eof then
'wError = "1"
'response.write  "<span align=center ><b>No hay datos para esta Unidad</b></span>"
'response.end
'else
'if wAnno = "" then wAnno = oRsAnno("Anno")
'end if

'wSQL = "pr_documentos_home_cantidad_felix " & wUEA
'Set wRs = Server.CreateObject("ADODB.recordset")
'wRs.Open wSQL, oConn
'w_Cantidad_Total = wRs("Total")
'w_Cantidad_Anual = wRs("TotalAnual")
'w_Cantidad_Mensual = wRs("TotalMensual")

'wSQL1 = "Set Language spanish "
'wSQL1 = "Select eva_Evaluacion_id, codigo, titulo, CONVERT(VARCHAR(6),fecha_inicio,6) as fecha,"
'wSQL1 = wSQL1 & "dbo.f_eva_hallazgos(eva_evaluacion_id, 'NC') as NoConformidades,"
'wSQL1 = wSQL1 & "dbo.f_eva_hallazgos(eva_evaluacion_id, 'OBS') as OBS,"
'wSQL1 = wSQL1 & "dbo.f_eva_hallazgos(eva_evaluacion_id, 'OM') as OM,"
'wSQL1 = wSQL1 & "dbo.f_eva_acciones(eva_evaluacion_id,'EJECUTADO') as EJECUTADO,"
'wSQL1 = wSQL1 & "dbo.f_eva_acciones(eva_evaluacion_id,'TOTAL') as TOTAL "
'wSQL1 = wSQL1 & "From eva_evaluacion eva where eva.eva_tipo_evaluacion_id = 2"
'wSQL1 = wSQL1 & "and eva.fb_uea_pe_id =" & wUEA
'Set wRsAud = Server.CreateObject("ADODB.recordset")
'wRsAud.Open wSQL1, oConn

%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Home Principal</title>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/peity/3.2.1/jquery.peity.min.js"></script>
  <script src="js/RGraph.common.core.js"></script>
  <script src="js/RGraph.common.dynamic.js"></script>
  <script src="js/RGraph.meter.js"></script>
  <script src="./js/home_primax_script.js"></script>
  <link rel="stylesheet" href="./css/home_primax_style.css">
</head>

<body>
  <div id="container" class="container" data-uea="<%=wUEA%>" data-empresa="<%=wEmpresa%>" data-user="<%=wUser%>" data-pass="<%=wPassword%>" data-urlApp="<%=wURL_APP%>">
    <div id="chartjs-tooltip"><table></table></div>
    <div class="row" style="margin-top:10px; margin-bottom:10px;">
      <div class="col-sm-8"></div>
      <div class="col-sm-4">

        <%
        'Render them in drop down box Año
        'Response.write "<SELECT id='anno' NAME='Anno'  size='1' size='1' class='form-control' onchange='onLoadCharts()'>"
                'While not oRsAnno.EOF
        'if int(wAnno) = int(oRsAnno("Anno")) then
                'Response.Write "<OPTION value='" & orsAnno("Anno") & "' selected>&nbsp;" & orsAnno("Anno") & "&nbsp;&nbsp;</OPTION>"
        'else
                'Response.Write "<OPTION value='" & orsAnno("Anno") & "'>&nbsp;" & orsAnno("Anno") & "&nbsp;&nbsp;</OPTION>"
        'end if
                'oRsAnno.MoveNext()
        'Wend
                'Response.write "</SELECT>"
        %>

      </div>
    </div>
    <div class="row">
      <!-- Capacitacion Texto -->
      <div class="col-sm-6">
        <div class="panel panel-primary">
          <div class="panel-heading"><b>CAPACITACIÓN</b></div>
          <div class="panel-body">
            <ul>
              <li> Cursos Dictados: <b><span id="cantCursos" style="font-size:10pt">0</span></b> </li>
              <li> Asistentes a los cursos: <b><span id="cantAsist" style="font-size:10pt">0</span></b> </li>
              <li> Trabajadores capacitados: <b><span id ="cantPersonas" style="font-size:10pt">0</span></b> </li>
              <li> Horas de Capacitación Realizadas: <b><span id ="totalHoras" style="font-size:10pt">0</span></b> </li>
              <li> H.H. de capacitación promedio por Empleado: <b> <span id="horaProm" style="font-size:10pt">0</span></b> </li>
            </ul>
          </div>
        </div>
      </div>
      <!-- Capacitacion -->
      <div class="col-sm-6">
        <div class="panel panel-primary">
          <div class="panel-heading"><b>CAPACITACION</b></div></b>
          <div class="panel-body">
            <div class="row vertical-align-meter">
              <div class="col-md-6 nopadding">
                <canvas id="cvs">
                  [No canvas support]
                </canvas>
              </div>
              <div class="col-md-6" style="text-align: center">
                Horas de capacitación programada : <b><span id="hhCap">0</span></b>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Accidentes -->
      <div class="col-sm-6">
        <div class="panel panel-primary">
          <div class="panel-heading"><b>ACCIDENTES E INCIDENTES</b></div>
          <div class="panel-body">
            <div class="row vertical-align">
              <div class="col-sm-6 nopadding vertical-align">
                <canvas id="accChart" class="chart" width="100px" height="100px"></canvas>
              </div>
              <div class="col-sm-6" style="text-align: center"  >
                <font size="7"><strong id="accidentes">...</strong></font><font size="5"> reportes de investigación</font>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Examenes Medicos -->
      <div class="col-sm-6">
        <div class="panel panel-primary">
          <div class="panel-heading"><b>EXÁMENES MÉDICOS POR ACTITUD</b></div>
          <div class="panel-body">
            <div class="row vertical-align">
              <div class="col-sm-6 nopadding vertical-align">
                <canvas id="exaChart" class="chart" width="100px" height="100px"></canvas>
              </div>
              <div class="col-sm-6" style="text-align: center">
                <font size="7"><strong id="examenes">...</strong></font><font size="5"> exámenes realizados</font>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Sistema de Gestion de archivos -->
      <div class="col-sm-6">
        <div class="panel panel-primary">
          <div class="panel-heading"><b>SISTEMA DE GESTION: DOCUMENTACION</b></div>
          <div class="panel-body">
            <ul>
              <li>
                Documentos Totales = (<%'=w_Cantidad_Total%>)       <!--Politica SST (Act. 20/10/2017).-->
              </li>
              <li>
                Documentos Anual = (<%'=w_Cantidad_Anual%>)    <!--Reglamento Interno SST (Act 15/09/2017).-->
              </li>
              <li>
                Documentos Mensual = (<%'=w_Cantidad_Mensual%>)
              </li>
            </ul>
          </div>
        </div>
      </div>
      <!-- Sac -->
      <div class="col-sm-6">
        <div class="panel panel-primary">
          <div class="panel-heading"><b>SAC - ESTADOS</b></div>
          <div class="panel-body">
            <div class="row vertical-align">
              <div class="col-sm-6 nopadding vertical-align">
                <canvas id="sacChart" class="chart" width="100px" height="100px"></canvas>
              </div>
              <div class="col-sm-6" style="text-align: center">
                <font size="7"><strong id="acciones">...</strong></font><font size="5"> acciones</font>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Auditorias -->
      <div class="col-sm-6">
        <div class="panel panel-primary">
          <div class="panel-heading"><b>AUDITORIAS</b></div>
          <div class="table-responsive">
            <table class="table table-striped table-condensed" style="font-size:0.7rem">
              <thead>
                <tr>
                  <th></th>
                  <th>TITULO</th>
                  <th>FECHA</th>
                  <th>NC</th>
                  <th>OBS</th>
                  <th style="text-align:center; min-width:60px; max-width:60px;">ACC</th>
                </tr>
              </thead>
              <tbody style="font-size:0.7rem">
                <%
                'While not wRsAud.EOF
                                'wTituloAud = wRsAud("titulo")
                'wAudFecha = wRsAud("fecha")
                                'wAudNC = wRsAud("NoConformidades")
                'wAudOBS = wRsAud("OBS")
                                'if wRsAud("TOTAL") <> "0" then
                'wAudACC = CInt(wRsAud("EJECUTADO")) / CInt(wRsAud("TOTAL"))
                                'wAudAccString = wRsAud("EJECUTADO") & "/" & wRsAud("TOTAL")
                'wAudPorcentaje = Round(wAudACC * 100)
                                'if wAudACC = 1 then
                'wAudSemaforo = "./images/sem-ver.png"
                                'else
                'wAudSemaforo = "./images/sem-roj.png"
                                'end if
                'else
                                'wAudACC = "1"
                'wAudPorcentaje = 100
                                'wAudSemaforo = "./images/sem-ver.png"
                'end if
                %>
                <tr>
                  <td><img src="<%'=wAudSemaforo%>" alt="ver"></td>
                  <td><%=wTituloAud%></td>
                  <td><%=wAudFecha%></td>
                  <td><%=wAudNC%></td>
                  <td><%=wAudOBS%></td>
                  <td style="text-align: right;"><%'=wAudPorcentaje%>% <span class="pie"><%'=wAudAccString%></span></td>
                </tr>
                <%
                'wRsAud.MoveNext()
                'Wend
                %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

  </div>
</div>

</body>
</html>
