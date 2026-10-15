import Byte
import SVG_Rendering_Test_Support
import Testing

enum SVGElementTests {

    static func render<V: SVG.View>(_ view: V) -> String {
        String(decoding: [Byte](view), as: UTF8.self)
    }

    @Suite struct Test {
        @Suite struct Unit {

            @Test
            func `renders element with tag`() {
                let element = SVG.Element(tag: "circle") { SVG.Empty() }
                let string = render(element)
                #expect(string == "<circle></circle>")
            }

            @Test
            func `renders element with text content`() {
                let element = SVG.Element(tag: "g") { SVG.Text("inner") }
                let string = render(element)
                #expect(string == "<g>inner</g>")
            }

            @Test
            func `renders element with presentation attributes`() {
                let rect = SVG.Element(tag: "rect") { SVG.Empty() }
                let styled = rect.fill("blue").stroke("black")
                let string = render(styled)
                #expect(string.contains("<rect"))
                #expect(string.contains("fill=\"blue\""))
                #expect(string.contains("stroke=\"black\""))
            }
        }

        @Suite struct EdgeCase {

            @Test
            func `attributes escape markup and preserve Unicode bytes`() {
                let element = SVG.Element(tag: "g") { SVG.Empty() }.fill("\"'&<>é🙂")
                let bytes = [Byte](element)
                #expect(
                    bytes.map(\.bitPattern)
                        == Array("<g fill=\"&quot;&apos;&amp;&lt;&gt;é🙂\"></g>".utf8)
                )
            }

            @Test
            func `nested elements render correctly`() {
                let inner = SVG.Element(tag: "circle") { SVG.Empty() }
                let styled = inner.fill("red")
                let outer = SVG.Element(tag: "svg") { styled }
                let string = render(outer)
                #expect(string.contains("<svg>"))
                #expect(string.contains("<circle"))
                #expect(string.contains("</circle>"))
                #expect(string.contains("</svg>"))
            }

            @Test
            func `element with empty content`() {
                let element = SVG.Element(tag: "defs") { SVG.Empty() }
                let string = render(element)
                #expect(string == "<defs></defs>")
            }
        }
    }
}
