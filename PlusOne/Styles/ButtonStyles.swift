import SwiftUI

// 自定义圆形按钮按下样式
struct CirclePressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0) // 按下时缩小到90%
            .opacity(configuration.isPressed ? 0.8 : 1.0) // 按下时透明度降低到80%
    }
}

// 颜色主题
struct AppColors {
    static let titleBarBackground = Color(red: 239/255, green: 240/255, blue: 245/255) // #eff0f5
    static let buttonColor = Color(red: 210/255, green: 182/255, blue: 142/255) // #d2b68e
    static let disabledColor = Color.gray
    static let navigationBarBackground = Color(red: 239/255, green: 240/255, blue: 245/255) // #eff0f5
} 