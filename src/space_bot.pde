import fisica.*;

FWorld world;
FBox fuel_top, fuel_bottom, fuel_left, fuel_right, robot;
FBox wall[];
FBox door1_closed, door2_closed, door1_open, door2_open;
FLine outer_walls[];
FCircle spaceship;
FCircle water_balloon;
FLine balloon_wall_bottom;


PImage whole_space;
PImage spaceship_image;
PImage recharge_station;
PImage control_panel;
PImage background_space;
PImage wall_image[];
PImage door_controler_1;
PImage door_controler_2;
int wall_size = 0;


int key_pressed = 0;
int robot_activated = 0;
int door_one_open = 0;  
int door_two_open = 0;

float acceleration_X = 0;
float acceleration_Y = 0;
float velocity_X = 0;
float velocity_Y = 0;
float position_X = 1000;
float position_Y= 500;

float robot_acceleration_X = 0;
float robot_acceleration_Y = 0;
float robot_velocity_X = 0;
float robot_velocity_Y = 0;

float balloon_velocity_X = 0;
float balloon_velocity_Y = 0;

float robot_battery = 20; 

/**Background setup: dark grey
  *world setup:
  *   gravity: 0
  *   objects: spaceship, robot,...
  */
void setup(){
  //background setup
  frameRate(60);
  size(1000, 700);
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0,0);

  /*background setup*/
  whole_space = loadImage("large_space_image.jpg");
  whole_space.resize(5000, 3200);
  set(-1000, -500, whole_space);
  
  /*spaceship setup*/
  spaceship_image = loadImage("Circle_Spaceship_1.png");  
  spaceship_image.resize(400,400);
  spaceship_image.loadPixels();     
  spaceship_image.format = ARGB;
  spaceship_image.updatePixels();
  image(spaceship_image, 250, 175, 400, 400);
  
  /*wall setup*/
  wall = new FBox[20];
  outer_walls = new FLine[40];
  wall_image = new PImage[20];
  //horizonal walls
  setup_wall("Wall_1.1.png", 384, 260, 100, 5);
  setup_wall("Wall_1.1.png", 519, 260, 100, 5);
  setup_wall("Wall_1.1.png", 500, 320, 220, 5);
  setup_wall("Wall_1.1.png", 317, 320, 40, 5);
  setup_wall("Wall_1.1.png", 312, 380, 50, 5);
  setup_wall("Wall_1.1.png", 440, 380, 100, 5);
  setup_wall("Wall_1.1.png", 585, 380, 60, 5);
  setup_wall("Wall_1.1.png", 422, 440, 250, 5);
  setup_wall("Wall_1.1.png", 501, 500, 110, 5);
  //vertical walls
  setup_wall("Wall_1.4.png", 450, 350, 5, 60);
  //outer circular walls 
  for (int i = 0; i < 40; i++){
      if (i != 2)
        setup_outerwall(450, 375, i);
  }
  FLine balloon_wall_1 = new FLine(501, 532, 507, 545);
  balloon_wall_bottom = new FLine(507, 545, 535, 532);
  FLine balloon_wall_3 = new FLine(535, 532, 531, 519);
  balloon_wall_1.setDrawable(false);
  balloon_wall_bottom.setDrawable(false);
  balloon_wall_3.setDrawable(false);
  world.add(balloon_wall_1);
  world.add(balloon_wall_bottom);
  world.add(balloon_wall_3);
  
  /*spaceship fuel set up*/
  fuel_top = new FBox(200, 200);
  fuel_bottom = new FBox(200, 200);
  fuel_left = new FBox(200, 200);
  fuel_right = new FBox(200, 200);
  
  PImage fuel_top_image = loadImage("Digital_Game_Exhaust.png");
  PImage fuel_left_image = loadImage("Digital_Game_Exhaust_2.png"); 
  PImage fuel_bottom_image = loadImage("Digital_Game_Exhaust_3.png");
  PImage fuel_right_image = loadImage("Digital_Game_Exhaust_4.png");
  setup_fuel(fuel_top, fuel_top_image);
  setup_fuel(fuel_left, fuel_left_image);
  setup_fuel(fuel_bottom, fuel_bottom_image);
  setup_fuel(fuel_right, fuel_right_image);
  fuel_top.setPosition(460, 90);
  fuel_left.setPosition(167, 360);
  fuel_bottom.setPosition(440, 663);
  fuel_right.setPosition(733, 380);
  
  /*robot setup*/
  PImage robot_image = loadImage("Digital_Game_Robot_1.png");
  robot_image.resize(30, 30);
  robot = new FBox(20,25);
  robot.attachImage(robot_image);
  robot.setPosition(470, 360);
  robot.setRotation(0);
  robot.setDamping(0);
  world.add(robot);
  
  /*robot battery setup*/
  recharge_station = loadImage("Digital_Game_Recharge_Station.png");
  recharge_station.resize(15,30);
  image(recharge_station, 425, 335, 15, 30);
  fill(255, 255, 255);
  textSize(32);
  text("robot battery: " + robot_battery, 10, 30);

  /*water balloon setup*/
  water_balloon = new FCircle(20);
  water_balloon.setPosition(530,280);
  water_balloon.setDamping(0);
  world.add(water_balloon);
  
  /*control panel setup*/
  control_panel = loadImage("Digital_Game_Control_Panel.png");
  control_panel.resize(30,20);
  image(control_panel, 460, 360, 30, 20);
  
  /*door controler setup*/
  door_controler_1 = loadImage("Door_Button_1.1.png");
  door_controler_1.resize(10,40);
  image(door_controler_1, 400, 232, 8, 30); 
  door_controler_2 = loadImage("Door_Button_1.2.png");
  door_controler_2.resize(10,40);
  image(door_controler_2, 580, 350, 8, 30);
  
  /*door setup*/
  door2_closed = new FBox(55, 5);
  door2_closed.setFill(0,64,0);
  door2_closed.setDrawable(true);
  door2_closed.setFriction(0);
  door2_closed.setPosition(363, 380);
  door2_closed.setDensity(0);
  door2_closed.setNoStroke();
  door2_closed.setStatic(true);
  world.add(door2_closed);
  
  door1_closed = new FBox(5, 35);
  door1_closed.setFill(100,200,0);
  door1_closed.setDrawable(true);
  door1_closed.setFriction(0);
  door1_closed.setPosition(450, 520);
  door1_closed.setDensity(0);
  door1_closed.setNoStroke();
  door1_closed.setStatic(true);
  world.add(door1_closed);
}

