import Byte
import SVG_Rendering_Test_Support
import Testing

enum SVGAttributesTests {

    static func render<V: SVG.View>(_ view: V) -> String {
        String(decoding: [Byte](view), as: UTF8.self)
    }

    @Suite struct Test {
        @Suite struct Unit {

            @Test
            func `fill sets fill attribute`() {
                let circle = SVG.Element(tag: "circle") { SVG.Empty() }
                let styled = circle.fill("red")
                let string = render(styled)
                #expect(string.contains("fill=\"red\""))
            }

            @Test
            func `stroke sets stroke attribute`() {
                let circle = SVG.Element(tag: "circle") { SVG.Empty() }
                let styled = circle.stroke("black")
                let string = render(styled)
                #expect(string.contains("stroke=\"black\""))
            }

            @Test
            func `strokeWidth sets stroke-width attribute`() {
                let circle = SVG.Element(tag: "circle") { SVG.Empty() }
                let styled = circle.strokeWidth(2)
                let string = render(styled)
                #expect(string.contains("stroke-width=\"2\""))
            }

            @Test
            func `chained presentation attributes accumulate`() {
                let circle = SVG.Element(tag: "circle") { SVG.Empty() }
                let styled = circle.fill("red").stroke("black").strokeWidth(2)
                let string = render(styled)
                #expect(string.contains("fill=\"red\""))
                #expect(string.contains("stroke=\"black\""))
                #expect(string.contains("stroke-width=\"2\""))
            }

            @Test
            func `transform attribute is set`() {
                let circle = SVG.Element(tag: "circle") { SVG.Empty() }
                let styled = circle.transform("rotate(45)")
                let string = render(styled)
                #expect(string.contains("transform=\"rotate(45)\""))
            }

            @Test
            func `fill and stroke combined`() {
                let rect = SVG.Element(tag: "rect") { SVG.Empty() }
                let styled = rect.fill("blue").stroke("red", width: 3)
                let string = render(styled)
                #expect(string.contains("fill=\"blue\""))
                #expect(string.contains("stroke=\"red\""))
                #expect(string.contains("stroke-width=\"3\""))
            }

            @Test
            func `font attributes set correctly`() {
                let text = SVG.Element(tag: "text") { SVG.Empty() }
                let styled = text.fontFamily("Arial").fontWeight("bold")
                let string = render(styled)
                #expect(string.contains("font-family=\"Arial\""))
                #expect(string.contains("font-weight=\"bold\""))
            }

            @Test
            func `stroke dash attributes`() {
                let line = SVG.Element(tag: "line") { SVG.Empty() }
                let styled = line.strokeDasharray("5 3").strokeLinecap("round")
                let string = render(styled)
                #expect(string.contains("stroke-dasharray=\"5 3\""))
                #expect(string.contains("stroke-linecap=\"round\""))
            }
        }

        @Suite struct EdgeCase {

            @Test
            func `fill none on element`() {
                let circle = SVG.Element(tag: "circle") { SVG.Empty() }
                let styled = circle.fill("none")
                let string = render(styled)
                #expect(string.contains("fill=\"none\""))
                #expect(string.contains("<circle"))
                #expect(string.contains("</circle>"))
            }
        }
    }
}
