class Sorter {
  int[] values;
  int[] auxArray; // For merge sort
  int size;
  int maxHeight;
  
  // Algorithm selection (0=bubble, 1=insertion, 2=merge)
  int algorithm = 0;
  
  // State variables
  boolean sorting = false;
  boolean sorted = false;
  
  // Statistics
  int comparisons = 0;
  int swaps = 0;
  
  // Bubble sort variables
  int bubbleI = 0;
  int bubbleJ = 0;
  
  // Insertion sort variables
  int insertionI = 1;
  int insertionJ = 0;
  int insertionKey = 0;
  boolean insertionKeySet = false;
  
  // Merge sort variables Placeholder
  
  // Visual highlighting
  int highlightIndex1 = -1;
  int highlightIndex2 = -1;
  
  Sorter(int size, int maxHeight) {
    this.size = size;
    this.maxHeight = maxHeight;
    values = new int[size];
    auxArray = new int[size];
    reset();
  }
  
  void reset() {
    for (int i = 0; i < size; i++) {
      values[i] = int(random(20, maxHeight));
    }
    sorting = false;
    sorted = false;
    comparisons = 0;
    swaps = 0;
    
    // Reset algorithm-specific variables
    bubbleI = 0;
    bubbleJ = 0;
    insertionI = 1;
    insertionJ = 0;
    insertionKeySet = false;
    // Merge sort variables placeholder

  }
  
  void setAlgorithm(int algo) {
    algorithm = algo;
    reset();
  }
  
  void toggleSorting() {
    if (!sorted) {
      sorting = !sorting;
    }
  }
  
  void sortStep() {
    if (!sorting || sorted) return;
    
    switch(algorithm) {
      case 0:
        bubbleSortStep();
        break;
      case 1:
        insertionSortStep();
        break;
      case 2:
        mergeSortStep();
        break;
    }
  }
  
  void bubbleSortStep() {
    if (bubbleJ < size - bubbleI - 1) {
      highlightIndex1 = bubbleJ;
      highlightIndex2 = bubbleJ + 1;
      
      comparisons++;
      if (values[bubbleJ] > values[bubbleJ + 1]) {
        swap(bubbleJ, bubbleJ + 1);
        swaps++;
      }
      bubbleJ++;
    } else {
      bubbleJ = 0;
      bubbleI++;
      
      if (bubbleI >= size - 1) {
        sorted = true;
        sorting = false;
        highlightIndex1 = -1;
        highlightIndex2 = -1;
      }
    }
  }
  
  void insertionSortStep() {
    if (insertionI < size) {
      if (!insertionKeySet) {
        // Start of new insertion
        insertionKey = values[insertionI];
        insertionJ = insertionI - 1;
        insertionKeySet = true;
      }
      
      highlightIndex1 = insertionJ >= 0 ? insertionJ : 0;
      highlightIndex2 = insertionJ + 1;
      
      if (insertionJ >= 0) {
        comparisons++;
        if (values[insertionJ] > insertionKey) {
          values[insertionJ + 1] = values[insertionJ];
          swaps++;
          insertionJ--;
        } else {
          values[insertionJ + 1] = insertionKey;
          insertionI++;
          insertionKeySet = false;
        }
      } else {
        values[0] = insertionKey;
        insertionI++;
        insertionKeySet = false;
      }
    } else {
      sorted = true;
      sorting = false;
      highlightIndex1 = -1;
      highlightIndex2 = -1;
    }
  }
  
  void mergeSortStep() {
    print("Under Works!");
  }
  
  void swap(int i, int j) {
    int temp = values[i];
    values[i] = values[j];
    values[j] = temp;
  }
  
  void display() {
    float barWidth = width / float(size);
    
    for (int i = 0; i < size; i++) {
      // Color coding
      if (sorted) {
        fill(0, 255, 0); // Green when sorted
      } else if (i == highlightIndex1 || i == highlightIndex2) {
        fill(255, 0, 0); // Red for comparing/swapping
      } else if (algorithm == 0 && i > size - bubbleI - 1) {
        fill(100, 200, 100); // Light green for bubble sorted portion
      } else if (algorithm == 1 && i < insertionI) {
        fill(100, 200, 100); // Light green for insertion sorted portion
      } else {
        fill(200); // White/gray for unsorted
      }
      
      rect(i * barWidth, height - values[i], barWidth - 1, values[i]);
    }
  }
}
