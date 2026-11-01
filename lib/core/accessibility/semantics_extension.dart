import 'package:flutter/material.dart';

/// Labeled helpers hide child semantics so the label is read only once
extension SemanticsExtension on Widget {
  Widget asButton({
    required String label,
    required VoidCallback onTap,
    String? hint,
    bool? selected,
  }) {
    return Semantics(
      button: true,
      label: label,
      hint: hint,
      selected: selected,
      onTap: onTap,
      excludeSemantics: true,
      child: this,
    );
  }

  Widget asToggle({
    required String label,
    required bool value,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: label,
      toggled: value,
      onTap: onTap,
      excludeSemantics: true,
      child: this,
    );
  }

  Widget asHeader({String? label}) {
    return Semantics(
      header: true,
      label: label,
      excludeSemantics: label != null,
      child: this,
    );
  }

  Widget asImage(String label) {
    return Semantics(
      image: true,
      label: label,
      excludeSemantics: true,
      child: this,
    );
  }

  Widget asLiveRegion({String? label}) {
    return Semantics(liveRegion: true, label: label, child: this);
  }

  Widget labeled(String label, {String? hint}) {
    return Semantics(
      container: true,
      label: label,
      hint: hint,
      excludeSemantics: true,
      child: this,
    );
  }

  Widget merged() => MergeSemantics(child: this);

  Widget decorative() => ExcludeSemantics(child: this);
}
