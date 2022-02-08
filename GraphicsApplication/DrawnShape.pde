//
// DrawnShape
// This class stores a draw shapes active on the canvas, and is responsible for
// 1/ Interpreting the mouse moves to successfully draw a shape
// 2/ Redrawing the shape every frame, once it is drawn
// 3/ Detecting selection events, and selecting the shape if necessary
// 4/ modifying the shape once it is drawn through further actions

class DrawnShape {
  // type of shape
  // line
  // ellipse
  // Rect .....
  String shapeType;

  // used to define the shape bounds during drawing and after
  PVector shapePoint1, shapePoint2;

  boolean isSelected = false;
  
  
  
  public DrawnShape(String shapeType) {
    this.shapeType  = shapeType;
  }


  public boolean tryToggleSelect(PVector p) {
    
    SimpleUIRect boundingBox = new SimpleUIRect(shapePoint1.x, shapePoint1.y, shapePoint2.x, shapePoint2.y);
   
    if ( boundingBox.isPointInside(p)) {
      this.isSelected = !this.isSelected;  // Boolean Logic flips
      return true;
    }
    return false;
  }



  public void drawMe() {

    if (this.isSelected) {
        setSelectedDrawingStyle();
      }else{
        setDefaultDrawingStyle(); 
      }
    
    float x1 = this.shapePoint1.x;
    float y1 = this.shapePoint1.y;
    float x2 = this.shapePoint2.x;
    float y2 = this.shapePoint2.y;
    float w = x2-x1;
    float h = y2-y1;
    
    if ( shapeType.equals("rect")) rect(x1, y1, w, h);
    if ( shapeType.equals("ellipse")) ellipse(x1+ w/2, y1 + h/2, w, h);
    if ( shapeType.equals("line")) line(x1, y1, x2, y2);
   

  }

  void setSelectedDrawingStyle() {
    strokeWeight(2);
    stroke(0, 0, 0);
    fill(255, 100, 100);
    
  }

  void setDefaultDrawingStyle() {
    strokeWeight(1);
    stroke(0, 0, 0);
    fill(127, 127, 127);
  }
  
}     // end DrawnShape
