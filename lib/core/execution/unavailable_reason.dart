enum UnavailableReason {
  permissionMissing('permission_denied', true),
  offline('execution_offline', true),
  consentMissing('execution_consent_missing', true),
  noLocalModel('execution_no_local_model', false),
  lowConfidence('execution_low_confidence', true);

  const UnavailableReason(this.messageKey, this.isRetryable);

  final String messageKey;
  final bool isRetryable;
}
