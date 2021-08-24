//
// This Tuple class can be used to construct a dynamic
// array of integers. The space for the array is allocated in
// blocks of size 2**LOG_BLKSIZE. In declaring a tuple the user
// may specify an estimate of how many elements he expects.
// Based on that estimate, suitable values will be calculated
// for log_blksize and base_increment. If these estimates are
// found to be off later, more space will be allocated.
//
class IntSegmentedTuple {
  int top = 0, _size = 0;

  int log_blksize = 3, base_size = 4;

  late List<List<int>> base;

  //
  // Allocate another block of storage for the dynamic array.
  //
  void allocateMoreSpace() {
    //
    // The variable size always indicates the maximum number of
    // elements that has been allocated for the array.
    // Initially, it is set to 0 to indicate that the array is empty.
    // The pool of available elements is divided into segments of size
    // 2**log_blksize each. Each segment is pointed to by a slot in
    // the array base.
    //
    // By dividing size by the size of the segment we obtain the
    // index for the next segment in base. If base is full, it is
    // reallocated.
    //
    //
    var k = _size >> log_blksize; /* which segment? */

    //
    // If the base is overflowed, reallocate it and initialize the new
    // elements to NULL.
    // Otherwise, allocate a new segment and place its adjusted address
    // in base[k]. The adjustment allows us to index the segment directly,
    // instead of having to perform a subtraction for each reference.
    // See operator[] below.
    //
    //
    if (k == base_size) {
      base_size *= 2;
      List.copyRange(base, 0, base = List.filled(base_size, []), 0, k);
    }

    base[k] = List.filled(1 << log_blksize, 0);

    //
    // Finally, we update SIZE.
    //
    _size += (1 << log_blksize);

    return;
  }

  //
  // This function is invoked with an integer argument n. It ensures
  // that enough space is allocated for n elements in the dynamic array.
  // I.e., that the array will be indexable in the range  (0..n-1)
  //
  // Note that this function can be used as a garbage collector.  When
  // invoked with no argument(or 0), it frees up all dynamic space that
  // was allocated for the array.
  //

  void resize(int? arg) {
    int n ;
    if(null == arg){
        n =0;
    }
    else{
      n = arg;
    }
    //
    // If array did not previously contain enough space, allocate
    // the necessary additional space. Otherwise, if the array had
    // more blocks than are needed, release the extra blocks.
    //
    if (n > _size) {
      do {
        allocateMoreSpace();
      } while (n > _size);
    }

    top = n;
  }

  //
  // This function is used to reset the size of a dynamic array without
  // allocating or deallocting space. It may be invoked with an integer
  // argument n which indicates the new size or with no argument which
  // indicates that the size should be reset to 0.
  //
  void reset({int n = 0}) {
    top = n;
  }

  //
  // Return size of the dynamic array.
  //
  int size() {
    return top;
  }

  //
  // Can the tuple be indexed with i?
  //
  bool outOfRange(int i) {
    return (i < 0 || i >= top);
  }

  //
  // Return a reference to the ith element of the dynamic array.
  //
  // Note that no check is made here to ensure that 0 <= i < top.
  // Such a check might be useful for debugging and a range exception
  // should be thrown if it yields true.
  //
  int get(int i) {
    return base[i >> log_blksize][i % (1 << log_blksize)];
  }

  //
  // Insert an element in the dynamic array at the location indicated.
  //
  void set(int i, int element) {
    base[i >> log_blksize][i % (1 << log_blksize)] = element;
  }

  //
  // Add an element to the dynamic array and return the top index.
  //
  int NextIndex() {
    var i = top++;
    if (i == _size) allocateMoreSpace();
    return i;
  }

  //
  // Add an element to the dynamic array and return a reference to
  // that new element.
  //
  void add(int element) {
    var i = NextIndex();
    base[i >> log_blksize][i % (1 << log_blksize)] = element;
  }

  //
  // If array is sorted, this function will find the index location
  // of a given element if it is contained in the array. Otherwise, it
  // will return the negation of the index of the element prior to
  // which the new element would be inserted in the array.
  //
  int binarySearch(int element) {
    var low = 0;
    var high = top;
    while (high > low) {
      var mid = ((high + low) / 2) as int;
      var mid_element = get(mid);
      if (element == mid_element) {
        return mid;
      } else if (element < mid_element) {
        high = mid;
      } else {
        low = mid + 1;
      }
    }

    return -low;
  }

  //
  // Constructor of a Tuple
  //
  IntSegmentedTuple(int? log_blksize_, int? base_size_) {
    if (log_blksize_ != null) log_blksize = log_blksize_;
    if (base_size_ != null) base_size = (base_size_ <= 0 ? 4 : base_size_);

    base = List.filled(base_size, []);
  }
}
