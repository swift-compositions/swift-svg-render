public import Byte

extension Optional: SVG.View where Wrapped: SVG.View {

    public static func _render<Buffer: RangeReplaceableCollection>(
        _ svg: Self,
        into buffer: inout Buffer,
        context: inout SVG.Context
    ) where Buffer.Element == Byte {
        guard let svg else { return }
        Wrapped._render(svg, into: &buffer, context: &context)
    }

    public var body: Never { fatalError("body should not be called") }
}
