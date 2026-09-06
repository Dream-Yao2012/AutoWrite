import SwiftUI

struct ContentView: View {
    @State private var showMenu = false

    // MARK: - 自定义文字
    // 以后直接修改这里即可
    private let title = "你的大标题"
    private let subtitle = "这里可以填写副标题"

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    Spacer()

                    // MARK: - 标题区域
                    VStack(spacing: 12) {
                        Text(title)
                            .font(.system(size: 42, weight: .bold))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 600)

                        Text(subtitle)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 500)
                    }
                    .padding(.horizontal, 24)

                    Spacer()

                    // MARK: - 开始按钮
                    StartButton {
                        showMenu = true
                    }
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

// MARK: - 开始按钮

struct StartButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
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
        .modifier(AdaptiveGlassButtonStyle())
    }
}

// MARK: - iOS 17 / iOS 26 按钮样式适配

struct AdaptiveGlassButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .buttonStyle(.glassProminent)
        } else {
            content
                .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - 菜单页面

struct MenuView: View {

    // 目前只是占位
    // 后续再替换成真正的功能
    private let items = [
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
                        MenuCard(title: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .navigationTitle("菜单")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - 菜单卡片

struct MenuCard: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            Image(systemName: "square.grid.2x2")
                .font(.system(size: 26, weight: .medium))

            Spacer()

            Text(title)
                .font(.headline)

            Text("即将推出")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140, alignment: .leading)
        .padding(20)
        .modifier(AdaptiveGlassCardStyle())
    }
}

// MARK: - iOS 17 / iOS 26 卡片适配

struct AdaptiveGlassCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular, in: .rect(cornerRadius: 24))
        } else {
            content
                .background(.thinMaterial)
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            Color.primary.opacity(0.08),
                            lineWidth: 1
                        )
                }
        }
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

// MARK: - Preview

#Preview {
    ContentView()
}
