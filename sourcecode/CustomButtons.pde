class CustomButtons implements ControllerView<Button>{
  public void display(PApplet theApplet, Button theButton) {
    theApplet.pushMatrix();
    if (theButton.isInside()) {
      if (theButton.isPressed()) { // button is pressed
        theApplet.fill(0, 240, 230);
      }  else { // mouse hovers the button
        theApplet.fill(0, 210, 200);
      }
    } else { // the mouse is located outside the button area
      theApplet.fill(0, 160, 150);
    }
    theApplet.rect(0, 0, theButton.getWidth(), theButton.getHeight());
    theApplet.ellipse(-theButton.getHeight()/2, 0, theButton.getHeight(), theButton.getHeight());
    theApplet.ellipse(theButton.getWidth()-theButton.getHeight()/2, 0, theButton.getHeight(), theButton.getHeight());
    // center the caption label 
    int x = theButton.getWidth()/2 - theButton.getCaptionLabel().getWidth()/2;
    int y = theButton.getHeight()/2 - theButton.getCaptionLabel().getHeight()/2;
    translate(x, y);
    theButton.getCaptionLabel().draw(theApplet);
    
    theApplet.popMatrix();
  }
}

