import SwiftUI

struct EventRowView: View {
    let event: Event
    let index: Int
    @Binding var events: [Event]
    let onEditCount: (Int) -> Void
    let onRename: (Int) -> Void
    let onDelete: (Int) -> Void
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        HStack {
            Text(event.name)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.leading, 16)
                .foregroundColor(.primary)
                .lineLimit(1)
            Spacer()
            // 计数功能区
            HStack(spacing: 16) {
                Button(action: {
                    feedbackGenerator.impactOccurred()
                    if index < events.count && events[index].count > 0 {
                        events[index].count -= 1
                        DataManager.shared.saveEvents(events)
                    }
                }) {
                    Text("-")
                        .font(.title2)
                        .foregroundColor(index < events.count && events[index].count == 0 ? AppColors.disabledColor : AppColors.buttonColor)
                }
                .buttonStyle(CirclePressButtonStyle())
                
                Text("\(event.count)")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .frame(minWidth: 60, alignment: .center)
                    .onTapGesture {
                        onEditCount(index)
                    }
                
                Button(action: {
                    feedbackGenerator.impactOccurred()
                    if index < events.count && events[index].count < 9999 {
                        events[index].count += 1
                        DataManager.shared.saveEvents(events)
                    }
                }) {
                    Text("+")
                        .font(.title2)
                        .foregroundColor(index < events.count && events[index].count >= 9999 ? AppColors.disabledColor : AppColors.buttonColor)
                }
                .buttonStyle(CirclePressButtonStyle())
            }
            .padding(.trailing, 16)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive) {
                    feedbackGenerator.impactOccurred()
                    onDelete(index)
                } label: {
                    Text("删除")
                        .frame(maxWidth: .infinity)
                }
                .tint(.red)
                
                Button {
                    feedbackGenerator.impactOccurred()
                    onRename(index)
                } label: {
                    Text("重命名")
                        .frame(maxWidth: .infinity)
                }
                .tint(.blue)
            }
        }
        .listRowBackground(Color(UIColor.systemBackground))
        .frame(height: 50)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
    }
} 