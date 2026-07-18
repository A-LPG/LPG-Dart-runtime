class NotGLRParseTableException implements Exception {
  String? str;

  NotGLRParseTableException([String? str]) {
    this.str = str;
  }

  @override
  String toString() {
    return str ?? 'NotGLRParseTableException';
  }
}
