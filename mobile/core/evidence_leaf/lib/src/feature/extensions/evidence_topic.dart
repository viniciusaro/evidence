import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';
import 'package:iconsax/iconsax.dart';

extension EvidenceTopicStatusUI on EvidenceTopicStatus {
  IconData icon(ThemeData theme) {
    switch (this) {
      case EvidenceTopicStatus.debate:
        return Iconsax.messages_35;
      case EvidenceTopicStatus.accepted:
        return Iconsax.verify5;
      case EvidenceTopicStatus.rejected:
        return Iconsax.close_square5;
    }
  }

  Color backgroundColor(ThemeData theme) {
    switch (this) {
      case EvidenceTopicStatus.debate:
        return theme.colorScheme.scrim;
      case EvidenceTopicStatus.accepted:
        return theme.colorScheme.scrim;
      case EvidenceTopicStatus.rejected:
        return theme.colorScheme.scrim;
    }
  }

  Color foregroundColor(ThemeData theme) {
    switch (this) {
      case EvidenceTopicStatus.debate:
        return theme.colorScheme.scrim;
      case EvidenceTopicStatus.accepted:
        return theme.colorScheme.scrim;
      case EvidenceTopicStatus.rejected:
        return theme.colorScheme.scrim.withAlpha(130);
    }
  }

  Color onBackgroundColor(ThemeData theme) {
    switch (this) {
      case EvidenceTopicStatus.debate:
        return theme.colorScheme.onPrimary;
      case EvidenceTopicStatus.accepted:
        return theme.colorScheme.onPrimary;
      case EvidenceTopicStatus.rejected:
        return theme.colorScheme.onPrimary;
    }
  }
}

extension EvidenceTopicStatusTag on EvidenceTopicStatus {
  String tagText(ThemeData theme) {
    switch (this) {
      case EvidenceTopicStatus.debate:
        return "Em debate";
      case EvidenceTopicStatus.accepted:
        return "Aceito";
      case EvidenceTopicStatus.rejected:
        return "Rejetado";
    }
  }

  LeafTagData tag(ThemeData theme) {
    return LeafTagData(
      color: backgroundColor(theme),
      textColor: onBackgroundColor(theme),
      text: tagText(theme),
    );
  }
}
