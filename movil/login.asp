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
  
<!-- Mirrored from safe2biz.com/app-prueba/login/login.html by HTTrack Website Copier/3.x [XR&CO'2010], Thu, 19 Nov 2020 19:09:41 GMT -->
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
	
    <title>Intrasolution :: Portal de Informaciones</title>

    
   
    <link rel="shortcut icon" type="image/x-icon" href="images/favicon.ico" />
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

<body><br>
<div class="container"><!-- /inicio Container -->
<div class="col-lg-12"> <!-- contenido general verde -->
<div class="panel panel-primary"> <!-- inicio Cabacera verde y lineas de cuadro-->
<div class="panel-heading"> <!-- inicio titulo -->
<h3 class="panel-title"><i class="fa fa-cog fa-spin"></i> &nbsp;&nbsp;Intranet: Portal de Informaciones</h3>
</div> <!-- fin titulo -->
            
             
             <div class="row"><!-- inicio Row -->
              <div class="col-xs-12 col-sm-6 col-md-5 col-lg-5"><img src="images/safe2.png" width="500" height="402" class="img-responsive"></div>
  				<div class="col-xs-12 col-sm-6 col-md-7 col-lg-7"><!-- contenido para logo formulario -->
                <br>
                 <div class="col-lg-12"> <img src="images/logo-safe.png" class="img-responsive center-left"></div>
                 
            <div class="col-lg-12 well-sm">
            <!-- <h4>INTRANET</h4>  -->
            </div> 
            
            <div class="col-lg-12">
              <h5 class="form-signin-heading">Usuario y Password</h5>
            </div>  
                            <div class="col-lg-6"> <!-- usuario password -->
                            <div>
                              <div>
                                 
                                  <div class="form-group form line">
                                  <form action="validaArroba.asp"  name="FrmDefault">
                                    <input type="hidden" id="Empresa" name="Empresa" value="<%=wEmpresa%>" class="form-control login-field">
                                    <!--input type="email" id="username" placeholder="Introduce tu Usuario" class="form-control login-field" -->
                                    <input type="email" id="TxtCodigo" name="TxtCodigo" placeholder="Introduce tu Usuario" class="form-control login-field">
                                    <i class="fa fa-user text-danger login-field-icon2"></i>
                                </div>
                                    <div class="form-group">
                                      <!--input id="password-field" type="password" class="form-control" name="password" placeholder="Password" value=""-->
                                      <input id="password-field" name="TxtPassword" required type="password" class="form-control" placeholder="Contraseña" value="">
                                      <span toggle="#password-field" class="fa fa-eye text-danger login-field-icon fa-fw  field-icon toggle-password"></span>
                                      <i class="fa fa-lock text-danger login-field-icon3"></i>
                                      </div>
                                      
                                      <!-- <input type="submit" class="btn btn-default btn-danger btn-block" onclick="location.href='1.html';" /> -->
                                      <button type="submit" onclick="JavaScript: Verifica();" class="btn btn-default btn-danger btn-block">Aceptar</button>
                                      <!--a href="JavaScript: Verifica();"  class="btn btn-default btn-primary btn-block">Aceptar</!--a-->
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
                <h3 class="panel-title text-center"><i class="fa fa-user"></i>&nbsp;&nbsp; © Todos los Derechos Reservados</h3>
              </div><!-- /fin pie color verde -->
           </div><!-- fin Cabacera verde -->

 </div> <!-- fin contenido general verde -->
 </div><!-- /fin Container -->


  <!-- JavaScript -->
    <script src="js/jquery-1.10.2.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/login.js"></script>

  </body>

<!-- Mirrored from safe2biz.com/app-prueba/login/login.html by HTTrack Website Copier/3.x [XR&CO'2010], Thu, 19 Nov 2020 19:09:46 GMT -->
</html>
