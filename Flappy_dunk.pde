import processing.sound.*;
PImage ballon;   // déclare une variable de type PImage 
PImage anneau;  // déclare une variable de type PImage 
PFont fonte12, fonte16, fonte24;   // déclare des variables de type PFont 
float anneauX; 
float anneauY;
boolean collisionAnneau=false;
boolean collisionBords=false;
int scrollX=2;
final float g=0.2;  // la force de pesanteur
float posX,posY,speedY;
int score;
boolean help; // est-ce qu'on veut l'écran d'aide ou non ?
boolean gameOver=false; // est-ce que la partie est finie ou non ?
boolean hit; 

SoundFile sonHop;
SoundFile sonHit; 
SoundFile sonBooo;

// initialisation du jeu
void setup() {
  size(400,500);
  anneau = loadImage("Anneau.png");  // charge l’image Anneau.png en mémoire 
  ballon = loadImage("Ballon.png");  // charge l’image Ballon.png en mémoire 
  fonte16 = createFont("joystix.ttf", 16); // crée les fontes 
  fonte12 = createFont("joystix.ttf", 12);
  fonte24 = createFont("joystix.ttf", 24);
 sonHop = new SoundFile(this, "hop.mp3");
  sonHit = new SoundFile(this, "hit.mp3");  
 sonBooo = new SoundFile(this, "booo.mp3"); 

  background(255);
  posX=50;
  posY=height/2;
  speedY = 0;
  score=0;
  anneauX=200;
  anneauY=260;
  
  init();

}
// boucle de rendu
void draw() {
  background(255);
  textSize(15);
  fill(64);
  text("score",210,15); // affiche le score en haut a droite
  text(+score,240,15);
  // si on n'a pas perdu et que le jeu n'est pas en pause
  if(!gameOver || help){

init();

  }else{
    image(anneau,anneauX,anneauY);
  image(ballon,posX,posY);
  updatePosition(); // met a jour la position de l'anneau et du ballon
if(collisionAnneau()){ // test de passage de l'anneau

 hit();
 }
 
  }
  if(collisionBords()){
 gameOver(); 
 
 }

  }

// met à jour la position du ballon et de l'anneau
void updatePosition(){
anneauX=anneauX-scrollX; // met a jour la position de l'anneau
speedY=speedY+1; // met a jour la vitesse du ballon
posY=posY+g+speedY; // met a jour la position du ballon
if(score>1){ // met a jour la position de l'anneau en fonction du score
if ((score % 2)==0)
anneauY=160;
 else
anneauY=300;
 }
}

void updateDisplay(){ // redessine la fenêtre graphique
if(!gameOver){ // ecran d'acceuil
  background(255);
fill(0); 
textAlign(LEFT, CENTER); 
textFont(fonte24);
text("Flappy Dunk", 100, 100);

image(ballon,180,220);
textFont(fonte12);
textAlign(CENTER);
text("- Press H for help",100,150);//aide
text("- Press the up ARROW key",130,170);
text("to make the ball go up",130,190);
text("Click to start", width/2, 300);
fill(0); 
textAlign(RIGHT); 
textFont(fonte12);
text("Created by Shivamshan",300, 450);


if(help){ // Affichage de l'écran d'aide
 help=false;
  background(255);
  noLoop();
  fill(0); 
textAlign(RIGHT); 
textFont(fonte12);
text("- To pause the game",230,100);
text("press the space key",250,110);
text("- Press the up ARROW key",278,150);
text("to make the ball go up",280,160);
text("Good Luck !!",250,250) ; 
text("Press any key to go",280,300);
text("to the Main screen",270,310);
}

}else{   // écran "GAME OVER"
background(255);

gameOver=false;
fill(0); 
textAlign(CENTER); 
textFont(fonte12);
text("Double click to restart", width/2, 150);// cliquer pour recommencer
text("score",140,130);
text(+score,190,130);
text("You Lose",width/2,280); 
fill(0);
textSize(15);
text("GameOver !!",150,250);



}
}



void keyPressed() { // met en place l'interactivité clavier
  if(keyCode==UP){// - la balle rebondit si on appuie sur la flèche du haut
  speedY= -13;
  sonHop.play(); // joue le son 
}
if(!gameOver){
if((key=='h')||(key=='H')){ // - la touche 'h' donne de l'aide
help=true;
loop();
}

}
if((key!='h')||(key!='H')){ // toutes les touches font revenir en mode normal
 loop();
  }        
if(key==' '){ // - la touche espace permet de redémarrer le jeu
  noLoop();
}

}

void mousePressed(){   // permet de demarrer le jeu
  if(!gameOver){
    gameOver=true;
    
  }else{
gameOver=false;

  }
 if((!gameOver)){ // permet de recommencer le jeu
 newAnneau(); // nouvelle anneau
 anneauX=250;
posY=150; // position de la balle
 speedY=2;
 score=0;// remet le score a 0
 loop();        
              }

    
  
}

void init(){// initialise le jeu
  if(!gameOver||help){// - au lancement du jeu
updateDisplay();
  }else{// - après qu'on ait perdu
 updateDisplay();
 
  }
 }
 
 
boolean collisionBords(){ // teste la collision avec les bords de la fenêtre
if((posY<10)||(posY>height-25)|| (anneauX<-5)){
collisionBords=true; // - renvoie faux si le ballon se cogne en haut ou en bas
gameOver();
init();
noLoop();

}
 else{
 collisionBords=false; // - renvoie vrai sinon
 }
return gameOver; 

}



boolean collisionAnneau(){ //test de passage de l'anneau
if((posX<anneauX+100)&& (posX>anneauX)&& (posY>anneauY-25)&& (posY<anneauY)){
collisionAnneau=true; // - renvoie vrai si le ballon touche l'anneau
hit=true;
}else{
collisionAnneau=false; // - renvoie faux sinon
}
return hit;
}

void hit(){

if(collisionAnneau==true){
score++; // met à jour le score et la vitesse de la balle
anneauX=width-5; // puis crée un nouvel anneau
sonHit.play(); // joue le son si la balle entre dans l'anneau
}
}
             
   // c'est perdu !!!        
void gameOver(){
gameOver=true;

}

void newAnneau(){ // crée un nouvel anneau
 image(anneau,anneauX,anneauY);
anneauY=150;// - à au moins de 100 pixels des bords haut et bas

}
