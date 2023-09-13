extension ListExtensions<T> on List<T> {
  List<T> removing(T item) {
    final copy = List<T>.from(this);
    copy.removeWhere((e) => e == item);
    return copy;
  }
}
