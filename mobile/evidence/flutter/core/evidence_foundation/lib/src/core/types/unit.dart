const unit = Void._();

class Void {
  const Void._();

  @override
  int get hashCode => unit.runtimeType.hashCode ^ 31;

  @override
  operator ==(Object other) => other is Void;
}
