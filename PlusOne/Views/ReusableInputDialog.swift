import SwiftUI

struct ReusableInputDialog: View {
    let title: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let maxLength: Int?
    let isNumberOnly: Bool
    let onCancel: () -> Void
    let onConfirm: () -> Void
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.top, 24)
                .padding(.bottom, 8)
            
            TextField("", text: $text)
                .keyboardType(keyboardType)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                .onChange(of: text) { newValue in
                    var filtered = newValue
                    if isNumberOnly {
                        filtered = newValue.filter { "0123456789".contains($0) }
                    }
                    if let maxLength = maxLength, filtered.count > maxLength {
                        filtered = String(filtered.prefix(maxLength))
                    }
                    if filtered != text {
                        text = filtered
                    }
                }
            
            Divider()
            
            HStack(spacing: 0) {
                Button(action: {
                    feedbackGenerator.impactOccurred()
                    onCancel()
                }) {
                    Text("取消")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .foregroundColor(.blue)
                
                Divider()
                    .frame(height: 44)
                
                Button(action: {
                    feedbackGenerator.impactOccurred()
                    onConfirm()
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