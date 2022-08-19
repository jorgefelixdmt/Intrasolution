<%
	'In this page, we open the connection to the Database
	'Our Access database is contained in ../FusionChartsDB/FusionChartsDB.mdb
	'It's a very simple database with just 2 tables (for the sake of demo)	
	Dim oConn
	
	if Request("Empresa") <> "" then
	    wEmpresa = UCase(Request("Empresa"))
	end if    

	'If not already defined, create object
	if not isObject(oConn) then
		Dim strConnQuery
		Set oConn = Server.CreateObject("ADODB.Connection")		

		'Create the path to database
        strConnQuery = Application(wEmpresa)
        
		'Connect

		
		oConn.Open(strConnQuery)		
		oConn.CommandTimeout = 60		

	end if
	
    PathURL = "/eco2biz_ASP/eco2biz_home"
%>
