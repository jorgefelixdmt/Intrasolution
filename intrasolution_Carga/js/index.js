function EjecutaAccion(Accion) {

    /* if (Accion == "Load") {
        //this will hide the waiting.gif

        showSuccess();
        showError();

        document.getElementsByClassName("loader")[0].style.visibility = 'visible';
        //document.getElementsByClassName("success-checkmark")[0].style.display = 'none';
        document.getElementsByClassName("success-msg")[0].style.display = 'none';
        document.getElementsByName("Acc").value = Accion;
        //frmCargos.Acc.value = Accion;
        frmCargos.submit();
    }
    else {

        document.getElementsByClassName("loader")[0].style.visibility = 'hidden';
        document.getElementsByClassName("success-msg")[1].style.visibility = 'hidden';

    } */

    if (Accion=="Load")
    {
        //this will hide the waiting.gif
        document.getElementById("waiting").removeAttribute("hidden");
        frmCargos.Acc.value=Accion; 
        frmCargos.submit();
     }
     else{
        ajaxindicatorstop();
        alert("No se puede grabar el archivo por que tiene errores. Corrijalos y vuelva a cargarlo.");
     }  
}
//funcion para obtener el archivo
function getFileName() {
    var x = document.getElementById('file')
    //document.getElementById('fileName').innerHTML = x.value.split('\\').pop()
    document.frmCargos.fileName.value = x.value.split('\\').pop()
}

// funcion para descargar el archivo
function descarga(){
    // logica para el archivo procesado a descargar
    console.log('se descarga el archivo...');
        
    
    
}
//animacion del resultado de la operacion exito o fracaso 
function showSuccess(){
    document.getElementsByClassName("success-msg")[0].style.visibility = 'visible';
}
function showError(){
    document.getElementsByClassName("error-msg")[0].style.visibility = 'visible';
}
  
//uso de libreria jquery
$(function(){
    $(".formGroup").hover(function(){
         $(".bg-color-dblue").css("background-color", "rgb(6, 6, 100)");
        },function(){
            $(".bg-color-dblue").css("background-color", "");
        });
});



