import SwiftUI

// MARK: - 数据模型

struct FireAccount: Identifiable, Codable {
    var id = UUID()
    var name: String
    var enabled: Bool
}

// MARK: - 主界面

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

    private var accountCount: Int {
        guard let data = Data(base64Encoded: accountsData),
              let accounts = try? JSONDecoder().decode(
                [FireAccount].self,
                from: data
              )
        else {
            return 0
        }

        return accounts.filter { $0.enabled }.count
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 14) {

                        // MARK: 顶部 Hero

                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.16))
                                    .frame(width: 62, height: 62)

                                Image(systemName: "flame.fill")
                                    .font(
                                        .system(
                                            size: 32,
                                            weight: .bold
                                        )
                                    )
                                    .foregroundStyle(.white)
                            }

                            Text("Auto Fire")
                                .font(
                                    .system(
                                        size: 26,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(.white)

                            Text("自动管理每日续火花任务")
                                .font(.system(size: 13))
                                .foregroundStyle(
                                    .white.opacity(0.82)
                                )
                        }
                        .frame(
                            width: geometry.size.width - 32
                        )
                        .frame(height: 185)
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
                                cornerRadius: 24
                            )
                        )
                        .shadow(
                            color: .black.opacity(0.10),
                            radius: 12,
                            y: 5
                        )

                        // MARK: 运行状态

                        VStack(alignment: .leading, spacing: 11) {
                            Text("运行状态")
                                .font(
                                    .system(
                                        size: 16,
                                        weight: .semibold
                                    )
                                )

                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            isRunning
                                            ? Color.green.opacity(0.13)
                                            : Color.orange.opacity(0.13)
                                        )
                                        .frame(
                                            width: 44,
                                            height: 44
                                        )

                                    Image(
                                        systemName:
                                            isRunning
                                            ? "bolt.fill"
                                            : "clock.fill"
                                    )
                                    .font(
                                        .system(
                                            size: 18,
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
                                            size: 15,
                                            weight: .semibold
                                        )
                                    )

                                    Text(
                                        isRunning
                                        ? "任务正在执行中"
                                        : "准备就绪"
                                    )
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Circle()
                                    .fill(
                                        isRunning
                                        ? .green
                                        : .gray.opacity(0.45)
                                    )
                                    .frame(
                                        width: 9,
                                        height: 9
                                    )
                            }
                        }
                        .padding(15)
                        .frame(
                            width: geometry.size.width - 32
                        )
                        .background(.background)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 19
                            )
                        )
                        .shadow(
                            color: .black.opacity(0.045),
                            radius: 7,
                            y: 3
                        )

                        // MARK: 数据卡片

                        HStack(spacing: 12) {
                            DataCard(
                                title: "账号",
                                value: "\(accountCount)",
                                icon: "person.2.fill"
                            )

                            DataCard(
                                title: "今日任务",
                                value: "\(accountCount)",
                                icon: "checklist"
                            )

                            DataCard(
                                title: "已完成",
                                value: "0",
                                icon: "checkmark.circle.fill"
                            )
                        }
                        .frame(
                            width: geometry.size.width - 32
                        )

                        // MARK: 运行按钮

                        Button {
                            withAnimation(
                                .easeInOut(duration: 0.2)
                            ) {
                                isRunning.toggle()
                            }
                        } label: {
                            HStack(spacing: 8) {
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
                                        size: 16,
                                        weight: .semibold
                                    )
                                )
                            }
                            .foregroundStyle(.white)
                            .frame(
                                width: geometry.size.width - 32,
                                height: 50
                            )
                            .background(
                                isRunning
                                ? Color.gray
                                : Color.orange
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 15
                                )
                            )
                        }
                        .padding(.top, 2)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .padding(.bottom, 18)
                }
                .scrollIndicators(.hidden)
            }
            .background(
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            )
            .navigationTitle("Auto Fire")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - 数据卡片

struct DataCard: View {

    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Image(systemName: icon)
                .font(
                    .system(
                        size: 14,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.orange)

            Text(value)
                .font(
                    .system(
                        size: 22,
                        weight: .bold
                    )
                )

            Text(title)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(12)
        .background(.background)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 17
            )
        )
        .shadow(
            color: .black.opacity(0.035),
            radius: 6,
            y: 2
        )
    }
}

// MARK: - 账号页面

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
                        ForEach(
                            $accounts
                        ) { $account in

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
                                                size: 15,
                                                weight: .semibold
                                            )
                                        )

                                    Text(
                                        account.enabled
                                        ? "已启用"
                                        : "已停用"
                                    )
                                    .font(.system(size: 12))
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

// MARK: - 空账号页面

struct EmptyAccountsView: View {

    let addAction: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        Color.orange.opacity(0.11)
                    )
                    .frame(
                        width: 78,
                        height: 78
                    )

                Image(systemName: "flame.fill")
                    .font(
                        .system(
                            size: 30,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.orange)
            }

            Text("还没有账号")
                .font(
                    .system(
                        size: 20,
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
                                systemName: "flame.fill"
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
                    .textInputAutocapitalization(
                        .never
                    )
                    .autocorrectionDisabled()

                    TextField(
                        "Repository",
                        text: $repository
                    )
                    .textInputAutocapitalization(
                        .never
                    )
                    .autocorrectionDisabled()

                    TextField(
                        "Workflow",
                        text: $workflow
                    )
                    .textInputAutocapitalization(
                        .never
                    )
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

                        Text("V1.1")
                            .foregroundStyle(
                                .secondary
                            )
                    }

                    HStack {
                        Label(
                            "项目",
                            systemImage:
                                "flame"
                        )

                        Spacer()

                        Text("Auto Fire")
                            .foregroundStyle(
                                .secondary
                            )
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
