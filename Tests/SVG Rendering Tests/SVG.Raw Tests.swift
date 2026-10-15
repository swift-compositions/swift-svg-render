import Byte
import SVG_Rendering_Test_Support
import Testing

extension SVG.Raw {

    static func render(_ view: some SVG.View) -> String {
        String(decoding: [Byte](view), as: UTF8.self)
    }

    @Suite struct Test {
        @Suite struct Unit {

            @Test
            func `renders content verbatim`() {
                let string = render(SVG.Raw("<circle cx=\"50\" cy=\"50\" r=\"40\"/>"))
                #expect(string == "<circle cx=\"50\" cy=\"50\" r=\"40\"/>")
            }

            @Test
            func `does not escape special characters`() {
                let string = render(SVG.Raw("<g><rect/></g>"))
                #expect(string == "<g><rect/></g>")
            }
        }

        @Suite struct EdgeCase {

            @Test
            func `empty raw renders empty`() {
                let string = render(SVG.Raw(""))
                #expect(string.isEmpty)
            }
        }
    }
}
