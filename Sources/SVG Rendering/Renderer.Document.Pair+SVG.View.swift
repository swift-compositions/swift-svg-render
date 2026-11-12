public import Byte
public import Renderer

extension Renderer.Document.Pair: SVG.View where First: SVG.View, Second: SVG.View {
    public var body: Never { fatalError("body should not be called") }

    public static func _render<Buffer: RangeReplaceableCollection>(
        _ svg: Self,
        into buffer: inout Buffer,
        context: inout SVG.Context
    ) where Buffer.Element == Byte {
        let attributes = context.attributes
        First._render(svg.first, into: &buffer, context: &context)
        context.attributes = attributes
        Second._render(svg.second, into: &buffer, context: &context)
        context.attributes = attributes
    }
}
