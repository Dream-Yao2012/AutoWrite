import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 60))

                Text("AutoWrite")
                    .font(.largeTitle)
                    .bold()

                Text("Swift 自动编译项目")
                    .foregroundStyle(.secondary)

                Button("测试") {
                    print("AutoWrite running")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("AutoWrite")
        }
    }
}

#Preview {
    ContentView()
}
