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

            buffer.append(Byte(bitPattern: ASCII.Character.Graphic.lessThanSign))
            buffer.append(contentsOf: svg.tag.utf8.lazy.map(Byte.init(bitPattern:)))

            context.attributes.forEach { name, value in
                buffer.append(Byte(bitPattern: ASCII.SPACE.sp))
                buffer.append(contentsOf: name.utf8.lazy.map(Byte.init(bitPattern:)))
                if !value.isEmpty {
                    buffer.append(Byte(bitPattern: ASCII.Character.Graphic.equalsSign))
                    buffer.append(Byte(bitPattern: ASCII.Character.Graphic.quotationMark))

                    for byte in value.utf8.lazy.map(Byte.init(bitPattern:)) {
                        switch byte {
                        case Byte(bitPattern: ASCII.Character.Graphic.quotationMark):
                            buffer.append(contentsOf: [Byte].SVG.doubleQuotationMark)

                        case Byte(bitPattern: ASCII.Character.Graphic.apostrophe):
                            buffer.append(contentsOf: [Byte].SVG.apostrophe)

                        case Byte(bitPattern: ASCII.Character.Graphic.ampersand):
                            buffer.append(contentsOf: [Byte].SVG.ampersand)

                        case Byte(bitPattern: ASCII.Character.Graphic.lessThanSign):
                            buffer.append(contentsOf: [Byte].SVG.lessThan)

                        case Byte(bitPattern: ASCII.Character.Graphic.greaterThanSign):
                            buffer.append(contentsOf: [Byte].SVG.greaterThan)

                        default:
                            buffer.append(byte)
                        }
                    }

                    buffer.append(Byte(bitPattern: ASCII.Character.Graphic.quotationMark))
                }
            }
            buffer.append(Byte(bitPattern: ASCII.Character.Graphic.greaterThanSign))

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
            buffer.append(Byte(bitPattern: ASCII.Character.Graphic.lessThanSign))
            buffer.append(Byte(bitPattern: ASCII.Character.Graphic.slant))
            buffer.append(contentsOf: svg.tag.utf8.lazy.map(Byte.init(bitPattern:)))
            buffer.append(Byte(bitPattern: ASCII.Character.Graphic.greaterThanSign))
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
        Byte(bitPattern: ASCII.Character.Graphic.ampersand),
        Byte(bitPattern: ASCII.Character.Graphic.q),
        Byte(bitPattern: ASCII.Character.Graphic.u),
        Byte(bitPattern: ASCII.Character.Graphic.o),
        Byte(bitPattern: ASCII.Character.Graphic.t),
        Byte(bitPattern: ASCII.Character.Graphic.semicolon),
    ]

    public static let apostrophe: [Byte] = [
        Byte(bitPattern: ASCII.Character.Graphic.ampersand),
        Byte(bitPattern: ASCII.Character.Graphic.a),
        Byte(bitPattern: ASCII.Character.Graphic.p),
        Byte(bitPattern: ASCII.Character.Graphic.o),
        Byte(bitPattern: ASCII.Character.Graphic.s),
        Byte(bitPattern: ASCII.Character.Graphic.semicolon),
    ]

    public static let ampersand: [Byte] = [
        Byte(bitPattern: ASCII.Character.Graphic.ampersand),
        Byte(bitPattern: ASCII.Character.Graphic.a),
        Byte(bitPattern: ASCII.Character.Graphic.m),
        Byte(bitPattern: ASCII.Character.Graphic.p),
        Byte(bitPattern: ASCII.Character.Graphic.semicolon),
    ]

    public static let lessThan: [Byte] = [
        Byte(bitPattern: ASCII.Character.Graphic.ampersand),
        Byte(bitPattern: ASCII.Character.Graphic.l),
        Byte(bitPattern: ASCII.Character.Graphic.t),
        Byte(bitPattern: ASCII.Character.Graphic.semicolon),
    ]

    public static let greaterThan: [Byte] = [
        Byte(bitPattern: ASCII.Character.Graphic.ampersand),
        Byte(bitPattern: ASCII.Character.Graphic.g),
        Byte(bitPattern: ASCII.Character.Graphic.t),
        Byte(bitPattern: ASCII.Character.Graphic.semicolon),
    ]
}
