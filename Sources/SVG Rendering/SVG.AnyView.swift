public import Byte

extension SVG {
    public struct AnyView: SVG.View {
        let renderInto: (inout [Byte], inout SVG.Context) -> Void

        public init<T: SVG.View>(_ base: T) {
            self.renderInto = { bytes, context in T._render(base, into: &bytes, context: &context) }
        }
    }
}

extension SVG.AnyView {
    public static func _render<Buffer: RangeReplaceableCollection>(
        _ svg: SVG.AnyView,
        into buffer: inout Buffer,
        context: inout SVG.Context
    ) where Buffer.Element == Byte {
        var bytes: [Byte] = []
        svg.renderInto(&bytes, &context)
        buffer.append(contentsOf: bytes)
    }

    public var body: Never { fatalError("body should not be called") }
}

extension SVG.AnyView {
    public init<Content: SVG.View>(@SVG.Builder _ closure: () -> Content) {
        self.init(closure())
    }
}
