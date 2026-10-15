import Byte
import SVG_Rendering_Test_Support
import Testing

extension SVG.AnyView {

    static func render<V: SVG.View>(_ view: V) -> String {
        String(decoding: [Byte](view), as: UTF8.self)
    }

    @Suite struct Test {
        @Suite struct Unit {

            @Test
            func `type erases text view`() {
                let string = render(SVG.AnyView(SVG.Text("Hello")))
                #expect(string == "Hello")
            }

            @Test
            func `type erases element view`() {
                let circle = SVG.Element(tag: "circle") { SVG.Empty() }
                let styled = circle.fill("blue").stroke("black")
                let string = render(SVG.AnyView(styled))
                #expect(string.contains("<circle"))
                #expect(string.contains("fill=\"blue\""))
            }

            @Test
            func `closure initializer works`() {
                let string = render(
                    SVG.AnyView {
                        SVG.Text("From closure")
                    }
                )
                #expect(string == "From closure")
            }
        }
    }
}
