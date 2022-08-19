<%
	'In this page, we open the connection to the Database
	'Our Access database is contained in ../FusionChartsDB/FusionChartsDB.mdb
	'It's a very simple database with just 2 tables (for the sake of demo)	
	Dim oConn
	'If not already defined, create object

	if Request("Empresa") <> "" then
	    wEmpresa = UCase(Request("Empresa"))
	end if    

    
	if not isObject(oConn) then
		Dim strConnQuery
		Set oConn = Server.CreateObject("ADODB.Connection")		

       
        strConnQuery = Application(wEmpresa)
		'Connect
		oConn.Open(strConnQuery)		
		oConn.CommandTimeout = 3600		
		
		'Or if you wish to connect using SQL, use the following:
		'oconn.Open "Provider=SQLOLEDB; Data Source=DATASRC; Initial Catalog=FusionChartsDB; UId=; Password="
	end if
%>