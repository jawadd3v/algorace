// SORTING ALGORITHM VISUALIZER + RACER (ALGORACE)
// Jawad Dajani ICS4U

import g4p_controls.*; // Import g4p module

// Variables
Sorter sorter; // Sorting logic class
int arraySize = 50; // Inital number of bars to sort (adjustable)
int setFPS = 30; // Animation speed in frames( also adjustable)

// Race mode variables
boolean raceMode = false; // Tracks if normal mode or race mode 
int raceAlgo1 = 0; // first algorithm to race (0 to 4)
int raceAlgo2 = 1; // second algorithm to race (0 to 4)
int racePhase = 0; // 0=first algo running, 1=second algo running, 2=done
int algo1Comparisons = 0; // Store comparisons from first algorithm
int algo2Comparisons = 0; // Store comparisons from second algorithm

void setup() {
  size(800, 600);
  createGUI(); // Initialize g4p elements
  sorter = new Sorter(arraySize, height - 100); // Constructor
  frameRate(setFPS);
}

void draw() {
  background(30); // Dark grey background
  
  sorter.display(); // Display sorting bars
  
  if (raceMode) {
    // Race mode active (run two algorithms sequentially)
    if (racePhase == 0) {
      // Running first algorithm
      sorter.sortStep();
      if (sorter.sorted) {
        algo1Comparisons = sorter.comparisons; // First algorithm finished save results
        // Start second algorithm
        sorter.restoreOriginal(); // Reset to original unosrted array
        sorter.setAlgorithm(raceAlgo2); // Switch to second alogrithm
        sorter.sorting = true; // Start sorting
        racePhase = 1; // Move to phase 1
      }
    } 
    else if (racePhase == 1) {
      // Running second algorithm
      sorter.sortStep();
      if (sorter.sorted) {
        algo2Comparisons = sorter.comparisons; // Second algorithm finished save results
        racePhase = 2; // Move to results
      }
    }
  } 
  else {
    // Normal mode
    sorter.sortStep();
  }
  
  displayStats(); // Displaying statistics on top
}

void displayStats() {
  fill(255);
  textSize(16);
  
  if (!raceMode) {
    // Normal mode display
    textSize(20);
    fill(100, 200, 255); // Light blue
    String algoName = getAlgorithmName(sorter.algorithm); // Get algoname
    
    text("Algorithm: " + algoName, 10, 30); 
    textSize(16);
    fill(255, 200, 100); // Orange
    text("Comparisons: " + sorter.comparisons, 10, 60); // Comparisons
    text("Swaps: " + sorter.swaps, 10, 85); // Swaps
    
    if (sorter.sorted) {
      // Show "SORTED!" when complete
      textSize(32);
      fill(0, 255, 0);
      text("SORTED!", width/2 - 80, 50);
    }
  } 
  else {
    // Race mode display
    textSize(24);
    fill(255, 200, 100); // Orange
    text("RACE MODE", 10, 30);
    
    textSize(16);
    fill(255);
    
    if (racePhase == 0) {
      // Show first algorithm running
      text("Running: " + getAlgorithmName(raceAlgo1), 10, 60);
      text("Comparisons: " + sorter.comparisons, 10, 85);
    } 
    else if (racePhase == 1) {
      // Show second algorithm running
      text("Running: " + getAlgorithmName(raceAlgo2), 10, 60);
      text("Comparisons: " + sorter.comparisons, 10, 85);
    } 
    else if (racePhase == 2) {
      // Show final results
      textSize(20);
      fill(0, 255, 0);
      text("RACE COMPLETE!", width/2 - 100, 50);
      
      textSize(18);
      fill(255); // White
      text(getAlgorithmName(raceAlgo1) + ": " + algo1Comparisons + " comparisons", 10, 110); // Race one stats
      text(getAlgorithmName(raceAlgo2) + ": " + algo2Comparisons + " comparisons", 10, 140); // Race two stats
      
      // Declare winner
      textSize(28);
      fill(255, 215, 0);
      if (algo1Comparisons < algo2Comparisons) {
        // If algo1 beat algo 2 algo1 wins
        text(getAlgorithmName(raceAlgo1) + " WINS!", width/2 - 150, 225);
      } 
      else if (algo2Comparisons < algo1Comparisons) {
        // If algo2 beat algo 1 algo2 wins
        text(getAlgorithmName(raceAlgo2) + " WINS!", width/2 - 150, 225);
      } 
      else {
        text("IT'S A TIE!", width/2 - 100, 225);
      }
    }
  }
}

String getAlgorithmName(int algo) {
  // Return string value of sorting algorithm
  if (algo == 0) {
    return "BUBBLE SORT";
  }
  if (algo == 1) {
    return "INSERTION SORT";
  }
  if (algo == 2) {
    return "MERGE SORT";
  }
  if (algo == 3) {
    return "QUICK SORT";
  }
  if (algo == 4) {
    return "BOGO SORT";
  }
  return "UNKNOWN";
}
