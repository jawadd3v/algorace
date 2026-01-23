class Sorter {
  int[] values; // Current array beign sorted
  int[] originalValues; // Copy of original unosrted array for race mode
  int[] auxArray; // Auxiliary (cool name for supplementary or extra) array for merge sort
  int size; // Number of elements in array
  int maxHeight; // Maximum bar height for visuals
  
  // Algorithm selection (0=bubble, 1=insertion, 2=merge, 3=quick, 4=bogo)
  int algorithm = 0;
  
  // State variables and tracking
  boolean sorting = false; // not sorting
  boolean sorted = false; // not sorted
  
  // Statistics
  int comparisons = 0; // Total number of element comparisons
  int swaps = 0; // Total number of swaps/writes (May be misleading in Merge and Quick sort)
  
  // Bubble sort variables
  int bubbleI = 0; // Outerloop for bubble
  int bubbleJ = 0; // Inner loop for bubble
  
  // Insertion sort variables
  int insertionI = 1; // Index of element being inserted
  int insertionJ = 0; // Position to check for insertion
  int insertionKey = 0; // Value being inserted
  boolean insertionKeySet = false; // Whether key has been set or not
  
  // Merge sort variables (recursive version)
  ArrayList<int[]> mergeStack; // Stack simulates recusrive calls [start, end, phase](can't directly use recursion with visualization)
  int mergePhase = 0; // 0=setup, 1=merging
  int mergeLeft = 0; // Left subarray
  int mergeRight = 0; // Right subarray
  int mergeIndex = 0; // Current merge position
  int mergeMid = 0; // Middle point of current merge
  int mergeEnd = 0; // End of current merge range
  
  // Quick sort variables (recursive version)
  ArrayList<int[]> quickStack; // Similar to merge, stack simulates recursive calls [start, end, phase]
  int quickPhase = 0; // 0=setup partition, 1="partitioning"
  int quickPivot = 0; // Pivot element index
  int quickI = 0; // Index of smaller element
  int quickJ = 0; // Current scanning position
  int quickPartitionIndex = 0; // Final pivot position
  
  // Bogo sort variables
  int bogoShuffleIndex = 0; // Current position in shuffle
  int bogoCheckIndex = 0; // Current position in sorted check
  boolean bogoShuffling = true; // Whether is shuffling or not
  
  // Visual highlighting
  int highlightIndex1 = -1; // First highlight bar (<0 for now)
  int highlightIndex2 = -1; // Second highlight bar (<0 for now)
  
  Sorter(int size, int maxHeight) {
    this.size = size;
    this.maxHeight = maxHeight;
    values = new int[size];
    originalValues = new int[size]; // For race mode
    auxArray = new int[size]; // For merge sort
    mergeStack = new ArrayList<int[]>();
    quickStack = new ArrayList<int[]>();
    reset();
  }
  
  void reset() {
    // Generate random array
    for (int i = 0; i < size; i++) {
      values[i] = int(random(20, maxHeight));
      originalValues[i] = values[i]; // Save original for race mode
    }
    // Reseting global stats
    sorting = false;
    sorted = false;
    comparisons = 0;
    swaps = 0;
    
    // Reset bubble variables
    bubbleI = 0;
    bubbleJ = 0;
    
    // Reset insertion variables
    insertionI = 1;
    insertionJ = 0;
    insertionKeySet = false;
    
    // Reset merge variables
    mergeStack.clear();
    mergeStack.add(new int[]{0, size - 1, 0});
    mergePhase = 0;
    
    // Reset quick variables
    quickStack.clear();
    quickStack.add(new int[]{0, size - 1, 0});
    quickPhase = 0;
    
    // Reset bogo variables
    bogoShuffleIndex = 0;
    bogoCheckIndex = 0;
    bogoShuffling = true;
    
    // Reset highlighting
    highlightIndex1 = -1;
    highlightIndex2 = -1;
  }
  
  void restoreOriginal() {
    // Restore original array for race mode
    // Resets array to original unsorted state without generating new random values
    for (int i = 0; i < size; i++) {
      values[i] = originalValues[i];
    }
    // Reset state (same as reset() but without new random values)
    sorting = false;
    sorted = false;
    comparisons = 0;
    swaps = 0;
    
    bubbleI = 0;
    bubbleJ = 0;
    
    insertionI = 1;
    insertionJ = 0;
    insertionKeySet = false;
    
    mergeStack.clear();
    mergeStack.add(new int[]{0, size - 1, 0});
    mergePhase = 0;
    
    quickStack.clear();
    quickStack.add(new int[]{0, size - 1, 0});
    quickPhase = 0;
    
    bogoShuffleIndex = 0;
    bogoCheckIndex = 0;
    bogoShuffling = true;
    
    highlightIndex1 = -1;
    highlightIndex2 = -1;
  }
  
  void setAlgorithm(int algo) {
    algorithm = algo;
    reset(); // Reset with new random array
  }
  
  void toggleSorting() {
    if (!sorted) {
      sorting = !sorting; // toggle
    }
  }
  
  void sortStep() {
    if (!sorting || sorted) return; // Don't sort if paused or finished
  
    // Call the right sorting step based on the algorithm selected
    if (algorithm == 0) {
      bubbleSortStep();
    }
    if (algorithm == 1) {
      insertionSortStep();
    }
    if (algorithm == 2) {
      mergeSortStep();
    }
    if (algorithm == 3) {
      quickSortStep();
    }
    if (algorithm == 4) {
      bogoSortStep();
    }
  }
  
  void bubbleSortStep() {
    // Bubble Sort - one step at a time
    // Compares adjacent elements and swaps if out of order
    // Big O run time of O(n^2)
    if (bubbleJ < size - bubbleI - 1) {
      // Highlight pair being compared
      highlightIndex1 = bubbleJ;
      highlightIndex2 = bubbleJ + 1;
      
      comparisons++; // Increase comparisons for tracking
      
      if (values[bubbleJ] > values[bubbleJ + 1]) {
        swap(bubbleJ, bubbleJ + 1); // Helper function to swap
        swaps++; // Increase swaps for tracking
      }
      
      bubbleJ++; // Move to next pair
    } 
    else {
      // Finisged one pass, start next
      bubbleJ = 0;
      bubbleI++;
      
      // Check if done (n-1 passes complete)
      if (bubbleI >= size - 1) {
        sorted = true;
        sorting = false;
        highlightIndex1 = -1;
        highlightIndex2 = -1;
      }
    }
  }
  
  void insertionSortStep() {
    // Inserstion Sort - One step at a time
    // Builds sorted array one element at a time by inserting into correct position
    // Big O run time of O(n^2)
    if (insertionI < size) {
      // Start new insertion
      if (!insertionKeySet) {
        insertionKey = values[insertionI]; // Svae value to insert
        insertionJ = insertionI - 1; // Start comparing backwards
        insertionKeySet = true;
      }
      
      // Set highlighting
      if (insertionJ >= 0) {
        highlightIndex1 = insertionJ;
      } 
      else {
        highlightIndex1 = 0;
      }
      
      highlightIndex2 = insertionJ + 1;
      
      if (insertionJ >= 0) {
      // Shift elements right while they're larger than key
        comparisons++;
        if (values[insertionJ] > insertionKey) {
          values[insertionJ + 1] = values[insertionJ];
          swaps++;
          insertionJ--; // Check next element
        } 
        else {
          // Found correct position
          values[insertionJ + 1] = insertionKey;
          insertionI++;
          insertionKeySet = false;
        }
      } 
      else {
        // Rached beginning of array
        values[0] = insertionKey;
        insertionI++;
        insertionKeySet = false;
      }
    } 
    else {
      // Done
      sorted = true;
      sorting = false;
      highlightIndex1 = -1;
      highlightIndex2 = -1;
    }
  }
  
  void mergeSortStep() {
    // Merge Sort - one step at a time
    // Recursive divide and conquer algorithm (simulated with stack)
    // Divides array in half, sorts each half, then merges sorted halves
    // Big O run time of O(n logn)
    if (mergeStack.size() == 0) {
      // Check if stack is empty (all done)
      sorted = true;
      sorting = false;
      highlightIndex1 = -1;
      highlightIndex2 = -1;
      return;
    }
    
    // Get current "recursive call" from stack
    int[] current = mergeStack.get(mergeStack.size() - 1);
    int start = current[0];
    int end = current[1];
    int phase = current[2];
    
    // Base Case - single element (already sorted)
    if (start >= end) {
      mergeStack.remove(mergeStack.size() - 1);
      return;
    }
    
    int mid = start + (end - start) / 2;
    
    if (phase == 0) {
      // Dividing phase - split into left and right halves
      mergeStack.remove(mergeStack.size() - 1);
      mergeStack.add(new int[]{start, end, 1});
      mergeStack.add(new int[]{mid + 1, end, 0});
      mergeStack.add(new int[]{start, mid, 0});
      
      // Visual logic
      highlightIndex1 = start;
      highlightIndex2 = end;
    } 
    else {
      // Merge phase - combine two sorted halves
      if (mergePhase == 0) {
        // Setup merge
        mergeLeft = start;
        mergeRight = mid + 1;
        mergeIndex = start;
        mergeMid = mid;
        mergeEnd = end;
        
        // Copy to awesome auxiliary array
        for (int i = start; i <= end; i++) {
          auxArray[i] = values[i];
        }
        mergePhase = 1;
      } 
      else {
        // Perform one merge operation/step
        if (mergeIndex <= mergeEnd) {
          if (mergeLeft <= mergeMid) {
            highlightIndex1 = mergeLeft;
          } 
          else {
            highlightIndex1 = -1;
          }
          if (mergeRight <= mergeEnd) {
            highlightIndex2 = mergeRight;
          } 
          else {
            highlightIndex2 = -1;
          }

          // Pick smaller element from left or right
          if (mergeLeft <= mergeMid && (mergeRight > mergeEnd || auxArray[mergeLeft] <= auxArray[mergeRight])) {
            comparisons++;
            values[mergeIndex] = auxArray[mergeLeft];
            mergeLeft++;
          } 
          else if (mergeRight <= mergeEnd) {
            comparisons++;
            values[mergeIndex] = auxArray[mergeRight];
            mergeRight++;
          }
          swaps++;
          mergeIndex++;
        } 
        else {
          // Done merging (Phew!)
          mergeStack.remove(mergeStack.size() - 1);
          mergePhase = 0;
        }
      }
    }
  }
  
  void quickSortStep() {
    // Quick sort - one step at a time
    // Rescruve divide and conqueor similar to merge sort
    // Picks a pivot point and then partitions around it, recursively sorts partitions
    // Big O run time of O(n logn) worst case of O(n^2)
    if (quickStack.size() == 0) {
      // Check if stack is empty
      sorted = true;
      sorting = false;
      highlightIndex1 = -1;
      highlightIndex2 = -1;
      return;
    }
    
    // Get current "recursive call" from stack
    int[] current = quickStack.get(quickStack.size() - 1);
    int start = current[0];
    int end = current[1];
    int phase = current[2]; // 0=setup, 1=partitioning
    
    // Base case - single element or invalid
    if (start >= end) {
      quickStack.remove(quickStack.size() - 1);
      return;
    }
    
    if (phase == 0) {
      // Setup the partition (choosing pivot which is last element)
      quickPivot = end;
      quickI = start - 1; // Boundary of smaller elements
      quickJ = start; // Current element being checked
      quickPhase = 1;
      
      highlightIndex1 = quickPivot;
      highlightIndex2 = -1;
      
      current[2] = 1; // Move to partitioning phase
    } 
    else if (phase == 1) {
      // Partitioning - move elements smaller than pivot to left
      if (quickJ < end) {
        highlightIndex2 = quickJ;
        
        comparisons++;
        if (values[quickJ] < values[quickPivot]) {
          quickI++;
          swap(quickI, quickJ);
          swaps++;
          highlightIndex1 = quickI;
        }
        quickJ++;
      } 
      else {
        // Place pivot in final position
        swap(quickI + 1, quickPivot);
        swaps++;
        quickPartitionIndex = quickI + 1;
        
        // Partition commplete - add sub problems to stack
        quickStack.remove(quickStack.size() - 1);
        
        if (quickPartitionIndex + 1 < end) {
          quickStack.add(new int[]{quickPartitionIndex + 1, end, 0});
        }
        
        // Add left partition (done first)
        if (start < quickPartitionIndex - 1) {
          quickStack.add(new int[]{start, quickPartitionIndex - 1, 0});
        }
        
        // Rest highlight index
        highlightIndex1 = -1;
        highlightIndex2 = -1;
      }
    }
  }
  
  void bogoSortStep() {
    // Bogo Sort - one step at a time
    // Randomly shuffles array and checks if sorted. Repeat until lucky (Not recommended for anything above 5!)
    // Big O run time of O((n+1)!)
    // Little joke hopefully Mr. Schattman enjoys
    if (bogoShuffling) {
      // Shuffling phase using Fisher-Yates shuffle, creates an unbiased, random permutation of a finite list by repeatedly swapping
      // the last element of the remaining unshuffled portion with a randomly chosen element from that portion 
      if (bogoShuffleIndex < size) {
        int randomIndex = int(random(bogoShuffleIndex, size));
        swap(bogoShuffleIndex, randomIndex);
        swaps++;
        
        highlightIndex1 = bogoShuffleIndex;
        highlightIndex2 = randomIndex;
        
        bogoShuffleIndex++;
      } 
      else {
        bogoShuffling = false;
        bogoCheckIndex = 0;
      }
    } 
    else {
      // Check/Verify array is sorted (it's probably not)
      if (bogoCheckIndex < size - 1) {
        highlightIndex1 = bogoCheckIndex;
        highlightIndex2 = bogoCheckIndex + 1;
        
        comparisons++;
        if (values[bogoCheckIndex] > values[bogoCheckIndex + 1]) {
          // Not sorted (Not surprised either)
          bogoShuffling = true;
          bogoShuffleIndex = 0;
          return;
        }
        bogoCheckIndex++;
      } 
      else {
        // Miracle case - its sorted!
        sorted = true;
        sorting = false;
        highlightIndex1 = -1;
        highlightIndex2 = -1;
      }
    }
  }
  
  void swap(int i, int j) {
    // Helper function that swaps two elements in the array
    int temp = values[i];
    values[i] = values[j];
    values[j] = temp;
  }
  
  void display() {
    // Display the array as colored bars
    // Color Scheme (Green: Sorted, Red: Currently comparing/swapping, Light green: Sorted portion, Grey: Unsorted
    float barWidth = width / float(size);
    
    for (int i = 0; i < size; i++) {
      if (sorted) {
        fill(0, 255, 0); // Green fully sorted
      } 
      else if (i == highlightIndex1 || i == highlightIndex2) {
        fill(255, 0, 0); // Red active comparison
      } 
      else if (algorithm == 0 && i > size - bubbleI - 1) {
        fill(100, 200, 100); // Light green (sorted, for bubble)
      } 
      else if (algorithm == 1 && i < insertionI) {
        fill(100, 200, 100); // Light green (sorted, for insertion)
      } 
      else {
        fill(200); //Grey, unsorted
      }
      
      //Draw bar
      rect(i * barWidth, height - values[i], barWidth - 1, values[i]);
    }
  }
}
