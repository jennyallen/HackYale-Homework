$(document).ready(function() {
  var x = 30;
  var y = 30;
  var dir = 39; // Right
  var speed = 5;
  // dir is 37 for left, 38 for up, 39 for right, 40 for down.
  function updateDotPosition() {
    switch(dir) {
      case 37:
        x-=speed;
        break;
      case 38:
        y-=speed;
        break;
      case 39:
        x+=speed;
        break;
      case 40:
        y+=speed;
        break;
      // Alternatively:
      // if (dir === 37) {
      //   x-=speed;
      // } else if (dir === 38) {
      //   y-=speed;
      // } else if (dir === 39) {
      //   x+=speed;
      // } else if (dir === 40) {
      //   y+=speed;
      // }
    }
    $("#dot").css({top: y, left: x});
  }
  
  updateDotPosition(x, y);
  $(window).keydown(function(e) {
    dir = e.which;
    // updateDotPosition();
  });

  // $("#change-speed").click(function() {
  //   speed = parseInt(prompt("What's the new speed? (1-10)"));
  // });

  setInterval(function() {
    updateDotPosition();
  }, 100);
});