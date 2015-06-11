class Effect {
  PImage tempImg;
  Effect() {
    tempImg=createImage(img.width, img.height, RGB);
  }
  PImage colorReduction() {
    tempImg=createImage(img.width, img.height, RGB);
    pushStyle();
    colorMode(RGB, 4);
    img.loadPixels();
    tempImg.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int loc=i+j*img.width;
        int r=int(red(img.pixels[loc]));
        int g=int(green(img.pixels[loc]));
        int b=int(blue(img.pixels[loc]));
        tempImg.pixels[loc]=color(r, g, b);
      }
    }
    img.updatePixels();
    tempImg.updatePixels();
    popStyle();
    return tempImg;
  }
  PImage pixellate() {
    tempImg=createImage(img.width, img.height, RGB);
    img.loadPixels();
    tempImg.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int loc=i+j*img.width;
        int colorLoc=(i/5)*5+((j/5)*5)*img.width;
        color c=img.pixels[colorLoc];
        tempImg.pixels[loc]=c;
      }
    }
    img.updatePixels();
    tempImg.updatePixels();
    return tempImg;
  }
  PImage fragmentation() {
    tempImg=createImage(img.width, img.height, RGB);
    tempImg=img.get();
    int fragW=img.width/4;
    int fragH=img.height/4;
    int frags=16;
    ArrayList<PImage> imgs=new ArrayList<PImage>();
    for (int i=0; i<img.width; i+=fragW) {
      for (int j=0; j<img.height; j+=fragH) {
        imgs.add(img.get(i, j, fragW, fragH));
      }
    }
    for (int i=0; i<img.width; i+=fragW) {
      for (int j=0; j<img.height; j+=fragH) {
        int r=int(random(0, imgs.size()));
        tempImg.blend(imgs.get(r), 0, 0, fragW, fragH, i, j, fragW, fragH, SOFT_LIGHT);
        imgs.remove(r);
      }
    }
    return tempImg;
  }
  PImage rgbUnphased() {
    tempImg=createImage(img.width, img.height, RGB);
    float r, g, b;
    PImage img1=img.get();
    tempImg.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int loc=i+j*img.width;
        if (i%img.width<(img.width-10))
          r=red(img1.pixels[i+10+j*img.width]);
        else r=20;
        g=green(img1.pixels[loc]);
        if (i%img.width>10 && j%img.height>5)
          b=blue(img1.pixels[i-10+(j-5)*img.width]);
        else b=20;
        tempImg.pixels[loc]=color(r, g, b);
      }
    }
    tempImg.updatePixels();    
    return tempImg;
  }
  PImage blackAndWhiteUnphased() {
    tempImg=createImage(img.width, img.height, RGB);
    float bw, bw1;
    img.loadPixels();
    tempImg.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int loc=i+j*img.width;
        float r=red(img.pixels[loc]);
        float g=green(img.pixels[loc]);
        float b=blue(img.pixels[loc]);
        bw = 0.2126*r + 0.7152*g + 0.0722*b;
        if (i<img.width-10 && j>5) {
          float r1=red(img.pixels[(i+10)+(j-5)*img.width]);
          float g1=green(img.pixels[(i+10)+(j-5)*img.width]);
          float b1=blue(img.pixels[(i+10)+(j-5)*img.width]);
          bw1 = 0.2126*r1 + 0.7152*g1 + 0.0722*b1;
        }
        else bw1=bw;
        color c=color((bw + bw1)/2);
        tempImg.pixels[loc]=c;
      }
    }
    img.updatePixels();
    tempImg.updatePixels();
    return tempImg;
  }
  PImage brightnessThreshold() {
    tempImg=createImage(img.width, img.height, RGB);
    pushStyle();
    colorMode(HSB, 100);
    img.loadPixels();
    tempImg.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int loc=i+j*img.width;
        float h=hue(img.pixels[loc]);
        float b=brightness(img.pixels[loc]);
        float s=saturation(img.pixels[loc]);
        if (b<50) {
          b=map(b, 0, 50, 10, 20);
          tempImg.pixels[loc]=color(h, s, b);
        }
        else {
          b=map(b, 50, 100, 80, 90);
          tempImg.pixels[loc]=color(h, s, b);
        }
      }
    }
    img.updatePixels();
    tempImg.updatePixels();
    popStyle();
    return tempImg;
  }
  PImage hueThreshold() {
    tempImg=createImage(img.width, img.height, RGB);
    pushStyle();
    colorMode(HSB, 100);
    img.loadPixels();
    tempImg.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int loc=i+j*img.width;
        float h=hue(img.pixels[loc]);
        float b=brightness(img.pixels[loc]);
        float s=saturation(img.pixels[loc]);
        if (h<75 && h>25) {
          tempImg.pixels[loc]=color(50, s, b);
        }
        else {
          tempImg.pixels[loc]=color(0, s, b);
        }
      }
    }
    img.updatePixels();
    tempImg.updatePixels();
    popStyle();
    return tempImg;
  } 
  PImage saturationThreshold() {
    tempImg=createImage(img.width, img.height, RGB);
    pushStyle();
    colorMode(HSB, 100);
    img.loadPixels();
    tempImg.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int loc=i+j*img.width;
        float h=hue(img.pixels[loc]);
        float b=brightness(img.pixels[loc]);
        float s=saturation(img.pixels[loc]);
        if (s<50) {
          s=map(s, 0, 50, 10, 20);
          tempImg.pixels[loc]=color(h, s, b);
        }
        else {
          s=map(s, 50, 100, 80, 90);
          tempImg.pixels[loc]=color(h, s, b);
        }
      }
    }
    img.updatePixels();
    tempImg.updatePixels();
    popStyle();
    return tempImg;
  }  
  PImage gaussianNoise() {
    tempImg=createImage(img.width, img.height, RGB);
    Random generator=new Random();
    img.loadPixels();
    tempImg.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int loc=i+j*img.width;
        float n=(float)generator.nextGaussian()*50;
        float r=red(img.pixels[loc]);
        float g=green(img.pixels[loc]);
        float b=blue(img.pixels[loc]);
        tempImg.pixels[loc]=color(r+n, g+n, b+n);
      }
    }
    img.updatePixels();
    tempImg.updatePixels();
    return tempImg;
  }
  PImage staticPeriodicNoise() {
    tempImg=createImage(img.width, img.height, RGB);
    float a=0;
    float c;
    img.loadPixels();
    tempImg.loadPixels();
    for (int i=0; i<img.width; i++) {
      c=0;
      for (int j=0; j<img.height; j++) {
        int loc=i+j*img.width;
        float n=map(sin(a+c), -1, 1, -70, 70);
        float r=red(img.pixels[loc]);
        float g=green(img.pixels[loc]);
        float b=blue(img.pixels[loc]);
        tempImg.pixels[loc]=color(r+n, g+n, b+n);
        c+=0.02;
      }
      a+=0.05;
    }
    img.updatePixels();
    tempImg.updatePixels();
    return tempImg;
  }
  PImage pepperSaltNoise() {
    tempImg=createImage(img.width, img.height, RGB);
    img.loadPixels();
    tempImg.loadPixels();
    for (int i=0; i<img.pixels.length; i++) {
      if (random(1)<0.1) {
        if (random(1)<0.5)
          tempImg.pixels[i]=color(0);
        else tempImg.pixels[i]=color(255);
      }
      else tempImg.pixels[i]=img.pixels[i];
    }
    img.updatePixels();
    tempImg.updatePixels();
    return tempImg;
  }
  PImage impulseNoise() {
    tempImg=createImage(img.width, img.height, RGB);
    float t=random(100);
    img.loadPixels();
    tempImg.loadPixels();
    for (int i=0; i<img.pixels.length; i++) {
      float n=noise(t);
      if (n>0.82) {
        tempImg.pixels[i]=color(0);
        t+=0.002;
      }
      else {
        tempImg.pixels[i]=img.pixels[i];
        t+=0.01;
      }
    }
    img.updatePixels();
    tempImg.updatePixels();
    return tempImg;
  }
  PImage laplasianEdit() {
    tempImg=createImage(img.width, img.height, RGB);
    float[][] filter= {
      {
        0, -1, 0
      }
      , {
        -1, 4.3, -1
      }
      , {
        0, -1, 0
      }
    };
    img.loadPixels();
    tempImg.loadPixels();
    for (int x=1; x<img.width-1; x++) {
      for (int y=1; y<img.height-1; y++) {
        int loc=x+y*img.width;
        color c=convolution(x, y, filter, 3, img);
        float r=red(c);
        float g=green(c);
        float b=blue(c);
        float bright=(0.26*r + 0.6*g + 0.14*b)*1.5;
        tempImg.pixels[loc]=color(bright);
      }
    }
    img.updatePixels();
    tempImg.updatePixels();
    return tempImg;
  }
  PImage blur() {
    tempImg=createImage(img.width, img.height, RGB);
    float[][] filter= {
      {
        0.04, 0.04, 0.04, 0.04, 0.04
      }
      , {
        0.04, 0.04, 0.04, 0.04, 0.04
      }
      , {
        0.04, 0.04, 0.04, 0.04, 0.04
      }
      , 
      {
        0.04, 0.04, 0.04, 0.04, 0.04
      }
      , {
        0.04, 0.04, 0.04, 0.04, 0.04
      }
    };
    img.loadPixels();
    tempImg.loadPixels();
    for (int h=0; h<3; h++) {
      for (int x=3; x<img.width-3; x++) {
        for (int y=3; y<img.height-3; y++) {
          int loc=x+y*img.width;
          color c=convolution(x, y, filter, 5, img);
          tempImg.pixels[loc]=c;
        }
      }
    }
    img.updatePixels();
    tempImg.updatePixels();
    return tempImg;
  }
  color convolution(int x, int y, float[][] filter, int matrixsize, PImage img) {
    float rtotal=0;
    float gtotal=0;
    float btotal=0;
    for (int i=0; i<matrixsize; i++) {
      for (int j=0; j<matrixsize; j++) {
        int xloc=x+i-1;
        int yloc=y+j-1;
        int loc=xloc+yloc*img.width;
        rtotal+=(red(img.pixels[loc])*filter[i][j]);
        gtotal+=(green(img.pixels[loc])*filter[i][j]);
        btotal+=(blue(img.pixels[loc])*filter[i][j]);
      }
    }
    rtotal=constrain(rtotal, 0, 255);
    gtotal=constrain(gtotal, 0, 255);
    btotal=constrain(btotal, 0, 255);
    return color(rtotal, gtotal, btotal);
  }
  PImage noiseDisplacement() {
    img.loadPixels();
    tempImg.loadPixels();
    float a=random(100);
    for (int j=0; j<img.height; j++) {
      int n=(int)map(noise(a), 0, 1, -33, 33);
      for (int i=0; i<img.width; i++) {
        int loc=i+j*img.width;
        if ((i+n)>0 && (i+n)<img.width) {
          tempImg.pixels[loc+n]=img.pixels[loc];
        }
      }
      a+=0.01;
    }
    img.updatePixels();
    tempImg.updatePixels();
    return tempImg;
  }
}
