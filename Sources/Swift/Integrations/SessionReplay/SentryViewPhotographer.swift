#if canImport(UIKit) && !SENTRY_NO_UIKIT
#if os(iOS) || os(tvOS)

@_implementationOnly import _SentryPrivate
import CoreGraphics
import Foundation
import UIKit

@available(iOS, introduced: 16.0)
@available(tvOS, introduced: 16.0)
@objcMembers
class SentryViewPhotographer: NSObject {
    
    //This is a list of UIView subclasses that will be ignored during redact process
    private var ignoreClasses: [AnyClass] = []
    //This is a list of UIView subclasses that need to be redacted from screenshot
    private var redactClasses: [AnyClass] = []
    
    static let shared = SentryViewPhotographer()
    
    override init() {
#if os(iOS)
        ignoreClasses = [  UISlider.self, UISwitch.self ]
#endif // os(iOS)
        redactClasses = [ UILabel.self, UITextView.self, UITextField.self ] + [
            "_TtCOCV7SwiftUI11DisplayList11ViewUpdater8Platform13CGDrawingView",
            "_TtC7SwiftUIP33_A34643117F00277B93DEBAB70EC0697122_UIShapeHitTestingView",
            "SwiftUI._UIGraphicsView", "SwiftUI.ImageLayer"
        ].compactMap { NSClassFromString($0) }
    }
    
    func image(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
    
        view.layer.render(in: currentContext)
        self.mask(view: view, context: currentContext)
        
        guard let screenshot = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return screenshot
    }
    
    private func mask(view: UIView, context: CGContext) {
        UIColor.black.setFill()
        let maskPath = self.buildPath(view: view, path: CGMutablePath(), area: view.frame)
        context.addPath(maskPath)
        context.fillPath()
    }
    
    private func shouldIgnore(view: UIView) -> Bool {
        ignoreClasses.contains { view.isKind(of: $0) }
    }
    
    private func shouldRedact(view: UIView) -> Bool {
        if let imageView = view as? UIImageView {
            return shouldRedact(imageView: imageView)
        }
        
        return redactClasses.contains { view.isKind(of: $0) }
    }
    
    private func shouldRedact(imageView: UIImageView) -> Bool {
        // Checking the size is to avoid redact gradient backgroud that
        // are usually small lines repeating
        guard let image = imageView.image, image.size.width > 10 && image.size.height > 10  else { return false }
        return image.imageAsset?.value(forKey: "_containingBundle") != nil
    }
    
    private func buildPath(view: UIView, path: CGMutablePath, area: CGRect) -> CGMutablePath {
        let rectInWindow = view.convert(view.bounds, to: nil)

        if !area.intersects(rectInWindow) || view.isHidden || view.alpha == 0 {
            return path
        }
        
        var result = path

        let ignore = shouldIgnore(view: view)
        
        if !ignore && shouldRedact(view: view) {
            result.addRect(rectInWindow)
            return result
        } else if isOpaqueOrHasBackground(view) {
            result = SentryCoreGraphicsHelper.excludeRect(rectInWindow, from: result).takeRetainedValue()
        }

        if !ignore {
            for subview in view.subviews {
                result = buildPath(view: subview, path: path, area: area)
            }
        }

        return result
    }
    
    private func isOpaqueOrHasBackground(_ view: UIView) -> Bool {
        return view.isOpaque || (view.backgroundColor != nil && (view.backgroundColor?.cgColor.alpha ?? 0) > 0.9)
    }
}

#endif // os(iOS) || os(tvOS)
#endif // canImport(UIKit) && !SENTRY_NO_UIKIT
