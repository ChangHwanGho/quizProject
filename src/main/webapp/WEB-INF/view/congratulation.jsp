<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>AWS Session April, 2018</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
  
  <link rel='stylesheet prefetch' href='https://fonts.googleapis.com/css?family=Open+Sans'>
  <link rel="stylesheet" href="css/style.css">
   <link rel="stylesheet" type="text/css" href="/css/login.css">
  
</head>
<style>
</style>

<body>

  <div class="cont">
  <div class="demo">
    <div class="login">
      <div class="login__form">
        <p class="login__signup"><a items="${quizList}" var="quizList"><font size="2">축하드립니다!! ${quizList.serialNo} 님<br></a><span><font color="red">당첨되셨습니다!</font></span></p>
          <button type="button" class="login1__submit">첫화면</button>
        
      </div>
    </div>
    
    
    
    
  </div>
</div>
  <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

  

    <script  src="js/index.js"></script>




</body>

</html>

<script>
var quizCode = "";

$(document).ready(function() {
  
  var animating = false,
      submitPhase1 = 1100,
      submitPhase2 = 400,
      logoutPhase1 = 800,
      $login = $(".login"),
      $app = $(".app");
  
  function ripple(elem, e) {
    $(".ripple").remove();
    var elTop = elem.offset().top,
        elLeft = elem.offset().left,
        x = e.pageX - elLeft,
        y = e.pageY - elTop;
    var $ripple = $("<div class='ripple'></div>");
    $ripple.css({top: y, left: x});
    elem.append($ripple);
  };
  
  
  $(document).on("click", ".login1__submit", function(e) {
	  location.href="/main"
  
  	});

  
  
});
</script>