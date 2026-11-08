public import Byte
public import Dictionary_Ordered
import Renderer
public import Buffer
public import Buffer_Linear_Primitive
public import Dictionary
public import Hash_Indexed_Primitive
public import Hash_Table_Primitive
public import Memory
public import Memory_Allocator
public import Ownership_Shared_Primitive
public import Storage

extension SVG {
    public struct Context: Sendable {

        public var attributes: Attributes

        public let configuration: SVG.Context.Configuration

        public var currentIndentation: [Byte]
    }
}

extension SVG.Context {
    public init(_ configuration: Configuration = .default) {
        self.attributes = .init()
        self.configuration = configuration
        self.currentIndentation = []
    }
}

extension SVG.Context {
}

extension SVG.Context.Configuration {
    public static let `default` = Self()
    public static let pretty = Self(indentation: "  ", newline: "\n")
}

extension SVG.Context {
    @inlinable
    public func appendNewline<Buffer: RangeReplaceableCollection>(
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        if !configuration.newline.isEmpty {
            buffer.append(contentsOf: configuration.newline)
        }
    }

    @inlinable
    public func indented() -> SVG.Context {
        var copy = self
        copy.currentIndentation.append(contentsOf: configuration.indentation)
        return copy
    }

    @inlinable
    public func outdented() -> SVG.Context {
        var copy = self
        if copy.currentIndentation.count >= configuration.indentation.count {
            copy.currentIndentation.removeLast(configuration.indentation.count)
        }
        return copy
    }

    @inlinable
    public func appendIndentation<Buffer: RangeReplaceableCollection>(
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        if !configuration.indentation.isEmpty && !currentIndentation.isEmpty {
            buffer.append(contentsOf: currentIndentation)
        }
    }
}

extension SVG.Context {

    public typealias Attributes = __DictionaryOrdered<
        Ownership.Shared<
            Hash.Entry<String, String>,
            Hash.Indexed<Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<String, String>>>.Linear>
        >
    >
}
