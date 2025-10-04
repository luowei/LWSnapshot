//
// SwiftUIExample.swift
// Example usage of LWSnapshot with SwiftUI
// Created by Luo Wei on 2025/10/04.
//

import SwiftUI

// MARK: - Example 1: Basic Usage

@available(iOS 13.0, *)
struct SnapshotExampleView1: View {
    @State private var showSnapshot = false

    var body: some View {
        VStack {
            Text("Hello, World!")
                .font(.largeTitle)
                .padding()

            Button("Take Screenshot") {
                showSnapshot = true
            }
        }
        .snapshotMask(isPresented: $showSnapshot) {
            print("Snapshot closed")
        }
    }
}

// MARK: - Example 2: Using snapshot modifier

@available(iOS 13.0, *)
struct SnapshotExampleView2: View {
    @State private var showSnapshot = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Image(systemName: "photo.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)

                Text("Tap to capture")
                    .font(.headline)

                Button("Show Snapshot Tool") {
                    showSnapshot = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .snapshot(isPresented: $showSnapshot) {
            print("User cancelled snapshot")
        }
    }
}

// MARK: - Example 3: With Custom Frame Tracking

@available(iOS 13.0, *)
struct SnapshotExampleView3: View {
    @State private var showSnapshot = false
    @State private var snapshotFrame: CGRect = .zero

    var body: some View {
        VStack {
            Text("Selected Frame:")
                .font(.headline)

            Text("x: \(Int(snapshotFrame.origin.x)), y: \(Int(snapshotFrame.origin.y))")
            Text("width: \(Int(snapshotFrame.width)), height: \(Int(snapshotFrame.height))")
                .padding(.bottom)

            Button("Take Screenshot") {
                showSnapshot = true
            }
        }
        .snapshot(isPresented: $showSnapshot, snapshotFrame: $snapshotFrame) {
            print("Final frame: \(snapshotFrame)")
        }
    }
}

// MARK: - Example 4: UIViewControllerRepresentable Integration

@available(iOS 13.0, *)
struct SnapshotExampleView4: View {
    @State private var showSnapshot = false

    var body: some View {
        VStack {
            Text("Screenshot with Long Press")
                .font(.title)
                .padding()

            SnapshotViewController()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

@available(iOS 13.0, *)
struct SnapshotViewController: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBackground

        // Add long press gesture
        let longPress = UILongPressGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleLongPress(_:))
        )
        longPress.numberOfTouchesRequired = 2
        viewController.view.addGestureRecognizer(longPress)

        // Listen for screenshot notification
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.screenCaptured),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )

        context.coordinator.viewController = viewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        weak var viewController: UIViewController?

        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                showSnapshot()
            }
        }

        @objc func screenCaptured() {
            showSnapshot()
        }

        private func showSnapshot() {
            guard let viewController = viewController else { return }
            viewController.showSnapshotMask {
                print("Snapshot closed from coordinator")
            }
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}

// MARK: - Example 5: Complete App Example

@available(iOS 14.0, *)
struct SnapshotExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

@available(iOS 13.0, *)
struct ContentView: View {
    @State private var showSnapshot = false
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(showSnapshot: $showSnapshot)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            SettingsView(showSnapshot: $showSnapshot)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(1)
        }
        .snapshotMask(isPresented: $showSnapshot)
    }
}

@available(iOS 13.0, *)
struct HomeView: View {
    @Binding var showSnapshot: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Home Screen")
                    .font(.largeTitle)

                Button("Take Screenshot") {
                    showSnapshot = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Home")
        }
    }
}

@available(iOS 13.0, *)
struct SettingsView: View {
    @Binding var showSnapshot: Bool

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button("Capture Screen") {
                        showSnapshot = true
                    }
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Preview

@available(iOS 13.0, *)
struct SnapshotExampleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SnapshotExampleView1()
                .previewDisplayName("Basic Usage")

            SnapshotExampleView2()
                .previewDisplayName("Custom Modifier")

            SnapshotExampleView3()
                .previewDisplayName("Frame Tracking")

            ContentView()
                .previewDisplayName("Complete App")
        }
    }
}
