import UIKit

extension UIFont {
    static func jura(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let fontName: String
        switch weight {
        case .regular:
            fontName = "Jura-Regular"
        case .medium:
            fontName = "Jura-Medium"
        case .semibold:
            fontName = "Jura-SemiBold"
        case .bold:
            fontName = "Jura-Bold"
        default:
            fontName = "Jura-Regular"
        }
        
        if let font = UIFont(name: fontName, size: size) {
            return font
        }
        
        // Fallback to system font if custom font fails to load
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
} 