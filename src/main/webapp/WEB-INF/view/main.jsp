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
      <div class="login__check"><img src="/img/ibm.png"></div>
      <!-- <div class="ibm-logo"><img src="/img/ibm.png"></div> -->
      <div class="login__form">
        <div class="login__row">
          <svg class="login__icon name svg-icon" viewBox="0 0 20 20">
            <path d="M0,20 a10,8 0 0,1 20,0z M10,0 a4,4 0 0,1 0,8 a4,4 0 0,1 0,-8" />
          </svg>
          <input id="serialNo" type="text" class="login__input name" placeholder="사원번호"/>
        </div>
        <div class="login__row">
          <svg class="login__icon pass svg-icon" viewBox="0 0 20 20">
            <path d="M0,20 20,20 20,8 0,8z M10,13 10,16z M4,8 a6,8 0 0,1 12,0" />
          </svg>
          <input id="quizCode" type="text" class="login__input pass" placeholder="문제코드"/>
        </div>
        <button type="button" class="login__submit">문제풀기</button>
        <p class="login__signup"><a>AWS Session April,2018<br></a><span>장지영 성혜용 김진성 김효준 이창종 정승수 고창환 고은정</span></p>
      </div>
    </div>
    
    
    <div class="app">
      <div class="app__top">
        <p class="app__hello" id="quizIs">  </p>
        <div class="app__user">
          <img src="//s3-us-west-2.amazonaws.com/s.cdpn.io/142996/profile/profile-512_5.jpg" alt="" class="app__user-photo" />
        </div>
      </div>
      <div class="app__bot">
        <div class="app__meetings">
        <div class="login__row">
          <input id="answer" type="text" class="login__input pass" placeholder="What is your Answer?"/>
        </div>

        <button type="button" class="login1__submit" id="login1__submit">제출하기</button>

      <div class="app__logout">
        <svg class="app__logout-icon svg-icon" viewBox="0 0 20 20">
          <path d="M6,3 a8,8 0 1,0 8,0 M10,0 10,12"/>
        </svg>
      </div>
        </div>
      </div>
    </div>
  </div>
</div>
  <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

  

<!--     <script  src="js/index.js"></script> -->

<form style="display: hidden" action="#" method="POST" id="frm">
  <input type="hidden" id="var1" name="var1" value=""/>
</form>


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
  
  $(document).on("click", ".login__submit", function(e) {
     quizCode=$('#quizCode').val();
     var serialNo=$('#serialNo').val();
     
     if(quizCode != null && quizCode != "" && serialNo.length==6){
       if (animating) return;
       animating = true;
       var that = this;
       ripple($(that), e);
       $(that).addClass("processing");
       setTimeout(function() {
         $(that).addClass("success");
         setTimeout(function() {
           $app.show();
           $app.css("top");
           $app.addClass("active");
         }, submitPhase2 - 70);
         setTimeout(function() {
           $login.hide();
           $login.addClass("inactive");
           animating = false;
           $(that).removeClass("success processing");
         }, submitPhase2);
       }, submitPhase1);
       
       quizCode=$('#quizCode').val();
       if(quizCode=="IBM")
       {
          document.getElementById("quizIs").innerHTML="예시) 한국IBM의 대표이사 사장님의 이름은?";   
       }
       else if(quizCode=="클라우드")
       {
          document.getElementById("quizIs").innerHTML="Cloud 환경에서 서비스를 개발 할 수 있는 환경과 그 환경을 이용하는 응용프로그램을 개발 할 수있는 API까지 제공하는 형태는 무엇인가요?";   
         }
       else if(quizCode=="솔루션")
       {
          var str = "Combining industry best practices for Design Thinking, Agile Development, DevOps, and Cloud to build and deliver innoavation solutions?<br>:IBM Bluemix ( ) Method";
          var result = str.fontsize(3);
          document.getElementById("quizIs").innerHTML = result;
         }
       else if(quizCode=="컴퓨팅")
       {
          document.getElementById("quizIs").innerHTML="AWS에서 제공하는 컴퓨팅 서비스는 무엇인가요?";      
         }
       else if(quizCode=="인터페이스")
       {
          document.getElementById("quizIs").innerHTML="Business Function을 Exposing하는 표준 인터페이스는 무엇인가요?";         
         }
       else if(quizCode=="광파오븐렌지")
       {
         var str = "<b>\"광파오븐렌지\"</b><br>추첨을 시작해 볼까요?<br><b>\"시작\"</b>을 입력해 주세요.";   
         var result = str.fontsize(4);
         document.getElementById("quizIs").innerHTML=result;
       }
       else
       {
         document.getElementById("quizIs").innerHTML="해당 문제코드에 대한 문제가 없습니다.";
       }
     }else{
    	 alert("사원번호 혹은 문제코드를 확인하세요.");
     }
  
  });
  
  $(document).on("click", ".login1__submit", function(e) {
      
     quizCode=$('#quizCode').val();
     var answer=$('#answer').val();
     answer=answer.toLowerCase()
     var serialNo=$('#serialNo').val();

     if(quizCode=="대박포차" && answer=="99"||quizCode=="IBM"&&answer=="장화진"||quizCode=="클라우드"&&answer=="paas"||quizCode=="솔루션"&&answer=="garage"||quizCode=="컴퓨팅"&&answer=="ec2"||quizCode=="인터페이스"&&answer=="api"){
        
        $.ajax({
            type : 'GET',
            url : '/result',
            data : {quizCode : quizCode, answer : answer, serialNo : serialNo},
            success:function(args){
               if(args=="notFirst")
               {
                  document.getElementById("frm").action = "/notFirst";
                  document.getElementById("frm").submit();
               }
               else if(args=="first")
               {
                  document.getElementById("frm").action = "/first";
                  document.getElementById("frm").submit();
               }
            }
         });
     }
		 else if(quizCode=="다이나모" && answer=="조회"){
    	 
    	 location.href="/dynamo"
     }
		 else if(quizCode=="광파오븐렌지" && answer=="시작"){
    	 
    	 location.href="/congratulation"
     }
     else{
        $.ajax({
            type : 'GET',
            url : '/result',
            data : {quizCode : quizCode, answer : answer, serialNo : serialNo},
            success:function(){
               alert("오답입니다. 다시 한 번 생각해보세요.");
            }
         });
     }
  });

  
  $(document).on("click", ".app__logout", function(e) {
    if (animating) return;
    $(".ripple").remove();
    animating = true;
    var that = this;
    $(that).addClass("clicked");
    setTimeout(function() {
      $app.removeClass("active");
      $login.show();
      $login.css("top");
      $login.removeClass("inactive");
    }, logoutPhase1 - 120);
    setTimeout(function() {
      $app.hide();
      animating = false;
      $(that).removeClass("clicked");
    }, logoutPhase1);
    
  });
  
});
</script>