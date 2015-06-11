import java.util.*;
import controlP5.*;
float displayW, displayH;
float w, h;
PImage img, img2, displayImg;
ControlP5 cp5;
ControlFont cfont;
boolean b=false;
int ar, ag, ab;
Effect e;
PImage[] imageArray;
int c, tracker;
PFont font;
String[] label;
void setup() {
  size(1000, 660);
  frame.setResizable(true);
  cp5=new ControlP5(this);
  font=createFont("SegoeUI-bold", 16);
  cp5.setControlFont(font);
  PFont font2=createFont("SegoeUI", 12);
  ControlFont cfont=new ControlFont(font2, 241);
  cp5.addButton("LOAD")
    .setValue(0)
      .setPosition(0.05*width, 0.355*height)
        .setSize(int(0.1*width), int(0.06*height))
          .setView(new CustomButtons())
            ;
  cp5.addButton("SAVE")
    .setValue(0)
      .setPosition(0.39*width, 0.85*height)
        .setSize(int(0.1*width), int(0.06*height))
          .setView(new CustomButtons())
            ;
  cp5.addButton("APPLY")
    .setValue(0)
      .setPosition(0.25*width, 0.92*height)
        .setSize(int(0.1*width), int(0.06*height))
          .setView(new CustomButtons())
            ;
  b=true;
  cp5.addSlider("Red").setPosition(0.15*width, 0.8*height)
    .setRange(0, 255).setSize(int(0.15*width), 15).setValue(255);
  cp5.addSlider("Green").setPosition(0.15*width, 0.85*height)
    .setRange(0, 255).setSize(int(0.15*width), 15).setValue(255);
  cp5.addSlider("Blue").setPosition(0.15*width, 0.9*height)
    .setRange(0, 255).setSize(int(0.15*width), 15).setValue(255);
  cp5.getController("Red").getCaptionLabel().setFont(cfont).setSize(12).toUpperCase(false).setColor(color(0, 160, 150));
  cp5.getController("Green").getCaptionLabel().setFont(cfont).setSize(12).toUpperCase(false).setColor(color(0, 160, 150));
  cp5.getController("Blue").getCaptionLabel().setFont(cfont).setSize(12).toUpperCase(false).setColor(color(0, 160, 150));
  c=0;
  imageArray=new PImage[16];
  tracker=0;
  //zvogelojme frameRate per te ekonomizuar perdorimin e procesorit
  frameRate(11);
  label=new String[16];
  createLabels();
}
void draw() {
  background(255);
  displayW=0.60*width;
  displayH=0.75*height;
  float leftPad=0.2*width;
  float topPad=0.02*height;
  fill(240);
  rect(leftPad, topPad, displayW, displayH);
  rect(0.66*width, 0.8*height, 80, 80);
  tint(ar, ag, ab);
  if (img!=null) {
    display(displayImg);
    if (c<16) {
      arrayCreator(c);
      c++;
    }
    displayEffect(tracker);
  }
  drawLeftButton();
  drawRightButton();
  updatePositions();
  stroke(0, 160, 150);
  noFill();
  rect(leftPad, topPad, displayW, displayH);
  stroke(200);
  rect(0.66*width, 0.8*height, 80, 80);
  if (dist(mouseX, mouseY, 0.625*width, 0.8*height+40)<0.03*width) {
    noStroke();
    fill(230, 100);
    ellipse(0.625*width, 0.8*height+40, 0.03*width, 0.03*width);
  } else if (dist(mouseX, mouseY, 0.695*width+80, 0.8*height+40)<0.03*width) {
    noStroke();
    fill(230, 100);
    ellipse(0.695*width+80, 0.8*height+40, 0.03*width, 0.03*width);
  } else if (mouseX>0.66*width && mouseX<0.66*width+80 && mouseY>0.8*height && mouseY<0.8*height+80) {
    pushStyle();
    strokeWeight(3);
    //stroke(255);
    fill(0, 160, 150, 50);
    rect(0.66*width, 0.8*height, 80, 80);
    popStyle();
  }
  drawLabel();
}
void LOAD() {
  if (b)
    selectInput("Select an image you want to process: ", "fileSelected");
}
void SAVE() {
  if (img!=null) {
    if (b) {
      img2=createImage(img.width, img.height, RGB);
      img.loadPixels();
      img2.loadPixels();
      for (int i=0; i<img.pixels.length; i++) {
        float r=red(img.pixels[i]);
        float g=green(img.pixels[i]);
        float b=blue(img.pixels[i]);
        r=map(r, 0, 255, 0, ar);
        g=map(g, 0, 255, 0, ag);
        b=map(b, 0, 255, 0, ab);
        img2.pixels[i]=color(r, g, b);
      } 
      img.updatePixels();
      img2.updatePixels();
      selectOutput("Save as: ", "saveImage");
    }
  }
}
void APPLY() {
  if (img!=null) {
    if (b) {
      displayImg.loadPixels();
      img.loadPixels();
      for (int i=0; i<displayImg.pixels.length; i++) {
        float r=red(displayImg.pixels[i]);
        float g=green(displayImg.pixels[i]);
        float b=blue(displayImg.pixels[i]);
        if(r>ar) r = ar;
        if(g>ag) g = ag;
        if(b>ab) b = ab;
        /*r=map(r, 0, 255, 0, ar);
        g=map(g, 0, 255, 0, ag);
        b=map(b, 0, 255, 0, ab);*/
        displayImg.pixels[i]=color(r, g, b);
      }
      displayImg.updatePixels();
      img.updatePixels();
      img=displayImg;
    }
  }
}

