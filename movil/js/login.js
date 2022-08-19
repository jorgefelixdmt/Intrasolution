// JavaScript Document

	// presionar y soltar
/*	$(document).ready(function(){
		$('#show').mousedown(function(){
			$('#pass').removeAttr('type');
			$('#show').addClass('fa-eye-slash').removeClass('fa-eye');
	});
	
	$('#show').mouseup(function(){
	 		 $('#pass').attr('type','password');
			 $('#show').addClass('fa-eye').removeClass('fa-eye-slash');
			 
	
	});
	}); */
	
// presionar revelar
$(".toggle-password").click(function() {

  $(this).toggleClass("fa-eye fa-eye-slash");
  var input = $($(this).attr("toggle"));
  if (input.attr("type") == "password") {
    input.attr("type", "text");
  } else {
    input.attr("type", "password");
  }
});


