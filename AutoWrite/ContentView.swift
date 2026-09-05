import SwiftUI

// MARK: - 数据模型

struct FireAccount: Identifiable, Codable {
    var id = UUID()
    var name: String
    var enabled: Bool
}

// MARK: - App

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }

            AccountsView()
                .tabItem {
                    Label("账号", systemImage: "person.2.fill")
                }

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
        }
        .tint(.orange)
    }
}

// MARK: - 首页

struct HomeView: View {

    @AppStorage("accountsData")
    private var accountsData = ""

    @State private var isRunning = false

    private var accounts: [FireAccount] {
        guard let data = Data(base64Encoded: accountsData),
              let result = try? JSONDecoder().decode(
                [FireAccount].self,
                from: data
              )
        else {
            return []
        }

        return result
    }

    private var enabledCount: Int {
        accounts.filter { $0.enabled }.count
    }

    var body: some View {
        GeometryReader { geometry in

            let width = geometry.size.width
            let horizontalPadding = min(width * 0.045, 20)
            let contentWidth = width - horizontalPadding * 2

            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {

                    VStack(spacing: width * 0.035) {

                        // MARK: Hero

                        HeroCard(
                            width: contentWidth
                        )

                        // MARK: 状态

                        StatusCard(
                            width: contentWidth,
                            isRunning: isRunning
                        )

                        // MARK: 数据

                        HStack(spacing: width * 0.03) {

                            StatCard(
                                icon: "person.2.fill",
                                value: "\(enabledCount)",
                                title: "账号"
                            )

                            StatCard(
                                icon: "checklist",
                                value: "\(enabledCount)",
                                title: "今日任务"
                            )

                            StatCard(
                                icon: "checkmark.circle.fill",
                                value: "0",
                                title: "已完成"
                            )
                        }
                        .frame(width: contentWidth)

                        // MARK: 运行按钮

                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isRunning.toggle()
                            }
                        } label: {

                            HStack(spacing: 9) {

                                Image(
                                    systemName:
                                        isRunning
                                        ? "stop.fill"
                                        : "play.fill"
                                )

                                Text(
                                    isRunning
                                    ? "停止任务"
                                    : "立即运行"
                                )
                                .font(
                                    .system(
                                        size: min(width * 0.043, 17),
                                        weight: .semibold
                                    )
                                )
                            }
                            .foregroundStyle(.white)
                            .frame(
                                width: contentWidth,
                                height: min(width * 0.135, 54)
                            )
                            .background(
                                isRunning
                                ? Color.gray
                                : Color.orange
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: min(width * 0.04, 16)
                                )
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, width * 0.025)
                    .padding(.bottom, 24)
                }
                .background(
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea()
                )
                .navigationTitle("Auto Fire")
            }
        }
    }
}

// MARK: - Hero

struct HeroCard: View {

    let width: CGFloat

