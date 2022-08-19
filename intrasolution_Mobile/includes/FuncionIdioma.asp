<%
Function Idioma1(Mensaje,TipoIdioma)	
	'Idioma Español 0,Ingles 1 	   
	
	If Isnull(Mensaje) or Mensaje = "" Then 
	   Idioma1 = "Falta Trad"
	ElseIf InStr(1,Mensaje, "|") = 0 Then
	   Idioma1 = Mensaje
	Else   
	   cadena = split(Mensaje,"|")
	   if Ubound(cadena) < cint(TipoIdioma) then 
			Idioma1 = "X" & cadena(0)
	   else
	      Idioma1 = cadena(TipoIdioma)
	   end if		
	End if
End function

Function PrefijoIdioma(TipoIdioma)	
	'Idioma Español 0,Ingles 1, Portugues 2 	   
	Select Case cint(TipoIdioma)
		Case 0
			PrefijoIdioma = "es"
		Case 1
			PrefijoIdioma = "in"
		Case 2
			PrefijoIdioma = "pr"
	End Select	
End function

'MODIFICACION 09/07/2003
Function fIdioma(Key)
    'Idioma Español 0,Ingles 1, Portugues 2 	   
    Idioma = Request.Cookies("Usuario")("TipoIdioma")
    if Idioma = "" then 
		Idioma = Session("wIdiomaDefecto")
	end if
	if Idioma = "" then Idioma = 0
    Mensaje = Trim(Application("MessageManager").Item(Key))

    If Isnull(Mensaje) or Mensaje = "" Then 
	   fIdioma = "Falta Trad"
    ElseIf InStr(1,Mensaje, "|") = 0 Then
	   fIdioma = Mensaje
	Else   
	   cadena = split(Mensaje,"|")
	   if Ubound(cadena) < cint(Idioma) then 
	      fIdioma = "X" & cadena(0)
	   else
	      fIdioma = cadena(Idioma)
	   end if		
	End if
End Function

Function tIdioma(Key,Idioma)
    'Idioma Español 0,Ingles 1, Portugues 2 	   
    Mensaje = Application("MessageManager").Item(Key)

    If Isnull(Mensaje) or Mensaje = "" Then 
	   tIdioma = "Falta Trad"
    ElseIf InStr(1,Mensaje, "|") = 0 Then
	   tIdioma = Mensaje
	Else   
	   cadena = split(Mensaje,"|")
	   if Ubound(cadena) < cint(Idioma) then 
	      tIdioma = "X" & cadena(0)
	   else
	      tIdioma = cadena(Idioma)
	   end if		
	End if
End Function

%>