/* helper function to setup boundary for spaceship*/
void setup_outerwall(int center_X, int center_Y, int num){
    if (num == 3){
         outer_walls[num] = new FLine(center_X + 165*sin(3.3*TWO_PI/40), center_Y + 165*cos(3.3*TWO_PI/40), 
              center_X + 165*sin((num+ 1)*TWO_PI/40), center_Y + 165*cos((num + 1)*TWO_PI/40));
    }
    else{   
         outer_walls[num] = new FLine(center_X + 165*sin(num*TWO_PI/40), center_Y + 165*cos(num*TWO_PI/40), 
              center_X + 165*sin((num+ 1)*TWO_PI/40), center_Y + 165*cos((num + 1)*TWO_PI/40));
    }
    outer_walls[num].setDrawable(false);
    outer_walls[num].setFriction(0);
    outer_walls[num].setDensity(0);
    world.add(outer_walls[num]);
    
}

/*helper function to set up walls inside the spaceship*/
void setup_wall(String image_name, int start_X, int start_Y, int width, int height){
    wall_image[wall_size] = loadImage(image_name);
    wall_image[wall_size].resize(width, height);
    wall[wall_size] = new FBox(width, height);
    wall[wall_size].attachImage(wall_image[wall_size]);
    wall[wall_size].setDrawable(true);
    wall[wall_size].setFriction(0);
    wall[wall_size].setPosition(start_X, start_Y);
    wall[wall_size].setDensity(0);
    wall[wall_size].setStatic(true);
    world.add(wall[wall_size]);
    wall_size++;
}

/*helper function to set up fuels*/
void setup_fuel(FBox fuel, PImage image){
   image.resize(200,200);
   fuel.attachImage(image);
   fuel.setStatic(true);
   fuel.setDrawable(false);
   world.add(fuel);
}

/**set robot&water balloon velocity, state of wining, battery state, 
 * door (open/close) state and so on before drawing 
 */
