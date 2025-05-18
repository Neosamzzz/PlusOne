//
//  ContentView.swift
//  PlusOne
//
//  Created by  Hyberiid on 2025/5/17.
//

import SwiftUI
import UIKit // 导入 UIKit 以使用震动反馈

struct ContentView: View {
    @State private var showAddEvent = false
    @State private var newEventName = ""
    @State private var events: [Event] = []
    @State private var showEditCount = false
    @State private var editingEventIndex: Int? = nil
    @State private var editCountValue: String = ""
    @State private var showRename = false
    @State private var renameValue: String = ""
    @State private var showDeleteAlert = false
    @State private var deletingEventIndex: Int? = nil
    @State private var showNativeDeleteAlert = false
    @State private var showEmptyNameAlert = false // 新增：空名称提示
    
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
        NavigationView {
            VStack(spacing: 0) {
                // 主内容区
                ZStack {
                    VStack(spacing: 0) {
                        if events.isEmpty {
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
                                ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                                    EventRowView(
                                        event: event,
                                        index: index,
                                        events: $events,
                                        onEditCount: { index in
                                            editingEventIndex = index
                                            editCountValue = String(events[index].count)
                                            showEditCount = true
                                        },
                                        onRename: { index in
                                            renameValue = events[index].name
                                            editingEventIndex = index
                                            showRename = true
                                        },
                                        onDelete: { index in
                                            deletingEventIndex = index
                                            showNativeDeleteAlert = true
                                        }
                                    )
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
                        ReusableInputDialog(
                            title: "请输入事件名称",
                            text: $newEventName,
                            keyboardType: .default,
                            maxLength: nil,
                            isNumberOnly: false,
                            onCancel: {
                                showAddEvent = false
                                newEventName = ""
                            },
                            onConfirm: {
                                if newEventName.trimmingCharacters(in: .whitespaces).isEmpty {
                                    showEmptyNameAlert = true
                                } else {
                                    events.append(Event(name: newEventName, count: 0))
                                    DataManager.shared.saveEvents(events)
                                    showAddEvent = false
                                    newEventName = ""
                                }
                            }
                        )
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
                                    events[index].count = newValue
                                    DataManager.shared.saveEvents(events)
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
                        ReusableInputDialog(
                            title: "请输入新的事件名称",
                            text: $renameValue,
                            keyboardType: .default,
                            maxLength: nil,
                            isNumberOnly: false,
                            onCancel: {
                                showRename = false
                                renameValue = ""
                                editingEventIndex = nil
                            },
                            onConfirm: {
                                if !renameValue.trimmingCharacters(in: .whitespaces).isEmpty {
                                    events[index].name = renameValue
                                    DataManager.shared.saveEvents(events)
                                }
                                showRename = false
                                renameValue = ""
                                editingEventIndex = nil
                            }
                        )
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
                        events.remove(at: index)
                        DataManager.shared.saveEvents(events)
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
        }
        .onAppear(perform: {
            events = DataManager.shared.loadEvents()
        })
    }
}

#Preview {
    ContentView()
}
