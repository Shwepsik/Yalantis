// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Please add some text
  internal static let addSomeText = L10n.tr("Localizable", "add_some_text")
  /// Shake me to get the answer
  internal static let answerLabelText = L10n.tr("Localizable", "answer_label_text")
  /// Here you can create your own answers
  internal static let descriptionLabelText = L10n.tr("Localizable", "description_label_text")
  /// Your Question
  internal static let mainTextFieldPlaceholder = L10n.tr("Localizable", "main_textField_placeholder")
  /// Magic Ball
  internal static let navigationTitle = L10n.tr("Localizable", "navigation_title")
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok")
  /// Perfect
  internal static let perfect = L10n.tr("Localizable", "perfect")
  /// Save
  internal static let saveButton = L10n.tr("Localizable", "save_button")
  /// Your Answer
  internal static let settingsTextFieldPlaceholder = L10n.tr("Localizable", "settings_textField_placeholder")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
