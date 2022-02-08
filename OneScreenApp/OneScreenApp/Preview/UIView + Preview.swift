#if DEBUG
import SwiftUI

extension UIView {
    private struct Preview: UIViewRepresentable {
        // this variable is used for injecting the current view controller
        let view: UIView
        func makeUIView(context: Context) -> UIView {
            return view
        }
        func updateUIView(_ uiView: UIView, context: Context) {
            // leave this empty
        }
    }
    func toPreview() -> some View {
        // inject self (the current view) for the preview
        Preview(view: self)
    }
}
#endif
