import 'package:evidence_domain/domain.dart';

mixin ArgumentRepository {
  Future<Result<EvidenceArgument, Never>> postArgument(EvidenceArgumentPost post);
  Future<Result<Void, Never>> registerArgumentPost(EvidenceArgumentPost post);
  Future<Result<Void, Never>> unregisterArgumentPost(EvidenceArgumentPost post);
  Stream<Result<EvidenceArgumentPosts, Never>> getArgumentPosts();
}
