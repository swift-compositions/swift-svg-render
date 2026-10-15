import Byte
import SVG_Rendering_Test_Support
import Testing

enum SVGViewTests {

    static func render(_ view: some SVG.View) -> String {
        String(decoding: [Byte](view), as: UTF8.self)
    }

    @Suite struct Test {
        @Suite struct Unit {

            @Test
            func `Optional none renders empty`() {
                let view: SVG.Text? = nil
                let bytes = [Byte](view)
                #expect(bytes.isEmpty)
            }

            @Test
            func `Optional some renders content`() {
                let view: SVG.Text? = SVG.Text("Present")
                let string = render(view)
                #expect(string == "Present")
            }

            @Test
            func `Array of views renders all`() {
                let views: [SVG.Text] = [SVG.Text("A"), SVG.Text("B"), SVG.Text("C")]
                let string = render(views)
                #expect(string == "ABC")
            }

            @Test
            func `custom view delegates to body`() {
                struct TwoTexts: SVG.View {
                    var body: some SVG.View {
                        SVG.Group {
                            SVG.Text("One")
                            SVG.Text("Two")
                        }
                    }
                }

                let string = render(TwoTexts())
                #expect(string == "OneTwo")
            }
        }

        @Suite struct EdgeCase {

            @Test
            func `empty array renders nothing`() {
                let views: [SVG.Text] = []
                let bytes = [Byte](views)
                #expect(bytes.isEmpty)
            }

            @Test
            func `deeply nested groups flatten`() {
                let view = SVG.Group {
                    SVG.Group {
                        SVG.Group {
                            SVG.Text("Deep")
                        }
                    }
                }
                let string = render(view)
                #expect(string == "Deep")
            }
        }
    }
}
