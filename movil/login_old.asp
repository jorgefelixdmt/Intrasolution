<%
Response.Expires = -1

Dim  wPaginaComprueba, wFlagAutenticacion, wEmpresa

Response.Cookies("Usuario") = ""

wFlagAutenticacion = Session("wFlagAutenticacion")
wPaginaComprueba = Session("wPaginaComprueba")
wError = Request("Error")

wFlagAutenticacion = 0
wPaginaComprueba = "Comprueba.asp"

Login = request("TxtCodigo")
Password = request("TxtPassword")

If wError = "" Then
	wError = 0
End If

%>

<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">

    <title>Intrasolution: Software de Gestión Empresarial</title>
	<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" >
    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- font iconos -->
    <link rel="stylesheet" href="font-awesome/css/font-awesome.min.css">
 
</head>

<script language="JavaScript">	
	function window_onload() 
	{
		document.FrmDefault.TxtCodigo.select();
		document.FrmDefault.TxtCodigo.focus();
		document.FrmDefault.TxtCodigo.value="";
	}
	function Enter(e)
	{
		if (e.keyCode == 13) 
		document.FrmDefault.submit(); 
		//Verifica();
	}

	
function Verifica() 
{	
	var frmchpass = document.FrmDefault; 			

	<%if wFlagAutenticacion = 0 then%>
		var Login = frmchpass.TxtCodigo.value; 
		var Password = frmchpass.TxtPassword.value; 
		var mess=" Debe digitar un password\n Por favor Intente Nuevamente"  
		
		if (frmchpass.TxtPassword.value=="") 
		{
			alert(mess);
			return;
		} 
		else 
		{
			if (frmchpass.TxtCodigo.value.includes("@"))
			{
				document.FrmDefault.submit(); 
			}
			else
			{
				alert(mess);
				return;
			}
		}
<%else%>

		document.FrmDefault.submit(); 		
<%end if%>

}
</script>	

<body>
<div class="container"><!-- /inicio Container -->
<div class=""> <!-- contenido general verde -->
<div class="panel panel-primary"> <!-- inicio Cabacera verde y lineas de cuadro-->
<div class="panel-heading"> <!-- inicio titulo -->
<h5 class="panel-title"><i class="fa fa-spinner fa-spin"></i> &nbsp;&nbsp;Intrasolution : Software de Gestión Empresarial</h5>
</div> <!-- fin titulo -->
            
             
             <div class="row"><!-- inicio Row -->
              <div class="col-xs-12 col-sm-6 col-md-5 col-lg-5"><img src="images/eco1.jpg" width="100%" height="auto" class="img-responsive">
              <div class="hidden-xs"><img src="images/eco2.jpg" width="100%" height="auto" class="img-responsive"></div>
              
              </div>
  			<!--  <div class="col-xs-12 col-sm-6 col-md-5 col-lg-5 visible-lg"><img src="images/eco2.jpg" width="100%" height="auto" class="img-responsive"></div> -->
  			  
              <div class="col-xs-12 col-sm-6 col-md-7 col-lg-7"><!-- contenido para logo formulario -->
                
                 <div class="col-lg-12"> <img src="images/logo.png" class="img-responsive center-left"></div>
                 
            <div class="col-lg-12 well-sm">
            <!-- <h4>SISTEMA DE GESTION DE INFORMACION DE MEDIO AMBIENTE</h4> -->
            </div> 
            
            <div class="col-lg-12">
              <h5 class="form-signin-heading">Código y Contraseña</h5>
            </div>  
            
                       <div class="col-xs-12 col-sm-12  col-md-12 col-lg-8"> <!-- usuario password -->
                            <div>
                              <div>
                              <div class="form-group form line">

                                <form action="validaArroba.asp"  name="FrmDefault">
                                <!--form action="Comprueba.asp"  name="FrmDefault"-->
                                  <input type="hidden" id="Empresa" name="Empresa" value="<%=wEmpresa%>" class="form-control login-field" >
                                   <input type="email" id="TxtCodigo" name="TxtCodigo" placeholder="Introduce tu Código" class="form-control login-field"   >
                                   <i class="fa fa-user text-primary login-field-icon2"></i>
                               </div>
                                                               
                                <div class="form-group">
                                    <input id="password-field" name="TxtPassword" required type="password" class="form-control" placeholder="Contraseña" value="">
                                      <span toggle="#password-field" class="fa fa-eye text-primary login-field-icon xfa-fw  field-icon toggle-password"></span>
                                      <i class="fa fa-lock text-primary login-field-icon3"></i>
                                </div>
                                   
                                <a href="JavaScript: Verifica();"  class="btn btn-default btn-primary btn-block">Aceptar</a>
                                <br>
                                
                                </form>
                                
                               </div>
                               
                            </div>      
                          </div> <!-- fin usuario password -->
						  
            				
              </div><!-- fin contenido para logo formulario -->
			  
			  <%If cdbl(wError) = 1 Then%>
			  <center style="color:red"> Usuario o Contraseña Incorrecta </center>
			  <%End If%>
			  
			  <%If cdbl(wError) = 2 Then%>
			  <center style="color:red"> La Empresa no Existe </center>
			  <%End If%>
				  
              </div><!-- fin Row -->
              
             
              <div class="panel-heading"> <!-- texto pie color verde -->
                <h6 class="panel-title text-center">Intrasolution-Sistema de Gestión Empresarial </h6>
                 <h6 class="panel-title text-center">Derechos Reservados</h6>
                 <h6 class="panel-title text-center">INTRASOLUTION</h6>
              </div><!-- /fin pie color verde -->
           </div><!-- fin Cabacera verde -->

 </div> <!-- fin contenido general verde -->
 </div><!-- /fin Container -->


  <!-- JavaScript -->
    <script src="js/jquery-1.10.2.js"></script>
    <script src="js/bootstrap.min.js"></script>
     <script src="js/login.js"></script>
  </body>
</html>
