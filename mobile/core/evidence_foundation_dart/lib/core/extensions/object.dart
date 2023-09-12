extension ObjectExt<T> on T {
  U let<U>(U Function(T) compute) {
    return compute(this);
  }
}
