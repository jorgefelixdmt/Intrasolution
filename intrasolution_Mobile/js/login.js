window.onload = function() {
  document.getElementById('pass').addEventListener("keyup", function(event) {
    event.preventDefault();
    if (event.keyCode == 13) {
      document.getElementById("submit").click();
    }
  });
};


function validaLogin() {
  var user = document.getElementById('user').value.split('@');
  const pass = document.getElementById('pass').value;
  // debugger;

  if (user.length>1) {
    var validacion = $.get("validaLogin.asp?empresa="+user[1]+"&user="+user[0]+"&pass="+pass,function(data) {
      if (data.split(',')[0] === "Correcto") {
        window.location.href = "unidades.asp?Empresa="+user[1]+"&Id_Usuario="+data.split(',')[1];
      } else{
        alert(data)
      }
    }).fail(function(){
      console.log("Ha ocurrido un error");
    });
  }
}
