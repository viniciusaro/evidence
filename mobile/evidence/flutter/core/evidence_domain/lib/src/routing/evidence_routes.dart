enum EvidenceRoutes {
  defaultRoute,
  topicDetail,
  topicCompositionModal,
  inFavorArgumentCompositionModal,
  againstArgumentCompositionModal,
}

extension EvidenceRoutesName on EvidenceRoutes {
  String get routeName {
    if (this == EvidenceRoutes.defaultRoute) {
      return "/";
    }
    return name;
  }
}
