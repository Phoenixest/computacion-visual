import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

// 1. Nub objects
Scene scene;
Node node;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

// 4. Window dimension
int dim = 9;

void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
}

void setup() {
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);

  // not really needed here but create a spinning task
  // just to illustrate some nub.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the node instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
      public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  node = new Node();
  node.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 50, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(node);
  triangleRaster();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the node system which has a dimension of 2^n
void triangleRaster() {
  // node.location converts points from world to node
  // here we convert v1 to illustrate the idea
  if (debug) {
    float area = (node.location(v3).x()-node.location(v1).x())*(node.location(v2).y()-node.location(v1).y()) - (node.location(v3).y()-node.location(v1).y())*(node.location(v2).x()-node.location(v1).x());
    pushStyle();
    noStroke();
    for (int x = round(-pow(2, n-1)); x < pow(2, n-1); x++) {
      for (int y = round(-pow(2, n-1)); y < pow(2, n-1); y++) {
        int c = 0;
        if (inside(x+0.25, y+0.25) == true)
          c += 1;
        if (inside(x+0.75, y+0.25) == true)
          c += 1;
        if (inside(x+0.25, y+0.75) == true)
          c += 1;
        if (inside(x+0.75, y+0.75) == true)
          c += 1;
        if (c > 0) {
          float w1 = edge(v2, v3, new Vector(x+0.5,y+0.5));
          float w2 = edge(v3, v1, new Vector(x+0.5,y+0.5));
          float w3 = edge(v1, v2, new Vector(x+0.5,y+0.5));
          w1 /= area;
          w2 /= area;
          w3 /= area;
          fill((map(w1, 0, 1, 0, 255)*c/4), (map(w2, 0, 1, 0, 255)*c/4), (map(w3, 0, 1, 0, 255)*c/4));
          square(x, y, 1);
        };
      }
    }
    popStyle();
  }
  
  
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

boolean inside(float x, float y) {
  boolean inside = true;
  inside &= (edge(v1, v2, new Vector(x,y)) <= 0);
  inside &= (edge(v2, v3, new Vector(x,y)) <= 0);
  inside &= (edge(v3, v1, new Vector(x,y)) <= 0);
  
  boolean inside2 = true;
  inside2 &= (edge(v1, v2, new Vector(x,y)) >= 0);
  inside2 &= (edge(v2, v3, new Vector(x,y)) >= 0);
  inside2 &= (edge(v3, v1, new Vector(x,y)) >= 0);
  return inside||inside2;
}

float edge(Vector a, Vector b, Vector c){
  return (c.x()-node.location(a).x())*(node.location(b).y()-node.location(a).y()) - (c.y()-node.location(a).y())*(node.location(b).x()-node.location(a).x());
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    node.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    node.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}
