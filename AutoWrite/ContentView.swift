import SwiftUI

struct ContentView: View {
    @State private var showMenu = false

    // MARK: - 可以自己修改的文字
    private let title = "欢迎使用DM工具箱！"
    private let subtitle = "由Dream创建"

    var body: some View {
        NavigationStack {
            ZStack {
                // 背景
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    Spacer()

                    // MARK: - 标题区域
                    VStack(spacing: 12) {
                        Text(title)
                            .font(.system(size: 42, weight: .bold))
                            .multilineTextAlignment(.center)

                        Text(subtitle)
                            .font(.system(size: 17))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    // MARK: - 开始按钮
                    Button {
                        showMenu = true
                    } label: {
                        HStack {
                            Text("让我们开始吧！")
                                .font(.system(size: 18, weight: .semibold))

                            Spacer()

                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .padding(.horizontal, 22)
                        .frame(height: 60)
                        .frame(maxWidth: 500)
                    }
                    .buttonStyle(.glassProminent)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
            }
            .navigationDestination(isPresented: $showMenu) {
                MenuView()
            }
        }
    }
}

// MARK: - 菜单页面

struct MenuView: View {
    let items = [
        "功能一",
        "功能二",
        "功能三",
        "功能四",
        "功能五",
        "功能六"
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(items, id: \.self) { item in
                    NavigationLink {
                        PlaceholderView(title: item)
                    } label: {
                        VStack(alignment: .leading, spacing: 12) {
                            Image(systemName: "square.grid.2x2")
                                .font(.system(size: 25))

                            Text(item)
                                .font(.headline)

                            Text("即将推出")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
                        .padding(20)
                    }
                    .buttonStyle(.glass)
                }
            }
            .padding(20)
        }
        .navigationTitle("菜单")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - 占位页面

struct PlaceholderView: View {
    let title: String

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: "hammer",
            description: Text("这个功能将在后续版本加入")
        )
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