int spaceship_change_status(){
   float x = robot.getX();
   float y = robot.getY();

   if (x > 420 && x < 430 && y > 320 && y < 350 && robot_battery < 20)
       robot_battery++;
   if (x > 395 && x < 405 && y > 217 && y < 247){
       if (door_one_open == 0){
           door_one_open = 1;
           world.remove(door1_closed);
       }
   }
   if (x > 575 && x < 585 && y > 335 && y < 365){
     if (door_two_open == 0){
           door_two_open = 1;
           world.remove(door2_closed);
       }
   }
       
   boolean touch = balloon_wall_bottom.isTouchingBody(water_balloon);
   if (touch == true){
       return 1;
   }
   
   velocity_X = velocity_X + 10*acceleration_X;
   velocity_Y = velocity_Y + 10*acceleration_Y;
   robot_velocity_X = robot.getVelocityX() + 2*robot_acceleration_X;
   robot_velocity_Y = robot.getVelocityY() + 2*robot_acceleration_Y;
   robot.setVelocity(robot_velocity_X, robot_velocity_Y);
   
   balloon_velocity_X = water_balloon.getVelocityX() - 10*acceleration_X;
   balloon_velocity_Y = water_balloon.getVelocityY() - 10*acceleration_Y;
   water_balloon.setVelocity(balloon_velocity_X, balloon_velocity_Y);
   return 0;
}

void draw(){
  int win = spaceship_change_status();
  if (win == 1){
      background(255,255,255);
      text("Congrats! You have saved your spaceship! ", 200, 300);
  }
  else{
      position_X += 0.016*velocity_X;
      position_Y += 0.016*velocity_Y;
      if (position_X >= 4900)
          position_X = 0;
      if (position_Y >= 3100)
          position_Y = 0;
      if (position_X < 0)
          position_X = 4899;
      if (position_Y < 0)
          position_Y = 3099;
      set(-(int)position_X, -(int)position_Y, whole_space);
      image(spaceship_image, 250, 175, 400, 400);
      image(recharge_station, 425, 335, 15, 30);
      fill(255, 255, 255);
      textSize(32);
      text("robot battery: " + robot_battery, 10, 30);
      image(control_panel, 460, 360, 30, 20);
      image(door_controler_1, 400, 232, 8, 30);
      image(door_controler_2, 580, 350, 8, 30);
      world.step();
      world.draw();
  }
  
}

/**Effect of keys:
  *   DOWN: accelerate down
  *   UP: accelerate up
  *   LEFT: accelerate left
  *   RIGHT: accelerate right
  *   SHIFT: no acceleration
  */
void keyPressed(){
  if (key == CODED){
    if (keyCode == DOWN){
        key_pressed = 1;
        if (robot_activated == 0){
          acceleration_Y = 1;
          fuel_top.setDrawable(true);
        }
        else{
          if (robot_battery > 0){
            robot_acceleration_Y = 1;
            robot_battery--;
          }
        }
    }
    else if (keyCode == UP){
        key_pressed = 2;
        if (robot_activated == 0){
          acceleration_Y = -1;
          fuel_bottom.setDrawable(true);
        }
        else{
          if (robot_battery > 0){
            robot_acceleration_Y = -1;
            robot_battery--;
          }
        }
    }
    else if (keyCode == LEFT){
        key_pressed = 3;
        if(robot_activated == 0){
          acceleration_X = -1;
          fuel_right.setDrawable(true);
        }
        else{
          if (robot_battery > 0){
            robot_acceleration_X = -1;
            robot_battery--;
          }
        }
    }
    else if(keyCode == RIGHT){
        key_pressed = 4;
        if(robot_activated == 0){
          acceleration_X = 1;
          fuel_left.setDrawable(true);
        }
        else{
          if (robot_battery > 0){
            robot_acceleration_X = 1;
            robot_battery--;
          }
        }
    }
    else if (keyCode == SHIFT){
        key_pressed = 0;
        acceleration_X = 0;
        acceleration_Y = 0;
        robot_activated = robot_activated == 1 ? 0 : 1;
        if (velocity_X < 5)
            velocity_X = 0;
        if (velocity_Y < 5)
            velocity_Y = 0;
    }
  }
}

void keyReleased(){
  if (key_pressed == 1 || key_pressed == 2){
      fuel_top.setDrawable(false);
      fuel_bottom.setDrawable(false);
      acceleration_Y = 0;
      robot_acceleration_Y = 0;
  }
  if (key_pressed == 3 || key_pressed == 4){
      fuel_left.setDrawable(false);
      fuel_right.setDrawable(false);
      acceleration_X = 0;
      robot_acceleration_X = 0;
  }
  key_pressed = 0;  
}

/**helper function to see where object is in contact with each other.
 * helped debugging in development stage
 */
void contactStarted(FContact contact) {
   // Draw in green an ellipse where the contact took place
   fill(0, 170, 0);
   ellipse(contact.getX(), contact.getY(), 20, 20);
 }