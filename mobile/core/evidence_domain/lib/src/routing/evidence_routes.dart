enum EvidenceRoutes {
  defaultRoute,
  topicDetail,
  topicCompositionModal,
}

extension EvidenceRoutesName on EvidenceRoutes {
  String get routeName {
    if (this == EvidenceRoutes.defaultRoute) {
      return "/";
    }
    return name;
  }
}
