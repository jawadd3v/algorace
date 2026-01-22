import g4p_controls.*;

Sorter sorter;
int arraySize = 200;
int setFPS = 30;

void setup() {
  size(800, 600);
  createGUI();
  sorter = new Sorter(arraySize, height - 100);
  frameRate(setFPS);
}

void draw() {
  background(30);
  
  sorter.display(); // Draw the bars
  sorter.sortStep(); // Draw the bars
  displayStats(); // Display stats
}

void displayStats() {
  fill(255);
  textSize(16);
  
  // Display current algorithm
  textSize(20);
  fill(100, 200, 255);
  String algoName = "";
  if (sorter.algorithm == 0) {
    algoName = "BUBBLE SORT";
  }
  if (sorter.algorithm == 1) {
    algoName = "INSERTION SORT";
  }
  if (sorter.algorithm == 2) {
    algoName = "MERGE SORT";
  }

  // Display stats
  text("Algorithm: " + algoName, 10, 30);
  textSize(16);
  fill(255, 200, 100);
  text("Comparisons: " + sorter.comparisons, 10, 60);
  text("Swaps: " + sorter.swaps, 10, 85);
  
  if (sorter.sorted) {
    textSize(32);
    fill(0, 255, 0);
    text("SORTED!", width/2 - 80, 50);
  }
}
