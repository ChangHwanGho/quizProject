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
  
  <script
  src="https://code.jquery.com/jquery-1.6.4.js"
  integrity="sha256-VJZPi1gK15WpYvsnBmcV0yga4a0Toov4rt1diFnrrjc="
  crossorigin="anonymous"></script>
<style>
body {
    background-color: #000000;
    margin: 0px;
    overflow: hidden;
}
</style>
  
<script>

var SCREEN_WIDTH = window.innerWidth,
SCREEN_HEIGHT = window.innerHeight,
mousePos = {
    x: 400,
    y: 300
},

// create canvas
canvas = document.createElement('canvas'),
context = canvas.getContext('2d'),
particles = [],
rockets = [],
MAX_PARTICLES = 400,
colorCode = 0;

//init
$(document).ready(function() {
document.body.appendChild(canvas);
canvas.width = SCREEN_WIDTH;
canvas.height = SCREEN_HEIGHT;
setInterval(launch, 800);
setInterval(loop, 1000 / 50);
});

//update mouse position
$(document).mousemove(function(e) {
e.preventDefault();
mousePos = {
    x: e.clientX,
    y: e.clientY
};
});

//launch more rockets!!!
$(document).mousedown(function(e) {
for (var i = 0; i < 5; i++) {
    launchFrom(Math.random() * SCREEN_WIDTH * 2 / 3 + SCREEN_WIDTH / 6);
}
});

function launch() {
launchFrom(mousePos.x);
}

function launchFrom(x) {
if (rockets.length < 10) {
    var rocket = new Rocket(x);
    rocket.explosionColor = Math.floor(Math.random() * 360 / 10) * 10;
    rocket.vel.y = Math.random() * -3 - 4;
    rocket.vel.x = Math.random() * 6 - 3;
    rocket.size = 8;
    rocket.shrink = 0.999;
    rocket.gravity = 0.01;
    rockets.push(rocket);
}
}

function loop() {
// update screen size
if (SCREEN_WIDTH != window.innerWidth) {
    canvas.width = SCREEN_WIDTH = window.innerWidth;
}
if (SCREEN_HEIGHT != window.innerHeight) {
    canvas.height = SCREEN_HEIGHT = window.innerHeight;
}

// clear canvas
context.fillStyle = "rgba(0, 0, 0, 0.05)";
context.fillRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

var existingRockets = [];

for (var i = 0; i < rockets.length; i++) {
    // update and render
    rockets[i].update();
    rockets[i].render(context);

    // calculate distance with Pythagoras
    var distance = Math.sqrt(Math.pow(mousePos.x - rockets[i].pos.x, 2) + Math.pow(mousePos.y - rockets[i].pos.y, 2));

    // random chance of 1% if rockets is above the middle
    var randomChance = rockets[i].pos.y < (SCREEN_HEIGHT * 2 / 3) ? (Math.random() * 100 <= 1) : false;

/* Explosion rules
         - 80% of screen
        - going down
        - close to the mouse
        - 1% chance of random explosion
    */
    if (rockets[i].pos.y < SCREEN_HEIGHT / 5 || rockets[i].vel.y >= 0 || distance < 50 || randomChance) {
        rockets[i].explode();
    } else {
        existingRockets.push(rockets[i]);
    }
}

rockets = existingRockets;

var existingParticles = [];

for (var i = 0; i < particles.length; i++) {
    particles[i].update();

    // render and save particles that can be rendered
    if (particles[i].exists()) {
        particles[i].render(context);
        existingParticles.push(particles[i]);
    }
}

// update array with existing particles - old particles should be garbage collected
particles = existingParticles;

while (particles.length > MAX_PARTICLES) {
    particles.shift();
}
}

function Particle(pos) {
this.pos = {
    x: pos ? pos.x : 0,
    y: pos ? pos.y : 0
};
this.vel = {
    x: 0,
    y: 0
};
this.shrink = .97;
this.size = 2;

this.resistance = 1;
this.gravity = 0;

this.flick = false;

this.alpha = 1;
this.fade = 0;
this.color = 0;
}

