import ASCII
public import Byte
import Dictionary_Ordered

extension SVG {

    public struct Element<Content: SVG.View>: SVG.View {

        let tag: String

        @SVG.Builder public let content: Content?

        public init(tag: String, @SVG.Builder content: () -> Content? = { Never?.none }) {
            self.tag = tag
            self.content = content()
        }

        public static func _render<Buffer: RangeReplaceableCollection>(
            _ svg: Self,
            into buffer: inout Buffer,
            context: inout SVG.Context
        ) where Buffer.Element == Byte {

            if !context.currentIndentation.isEmpty {
                buffer.append(contentsOf: context.configuration.newline)
            }
            buffer.append(contentsOf: context.currentIndentation)

            buffer.append(ASCII.Character.Graphic.lessThanSign)
            buffer.append(contentsOf: svg.tag.utf8.lazy.map(Byte.init(bitPattern:)))

            context.attributes.forEach { name, value in
                buffer.append(ASCII.SPACE.sp)
                buffer.append(contentsOf: name.utf8.lazy.map(Byte.init(bitPattern:)))
                if !value.isEmpty {
                    buffer.append(ASCII.Character.Graphic.equalsSign)
                    buffer.append(ASCII.Character.Graphic.quotationMark)

                    for byte in value.utf8.lazy.map(Byte.init(bitPattern:)) {
                        switch byte {
                        case ASCII.Character.Graphic.quotationMark:
                            buffer.append(contentsOf: [Byte].SVG.doubleQuotationMark)

                        case ASCII.Character.Graphic.apostrophe:
                            buffer.append(contentsOf: [Byte].SVG.apostrophe)

                        case ASCII.Character.Graphic.ampersand:
                            buffer.append(contentsOf: [Byte].SVG.ampersand)

                        case ASCII.Character.Graphic.lessThanSign:
                            buffer.append(contentsOf: [Byte].SVG.lessThan)

                        case ASCII.Character.Graphic.greaterThanSign:
                            buffer.append(contentsOf: [Byte].SVG.greaterThan)

                        default:
                            buffer.append(byte)
                        }
                    }

                    buffer.append(ASCII.Character.Graphic.quotationMark)
                }
            }
            buffer.append(ASCII.Character.Graphic.greaterThanSign)

            if let content = svg.content {
                let oldAttributes = context.attributes
                let oldIndentation = context.currentIndentation
                defer {
                    context.attributes = oldAttributes
                    context.currentIndentation = oldIndentation
                }
                context.attributes.removeAll()
                context.currentIndentation += context.configuration.indentation
                Content._render(content, into: &buffer, context: &context)
            }

            buffer.append(contentsOf: context.configuration.newline)
            buffer.append(contentsOf: context.currentIndentation)
            buffer.append(ASCII.Character.Graphic.lessThanSign)
            buffer.append(ASCII.Character.Graphic.slant)
            buffer.append(contentsOf: svg.tag.utf8.lazy.map(Byte.init(bitPattern:)))
            buffer.append(ASCII.Character.Graphic.greaterThanSign)
        }

        public var body: Never {
            fatalError("body should not be called")
        }
    }
}

extension SVG.Element: Sendable where Content: Sendable {}

extension [Byte] {

    public enum SVG {}
}

extension [Byte].SVG {

    public static let doubleQuotationMark: [Byte] = [
        ASCII.Character.Graphic.ampersand, ASCII.Character.Graphic.q, ASCII.Character.Graphic.u,
        ASCII.Character.Graphic.o, ASCII.Character.Graphic.t, ASCII.Character.Graphic.semicolon,
    ]

    public static let apostrophe: [Byte] = [
        ASCII.Character.Graphic.ampersand, ASCII.Character.Graphic.a, ASCII.Character.Graphic.p,
        ASCII.Character.Graphic.o, ASCII.Character.Graphic.s, ASCII.Character.Graphic.semicolon,
    ]

    public static let ampersand: [Byte] = [
        ASCII.Character.Graphic.ampersand, ASCII.Character.Graphic.a, ASCII.Character.Graphic.m,
        ASCII.Character.Graphic.p, ASCII.Character.Graphic.semicolon,
    ]

    public static let lessThan: [Byte] = [
        ASCII.Character.Graphic.ampersand, ASCII.Character.Graphic.l, ASCII.Character.Graphic.t,
        ASCII.Character.Graphic.semicolon,
    ]

    public static let greaterThan: [Byte] = [
        ASCII.Character.Graphic.ampersand, ASCII.Character.Graphic.g, ASCII.Character.Graphic.t,
        ASCII.Character.Graphic.semicolon,
    ]
}