    var body: some View {

        let iconSize = min(width * 0.17, 70)

        VStack(spacing: width * 0.018) {

            ZStack {
                Circle()
                    .fill(.white.opacity(0.16))
                    .frame(
                        width: iconSize,
                        height: iconSize
                    )

                Image(systemName: "flame.fill")
                    .font(
                        .system(
                            size: iconSize * 0.48,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
            }

            Text("Auto Fire")
                .font(
                    .system(
                        size: min(width * 0.07, 28),
                        weight: .bold
                    )
                )
                .foregroundStyle(.white)

            Text("自动管理每日续火花任务")
                .font(
                    .system(
                        size: min(width * 0.035, 14)
                    )
                )
                .foregroundStyle(
                    .white.opacity(0.82)
                )
        }
        .frame(
            width: width,
            height: min(width * 0.48, 190)
        )
        .background(
            LinearGradient(
                colors: [
                    Color(
                        red: 0.96,
                        green: 0.25,
                        blue: 0.28
                    ),
                    Color(
                        red: 0.72,
                        green: 0.06,
                        blue: 0.13
                    )
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: min(width * 0.065, 25)
            )
        )
        .shadow(
            color: .black.opacity(0.10),
            radius: 12,
            y: 5
        )
    }
}

// MARK: - 状态卡片

struct StatusCard: View {

    let width: CGFloat
    let isRunning: Bool

    var body: some View {

        let iconSize = min(width * 0.115, 46)

        VStack(alignment: .leading, spacing: width * 0.025) {

            Text("运行状态")
                .font(
                    .system(
                        size: min(width * 0.043, 17),
                        weight: .semibold
                    )
                )

            HStack(spacing: width * 0.035) {

                ZStack {

                    Circle()
                        .fill(
                            isRunning
                            ? Color.green.opacity(0.13)
                            : Color.orange.opacity(0.13)
                        )
                        .frame(
                            width: iconSize,
                            height: iconSize
                        )

                    Image(
                        systemName:
                            isRunning
                            ? "bolt.fill"
                            : "clock.fill"
                    )
                    .font(
                        .system(
                            size: iconSize * 0.42,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        isRunning
                        ? .green
                        : .orange
                    )
                }

                VStack(
                    alignment: .leading,
                    spacing: 3
                ) {

                    Text(
                        isRunning
                        ? "正在运行"
                        : "等待运行"
                    )
                    .font(
                        .system(
                            size: min(width * 0.04, 16),
                            weight: .semibold
                        )
                    )

                    Text(
                        isRunning
                        ? "任务正在执行中"
                        : "准备就绪"
                    )
                    .font(
                        .system(
                            size: min(width * 0.032, 13)
                        )
                    )
                    .foregroundStyle(.secondary)
                }

                Spacer()

                Circle()
                    .fill(
                        isRunning
                        ? .green
                        : .gray.opacity(0.4)
                    )
                    .frame(
                        width: 9,
                        height: 9
                    )
            }
        }
        .padding(width * 0.04)
        .frame(width: width)
        .background(.background)
        .clipShape(
            RoundedRectangle(
                cornerRadius: min(width * 0.05, 20)
            )
        )
        .shadow(
            color: .black.opacity(0.045),
            radius: 7,
            y: 3
        )
    }
}

// MARK: - 数据卡片

struct StatCard: View {

    let icon: String
    let value: String
    let title: String

    var body: some View {

        GeometryReader { geometry in

            VStack(
                alignment: .leading,
                spacing: geometry.size.width * 0.07
            ) {

                Image(systemName: icon)
                    .font(
                        .system(
                            size: min(
                                geometry.size.width * 0.13,
                                18
                            ),
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.orange)

                Text(value)
                    .font(
                        .system(
                            size: min(
                                geometry.size.width * 0.20,
                                26
                            ),
                            weight: .bold
                        )
                    )

                Text(title)
                    .font(
                        .system(
                            size: min(
                                geometry.size.width * 0.11,
                                13
                            )
                        )
                    )
                    .foregroundStyle(.secondary)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(
                min(geometry.size.width * 0.13, 14)
            )
            .background(.background)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 18
                )
            )
            .shadow(
                color: .black.opacity(0.035),
                radius: 6,
                y: 2
            )
        }
        .aspectRatio(0.92, contentMode: .fit)
    }
}

// MARK: - 账号

struct AccountsView: View {

    @AppStorage("accountsData")
    private var accountsData = ""

    @State private var accounts: [FireAccount] = []
    @State private var showingAdd = false

    var body: some View {

        NavigationStack {

            ZStack {

                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                if accounts.isEmpty {

                    EmptyAccountsView {
                        showingAdd = true
                    }

                } else {

                    List {

                        ForEach($accounts) { $account in

                            HStack(spacing: 12) {

                                ZStack {

                                    Circle()
                                        .fill(
                                            account.enabled
                                            ? Color.orange.opacity(0.12)
                                            : Color.gray.opacity(0.12)
                                        )
                                        .frame(
                                            width: 44,
                                            height: 44
                                        )

                                    Image(
                                        systemName:
                                            "person.fill"
                                    )
                                    .foregroundStyle(
                                        account.enabled
                                        ? .orange
                                        : .gray
                                    )
                                }

                                VStack(
                                    alignment: .leading,
                                    spacing: 3
                                ) {

                                    Text(account.name)
                                        .font(
                                            .system(
                                                size: 16,
                                                weight: .semibold
                                            )
                                        )

                                    Text(
                                        account.enabled
                                        ? "已启用"
                                        : "已停用"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Toggle(
                                    "",
                                    isOn:
                                        $account.enabled
                                )
                                .labelsHidden()
                                .tint(.orange)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete { indexSet in

                            accounts.remove(
                                atOffsets: indexSet
                            )

                            saveAccounts()
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("账号")
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(
                isPresented: $showingAdd
            ) {

                AddAccountView { name in

                    accounts.append(
                        FireAccount(
                            name: name,
                            enabled: true
                        )
                    )

                    saveAccounts()
                }
            }
            .onAppear {
                loadAccounts()
            }
        }
    }

    private func saveAccounts() {

        if let data = try? JSONEncoder().encode(
            accounts
        ) {
            accountsData =
                data.base64EncodedString()
        }
    }

    private func loadAccounts() {

        guard
            let data = Data(
                base64Encoded: accountsData
            ),
            let decoded =
                try? JSONDecoder().decode(
                    [FireAccount].self,
                    from: data
                )
        else {
            return
        }

        accounts = decoded
    }
}

// MARK: - 空账号

struct EmptyAccountsView: View {

    let addAction: () -> Void

    var body: some View {

        VStack(spacing: 15) {

            ZStack {

                Circle()
                    .fill(
                        Color.orange.opacity(0.11)
                    )
                    .frame(
                        width: 80,
                        height: 80
                    )

                Image(systemName: "flame.fill")
                    .font(
                        .system(
                            size: 31,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.orange)
            }

            Text("还没有账号")
                .font(
                    .system(
                        size: 21,
                        weight: .semibold
                    )
                )

            Text("添加账号后即可管理续火花任务")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)

            Button(action: addAction) {

                Label(
                    "添加账号",
                    systemImage: "plus"
                )
                .font(
                    .system(
                        size: 14,
                        weight: .semibold
                    )
                )
                .frame(
                    width: 140,
                    height: 42
                )
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
        }
        .padding(25)
    }
}

// MARK: - 添加账号

struct AddAccountView: View {

    @Environment(\.dismiss)
    private var dismiss

    @State private var name = ""

    let onSave: (String) -> Void

    var body: some View {

        NavigationStack {

            Form {

                Section("账号信息") {

                    TextField(
                        "账号名称",
                        text: $name
                    )
                }

                Section {

                    Text(
                        "请只添加你自己授权使用的账号。"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("添加账号")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(
                    placement: .cancellationAction
                ) {

                    Button("取消") {
                        dismiss()
                    }
                }

                ToolbarItem(
                    placement: .confirmationAction
                ) {

                    Button("保存") {

                        let trimmed =
                            name.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )

                        guard !trimmed.isEmpty else {
                            return
                        }

                        onSave(trimmed)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - 设置

struct SettingsView: View {

    @AppStorage("githubOwner")
    private var owner = ""

    @AppStorage("githubRepository")
    private var repository = ""

    @AppStorage("githubWorkflow")
    private var workflow = "send.yml"

    var body: some View {

        NavigationStack {

            Form {

                Section {

                    HStack(spacing: 12) {

                        ZStack {

                            RoundedRectangle(
                                cornerRadius: 13
                            )
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .orange,
                                        .red
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(
                                width: 52,
                                height: 52
                            )

                            Image(
                                systemName:
                                    "flame.fill"
                            )
                            .font(.title3)
                            .foregroundStyle(.white)
                        }

                        VStack(
                            alignment: .leading,
                            spacing: 3
                        ) {

                            Text("Auto Fire")
                                .font(.headline)

                            Text(
                                "自动续火花管理工具"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 3)
                }

                Section("GitHub 配置") {

                    TextField(
                        "Owner",
                        text: $owner
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                    TextField(
                        "Repository",
                        text: $repository
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                    TextField(
                        "Workflow",
                        text: $workflow
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                }

                Section("应用") {

                    HStack {

                        Label(
                            "版本",
                            systemImage:
                                "info.circle"
                        )

                        Spacer()

                        Text("V1.2")
                            .foregroundStyle(.secondary)
                    }

                    HStack {

                        Label(
                            "项目",
                            systemImage:
                                "flame"
                        )

                        Spacer()

                        Text("Auto Fire")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("设置")
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
