var config; //Здесь будут хранится настройки из конфигурационного файла
var snailImages = [];
var bodyRotation = new Object({'foreward':0, 'bacward':180, 'up':270, 'down':90})
var leftBorder = 40;
var rightBorder = 640;
var topBorder = 480;
var bottomBorder = 0;
var image_number = 1;
var lastImage = 1;
var cursorX = 0;//Переменная вынесена сюда, чтобы дальше не менятся, ведь при следующем обращении к ней курсор может быть в другом месте, что внесет неразбериху
var cursorY = 0;//Переменная вынесена сюда, чтобы дальше не менятся

function initialize(){
  config = readConfigurationFile(); //Читаем настройки из файла конфигурации
  cursorX = config.xCursorPos;//По положению курсора узнаем куда пользователь поместил плазмоид так как в момент инициализации плазмоида курсор все еще будет над ним
  cursorY = config.yCursorPos;
  rightBorder = config.screenWidth -cursorX;
  leftBorder = -cursorX;
  topBorder = cursorY -config.screenHeight;
  bottomBorder = config.screenHeight -cursorY;
  
  for (var i=1; i < 30; i+=1) {
        snailImages[i] = '../images/snail_' + i + '.svg';
      }
}

function readConfigurationFile(){
   var configEntry = {};
   configEntry.screenWidth = plasmoid.configuration.availableWidth;
   configEntry.screenHeight = plasmoid.configuration.availableHeight;
   configEntry.shellRotationLevel = plasmoid.configuration.shellRotationLevel;
   configEntry.xCursorPos = plasmoid.configuration.xCursorPos;
   configEntry.yCursorPos = plasmoid.configuration.yCursorPos;
   return configEntry;
}


function animate(){

      var previos_img = lastImage;
      var current_img = image_number;
        
	  if(image_number < 13){
           body.source = snailImages[current_img];
	       lastImage = current_img;
	       image_number += 1;
	  }
	  else{
	    image_number = 1;
	  }   
 }


function move(){
  
  var speed = plasmoid.configuration.speed;//Для того чтобы улитка сразу реагировала на новое значение скорости
  var current_direction = defineDirection();
  
  switch(current_direction){
    case 'foreward':
      body.rotation = bodyRotation['foreward'];
      shell.rotation = 20;
      body.x += speed;
      shell.x += speed;
    break 
    case 'bacward':
      body.rotation = bodyRotation['bacward'];
      shell.rotation = 210;
      body.x -= speed;
      shell.x -= speed;
    break
    case 'up':
      body.rotation = bodyRotation['up'];
      shell.rotation = 320;
      body.y -= speed;
      shell.y -= speed;
    break
    case 'down':
      body.rotation = bodyRotation['down'];
      shell.rotation = 105;
      body.y += speed;
      shell.y += speed;
    break
  }
}

var direction = 'foreward';
 
function defineDirection(){
  //Если анимированный рисунок достиг граници, изменить его направление на противоположное
  var availableDirections = ['foreward', 'bacward', 'up', 'down'];
  var current_direction = 'foreward';
  
   if (body.x < leftBorder||
        body.x > rightBorder||
        body.y < topBorder||
        body.y > bottomBorder
       ){
          current_direction = availableDirections[getRandom(0, 4)];
          direction = current_direction;
          print('Now I going to moving ' + current_direction + "; leftBorder = " + leftBorder + "; rightBorder = " + rightBorder)
          image_number = 14;//Указываем на первый кадр анимацмм разворота
	      preventTrimig();
          switchBehavior('turne_around');//Переключаем на разворот
        }
        else{
		  current_direction = direction;
	    }
  
  return current_direction;
}

function switchBehavior(behavior){
	
	switch(behavior){
		
		case 'crawl':
		    turn_around.visible = false;
			body.visible = true;
			shell.visible = true;
			hiding_animation.running = false;
			turn_around_animation.running = false;
			crawl_animation.running = true;
	    break
	    
	    case 'turne_around':
	        
	        body.visible = false;
	        shell.visible = false;
			turn_around.visible = true;
			crawl_animation.running = false;
			hiding_animation.running = false;
			turn_around_animation.running = true;
			
         break
         
         case 'hide_into_the_shell':
          
            crawl_animation.running = false;
            image_number = 21;
            hiding_animation.running = true;
           
         break
         
		}
	
}

function turnAround(){
	//Анимация разворота
	var previos_img = lastImage;
    var current_img = image_number;
        
	  if(image_number < 20){
           turn_around.source = snailImages[current_img];
	       lastImage =  current_img;
	       image_number += 1;
	     }
	     
	     else{
	    
	    image_number = 1;
	    switchBehavior('crawl') //Когда прокрутили всю анимацию разворота, возобновляем движение
	    
	  }
	  
}
	
function hideIntoTheShell(){
	//Улитка прячется в раковину
	var previos_img = lastImage;
    var current_img = image_number;
        
	  if(image_number < 30){
         body.source = snailImages[current_img];
	     lastImage =  current_img;
	     image_number += 1;
	     }
	     
	   else{
	    image_number = 1;
	    hiding_animation.running = false;
	   }
}

function preventTrimig(){
	if(leftBorder > body.x){
		leftBorder = body.x
		}
	if(rightBorder < body.x){
		rightBorder = body.x
		}
	if(topBorder > body.y){
		topBorder = body.y
		}
	if(bottomBorder < body.y){
		bottomBorder = body.y
		}
	 
	 turn_around.x = body.x;
	 turn_around.y = body.y;
	}

function definrBorders(){
  
   leftBorder = getRandom(-cursorX, config.screenWidth/2);
   rightBorder = getRandom(config.screenWidth/2, config.screenWidth -cursorX);
   topBorder = getRandom(-cursorY, config.screenHeight/4);
   bottomBorder = getRandom((config.screenHeight -cursorY)/2, (config.screenHeight -cursorY))
   print("current borders: left = " + leftBorder + "; right = " + rightBorder + "; top = " + topBorder + "; bottom = " + bottomBorder);
   
}

var wiggle = 'left';

function shellWiggle(){
	var rotationLevel = config.shellRotationLevel;
	
	if(wiggle == 'right'){
	 shell.rotation += rotationLevel;
	 wiggle = 'left';
	 }
	else{
	  shell.rotation -= rotationLevel;
	  wiggle = 'right';
	}
}

function getRandom(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

