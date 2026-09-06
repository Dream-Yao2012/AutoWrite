import SwiftUI

// MARK: - App Entry

struct ContentView: View {

    @State private var showMenu = false

    var body: some View {
        ZStack {
            if showMenu {
                MenuView(
                    onBack: {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.86)) {
                            showMenu = false
                        }
                    }
                )
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    )
                )
            } else {
                HomeView(
                    onStart: {
                        withAnimation(.spring(response: 0.48, dampingFraction: 0.84)) {
                            showMenu = true
                        }
                    }
                )
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    )
                )
            }
        }
        .preferredColorScheme(nil)
    }
}

// MARK: - Home

struct HomeView: View {

    let onStart: () -> Void

    @State private var appeared = false
    @State private var floating = false

    private let title = "你的工具箱"
    private let subtitle = "一个简洁、快速、漂亮的工具中心"

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                AppBackground()

                DecorativeOrbs(
                    size: proxy.size,
                    animated: floating
                )

                VStack(spacing: 0) {

                    Spacer(minLength: proxy.size.height * 0.08)

                    HomeHeader(
                        title: title,
                        subtitle: subtitle,
                        appeared: appeared
                    )

                    Spacer(minLength: proxy.size.height * 0.10)

                    HomeFeatureCard(
                        appeared: appeared
                    )
                    .frame(
                        maxWidth: min(proxy.size.width - 40, 520)
                    )

                    Spacer(minLength: proxy.size.height * 0.06)

                    HomeHint(
                        appeared: appeared
                    )

                    Spacer(minLength: proxy.size.height * 0.04)
                }
                .padding(.horizontal, 20)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                StartButton(
                    title: "让我们开始吧！",
                    action: onStart
                )
                .frame(
                    maxWidth: min(proxy.size.width - 40, 520)
                )
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(
                    BottomFade()
                )
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 30)
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .onAppear {
            floating = true

            withAnimation(
                .spring(
                    response: 0.65,
                    dampingFraction: 0.82
                )
            ) {
                appeared = true
            }
        }
    }
}

// MARK: - Home Header

struct HomeHeader: View {

    let title: String
    let subtitle: String
    let appeared: Bool

