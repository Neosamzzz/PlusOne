import SwiftUI

struct EventDetailView: View {
    let eventId: UUID
    var onBack: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = EventStore.shared
    @State private var showEditTime = false
    @State private var showEditNote = false
    @State private var selectedRecord: CountRecord? = nil
    @State private var editNote = ""
    @State private var editDate = Date()
    @State private var showDeleteAlert = false
    @State private var isSelectionMode = false
    @State private var showAddRecord = false
    @State private var selectedRecordIDs: Set<UUID> = []
    
    private var currentEvent: Event? {
        store.events.first(where: { $0.id == eventId })
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            if let event = currentEvent {
                // 大号计数数字
                Text("\(event.count)")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                // 历史记录列表
                List {
                    ForEach(event.records.sorted(by: { $0.timestamp > $1.timestamp })) { record in
                        HStack {
                            if isSelectionMode {
                                Button(action: {
                                    if selectedRecordIDs.contains(record.id) {
                                        selectedRecordIDs.remove(record.id)
                                    } else {
                                        selectedRecordIDs.insert(record.id)
                                    }
                                }) {
                                    Image(systemName: selectedRecordIDs.contains(record.id) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedRecordIDs.contains(record.id) ? .blue : .gray)
                                }
                            }
                            Text(record.note)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(dateFormatter.string(from: record.timestamp))
                                .foregroundColor(.secondary)
                                .onTapGesture {
                                    if !isSelectionMode {
                                        selectedRecord = record
                                        editDate = record.timestamp
                                        showEditTime = true
                                    }
                                }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if isSelectionMode {
                                if selectedRecordIDs.contains(record.id) {
                                    selectedRecordIDs.remove(record.id)
                                } else {
                                    selectedRecordIDs.insert(record.id)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            if !isSelectionMode {
                                Button(role: .destructive) {
                                    selectedRecord = record
                                    showDeleteAlert = true
                                } label: {
                                    Label("删除", systemImage: "trash")
                                }
                                Button {
                                    selectedRecord = record
                                    editNote = record.note
                                    showEditNote = true
                                } label: {
                                    Label("重命名", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                        .background(isSelectionMode && selectedRecordIDs.contains(record.id) ? Color.blue.opacity(0.1) : Color.clear)
                    }
                }
                .id(UUID())
                .listStyle(PlainListStyle())
                // 底部操作栏
                if isSelectionMode {
                    VStack(spacing: 0) {
                        Divider()
                        HStack {
                            Button(action: {
                                let allIDs = Set(event.records.map { $0.id })
                                if selectedRecordIDs.count == allIDs.count {
                                    selectedRecordIDs.removeAll()
                                } else {
                                    selectedRecordIDs = allIDs
                                }
                            }) {
                                Text(selectedRecordIDs.count == event.records.count && !event.records.isEmpty ? "取消全选" : "全选")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            Button(action: {
                                if !selectedRecordIDs.isEmpty {
                                    showDeleteAlert = true
                                }
                            }) {
                                Text("删除")
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedRecordIDs.isEmpty ? .gray : .red)
                            }
                            .frame(maxWidth: .infinity)
                            .disabled(selectedRecordIDs.isEmpty)
                        }
                        .padding(.vertical, 12)
                        .background(Color(UIColor.systemGray6))
                    }
                    .transition(.move(edge: .bottom))
                }
            } else {
                Text("事件不存在或已被删除")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle(currentEvent?.name.isEmpty == false ? currentEvent!.name : "详情")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemBackground))
        .navigationBarBackButtonHidden(isSelectionMode)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if isSelectionMode {
                    Button(action: {
                        showAddRecord = true
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                } else {
                    EmptyView()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isSelectionMode.toggle()
                    if !isSelectionMode {
                        selectedRecordIDs.removeAll()
                    }
                }) {
                    Text(isSelectionMode ? "取消" : "选择")
                }
            }
        }
        .sheet(isPresented: $showEditTime) {
            NavigationView {
                Form {
                    DatePicker("时间", selection: $editDate)
                }
                .navigationTitle("修改时间")
                .navigationBarItems(
                    leading: Button("取消") {
                        showEditTime = false
                    },
                    trailing: Button("保存") {
                        if let record = selectedRecord {
                            store.updateRecord(in: eventId, recordId: record.id, timestamp: editDate)
                        }
                        showEditTime = false
                    }
                )
            }
        }
        .sheet(isPresented: $showEditNote) {
            NavigationView {
                Form {
                    TextField("备注", text: $editNote)
                }
                .navigationTitle("修改备注")
                .navigationBarItems(
                    leading: Button("取消") {
                        showEditNote = false
                    },
                    trailing: Button("保存") {
                        if let record = selectedRecord {
                            store.updateRecord(in: eventId, recordId: record.id, note: editNote)
                        }
                        showEditNote = false
                    }
                )
            }
        }
        .sheet(isPresented: $showAddRecord) {
            NavigationView {
                Form {
                    DatePicker("时间", selection: $editDate)
                    TextField("备注", text: $editNote)
                }
                .navigationTitle("添加记录")
                .navigationBarItems(
                    leading: Button("取消") {
                        showAddRecord = false
                        editNote = ""
                    },
                    trailing: Button("保存") {
                        if let event = currentEvent {
                            store.addRecord(to: event.id, record: CountRecord(
                                count: event.count,
                                timestamp: editDate,
                                note: editNote.isEmpty ? "计数：\(event.count)" : editNote
                            ))
                        }
                        showAddRecord = false
                        editNote = ""
                        isSelectionMode = false
                    }
                )
            }
        }
        .alert("确认删除", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                if isSelectionMode {
                    if let event = currentEvent {
                        store.removeRecords(from: event.id, recordIds: selectedRecordIDs)
                    }
                    selectedRecordIDs.removeAll()
                    isSelectionMode = false
                } else if let record = selectedRecord, let event = currentEvent {
                    store.removeRecords(from: event.id, recordIds: [record.id])
                }
            }
        } message: {
            Text(isSelectionMode ? "确定要删除选中的记录吗？" : "确定要删除这条记录吗？")
        }
    }
}

#Preview {
    NavigationStack {
        EventDetailView(eventId: UUID())
    }
} 