Particle.prototype.update = function() {
// apply resistance
this.vel.x *= this.resistance;
this.vel.y *= this.resistance;

// gravity down
this.vel.y += this.gravity;

// update position based on speed
this.pos.x += this.vel.x;
this.pos.y += this.vel.y;

// shrink
this.size *= this.shrink;

// fade out
this.alpha -= this.fade;
};

Particle.prototype.render = function(c) {
if (!this.exists()) {
    return;
}

c.save();

c.globalCompositeOperation = 'lighter';

var x = this.pos.x,
    y = this.pos.y,
    r = this.size / 2;

var gradient = c.createRadialGradient(x, y, 0.1, x, y, r);
gradient.addColorStop(0.1, "rgba(255,255,255," + this.alpha + ")");
gradient.addColorStop(0.8, "hsla(" + this.color + ", 100%, 50%, " + this.alpha + ")");
gradient.addColorStop(1, "hsla(" + this.color + ", 100%, 50%, 0.1)");

c.fillStyle = gradient;

c.beginPath();
c.arc(this.pos.x, this.pos.y, this.flick ? Math.random() * this.size : this.size, 0, Math.PI * 2, true);
c.closePath();
c.fill();

c.restore();
};

Particle.prototype.exists = function() {
return this.alpha >= 0.1 && this.size >= 1;
};

function Rocket(x) {
Particle.apply(this, [{
    x: x,
    y: SCREEN_HEIGHT}]);

this.explosionColor = 0;
}

Rocket.prototype = new Particle();
Rocket.prototype.constructor = Rocket;

Rocket.prototype.explode = function() {
var count = Math.random() * 10 + 80;

for (var i = 0; i < count; i++) {
    var particle = new Particle(this.pos);
    var angle = Math.random() * Math.PI * 2;

    // emulate 3D effect by using cosine and put more particles in the middle
    var speed = Math.cos(Math.random() * Math.PI / 2) * 15;

    particle.vel.x = Math.cos(angle) * speed;
    particle.vel.y = Math.sin(angle) * speed;

    particle.size = 10;

    particle.gravity = 0.2;
    particle.resistance = 0.92;
    particle.shrink = Math.random() * 0.05 + 0.93;

    particle.flick = true;
    particle.color = this.explosionColor;

    particles.push(particle);
}
};

Rocket.prototype.render = function(c) {
if (!this.exists()) {
    return;
}

c.save();

c.globalCompositeOperation = 'lighter';

var x = this.pos.x,
    y = this.pos.y,
    r = this.size / 2;

var gradient = c.createRadialGradient(x, y, 0.1, x, y, r);
gradient.addColorStop(0.1, "rgba(255, 255, 255 ," + this.alpha + ")");
gradient.addColorStop(1, "rgba(0, 0, 0, " + this.alpha + ")");

c.fillStyle = gradient;

c.beginPath();
c.arc(this.pos.x, this.pos.y, this.flick ? Math.random() * this.size / 2 + this.size / 2 : this.size, 0, Math.PI * 2, true);
c.closePath();
c.fill();

c.restore();
};

</script>

</head>




<body>

  <div class="cont" style='display:none;'>
  <div class="demo">
    <div class="login">
      <div class="login__form" style='top:30% !important;'>
        <p class="login__signup"><a>축하드립니다!<br><br>
        	<font style="font-size:30px;"><b>${winner}</b> 님<br><br></font>
        	당첨되셨습니다!</a></p>
        	<button type="button" id='retry' class="login1__submit" style='margin:20px 0px 2px 0px;'>다시하기</button>
          <button type="button" id='goMain' class="login1__submit" style='margin:20px 0px 2px 0px;'>첫화면</button>
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
  setTimeout(function(){ 
    $(".cont").show(1000);
   },5000);
 
  
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
  
  
  $(document).on("click", "#goMain", function(e) {
	  location.href="/main"
  });
  
  $(document).on("click", "#retry", function(e) {
	  location.href="/congratulation"
  });

});
</script>