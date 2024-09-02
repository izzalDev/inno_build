/// Enum representing the languages that can be used with Inno Setup.
///
/// Each constant is associated with a filename of a language-specific Inno Setup
/// language file. The language file contains the strings used in the setup
/// wizard.
///
/// The [getByNameOrNull] method can be used to retrieve a [Language] instance
/// by its name, or `null` if not found.
enum Language {
  /// English
  english("Default.isl"),

  /// Armenian
  armenian("Languages\\Armenian.isl"),

  /// Brazilian Portuguese
  brazilianportuguese("Languages\\BrazilianPortuguese.isl"),

  /// Bulgarian
  bulgarian("Languages\\Bulgarian.isl"),

  /// Catalan
  catalan("Languages\\Catalan.isl"),

  /// Corsican
  corsican("Languages\\Corsican.isl"),

  /// Czech
  czech("Languages\\Czech.isl"),

  /// Danish
  danish("Languages\\Danish.isl"),

  /// Dutch
  dutch("Languages\\Dutch.isl"),

  /// Finnish
  finnish("Languages\\Finnish.isl"),

  /// French
  french("Languages\\French.isl"),

  /// German
  german("Languages\\German.isl"),

  /// Hebrew
  hebrew("Languages\\Hebrew.isl"),

  /// Hungarian
  hungarian("Languages\\Hungarian.isl"),

  /// Icelandic
  icelandic("Languages\\Icelandic.isl"),

  /// Italian
  italian("Languages\\Italian.isl"),

  /// Japanese
  japanese("Languages\\Japanese.isl"),

  /// Norwegian
  norwegian("Languages\\Norwegian.isl"),

  /// Polish
  polish("Languages\\Polish.isl"),

  /// Portuguese
  portuguese("Languages\\Portuguese.isl"),

  /// Russian
  russian("Languages\\Russian.isl"),

  /// Slovak
  slovak("Languages\\Slovak.isl"),

  /// Slovenian
  slovenian("Languages\\Slovenian.isl"),

  /// Spanish
  spanish("Languages\\Spanish.isl"),

  /// Turkish
  turkish("Languages\\Turkish.isl"),

  /// Ukrainian
  ukrainian("Languages\\Ukrainian.isl");

  /// The filename of the language-specific Inno Setup language file.
  final String file;

  /// Creates a [Language] instance with the associated [file] name.
  const Language(this.file);

  /// Retrieves a [Language] instance by its name, or `null` if not found.
  static Language? getByNameOrNull(String name) {
    final index = Language.values.indexWhere((l) => l.name == name);
    return index != -1 ? Language.values[index] : null;
  }
}
