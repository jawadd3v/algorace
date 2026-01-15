import g4p_controls.*;

int[] values;
int arraySize = 100;

int i = 0;
int j = 0;
boolean sorting = false;
boolean sorted = false;

void setup() {
  size(800, 600);
  createGUI();
  values = new int[arraySize];
  
  for (int k = 0; k < arraySize; k++) {
    values[k] = int(random(height - 50));
  }
  
  frameRate(60);
}

void draw() {
  background(30);
  drawBars();
  
  if (sorting && !sorted) {
    bubbleSortStep();
  }
  displayText();
}

void drawBars() {
  float barWidth = width / float(arraySize);
  
  for (int k = 0; k < arraySize; k++) {
    if (sorted) {
      fill(0, 255, 0); // Green when sorted
    }
    else if (k == j || k == j + 1) {
      fill(255, 0, 0);
    }
    else if (k > arraySize - i - 1) {
      fill(100, 200, 100); // Light green for sorted portion
    }
    
    else {
      fill(200); // White/gray for unsorted
    }
    
    rect(k * barWidth, height - values[k], barWidth, values[k]);
  }
}

void bubbleSortStep() {
  if (j < arraySize - i - 1) {
    if ( values[j] > values[j + 1] ) {
      int temp = values[j];
      values[j] = values[j + 1];
      values[j + 1] = temp;
    }
    j++;
  }
  else {
    j = 0;
    i++;
    
    if ( i >= arraySize - 1) {
      sorted = true;
      sorting = false;
    }
  }
}

void displayText() {
  fill(255);
  textSize(16);
  text("Press SPACE to start/pause", 10, 20);
  text("Press 'R' to reset", 10, 40);
  
  if (sorted) {
    textSize(24);
    fill(0, 255, 0);
    text("SORTED!", width/2 - 50, 30);
  }
}

void resetArray() {
  for (int k = 0; k < arraySize; k++) {
    values[k] = int(random(height - 50));
  }
  i = 0;
  j = 0;
  sorting = false;
  sorted = false;
}
