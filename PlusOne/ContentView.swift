//
//  ContentView.swift
//  PlusOne
//
//  Created by  Hyberiid on 2025/5/17.
//

import SwiftUI
import UIKit // 导入 UIKit 以使用震动反馈

struct ContentView: View {
    @StateObject private var store = EventStore.shared
    @State private var showAddEvent = false
    @State private var newEventName = ""
    @State private var showEditCount = false
    @State private var editingEventIndex: Int? = nil
    @State private var editCountValue: String = ""
    @State private var showRename = false
    @State private var renameValue: String = ""
    @State private var showDeleteAlert = false
    @State private var deletingEventIndex: Int? = nil
    @State private var showNativeDeleteAlert = false
    @State private var showEmptyNameAlert = false // 新增：空名称提示
    // 新增：自定义跳转相关
    @State private var showDetail = false
    @State private var selectedEventId: UUID? = nil
    // 新增：震动反馈生成器
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray6 // ✅ 更贴近苹果味
        appearance.shadowColor = UIColor.separator // ✅ 保留底部分割线

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 主内容区
                ZStack {
                    VStack(spacing: 0) {
                        if store.events.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "rectangle.stack.badge.plus")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                Text("你还没有添加任何事件哦～")
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            // 事件列表
                            List {
                                ForEach(store.events.indices, id: \.self) { index in
                                    let event = store.events[index]
                                    Button(action: {
                                        feedbackGenerator.impactOccurred()
                                        selectedEventId = event.id
                                        DispatchQueue.main.async {
                                            showDetail = true
                                        }
                                    }) {
                                    EventRowView(
                                        event: event,
                                        index: index,
                                        events: $store.events,
                                        onEditCount: { index in
                                            editingEventIndex = index
                                            editCountValue = String(store.events[index].count)
                                            showEditCount = true
                                        },
                                        onRename: { index in
                                            renameValue = store.events[index].name
                                            editingEventIndex = index
                                            showRename = true
                                        },
                                        onDelete: { index in
                                            deletingEventIndex = index
                                            showNativeDeleteAlert = true
                                        }
                                    )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .listRowBackground(Color.clear)
                                }
                                .onDelete { indexSet in
                                    if let first = indexSet.first {
                                        deletingEventIndex = first
                                        showNativeDeleteAlert = true
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .background(Color(UIColor.systemBackground))
                        }
                    }
                    
                    // 添加事件弹窗
                    if showAddEvent {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        NavigationView {
                            Form {
                                Section(header: Spacer().frame(height: 10)) {
                                    TextField("事件名称", text: $newEventName)
                                }
                            }
                            .navigationTitle("添加事件")
                            .navigationBarItems(
                                leading: Button("取消") {
                                showAddEvent = false
                                newEventName = ""
                            },
                                trailing: Button("保存") {
                                if newEventName.trimmingCharacters(in: .whitespaces).isEmpty {
                                    showEmptyNameAlert = true
                                } else {
                                    store.events.append(Event(name: newEventName, count: 0))
                                    store.saveEvents()
                                    showAddEvent = false
                                    newEventName = ""
                                }
                            }
                        )
                        }
                        .presentationDetents([.height(200)])
                    }
                    
                    // 编辑计数弹窗
                    if showEditCount, let index = editingEventIndex {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        ReusableInputDialog(
                            title: "请输入新的计数值",
                            text: $editCountValue,
                            keyboardType: .numberPad,
                            maxLength: 4,
                            isNumberOnly: true,
                            onCancel: {
                                showEditCount = false
                                editCountValue = ""
                                editingEventIndex = nil
                            },
                            onConfirm: {
                                if let newValue = Int(editCountValue), newValue >= 0 && newValue <= 9999 {
                                    store.events[index].count = newValue
                                    // 添加记录
                                    store.events[index].records.append(CountRecord(count: newValue))
                                    store.saveEvents()
                                }
                                showEditCount = false
                                editCountValue = ""
                                editingEventIndex = nil
                            }
                        )
                    }
                    
                    // 重命名弹窗
                    if showRename, let index = editingEventIndex {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        NavigationView {
                            Form {
                                Section(header: Spacer().frame(height: 10)) {
                                    TextField("事件名称", text: $renameValue)
                                }
                            }
                            .navigationTitle("重命名")
                            .navigationBarItems(
                                leading: Button("取消") {
                                showRename = false
                                renameValue = ""
                                editingEventIndex = nil
                            },
                                trailing: Button("保存") {
                                if !renameValue.trimmingCharacters(in: .whitespaces).isEmpty {
                                    store.events[index].name = renameValue
                                    store.saveEvents()
                                }
                                showRename = false
                                renameValue = ""
                                editingEventIndex = nil
                            }
                        )
                        }
                        .presentationDetents([.height(200)])
                    }
                }
            }
            .navigationTitle("PLUSONE")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        feedbackGenerator.impactOccurred()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            showAddEvent = true
                        }
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large) // ✅ 系统推荐大小
                    }
                }
            }
            .alert("确认删除", isPresented: $showNativeDeleteAlert) {
                Button("取消", role: .cancel) { }
                Button("删除", role: .destructive) {
                    if let index = deletingEventIndex {
                        store.events.remove(at: index)
                        store.saveEvents()
                    }
                }
            } message: {
                Text("确定要删除这个事件吗？")
            }
            .alert("提示", isPresented: $showEmptyNameAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text("事件名称不能为空哦～")
            }
            // 详情页跳转
            .background(
                NavigationLink(
                    isActive: $showDetail,
                    destination: {
                        EventDetailWrapper(
                            eventId: selectedEventId,
                            onBack: {
                                showDetail = false
                                selectedEventId = nil
                            }
                        )
                    },
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
    }
}

#Preview {
    ContentView()
}
