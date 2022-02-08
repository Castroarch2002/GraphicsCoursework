// This is my Graphics Application
// Made by Hugo Castro N0936926

PImage loadedImage;

SimpleUI myUI;
DrawingList drawingList;

String toolMode = "";

void setup() {
  size(900,600);
  
  myUI = new SimpleUI();
  drawingList = new DrawingList();
 
 // Draw Rectangle (Live Shape)
  RadioButton  rectButton = myUI.addRadioButton("rect", 5, 50, "group1");
  
  // Draw Ellipse (Live Shape)
  myUI.addRadioButton("ellipse", 5, 80, "group1");
  
  // Draw Line (Live Shape)
  myUI.addRadioButton("line", 5, 110, "group1");
  
  rectButton.selected = true;
  toolMode = rectButton.UILabel;
  
  // add a new tool .. the select tool
  myUI.addRadioButton("select", 5, 140, "group1");
  
  // Add Canvas
  myUI.addCanvas(110,10,780,580);
  
  // Ordinary buttons
  myUI.addSimpleButton("Load File", 5, 170);
  myUI.addSimpleButton("Save File", 5, 200);
  
}

void draw() {
 background(255);
 drawingList.drawMe();
 myUI.update();
}


void handleUIEvent(UIEventData eventData){
  
  // if from a tool-mode button, the just set the current tool mode string 
  if(eventData.uiComponentType == "RadioButton"){
    toolMode = eventData.uiLabel;
    return;
  }

  // only canvas events below here! First get the mouse point
  if(eventData.eventIsFromWidget("canvas")==false) return;
  PVector p =  new PVector(eventData.mousex, eventData.mousey);
  
  // this next line catches all the tool shape-drawing modes 
  // so that drawing events are sent to the display list class only if the current tool 
  // is a shape drawing tool
  if( toolMode.equals("rect") || 
      toolMode.equals("ellipse") ||
      toolMode.equals("line"))  {    
     drawingList.createShape(toolMode,eventData.mouseEventType, p);
     return;
  }
   
  // if the current tool is "select" then do this
  if( toolMode.equals("select") ) {    
      drawingList.trySelect(eventData.mouseEventType, p);
    }
  

}

void keyPressed(){
  if(key == BACKSPACE){
    drawingList.deleteSelected();
  }
}
