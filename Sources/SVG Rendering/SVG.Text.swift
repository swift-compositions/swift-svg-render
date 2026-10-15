import ASCII
public import Byte

extension SVG {
    public struct Text: SVG.View {

        let text: String

        public init(_ text: String) {
            self.text = text
        }
    }
}

extension SVG.Text {

    public static func _render<Buffer: RangeReplaceableCollection>(
        _ svg: Self,
        into buffer: inout Buffer,
        context: inout SVG.Context
    ) where Buffer.Element == Byte {
        buffer.reserveCapacity(buffer.count + svg.text.utf8.count)
        for byte in svg.text.utf8.lazy.map(Byte.init(bitPattern:)) {
            switch byte {
            case .ascii.ampersand:
                buffer.append(contentsOf: "&amp;".utf8.lazy.map(Byte.init(bitPattern:)))

            case .ascii.lessThanSign:
                buffer.append(contentsOf: "&lt;".utf8.lazy.map(Byte.init(bitPattern:)))

            case .ascii.greaterThanSign:
                buffer.append(contentsOf: "&gt;".utf8.lazy.map(Byte.init(bitPattern:)))

            case .ascii.dquote:
                buffer.append(contentsOf: "&quot;".utf8.lazy.map(Byte.init(bitPattern:)))

            case .ascii.apostrophe:
                buffer.append(contentsOf: "&apos;".utf8.lazy.map(Byte.init(bitPattern:)))

            default:
                buffer.append(byte)
            }
        }
    }

    public var body: Never { fatalError("body should not be called") }

    public static func + (lhs: Self, rhs: Self) -> Self {
        SVG.Text(lhs.text + rhs.text)
    }
}

extension SVG.Text: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension SVG.Text: ExpressibleByStringInterpolation {}
