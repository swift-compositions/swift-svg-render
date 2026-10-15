import Byte
import SVG_Rendering_Test_Support
import Testing

extension SVG.Text {

    static func render(_ view: some SVG.View) -> String {
        String(decoding: [Byte](view), as: UTF8.self)
    }

    @Suite struct Test {
        @Suite struct Unit {

            @Test
            func `renders plain text`() {
                let string = render(SVG.Text("Hello"))
                #expect(string == "Hello")
            }

            @Test
            func `escapes ampersand`() {
                let string = render(SVG.Text("A&B"))
                #expect(string == "A&amp;B")
            }

            @Test
            func `escapes less than sign`() {
                let string = render(SVG.Text("A<B"))
                #expect(string == "A&lt;B")
            }

            @Test
            func `escapes greater than sign`() {
                let string = render(SVG.Text("A>B"))
                #expect(string == "A&gt;B")
            }

            @Test
            func `escapes quotation mark`() {
                let string = render(SVG.Text("A\"B"))
                #expect(string == "A&quot;B")
            }

            @Test
            func `escapes apostrophe`() {
                let string = render(SVG.Text("A'B"))
                #expect(string == "A&apos;B")
            }

            @Test
            func `concatenation combines text`() {
                let string = render(SVG.Text("Hello") + SVG.Text(" World"))
                #expect(string == "Hello World")
            }

            @Test
            func `string literal initialization`() {
                let text: SVG.Text = "Hello"
                let string = render(text)
                #expect(string == "Hello")
            }
        }

        @Suite struct EdgeCase {

            @Test
            func `empty string renders empty`() {
                let string = render(SVG.Text(""))
                #expect(string.isEmpty)
            }

            @Test
            func `escapes all special characters in sequence`() {
                let string = render(SVG.Text("<script>alert('xss')</script>"))
                #expect(string == "&lt;script&gt;alert(&apos;xss&apos;)&lt;/script&gt;")
            }

            @Test
            func `preserves non-ASCII unicode`() {
                let string = render(SVG.Text("cafe\u{0301}"))
                #expect(string == "cafe\u{0301}")
            }
        }
    }
}
