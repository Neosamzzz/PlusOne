//
//  ContentView.swift
//  PlusOne
//
//  Created by  Hyberiid on 2025/5/17.
//

import SwiftUI
import UIKit // 导入 UIKit 以使用震动反馈

// 自定义圆形按钮按下样式
struct CirclePressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0) // 按下时缩小到90%
            .opacity(configuration.isPressed ? 0.8 : 1.0) // 按下时透明度降低到80%
    }
}

struct Event: Identifiable, Codable {
    let id = UUID()
    var name: String
    var count: Int
}

// 获取保存文件的URL
private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

// 保存事件数据到文件
private func saveEvents(_ events: [Event]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(events) {
        let url = getDocumentsDirectory().appendingPathComponent("events.json")
        try? encoded.write(to: url)
    }
}

// 从文件加载事件数据
private func loadEvents() -> [Event] {
    let url = getDocumentsDirectory().appendingPathComponent("events.json")
    if let data = try? Data(contentsOf: url) {
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Event].self, from: data) {
            return decoded
        }
    }
    return []
}

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
    
    // 新增：震动反馈生成器
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部灰色分隔线
            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
                .edgesIgnoringSafeArea(.horizontal)
            // 主内容区
            ZStack {
                VStack(spacing: 0) {
                    // 事件列表
                    List {
                        ForEach(Array(events.enumerated()), id: \ .element.id) { index, event in
                            HStack {
                                Text(event.name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.leading, 16)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                Spacer()
                                // 计数功能区
                                HStack(spacing: 16) {
                                    Button(action: {
                                        feedbackGenerator.impactOccurred() // 添加震动反馈
                                        if events[index].count > 0 {
                                            events[index].count -= 1
                                            saveEvents(events) // 保存数据
                                        }
                                    }) {
                                        Text("-")
                                            .font(.title2)
                                            .foregroundColor(events[index].count == 0 ? Color.gray : Color(red: 210/255, green: 182/255, blue: 142/255))
                                    }
                                    .buttonStyle(CirclePressButtonStyle())
                                    // 移除计数数字外层的Button，直接在Text上添加点击手势
                                    Text("\(event.count)")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                        .frame(minWidth: 60, alignment: .center) // 保持固定宽度以对齐
                                        .onTapGesture {
                                            editingEventIndex = index
                                            editCountValue = String(events[index].count)
                                            showEditCount = true
                                        }
                                    Button(action: {
                                        feedbackGenerator.impactOccurred() // 添加震动反馈
                                        if events[index].count < 9999 {
                                            events[index].count += 1
                                            saveEvents(events) // 保存数据
                                        }
                                    }) {
                                        Text("+")
                                            .font(.title2)
                                            .foregroundColor(events[index].count >= 9999 ? Color.gray : Color(red: 210/255, green: 182/255, blue: 142/255))
                                    }
                                    .buttonStyle(CirclePressButtonStyle())
                                }
                                .padding(.trailing, 16)
                                // 左滑删除
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        deletingEventIndex = index
                                        showNativeDeleteAlert = true
                                    } label: {
                                        Text("删除")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .tint(.red)
                                    // 左滑重命名
                                    Button {
                                        renameValue = event.name
                                        editingEventIndex = index
                                        showRename = true
                                    } label: {
                                        Text("重命名")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .tint(.blue)
                                }
                            }
                            .listRowBackground(Color.white)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .onDelete { indexSet in
                            if let first = indexSet.first {
                                deletingEventIndex = first
                                showNativeDeleteAlert = true
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.white)
                    
                    // 将"+"按钮移到列表下方
                    HStack {
                        Spacer()
                        Button(action: {
                            feedbackGenerator.impactOccurred() // 添加震动反馈
                            showAddEvent = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }
                        .contentShape(Circle()) // 限定点击区域为圆形
                        .buttonStyle(CirclePressButtonStyle()) // 应用自定义样式
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .listRowSeparator(.hidden) // 隐藏底部线条
                }
                
                if showAddEvent {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    VStack(spacing: 0) {
                        Text("请输入事件名称")
                            .font(.headline)
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                        TextField("事件名称", text: $newEventName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                            .onChange(of: newEventName) { newValue in
                                if newValue.count > 7 {
                                    newEventName = String(newValue.prefix(7))
                                }
                            }
                        Divider()
                        HStack(spacing: 0) {
                            Button(action: {
                                showAddEvent = false
                                newEventName = ""
                            }) {
                                Text("取消")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                            }
                            .foregroundColor(.blue)
                            Divider()
                                .frame(height: 44)
                            Button(action: {
                                if !newEventName.trimmingCharacters(in: .whitespaces).isEmpty {
                                    events.append(Event(name: newEventName, count: 0))
                                    saveEvents(events)
                                }
                                showAddEvent = false
                                newEventName = ""
                            }) {
                                Text("确认")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .frame(width: 300)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(14)
                    .shadow(radius: 10)
                    .padding(.horizontal, 40)
                }
                
                if showEditCount, let index = editingEventIndex {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    VStack(spacing: 0) {
                        Text("请输入新的计数值")
                            .font(.headline)
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                        TextField("计数", text: $editCountValue)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                            .onChange(of: editCountValue) { newValue in
                                // 只允许输入数字
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                // 限制最大4位数
                                if filtered.count > 4 {
                                    editCountValue = String(filtered.prefix(4))
                                } else {
                                    editCountValue = filtered
                                }
                            }
                        Divider()
                        HStack(spacing: 0) {
                            Button(action: {
                                showEditCount = false
                                editCountValue = ""
                                editingEventIndex = nil
                            }) {
                                Text("取消")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                            }
                            .foregroundColor(.blue)
                            Divider()
                                .frame(height: 44)
                            Button(action: {
                                if let newValue = Int(editCountValue), newValue >= 0 && newValue <= 9999 {
                                    events[index].count = newValue
                                    saveEvents(events)
                                }
                                showEditCount = false
                                editCountValue = ""
                                editingEventIndex = nil
                            }) {
                                Text("确认")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .frame(width: 300)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(14)
                    .shadow(radius: 10)
                    .padding(.horizontal, 40)
                }
                
                if showRename, let index = editingEventIndex {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    VStack(spacing: 0) {
                        Text("请输入新的事件名称")
                            .font(.headline)
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                        TextField("事件名称", text: $renameValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                            .onChange(of: renameValue) { newValue in
                                if newValue.count > 7 {
                                    renameValue = String(newValue.prefix(7))
                                }
                            }
                        Divider()
                        HStack(spacing: 0) {
                            Button(action: {
                                showRename = false
                                renameValue = ""
                                editingEventIndex = nil
                            }) {
                                Text("取消")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                            }
                            .foregroundColor(.blue)
                            Divider()
                                .frame(height: 44)
                            Button(action: {
                                if !renameValue.trimmingCharacters(in: .whitespaces).isEmpty {
                                    events[index].name = renameValue
                                    saveEvents(events)
                                }
                                showRename = false
                                renameValue = ""
                                editingEventIndex = nil
                            }) {
                                Text("确认")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .frame(width: 300)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(14)
                    .shadow(radius: 10)
                    .padding(.horizontal, 40)
                }
            }
            .alert("确认删除该事件？", isPresented: $showNativeDeleteAlert) {
                Button("取消", role: .cancel) {
                    showNativeDeleteAlert = false
                    deletingEventIndex = nil
                }
                Button("确认", role: .destructive) {
                    if let index = deletingEventIndex {
                        events.remove(at: index)
                        saveEvents(events) // 保存数据
                    }
                    showNativeDeleteAlert = false
                    deletingEventIndex = nil
                }
            }
        }
        .onAppear(perform: {
            events = loadEvents() // 加载数据
        })
    }
}

#Preview {
    ContentView()
}
