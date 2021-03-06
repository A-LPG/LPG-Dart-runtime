/// Low-Level interface to act as recipient for error messages generated by a
/// parser/compiler.

class Location{
  int left_loc;
  int length;
  int start_line;
  int start_column;
  int end_line;
  int end_column;
  Location(this.left_loc,
      this.length,
      this.start_line,
      this.start_column,
      this.end_line,
      this.end_column);
}
abstract class IMessageHandler {


  /**
     * The following constants can be used as indexes to dereference
     * values in the msgLocation and errorLocation arrays.
     *
     * Locations are constructed by the method getLocation in LexStream which
     * takes two arguments: a start and an end location and returns an array
     * of 6 integers.
     */
  static const int OFFSET_INDEX = 0,
      LENGTH_INDEX = 1,
      START_LINE_INDEX = 2,
      START_COLUMN_INDEX = 3,
      END_LINE_INDEX = 4,
      END_COLUMN_INDEX = 5;

  /**
     *
     * When a location is undefined, the value of its offset is 0.
     *
     * @param errorCode
     * @param msgLocation
     * @param errorLocation
     * @param filename
     * @param errorInfo
     */
  void handleMessage(int errorCode, Location msgLocation,
      Location errorLocation, String filename, List<String> errorInfo);
}
