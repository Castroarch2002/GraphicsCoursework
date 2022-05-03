// This is my Graphics Application
// Made by Hugo Castro N0936926

PImage loadedImage;
PImage outputImage;

SimpleUI myUI;
DrawingList drawingList;

String toolMode = "";

void setup() {
  size(900, 600);

  myUI = new SimpleUI();
  drawingList = new DrawingList();

  // Draw Rectangle (Live Shape)
  RadioButton  rectButton = myUI.addRadioButton("rect", 5, 50, "group1");

  // Draw Ellipse (Live Shape)
  myUI.addRadioButton("ellipse", 5, 80, "group1");

  // Draw Line (Live Shape)
  myUI.addRadioButton("line", 5, 110, "group1");

  // Draw Image (Click and Drag)
  myUI.addRadioButton("image", 5, 140, "group1");

  // Undo Image Changes
  myUI.addRadioButton("undo", 5, 170, "group1");

  rectButton.selected = true;
  toolMode = rectButton.UILabel;

  // add a new tool .. the select tool
  myUI.addRadioButton("select", 5, 200, "group1");

  // Add Canvas
  myUI.addCanvas(110, 10, 780, 580);

  // Simple buttons
  myUI.addSimpleButton("load file", 5, 230);
  myUI.addSimpleButton("save file", 5, 260);

  // Image Processing Menu 
  String[] items = { "brighten", "darken", "contrast", "negative" };
  myUI.addMenu("Effect", 5, 290, items);
}

void draw() {
  background(255);

  drawingList.drawMe();

  // Must Update the UI in draw 
  myUI.update();
}

void handleUIEvent(UIEventData uied) {


  // if from a tool-mode button, the just set the current tool mode string 
  if (uied.uiComponentType == "RadioButton") {
    toolMode = uied.uiLabel;
    return;
  }

  // Saving and Loading Images 
  // here we just get the event to print its self
  // with "verbosity" set to 1, (1 = low, 3 = high, 0 = do not print anything)
  uied.print(2);

  //////////////////////////////////////////////////
  // loading a file via the file dialog 
  //

  // this responds to the "load file" button and opens the file-load dialogue
  if (uied.eventIsFromWidget("load file")) {
    myUI.openFileLoadDialog("load an image");
  }

  //this catches the file load information when the file load dialogue's "open" button is hit
  if (uied.eventIsFromWidget("fileLoadDialog")) {
    loadedImage = loadImage(uied.fileSelection);
    outputImage =  loadedImage.copy();
  }

  //////////////////////////////////////////////////
  // saving a file via the file dialog 
  //

  // this responds to the "save file" button and opens the file-save dialogue
  if (uied.eventIsFromWidget("save file")) {
    myUI.openFileSaveDialog("save an image");
  }

  //this catches the file save information when the file save dialogue's "save" button is hit
  if (uied.eventIsFromWidget("fileSaveDialog")) {
    outputImage.save(uied.fileSelection);
  }

  if ( uied.eventIsFromWidget("brighten")) {
    int[] lut =  makeLUT("brighten", 1.5, 0.0);
    outputImage = applyPointProcessing(lut, loadedImage);
  }

  if ( uied.eventIsFromWidget("darken")) {
    int[] lut =  makeLUT("brighten", 0.5, 0.0);
    outputImage = applyPointProcessing(lut, loadedImage);
  }


  if ( uied.eventIsFromWidget("contrast")) {
    int[] lut =  makeLUT("sigmoid", 0.0, 0.0);
    outputImage = applyPointProcessing(lut, loadedImage);
  }

  if ( uied.eventIsFromWidget("negative")) {
    int[] lut =  makeLUT("negative", 0.0, 0.0);
    outputImage = applyPointProcessing(lut, loadedImage);
  }

  // only canvas events below here! First get the mouse point
  if (uied.eventIsFromWidget("canvas")==false) return;
  PVector p =  new PVector(uied.mousex, uied.mousey);

  // this next line catches all the tool shape-drawing modes 
  // so that drawing events are sent to the display list class only if the current tool 
  // is a shape drawing tool
  if ( toolMode.equals("rect") || 
    toolMode.equals("ellipse")||
    toolMode.equals("line")||
    toolMode.equals("image")) {
    drawingList.createShape(toolMode, uied.mouseEventType, p);
    return;
  }

  // if the current tool is "select" then do this
  if ( toolMode.equals("select") ) {    
    drawingList.trySelect(uied.mouseEventType, p);
  }

  // Changing back to original
  if ( uied.eventIsFromWidget("undo")) {
    outputImage = loadedImage.copy();
  }
}

// Making LUTs

int[] makeLUT(String functionName, float param1, float param2) {
  int[] lut = new int[256];
  for (int n = 0; n < 256; n++) {

    float p = n/255.0f;  // p ranges between 0...1
    float val = getValueFromFunction( p, functionName, param1, param2);
    lut[n] = (int)(val*255);
  }
  return lut;
}

float getValueFromFunction(float inputVal, String functionName, float param1, float param2) {
  if (functionName.equals("brighten")) {
    return simpleScale(inputVal, param1);
  }

  if (functionName.equals("step")) {
    return step(inputVal, (int)param1);
  }

  if (functionName.equals("negative")) {
    return invert(inputVal);
  }

  if (functionName.equals("sigmoid")) {
    return sigmoidCurve(inputVal);
  }

  // should only get here is the functionName is undefined
  return 0;
}


PImage applyPointProcessing(int[] LUT, PImage inputImage) {
  PImage outputImage = createImage(inputImage.width, inputImage.height, RGB);




  for (int y = 0; y < inputImage.height; y++) {
    for (int x = 0; x < inputImage.width; x++) {

      color c = inputImage.get(x, y);

      int r = (int)red(c);
      int g = (int)green(c);
      int b = (int)blue(c);

      int lutR = LUT[r];
      int lutG = LUT[g];
      int lutB = LUT[b];


      outputImage.set(x, y, color(lutR, lutG, lutB));
    }
  }

  return outputImage;
}



float getSeconds() {
  float t = millis()/1000.0;
  return t;
}

// makeFunctionLUT
// this function returns a LUT from the range of functions listed
// in the second TAB above
// The parameters are functionName: a string to specify the function used
// parameter1 and parameter2 are optional, some functions do not require
// any parameters, some require one, some two

int[] makeFunctionLUT(String functionName, float parameter1, float parameter2) {

  int[] lut = new int[256];
  for (int n = 0; n < 256; n++) {

    float p = n/256.0f;  // ranges between 0...1
    float val = 0;

    switch(functionName) {
      // add in the list of functions here
      // and set the val accordingly
      //
      //
    }// end of switch statement


    lut[n] = (int)(val*255);
  }

  return lut;
}  

void keyPressed() {
  if (key == BACKSPACE) {
    drawingList.deleteSelected();
  }
}
