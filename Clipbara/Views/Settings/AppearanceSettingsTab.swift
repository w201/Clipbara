import SwiftUI

enum AppTheme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    /// Localized label. `rawValue` is what is stored in UserDefaults.
    var displayName: String {
        switch self {
        case .system: String(localized: "System")
        case .light: String(localized: "Light")
        case .dark: String(localized: "Dark")
        }
    }
}

struct AppearanceSettingsTab: View {
    @AppStorage("appTheme") private var appTheme: String = AppTheme.system.rawValue
    @AppStorage(PanelController.animatesPanelDefaultsKey) private var animatesPanel: Bool = true
    @AppStorage(QuickLookScaleSetting.defaultsKey) private var quickLookScale = QuickLookScaleSetting.defaultValue
    @State private var reducesMotion = NSWorkspace.shared.accessibilityDisplayShouldReduceMotion

    var body: some View {
        Form {
            Picker("Theme", selection: $appTheme) {
                ForEach(AppTheme.allCases, id: \.rawValue) { theme in
                    Text(theme.displayName).tag(theme.rawValue)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: appTheme) { _, newValue in
                applyTheme(newValue)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Preview Size")
                    Spacer()
                    Text("\(Int((quickLookScale * 100).rounded()))%")
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                    Button("Reset") {
                        quickLookScale = QuickLookScaleSetting.defaultValue
                    }
                    .disabled(quickLookScale == QuickLookScaleSetting.defaultValue)
                }
                Slider(
                    value: $quickLookScale,
                    in: QuickLookScaleSetting.range,
                    step: QuickLookScaleSetting.step
                ) {
                    EmptyView()
                } minimumValueLabel: {
                    Image(systemName: "textformat.size.smaller")
                } maximumValueLabel: {
                    Image(systemName: "textformat.size.larger")
                }
                .labelsHidden()
                Text("Scales the text, controls and window of the Quick Look preview. 100% is the default.")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Animate Panel")
                    Group {
                        if reducesMotion {
                            Text("Off while Reduce Motion is on in System Settings > Accessibility > Display.")
                        } else {
                            Text("Slide the history panel in and out. When off, it appears and closes at once.")
                        }
                    }
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Toggle("", isOn: $animatesPanel)
                    .labelsHidden()
                    .disabled(reducesMotion)
            }
            .onReceive(NSWorkspace.shared.notificationCenter.publisher(
                for: NSWorkspace.accessibilityDisplayOptionsDidChangeNotification
            )) { _ in
                reducesMotion = NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
            }
        }
        .formStyle(.grouped)
        .padding()
        .onAppear {
            applyTheme(appTheme)
        }
    }

    private func applyTheme(_ theme: String) {
        switch AppTheme(rawValue: theme) {
        case .light:
            NSApp.appearance = NSAppearance(named: .aqua)
        case .dark:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        default:
            NSApp.appearance = nil
        }
    }
}
