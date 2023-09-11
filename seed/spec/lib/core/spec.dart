enum SpecType {
  feature,
}

mixin Source {
  List<Resource> get resources;
}

mixin Resource<T> {
  Stream<T> produce();
}

enum PresentationActionType {
  input,
  tap,
  swipe,
  load,
  loaded,
  error,
}

enum PresentationActionLifecycle {
  start,
  end,
}

enum PresentationStateType {
  regular,
  loading,
  error,
  disabled,
  enabled,
  hidden,
}

typedef PresentationStates<Element> = Map<(PresentationActionType, Element), PresentationStateType>;

mixin Presentation<Element, Interaction> {
  List<Element> get elements;
  Map<(PresentationActionType, Element), Interaction> get actions;
  Map<(Interaction, PresentationActionLifecycle), PresentationActionType> get interactions;
  Map<(PresentationActionType, Element), PresentationStateType> get states;

  Map<Element, List<PresentationStateType>> get elementStates {
    return states.entries.fold(
      {},
      (acc, entry) => {
        ...acc,
        entry.key.$2: (acc[entry.key.$2] ?? []) + [entry.value]
      },
    );
  }
}

mixin ElementStateMapper<State> {
  State generateState(PresentationStateType state);
}

mixin Spec {
  SpecType get type;
  Source get source;
  Presentation get presentation;
}