    var body: some View {
        VStack(spacing: 14) {

            Text("WELCOME")
                .font(
                    .system(
                        size: 12,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .tracking(3.2)
                .foregroundStyle(
                    .secondary
                )
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 15)

            Text(title)
                .font(
                    .system(
                        size: 46,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .minimumScaleFactor(0.65)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            .primary,
                            .primary.opacity(0.72)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .opacity(appeared ? 1 : 0)
                .scaleEffect(appeared ? 1 : 0.92)
                .offset(y: appeared ? 0 : 20)

            Text(subtitle)
                .font(
                    .system(
                        size: 16,
                        weight: .medium,
                        design: .rounded
                    )
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .frame(maxWidth: 360)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 25)
        }
    }
}

// MARK: - Home Feature Card

struct HomeFeatureCard: View {

    let appeared: Bool

    var body: some View {
        AdaptiveGlassContainer {
            VStack(spacing: 0) {

                HStack(spacing: 16) {

                    FeatureIcon(
                        systemName: "sparkles",
                        size: 52
                    )

                    VStack(alignment: .leading, spacing: 5) {

                        Text("全部工具")
                            .font(
                                .system(
                                    size: 18,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )

                        Text("把常用功能集中在这里")
                            .font(
                                .system(
                                    size: 14,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(
                            .system(
                                size: 14,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.secondary)
                }

                Divider()
                    .padding(.vertical, 18)

                HStack(spacing: 0) {

                    MiniStat(
                        number: "01",
                        text: "简单"
                    )

                    MiniStat(
                        number: "02",
                        text: "快速"
                    )

                    MiniStat(
                        number: "03",
                        text: "实用"
                    )
                }
            }
            .padding(20)
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 35)
        .animation(
            .spring(
                response: 0.7,
                dampingFraction: 0.82
            )
            .delay(0.08),
            value: appeared
        )
    }
}

// MARK: - Mini Stat

struct MiniStat: View {

    let number: String
    let text: String

    var body: some View {
        VStack(spacing: 5) {

            Text(number)
                .font(
                    .system(
                        size: 15,
                        weight: .bold,
                        design: .rounded
                    )
                )

            Text(text)
                .font(
                    .system(
                        size: 12,
                        weight: .medium,
                        design: .rounded
                    )
                )
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Home Hint

struct HomeHint: View {

    let appeared: Bool

    var body: some View {
        HStack(spacing: 8) {

            Image(systemName: "hand.tap")
                .font(.system(size: 13, weight: .semibold))

            Text("选择一个工具，开始你的操作")
                .font(
                    .system(
                        size: 13,
                        weight: .medium,
                        design: .rounded
                    )
                )
        }
        .foregroundStyle(.secondary)
        .opacity(appeared ? 1 : 0)
    }
}

// MARK: - Start Button

struct StartButton: View {

    let title: String

    let action: () -> Void

    @State private var pressed = false

    var body: some View {

        Button {
            let impact = UIImpactFeedbackGenerator(
                style: .medium
            )

            impact.impactOccurred()

            action()
        } label: {

            HStack(spacing: 12) {

                Text(title)
                    .font(
                        .system(
                            size: 17,
                            weight: .bold,
                            design: .rounded
                        )
                    )

                Image(systemName: "arrow.right")
                    .font(
                        .system(
                            size: 15,
                            weight: .bold
                        )
                    )
            }
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .contentShape(Rectangle())
        }
        .buttonStyle(AdaptivePrimaryButtonStyle())
        .scaleEffect(pressed ? 0.97 : 1)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeOut(duration: 0.12)) {
                        pressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.25)) {
                        pressed = false
                    }
                }
        )
    }
}

// MARK: - Menu

struct MenuView: View {

    let onBack: () -> Void

    @State private var appeared = false

    private let items: [ToolItem] = [
        ToolItem(
            title: "工具一",
            subtitle: "功能占位",
            icon: "wand.and.stars",
            tintIndex: 0
        ),
        ToolItem(
            title: "工具二",
            subtitle: "功能占位",
            icon: "bolt.fill",
            tintIndex: 1
        ),
        ToolItem(
            title: "工具三",
            subtitle: "功能占位",
            icon: "gearshape.fill",
            tintIndex: 2
        ),
        ToolItem(
            title: "工具四",
            subtitle: "功能占位",
            icon: "slider.horizontal.3",
            tintIndex: 3
        ),
        ToolItem(
            title: "工具五",
            subtitle: "功能占位",
            icon: "square.grid.2x2.fill",
            tintIndex: 4
        ),
        ToolItem(
            title: "工具六",
            subtitle: "功能占位",
            icon: "sparkles",
            tintIndex: 5
        ),
        ToolItem(
            title: "工具七",
            subtitle: "功能占位",
            icon: "command",
            tintIndex: 6
        ),
        ToolItem(
            title: "工具八",
            subtitle: "功能占位",
            icon: "hammer.fill",
            tintIndex: 7
        ),
        ToolItem(
            title: "工具九",
            subtitle: "功能占位",
            icon: "wrench.and.screwdriver.fill",
            tintIndex: 8
        ),
        ToolItem(
            title: "工具十",
            subtitle: "功能占位",
            icon: "circle.grid.3x3.fill",
            tintIndex: 9
        ),
        ToolItem(
            title: "工具十一",
            subtitle: "功能占位",
            icon: "cpu.fill",
            tintIndex: 10
        ),
        ToolItem(
            title: "工具十二",
            subtitle: "功能占位",
            icon: "ellipsis.circle.fill",
            tintIndex: 11
        )
    ]

    var body: some View {

        NavigationStack {

            GeometryReader { proxy in

                ZStack {

                    AppBackground()

                    ScrollView(
                        .vertical,
                        showsIndicators: false
                    ) {

                        VStack(
                            alignment: .leading,
                            spacing: 24
                        ) {

                            MenuHeader(
                                onBack: onBack,
                                appeared: appeared
                            )

                            MenuIntro(
                                appeared: appeared
                            )

                            ToolGrid(
                                items: items,
                                width: proxy.size.width,
                                appeared: appeared
                            )

                            Color.clear
                                .frame(height: 30)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {

            withAnimation(
                .spring(
                    response: 0.6,
                    dampingFraction: 0.85
                )
            ) {
                appeared = true
            }
        }
    }
}

// MARK: - Tool Item

struct ToolItem: Identifiable {

    let id = UUID()

    let title: String

    let subtitle: String

    let icon: String

    let tintIndex: Int
}

// MARK: - Menu Header

struct MenuHeader: View {

    let onBack: () -> Void

    let appeared: Bool

    var body: some View {

        HStack(spacing: 14) {

            Button {

                onBack()

            } label: {

                Image(systemName: "chevron.left")
                    .font(
                        .system(
                            size: 16,
                            weight: .bold
                        )
                    )
                    .frame(
                        width: 42,
                        height: 42
                    )
            }
            .buttonStyle(AdaptiveIconButtonStyle())

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text("工具中心")
                    .font(
                        .system(
                            size: 27,
                            weight: .bold,
                            design: .rounded
                        )
                    )

                Text("选择一个功能继续")
                    .font(
                        .system(
                            size: 13,
                            weight: .medium,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : -15)
    }
}

// MARK: - Menu Intro

struct MenuIntro: View {

    let appeared: Bool

    var body: some View {

        AdaptiveGlassContainer {

            HStack(spacing: 14) {

                Image(systemName: "square.grid.2x2")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                    .frame(
                        width: 48,
                        height: 48
                    )
                    .background(
                        Circle()
                            .fill(
                                .primary.opacity(0.07)
                            )
                    )

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text("功能菜单")
                        .font(
                            .system(
                                size: 16,
                                weight: .bold,
                                design: .rounded
                            )
                        )

                    Text("目前所有项目都是占位功能")
                        .font(
                            .system(
                                size: 13,
                                weight: .medium,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(16)
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 15)
    }
}

// MARK: - Tool Grid

struct ToolGrid: View {

    let items: [ToolItem]

    let width: CGFloat

    let appeared: Bool

    private var columns: [GridItem] {

        if width >= 700 {

            return [
                GridItem(
                    .flexible(),
                    spacing: 14
                ),
                GridItem(
                    .flexible(),
                    spacing: 14
                ),
                GridItem(
                    .flexible(),
                    spacing: 14
                )
            ]

        } else {

            return [
                GridItem(
                    .flexible(),
                    spacing: 14
                ),
                GridItem(
                    .flexible(),
                    spacing: 14
                )
            ]
        }
    }

    var body: some View {

        LazyVGrid(
            columns: columns,
            spacing: 14
        ) {

            ForEach(
                Array(items.enumerated()),
                id: \.element.id
            ) { index, item in

                NavigationLink {

                    PlaceholderView(
                        item: item
                    )

                } label: {

                    ToolCard(
                        item: item
                    )
                }
                .buttonStyle(.plain)
                .opacity(appeared ? 1 : 0)
                .offset(
                    y: appeared ? 0 : 20
                )
                .animation(
                    .spring(
                        response: 0.55,
                        dampingFraction: 0.82
                    )
                    .delay(
                        Double(index) * 0.035
                    ),
                    value: appeared
                )
            }
        }
    }
}

// MARK: - Tool Card

struct ToolCard: View {

    let item: ToolItem

    @State private var pressed = false

    var body: some View {

        AdaptiveGlassContainer {

            VStack(
                alignment: .leading,
                spacing: 15
            ) {

                HStack {

                    ToolIcon(
                        name: item.icon,
                        index: item.tintIndex
                    )

                    Spacer()

                    Image(
                        systemName: "chevron.right"
                    )
                    .font(
                        .system(
                            size: 12,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.tertiary)
                }

                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {

                    Text(item.title)
                        .font(
                            .system(
                                size: 17,
                                weight: .bold,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(.primary)

                    Text(item.subtitle)
                        .font(
                            .system(
                                size: 12,
                                weight: .medium,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(.secondary)
                }
            }
            .padding(17)
            .frame(
                maxWidth: .infinity,
                minHeight: 142,
                alignment: .leading
            )
        }
        .scaleEffect(pressed ? 0.96 : 1)
        .animation(
            .spring(
                response: 0.25,
                dampingFraction: 0.7
            ),
            value: pressed
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    pressed = true
                }
                .onEnded { _ in
                    pressed = false
                }
        )
    }
}

// MARK: - Tool Icon

struct ToolIcon: View {

    let name: String

    let index: Int

    var body: some View {

        Image(systemName: name)
            .font(
                .system(
                    size: 19,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                iconGradient
            )
            .frame(
                width: 48,
                height: 48
            )
            .background(
                Circle()
                    .fill(
                        .primary.opacity(0.06)
                    )
            )
            .overlay(
                Circle()
                    .stroke(
                        .primary.opacity(0.07),
                        lineWidth: 1
                    )
            )
    }

    private var iconGradient: LinearGradient {

        let colors: [[Color]] = [
            [.blue, .purple],
            [.orange, .pink],
            [.green, .mint],
            [.indigo, .cyan],
            [.purple, .pink],
            [.teal, .blue],
            [.red, .orange],
            [.cyan, .indigo],
            [.pink, .purple],
            [.mint, .green],
            [.blue, .cyan],
            [.orange, .yellow]
        ]

        let selected =
            colors[index % colors.count]

        return LinearGradient(
            colors: selected,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Placeholder

struct PlaceholderView: View {

    let item: ToolItem

    @Environment(\.dismiss)
    private var dismiss

    @State private var appeared = false

    var body: some View {

        ZStack {

            AppBackground()

            ScrollView(
                showsIndicators: false
            ) {

                VStack(spacing: 24) {

                    Spacer()
                        .frame(height: 30)

                    ToolIcon(
                        name: item.icon,
                        index: item.tintIndex
                    )
                    .scaleEffect(
                        appeared ? 1.15 : 0.75
                    )

                    VStack(spacing: 9) {

                        Text(item.title)
                            .font(
                                .system(
                                    size: 31,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )

                        Text("功能页面")
                            .font(
                                .system(
                                    size: 14,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(.secondary)
                    }

                    AdaptiveGlassContainer {

                        VStack(
                            spacing: 16
                        ) {

                            Image(
                                systemName:
                                    "hammer.and.wrench"
                            )
                            .font(
                                .system(
                                    size: 28,
                                    weight: .medium
                                )
                            )
                            .foregroundStyle(.secondary)

                            Text("这里暂时还是占位页面")
                                .font(
                                    .system(
                                        size: 17,
                                        weight: .semibold,
                                        design: .rounded
                                    )
                                )

                            Text(
                                "后续可以把真正的功能放到这里。"
                            )
                            .font(
                                .system(
                                    size: 14,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                        }
                        .frame(
                            maxWidth: .infinity
                        )
                        .padding(30)
                    }

                    Button {

                        dismiss()

                    } label: {

                        Text("返回工具中心")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )
                            .frame(
                                maxWidth: .infinity
                            )
                            .frame(height: 54)
                    }
                    .buttonStyle(
                        AdaptiveSecondaryButtonStyle()
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {

            withAnimation(
                .spring(
                    response: 0.6,
                    dampingFraction: 0.78
                )
            ) {
                appeared = true
            }
        }
    }
}

// MARK: - Background

struct AppBackground: View {

    var body: some View {

        ZStack {

            Color(
                uiColor:
                    UIColor.systemBackground
            )

            LinearGradient(
                colors: [
                    Color.primary.opacity(0.025),
                    Color.clear,
                    Color.primary.opacity(0.018)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .ignoresSafeArea()
    }
}

// MARK: - Decorative Orbs

struct DecorativeOrbs: View {

    let size: CGSize

    let animated: Bool

    var body: some View {

        ZStack {

            Circle()
                .fill(
                    Color.blue.opacity(0.055)
                )
                .frame(
                    width: min(
                        size.width * 0.7,
                        360
                    )
                )
                .blur(radius: 35)
                .position(
                    x: size.width * 0.05,
                    y: size.height * 0.16
                )
                .offset(
                    x: animated ? 10 : 0,
                    y: animated ? -8 : 0
                )

            Circle()
                .fill(
                    Color.purple.opacity(0.045)
                )
                .frame(
                    width: min(
                        size.width * 0.65,
                        330
                    )
                )
                .blur(radius: 40)
                .position(
                    x: size.width * 0.96,
                    y: size.height * 0.72
                )
                .offset(
                    x: animated ? -8 : 0,
                    y: animated ? 10 : 0
                )
        }
        .animation(
            .easeInOut(
                duration: 5
            )
            .repeatForever(
                autoreverses: true
            ),
            value: animated
        )
        .allowsHitTesting(false)
    }
}

// MARK: - Bottom Fade

struct BottomFade: View {

    var body: some View {

        LinearGradient(
            colors: [
                Color.clear,
                Color(
                    uiColor:
                        UIColor.systemBackground
                )
                .opacity(0.94)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea(
            edges: .bottom
        )
    }
}

// MARK: - Feature Icon

struct FeatureIcon: View {

    let systemName: String

    let size: CGFloat

    var body: some View {

        Image(systemName: systemName)
            .font(
                .system(
                    size: size * 0.38,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        .blue,
                        .purple
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(
                width: size,
                height: size
            )
            .background(
                Circle()
                    .fill(
                        .primary.opacity(0.055)
                    )
            )
            .overlay(
                Circle()
                    .stroke(
                        .primary.opacity(0.06),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - Adaptive Glass Container

struct AdaptiveGlassContainer<Content: View>: View {

    let content: Content

    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    var body: some View {

        if #available(iOS 26.0, *) {

            content
                .glassEffect(
                    .regular,
                    in: .rect(
                        cornerRadius: 26
                    )
                )

        } else {

            content
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(
                        cornerRadius: 26,
                        style: .continuous
                    )
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 26,
                        style: .continuous
                    )
                    .stroke(
                        .primary.opacity(0.08),
                        lineWidth: 1
                    )
                )
        }
    }
}

// MARK: - Primary Button Style

struct AdaptivePrimaryButtonStyle: ButtonStyle {

    func makeBody(
        configuration: Configuration
    ) -> some View {

        Group {

            if #available(iOS 26.0, *) {

                configuration.label
                    .foregroundStyle(.white)
                    .buttonStyle(
                        .glassProminent
                    )

            } else {

                configuration.label
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            colors: [
                                .blue,
                                .indigo
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        )
                    )
            }
        }
        .opacity(
            configuration.isPressed
            ? 0.82
            : 1
        )
    }
}

// MARK: - Secondary Button

struct AdaptiveSecondaryButtonStyle:
    ButtonStyle {

    func makeBody(
        configuration: Configuration
    ) -> some View {

        Group {

            if #available(iOS 26.0, *) {

                configuration.label
                    .foregroundStyle(.primary)
                    .buttonStyle(.glass)

            } else {

                configuration.label
                    .foregroundStyle(.primary)
                    .background(
                        .thinMaterial,
                        in: RoundedRectangle(
                            cornerRadius: 18,
                            style: .continuous
                        )
                    )
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 18,
                            style: .continuous
                        )
                        .stroke(
                            .primary.opacity(0.08),
                            lineWidth: 1
                        )
                    )
            }
        }
        .opacity(
            configuration.isPressed
            ? 0.7
            : 1
        )
    }
}

// MARK: - Icon Button

struct AdaptiveIconButtonStyle:
    ButtonStyle {

    func makeBody(
        configuration: Configuration
    ) -> some View {

        Group {

            if #available(iOS 26.0, *) {

                configuration.label
                    .foregroundStyle(.primary)
                    .glassEffect(
                        .regular,
                        in: Circle()
                    )

            } else {

                configuration.label
                    .foregroundStyle(.primary)
                    .background(
                        .thinMaterial,
                        in: Circle()
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                .primary.opacity(0.08),
                                lineWidth: 1
                            )
                    )
            }
        }
        .scaleEffect(
            configuration.isPressed
            ? 0.92
            : 1
        )
        .animation(
            .spring(
                response: 0.25,
                dampingFraction: 0.7
            ),
            value: configuration.isPressed
        )
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