void display(PImage img) {
  w=img.width;
  h=img.height;
  if (w>displayW) {
    float r=w/displayW;
    h=h/r;
    w=displayW;
  }
  if (h>displayH) {
    float r=h/displayH;
    w=w/r;
    h=displayH;
  }
  imageMode(CENTER);
  image(img, 0.5*width, 0.395*height, w, h);
  e=new Effect();
}
void saveImage(File destination) {
  img2.save(destination.getAbsolutePath()+".jpg");
}
void fileSelected(File selection) {
  if (selection==null) {
    println("Window was closed or the user hit cancel.");
  } else {
    img=loadImage(selection.getAbsolutePath());
    displayImg=img;
    c=0;
  }
}
void Red(int theValue) {
  ar=theValue;
}
void Green(int theValue) {
  ag=theValue;
}
void Blue(int theValue) {
  ab=theValue;
}
void mousePressed() {
  if (img!=null) {
    if (dist(mouseX, mouseY, 0.625*width, 0.8*height+40)<0.03*width) {
      if (tracker>0) tracker--;
      else tracker=15;
    } else if (dist(mouseX, mouseY, 0.695*width+80, 0.8*height+40)<0.03*width) {
      if (tracker<15) tracker++;
      else tracker=0;
    } else if (mouseX>0.66*width && mouseX<0.66*width+80 && mouseY>0.8*height && mouseY<0.8*height+80) {
      changeImage();
    }
  }
}
void arrayCreator(int c) {
  switch(c) {
  case 0: 
    imageArray[0]=img;
    break;
  case 1: 
    imageArray[15]=e.noiseDisplacement();
    imageArray[1]=e.colorReduction();   
    break;
  case 2: 
    imageArray[2]=e.pixellate();
    imageArray[14]=e.blur(); 
    break;
  case 3: 
    imageArray[3]=e.fragmentation(); 
    break;
  case 4:
    imageArray[4]=e.rgbUnphased();  
    break;
  case 5: 
    imageArray[5]=e.blackAndWhiteUnphased(); 
    break;
  case 6: 
    imageArray[6]=e.hueThreshold();
    break;
  case 7: 
    imageArray[7]=e.saturationThreshold();  
    break;
  case 8: 
    imageArray[8]=e.brightnessThreshold();
    break;
  case 9: 
    imageArray[9]=e.gaussianNoise();  
    break;
  case 10: 
    imageArray[10]=e.staticPeriodicNoise(); 
    break;
  case 11: 
    imageArray[11]=e.pepperSaltNoise(); 
    break;
  case 12: 
    imageArray[12]=e.impulseNoise();
    break;
  case 13: 
    imageArray[13]=e.laplasianEdit();  
    break;
  case 14:
    imageArray[14]=e.blur();
    break;
  case 15: 
    imageArray[15]=e.noiseDisplacement(); 
    break;
  }
}
void displayEffect(int t) {
  float ew=img.width;
  float eh=img.height;
  if (ew>80) {
    float r=ew/80;
    eh=eh/r;
    ew=80;
  }
  if (eh>80) {
    float r=eh/80;
    eh=80;
    ew=80/r;
  }
  imageMode(CENTER);
  image(imageArray[t], 0.66*width+40, 0.80*height+40, ew, eh);
}
void drawLeftButton() {
  pushStyle();
  stroke(180);
  line(0.61*width, 0.8*height+40, 0.64*width, 0.8*height+40);
  line(0.61*width, 0.8*height+40, 0.62*width, 0.79*height+40);
  line(0.61*width, 0.8*height+40, 0.62*width, 0.81*height+40);
  popStyle();
}
void drawRightButton() {
  pushStyle();
  stroke(180);
  line(0.68*width+80, 0.8*height+40, 0.71*width+80, 0.8*height+40);
  line(0.71*width+80, 0.8*height+40, 0.70*width+80, 0.79*height+40);
  line(0.71*width+80, 0.8*height+40, 0.70*width+80, 0.81*height+40);
  popStyle();
}
void changeImage() {
  switch(tracker) {
  case 1: 
    displayImg=e.colorReduction(); 
    break;
  case 2: 
    displayImg=e.pixellate(); 
    break;
  case 3: 
    displayImg=e.fragmentation(); 
    break;
  case 4: 
    displayImg=e.rgbUnphased(); 
    break;
  case 5: 
    displayImg=e.blackAndWhiteUnphased(); 
    break;
  case 6: 
    displayImg=e.hueThreshold(); 
    break;
  case 7: 
    displayImg=e.saturationThreshold(); 
    break;
  case 8: 
    displayImg=e.brightnessThreshold(); 
    break;
  case 9: 
    displayImg=e.gaussianNoise(); 
    break;
  case 10: 
    displayImg=e.staticPeriodicNoise(); 
    break;
  case 11: 
    displayImg=e.pepperSaltNoise(); 
    break;
  case 12: 
    displayImg=e.impulseNoise(); 
    break;
  case 13: 
    displayImg=e.laplasianEdit(); 
    break;
  case 14: 
    displayImg=e.blur(); 
    break;
  case 15: 
    displayImg=e.noiseDisplacement();
    break;
  case 0:
    displayImg=img; 
    break;
  }
}
void drawLabel() {
  pushStyle();
  textFont(font, 12);
  textAlign(CENTER);
  fill(0, 160, 150);
  text(label[tracker], 0.66*width+40, 0.95*height);
  popStyle();
}
void createLabels() {
  label[1]="color reduction";
  label[2]="pixellate";
  label[3]="fragments";
  label[4]="caleidoscope";
  label[5]="double";
  label[6]="threshold experoment 1";
  label[7]="threshold experoment 2";
  label[8]="threshold experoment 3";
  label[9]="gaussian noise";
  label[10]="periodic nosie";
  label[11]="salt and pepper";
  label[12]="impulses";
  label[13]="laplasian experiment";
  label[14]="unclear";
  label[15]="waves";
  label[0]="no effect";
}
void updatePositions() {
  cp5.getController("LOAD").setPosition(0.05*width, 0.355*height);
  cp5.getController("SAVE").setPosition(0.95*width-100, 0.355*height);
  cp5.getController("APPLY").setPosition(0.5*width-50, 0.85*height);
  cp5.getController("Red").setPosition(0.21*width, 0.8*height);
  cp5.getController("Green").setPosition(0.21*width, 0.85*height);
  cp5.getController("Blue").setPosition(0.21*width, 0.9*height);
  cp5.getController("Red").setSize(int(0.15*width), 15);
  cp5.getController("Green").setSize(int(0.15*width), 15);
  cp5.getController("Blue").setSize(int(0.15*width), 15);
}

