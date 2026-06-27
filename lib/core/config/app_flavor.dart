/// Build flavors for TripMate (Technical Architecture §19).
///
/// Selected at compile time via `--dart-define=FLAVOR=dev|staging|prod`.
enum AppFlavor {
  dev,
  staging,
  prod;

  /// Resolves a flavor from its string name, defaulting to [AppFlavor.dev].
  static AppFlavor fromName(String name) {
    return AppFlavor.values.firstWhere(
      (flavor) => flavor.name == name,
      orElse: () => AppFlavor.dev,
    );
  }

  bool get isProd => this == AppFlavor.prod;
}
