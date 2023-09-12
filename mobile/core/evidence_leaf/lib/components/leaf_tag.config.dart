part of 'leaf_tag.dart';

enum LeafTagStatus {
  debate,
  accepted,
  rejected,
}

class LeafTagData {
  final LeafTagStatus status;
  const LeafTagData({required this.status});
}

extension on LeafTagStatus {
  Color color(ThemeData theme) {
    switch (this) {
      case LeafTagStatus.debate:
        return theme.colorScheme.outline;
      case LeafTagStatus.accepted:
        return theme.colorScheme.outline;
      case LeafTagStatus.rejected:
        return theme.colorScheme.outline;
    }
  }

  Color textColor(ThemeData theme) {
    switch (this) {
      case LeafTagStatus.debate:
        return theme.colorScheme.onPrimary;
      case LeafTagStatus.accepted:
        return theme.colorScheme.onPrimary;
      case LeafTagStatus.rejected:
        return theme.colorScheme.onPrimary;
    }
  }

  String text(ThemeData theme) {
    switch (this) {
      case LeafTagStatus.debate:
        return "Em debate";
      case LeafTagStatus.accepted:
        return "Aceito";
      case LeafTagStatus.rejected:
        return "Rejetado";
    }
  }
}
