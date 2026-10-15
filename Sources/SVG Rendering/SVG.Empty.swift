public import Byte

extension SVG {
    public struct Empty: SVG.View {

        public init() {}
    }
}

extension SVG.Empty {

    public static func _render<Buffer: RangeReplaceableCollection>(
        _ svg: Self,
        into buffer: inout Buffer,
        context: inout SVG.Context
    ) where Buffer.Element == Byte {

    }

    public var body: Never { fatalError("body should not be called") }
}
