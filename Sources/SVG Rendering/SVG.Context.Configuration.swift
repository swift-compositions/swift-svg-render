public import Buffer
public import Buffer_Linear_Primitive
public import Byte
public import Dictionary
public import Dictionary_Ordered
public import Hash_Indexed_Primitive
public import Hash_Table_Primitive
public import Memory
public import Memory_Allocator
public import Ownership_Shared_Primitive
import Renderer
public import Storage

extension SVG.Context {
    public struct Configuration: Sendable {
        public var indentation: [Byte]
        public var newline: [Byte]

        public init(indentation: String = "", newline: String = "") {
            self.indentation = [Byte](utf8: indentation)
            self.newline = [Byte](utf8: newline)
        }
    }
}
