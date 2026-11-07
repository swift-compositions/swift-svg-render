public import Byte

extension Array: SVG_Rendering::SVG.View where Element: SVG_Rendering::SVG.View {
    public var body: Never { fatalError("body should not be called") }

    public static func _render<Buffer: RangeReplaceableCollection>(
        _ svg: Self,
        into buffer: inout Buffer,
        context: inout SVG_Rendering::SVG.Context
    ) where Buffer.Element == Byte {
        for element in svg {
            Element._render(element, into: &buffer, context: &context)
        }
    }
}
