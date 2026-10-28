import UIKit

@objcMembers public class SwiftClass: NSObject {

    @available(iOS 27.1, *)
    private static var hingeInteraction: UIHingeInteraction?
    private static let stateLock = NSLock()

    private static var hingeStatus = "not_started"
    private static var hingeAngle: Float = -1.0

    // Godot 调用此方法，开始监听铰链
    static func startMonitoring() {
        DispatchQueue.main.async {
            if #available(iOS 27.1, *) {
                Self.installHingeInteraction()
            } else {
                Self.updateState(status: "unsupported", angle: -1.0)
            }
        }
    }

    // 必须在主线程安装 UIKit Interaction
    @MainActor
    @available(iOS 27.1, *)
    private static func installHingeInteraction() {
        // 避免重复安装
        guard hingeInteraction == nil else {
            return
        }

        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }

        guard let window =
                windows.first(where: { $0.isKeyWindow }) ?? windows.first,
              let view = window.rootViewController?.view else {
            updateState(status: "no_window", angle: -1.0)
            return
        }

        let interaction = UIHingeInteraction { _, update in
            guard let hinge = update.hinge else {
                Self.updateState(
                    status: "unavailable",
                    angle: -1.0
                )
                return
            }

            let status: String

            switch hinge.status {
            case .closed:
                status = "closed"
            case .partiallyOpen:
                status = "partiallyOpen"
            case .fullyOpen:
                status = "fullyOpen"
            case .unknown:
                status = "unknown"
            @unknown default:
                status = "unknown"
            }

            Self.updateState(
                status: status,
                angle: Float(hinge.angle)
            )
        }

        hingeInteraction = interaction
        view.addInteraction(interaction)
    }

    // 安全地保存系统返回的数据
    private static func updateState(status: String, angle: Float) {
        stateLock.lock()
        hingeStatus = status
        hingeAngle = angle
        stateLock.unlock()
    }

    // 返回当前状态
    static func getStatus() -> NSString {
        stateLock.lock()
        let result = hingeStatus
        stateLock.unlock()

        return result as NSString
    }

    // 返回当前角度，单位为弧度；-1 表示暂时没有可用角度
    static func getAngle() -> Float {
        stateLock.lock()
        let result = hingeAngle
        stateLock.unlock()

        return result
    }
}
