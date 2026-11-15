import 'consent_scope.dart';

class GrantedConsent {
  Set<ConsentScope> _scopes = const {};

  Set<ConsentScope> get scopes => _scopes;

  bool allows(ConsentScope scope) => _scopes.contains(scope);

  void update(Set<ConsentScope> granted) {
    _scopes = Set.unmodifiable(granted);
  }
}
