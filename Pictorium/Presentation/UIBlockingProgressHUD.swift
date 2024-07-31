import ProgressHUD
import UIKit

enum UIBlockingProgressHUD {
    // MARK: - Private Methods

    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }

    // MARK: - Public Methods

    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
        isVisible = true
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
        isVisible = false
    }

    private(set) static var isVisible = false
}
