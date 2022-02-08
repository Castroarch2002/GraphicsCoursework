// DrawingList Class
// this class stores all the drawn shapes during and after thay have been drawn

class DrawingList {

  ArrayList<DrawnShape> shapeList = new ArrayList<DrawnShape>();

  

  public DrawingList() {
  }
  
  public void drawMe() {
    for (DrawnShape s : shapeList) {
      s.drawMe();
    }
  }


  public void createShape(String shapeType, String mouseEventType, PVector mouseLoc) {

    if ( mouseEventType.equals("mousePressed")) {
      // create a new shape that is being drawn
      DrawnShape newShape = new DrawnShape(shapeType);
      newShape.shapePoint1 = mouseLoc;
      newShape.shapePoint2 = mouseLoc;
      // add it to the drawingList so that is is drawn from now on
      shapeList.add(newShape);
    }

    if ( mouseEventType.equals("mouseDragged")) {
      DrawnShape mostRecentShape = shapeList.get(shapeList.size()-1);
      mostRecentShape.shapePoint2 = mouseLoc;
    }

  }


  

  public void trySelect(String mouseEventType, PVector mouseLoc) {
    if( mouseEventType.equals("mousePressed")){
      
      for (DrawnShape s : shapeList) {
        boolean selectionFound = s.tryToggleSelect(mouseLoc);
       if (selectionFound) break;
      }
      
    }
    
  }
  
  
  void deleteSelected(){
    ArrayList<DrawnShape> tempShapeList = new ArrayList<DrawnShape>();
    for (DrawnShape s : shapeList) {
     
        if (s.isSelected == false) tempShapeList.add(s);
      }
    shapeList = tempShapeList;
  }
  
  
  
}
