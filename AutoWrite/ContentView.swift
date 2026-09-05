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
    @AppStorage("accountCount") private var accountCount = 0
    @State private var isRunning = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // 顶部卡片
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.18))
                                .frame(width: 68, height: 68)

                            Image(systemName: "flame.fill")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundStyle(.white)
                        }

                        Text("Auto Fire")
                            .font(.system(size: 27, weight: .bold))
                            .foregroundStyle(.white)

                        Text("自动管理每日续火花任务")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.95, green: 0.18, blue: 0.25),
                                Color(red: 0.68, green: 0.05, blue: 0.12)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22))

                    // 状态
                    VStack(alignment: .leading, spacing: 12) {
                        Text("运行状态")
                            .font(.headline)

                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        isRunning
                                        ? Color.green.opacity(0.14)
                                        : Color.orange.opacity(0.14)
                                    )
                                    .frame(width: 46, height: 46)

                                Image(
                                    systemName:
                                        isRunning
                                        ? "bolt.fill"
                                        : "clock.fill"
                                )
                                .foregroundStyle(
                                    isRunning ? .green : .orange
                                )
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text(
                                    isRunning
                                    ? "正在运行"
                                    : "等待运行"
                                )
                                .font(.subheadline.weight(.semibold))

                                Text(
                                    isRunning
                                    ? "任务正在执行中"
                                    : "准备就绪"
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                    }
                    .padding(16)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    // 数据
                    HStack(spacing: 12) {
                        StatCard(
                            title: "账号",
                            value: "\(accountCount)",
                            icon: "person.2.fill"
                        )

                        StatCard(
                            title: "今日任务",
                            value: "\(accountCount)",
                            icon: "checklist"
                        )
                    }

                    // 运行
                    Button {
                        withAnimation {
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
                            .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            isRunning ? Color.gray : Color.orange
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 15)
                        )
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Auto Fire")
        }
    }
}

// MARK: - 数据卡片

struct StatCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.orange)

            Text(value)
                .font(.system(size: 25, weight: .bold))

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 17))
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
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.12))
                                .frame(width: 76, height: 76)

                            Image(systemName: "flame.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(.orange)
                        }

                        Text("还没有账号")
                            .font(.title3.weight(.semibold))

                        Text("添加账号后即可管理续火花任务")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Button {
                            showingAdd = true
                        } label: {
                            Label("添加账号", systemImage: "plus")
                                .frame(width: 140, height: 42)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                    }
                    .padding()
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
                                        .frame(width: 44, height: 44)

                                    Image(systemName: "person.fill")
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
                                            .subheadline.weight(
                                                .semibold
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

                                Toggle("", isOn: $account.enabled)
                                    .labelsHidden()
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete { indexSet in
                            accounts.remove(atOffsets: indexSet)
                            saveAccounts()
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("账号")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddAccountView { name in
                    let account = FireAccount(
                        name: name,
                        enabled: true
                    )

                    accounts.append(account)
                    saveAccounts()
                }
            }
            .onAppear {
                loadAccounts()
            }
        }
    }

    private func saveAccounts() {
        if let data = try? JSONEncoder().encode(accounts) {
            accountsData = data.base64EncodedString()
        }
    }

    private func loadAccounts() {
        guard
            let data = Data(base64Encoded: accountsData),
            let decoded = try? JSONDecoder().decode(
                [FireAccount].self,
                from: data
            )
        else {
            return
        }

        accounts = decoded
    }
}

// MARK: - 添加账号

struct AddAccountView: View {
    @Environment(\.dismiss) private var dismiss

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
                        "这里只保存你自己授权使用的账号配置。"
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
                        let trimmed = name.trimmingCharacters(
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
                            .frame(width: 52, height: 52)

                            Image(systemName: "flame.fill")
                                .foregroundStyle(.white)
                        }

                        VStack(
                            alignment: .leading,
                            spacing: 3
                        ) {
                            Text("Auto Fire")
                                .font(.headline)

                            Text("自动续火花管理工具")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("GitHub 配置") {
                    TextField(
                        "Owner",
                        text: $owner
                    )
                    .textInputAutocapitalization(.never)

                    TextField(
                        "Repository",
                        text: $repository
                    )
                    .textInputAutocapitalization(.never)

                    TextField(
                        "Workflow",
                        text: $workflow
                    )
                    .textInputAutocapitalization(.never)
                }

                Section("应用") {
                    HStack {
                        Label(
                            "版本",
                            systemImage: "info.circle"
                        )

                        Spacer()

                        Text("V1.1")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Label(
                            "项目",
                            systemImage: "flame"
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
