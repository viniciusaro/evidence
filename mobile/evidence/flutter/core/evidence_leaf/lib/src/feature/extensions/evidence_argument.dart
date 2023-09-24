import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';
import 'package:iconsax/iconsax.dart';

extension EvidenceArgumentTypeUI on EvidenceArgumentType {
  Color iconColor(ThemeData theme) {
    switch (this) {
      case EvidenceArgumentType.inFavor:
        return theme.colorScheme.secondary;
      case EvidenceArgumentType.against:
        return theme.colorScheme.secondary;
    }
  }

  IconData icon(ThemeData theme) {
    switch (this) {
      case EvidenceArgumentType.inFavor:
        return Iconsax.arrow_circle_up4;
      case EvidenceArgumentType.against:
        return Iconsax.arrow_circle_down5;
    }
  }
}
