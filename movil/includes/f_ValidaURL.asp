<% 
'  SqlCheckInclude.asp
'
'  Author: Nazim Lala
'
'  This is the include file to use with your asp pages to 
'  validate input for SQL injection.


Dim BlackList, ErrorPage, s

'
'  Below is a black list that will block certain SQL commands and 
'  sequences used in SQL injection will help with input sanitization
'
'  However this is may not suffice, because:
'  1) These might not cover all the cases (like encoded characters)
'  2) This may disallow legitimate input
'
'  Creating a raw sql query strings by concatenating user input is 
'  unsafe programming practice. It is advised that you use parameterized
'  SQL instead. Check http://support.microsoft.com/kb/q164485/ for information
'  on how to do this using ADO from ASP.
'
'  Moreover, you need to also implement a white list for your parameters.
'  For example, if you are expecting input for a zipcode you should create
'  a validation rule that will only allow 5 characters in [0-9].
'

BlackList = Array("--", ";", "/*", "*/", "@@", "@",_
                 "=","#","$","%","^","&","*",";","<",">","'","""","(",")","--",_
                  "char", "nchar", "varchar", "nvarchar",_
                  "alter", "begin", "cast", "create", "cursor",_
                  "declare", "delete", "drop", "end", "exec",_
                  "execute", "fetch", "insert", "kill", "open",_
                  "select", "sys", "sysobjects", "syscolumns",_
                  "table", "update","iframe")

'  Populate the error page you want to redirect to in case the 
'  check fails.

ErrorPage = "/ErrorPage.asp"
               
'''''''''''''''''''''''''''''''''''''''''''''''''''               
'  This function does not check for encoded characters
'  since we do not know the form of encoding your application
'  uses. Add the appropriate logic to deal with encoded characters
'  in here 
'''''''''''''''''''''''''''''''''''''''''''''''''''
Function CheckStringForSQL(str) 
  On Error Resume Next 
  
  Dim lstr 
  
  ' If the string is empty, return true
  If ( IsEmpty(str) ) Then
    CheckStringForSQL = false
    Exit Function
  ElseIf ( StrComp(str, "") = 0 ) Then
    CheckStringForSQL = false
    Exit Function
  End If
  
  lstr = LCase(str)
  
  ' Check if the string contains any patterns in our
  ' black list
  For Each s in BlackList
  
    If ( InStr (lstr, s) <> 0 ) Then
      CheckStringForSQL = true
      Exit Function
    End If
  
  Next
  
  CheckStringForSQL = false
  
End Function 


'''''''''''''''''''''''''''''''''''''''''''''''''''
'  Check forms data
'''''''''''''''''''''''''''''''''''''''''''''''''''

For Each s in Request.Form
  If ( CheckStringForSQL(Request.Form(s)) ) Then
    PrepareReport("FORM VARIABLES")
    ' Redirect to an error page
      Response.end
      Response.Redirect(ErrorPage)
  
  End If
Next

'''''''''''''''''''''''''''''''''''''''''''''''''''
'  Check query string
'''''''''''''''''''''''''''''''''''''''''''''''''''

For Each s in Request.QueryString
  If ( CheckStringForSQL(Request.QueryString(s)) ) Then
    PrepareReport("QUERY STRING")
    ' Redirect to error page
    Response.Redirect(ErrorPage)

    End If
  
Next


'''''''''''''''''''''''''''''''''''''''''''''''''''
'  Check cookies
'''''''''''''''''''''''''''''''''''''''''''''''''''

For Each s in Request.Cookies
  If ( CheckStringForSQL(Request.Cookies(s)) ) Then
    PrepareReport("COOKIES")
    ' Redirect to error page
    Response.Redirect(ErrorPage)

  End If
  
Next

'''''''''''''''''''''''''''''''''''''''''''''''''''
'  Add additional checks for input that your application
'  uses. (for example various request headers your app 
'  might use)
'''''''''''''''''''''''''''''''''''''''''''''''''''

Function PrepareReport(injectionType)
    'Build the messege
    Dim MessageBody
    MessageBody="<h1>One Sql Injection Attempt Was Blocked! </h1><br/>"
    MessageBody=MessageBody & "Attack Time: " & FormatDateTime(Now,3) & "<br/>"
    MessageBody=MessageBody & "Attaker IP Address: " & Request.ServerVariables("REMOTE_HOST") & "<br/>"
    MessageBody=MessageBody & "Injection Type: " & injectionType & "<hr size='1'/><br/>"
    MessageBody=MessageBody & "More Details Information: <br/>"
    
    MessageBody=MessageBody&"<table width='100%'>"
    MessageBody=MessageBody&"<tr><td colspan='2'><h2>Form Variables</h2></td></tr>"
    'List Form Data
    For Each s in Request.Form
        MessageBody=MessageBody&"<tr>"
        MessageBody=MessageBody&"   <td>" & s & "</td>"
        MessageBody=MessageBody&"   <td>" & Request.Form(s) & "</td>"
        MessageBody=MessageBody&"<tr>"
    Next
    MessageBody=MessageBody& "<tr><td colspan='2'><h2>QueryString Variables</h2></td></tr>"
    For Each s in Request.QueryString
        MessageBody=MessageBody&"<tr>"
        MessageBody=MessageBody&"   <td>" & s & "</td>"
        MessageBody=MessageBody&"   <td>" & Request.QueryString(s) & "</td>"
        MessageBody=MessageBody&"<tr>"
    Next
 
    MessageBody=MessageBody & "<tr><td colspan='2'><h2>Cookie Variables</h2></td></tr>"
    For Each s in Request.Cookies
        MessageBody=MessageBody&"<tr>"
        MessageBody=MessageBody&"   <td>" & s & "</td>"
        MessageBody=MessageBody&"   <td>" & Request.Cookies(s) & "</td>"
        MessageBody=MessageBody&"<tr>"
    Next
    
    MessageBody=MessageBody&"</table><br/>"
    MessageBody=MessageBody & "Script Page: " & GetCurrentPageUrl() & "<br/>"
    MessageBody=MessageBody & "Referer Page: " & GetRefererPageUrl() & "<br/><br/>Automated Generated Report"
    
    Response.write MessageBody
    //Result= SendEmail("Sql Injection Attempt Was Detected by " & injectionType & "!",MessageBody)
End Function

Function GetCurrentPageUrl()
    domainname = GetCurrentServerName() 
    filename = Request.ServerVariables("SCRIPT_NAME") 
    querystring = Request.ServerVariables("QUERY_STRING") 
    GetCurrentPageUrl= domainname & filename & "?" & querystring 
End Function
 
Function GetRefererPageUrl()
    GetRefererPageUrl= Request.ServerVariables("HTTP_REFERER") 
End Function
 
Function GetCurrentServerName()
    prot = "http" 
    https = lcase(request.ServerVariables("HTTPS")) 
    if https <> "off" then prot = "https" 
    domainname = Request.ServerVariables("SERVER_NAME") 
    GetCurrentServerName=prot & "://" & domainname 
End Function
 
Function GetPageNameFromPath(strPath)
    strPos= len(strPath)-InStrRev(strPath,"/")
    pageName=right(strPath,strPos)
    GetPageNameFromPath=pageName
End Function
 
Function GetCurrentPageName()
    scriptPath = Request.ServerVariables("SCRIPT_NAME") 
    pageName=GetPageNameFromPath(scriptPath)
    GetCurrentPageName=pageName
End Function

%>