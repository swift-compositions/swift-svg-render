import Byte
import SVG_Rendering_Test_Support
import Testing

extension SVG.Empty {
    @Suite struct Test {
        @Suite struct Unit {

            @Test
            func `renders to empty bytes`() {
                let empty = SVG.Empty()
                let bytes = [Byte](empty)
                #expect(bytes.isEmpty)
            }

            @Test
            func `String representation is empty`() {
                let empty = SVG.Empty()
                let string = String(decoding: [Byte](empty), as: UTF8.self)
                #expect(string.isEmpty)
            }
        }

        @Suite struct EdgeCase {

            @Test
            func `multiple empties compose to empty`() {
                let group = SVG.Group {
                    SVG.Empty()
                    SVG.Empty()
                    SVG.Empty()
                }
                let bytes = [Byte](group)
                #expect(bytes.isEmpty)
            }
        }
    }
}
