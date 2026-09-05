import SwiftUI

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
    @State private var isRunning = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // 顶部火花卡片
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color.orange,
                                Color.red
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        VStack(spacing: 12) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.white)

                            Text("续火花")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundStyle(.white)

                            Text("自动管理每日续火花任务")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.85))
                        }
                        .padding(.vertical, 35)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .shadow(
                        color: .black.opacity(0.12),
                        radius: 15,
                        y: 8
                    )

                    // 状态
                    VStack(alignment: .leading, spacing: 14) {
                        Text("运行状态")
                            .font(.headline)

                        HStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(
                                        isRunning
                                        ? Color.green.opacity(0.15)
                                        : Color.orange.opacity(0.15)
                                    )
                                    .frame(width: 52, height: 52)

                                Image(systemName:
                                    isRunning
                                    ? "bolt.fill"
                                    : "clock.fill"
                                )
                                .foregroundStyle(
                                    isRunning
                                    ? .green
                                    : .orange
                                )
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(isRunning ? "正在运行" : "等待运行")
                                    .font(.headline)

                                Text(
                                    isRunning
                                    ? "任务正在执行中"
                                    : "今天还没有运行任务"
                                )
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(
                        color: .black.opacity(0.06),
                        radius: 10,
                        y: 4
                    )

                    // 数据卡片
                    HStack(spacing: 12) {
                        StatCard(
                            title: "今日任务",
                            value: "0",
                            icon: "checklist"
                        )

                        StatCard(
                            title: "已完成",
                            value: "0",
                            icon: "checkmark.circle.fill"
                        )
                    }

                    // 运行按钮
                    Button {
                        withAnimation {
                            isRunning.toggle()
                        }
                    } label: {
                        HStack {
                            Image(systemName:
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
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(isRunning ? .gray : .orange)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("首页")
        }
    }
}

// MARK: - 数据卡片

struct StatCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.orange)

            Text(value)
                .font(.system(size: 28, weight: .bold))

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: .black.opacity(0.05),
            radius: 8,
            y: 3
        )
    }
}

// MARK: - 账号

struct AccountsView: View {
    @State private var accounts: [String] = []

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                if accounts.isEmpty {
                    VStack(spacing: 18) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.12))
                                .frame(width: 90, height: 90)

                            Image(systemName: "person.2.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(.orange)
                        }

                        Text("还没有账号")
                            .font(.title2)
                            .bold()

                        Text("添加账号后即可管理续火花任务")
                            .foregroundStyle(.secondary)

                        Button {
                            accounts.append("账号 \(accounts.count + 1)")
                        } label: {
                            Label("添加账号", systemImage: "plus")
                                .frame(width: 150)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(accounts, id: \.self) { account in
                            HStack(spacing: 15) {
                                ZStack {
                                    Circle()
                                        .fill(Color.orange.opacity(0.12))
                                        .frame(width: 45, height: 45)

                                    Image(systemName: "person.fill")
                                        .foregroundStyle(.orange)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(account)
                                        .font(.headline)

                                    Text("等待运行")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Circle()
                                    .fill(.gray.opacity(0.4))
                                    .frame(width: 9, height: 9)
                            }
                            .padding(.vertical, 6)
                        }
                        .onDelete { indexSet in
                            accounts.remove(atOffsets: indexSet)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("账号")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        accounts.append("账号 \(accounts.count + 1)")
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

// MARK: - 设置

struct SettingsView: View {
    @State private var owner = ""
    @State private var repository = ""
    @State private var workflow = "send.yml"

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
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
                                .frame(width: 55, height: 55)

                            Image(systemName: "flame.fill")
                                .foregroundStyle(.white)
                                .font(.title2)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("续火花")
                                .font(.headline)

                            Text("自动续火花管理工具")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }

                Section("GitHub 配置") {
                    TextField("Owner", text: $owner)
                        .textInputAutocapitalization(.never)

                    TextField("Repository", text: $repository)
                        .textInputAutocapitalization(.never)

                    TextField("Workflow", text: $workflow)
                        .textInputAutocapitalization(.never)
                }

                Section("应用") {
                    HStack {
                        Label("版本", systemImage: "info.circle")

                        Spacer()

                        Text("V1.0")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Label("项目", systemImage: "flame")

                        Spacer()

                        Text("续火花")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("设置")
        }
    }
}

#Preview {
    ContentView()
}
