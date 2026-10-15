import Byte
import Testing

@testable import SVG_Rendering

extension SVG {
    #Tests
}

extension SVG.Test.Performance {

    @Test(.timed(iterations: 1000, warmup: 100))
    func `render short text`() {
        let text = SVG.Text("Hello World")
        let _ = [Byte](text)
    }

    @Test(.timed(iterations: 500, warmup: 50))
    func `render text with escaping`() {
        let text = SVG.Text("<script>alert('xss')</script> & \"more\"")
        let _ = [Byte](text)
    }

    @Test(.timed(iterations: 100, warmup: 10))
    func `render long text`() {
        let content = String(
            repeating: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
            count: 50
        )
        let text = SVG.Text(content)
        let _ = [Byte](text)
    }
}

extension SVG.Test.Performance {

    @Test(.timed(iterations: 500, warmup: 50))
    func `render element with no attributes`() {
        let element = SVG.Element(tag: "circle") { SVG.Empty() }
        let _ = [Byte](element)
    }

    @Test(.timed(iterations: 500, warmup: 50))
    func `render element with attributes`() {
        let element = SVG.Element(tag: "circle") { SVG.Empty() }
        let styled =
            element
            .cx(50.0 as Double)
            .cy(50.0 as Double)
            .r(40.0 as Double)
            .fill("red")
            .stroke("black")
            .strokeWidth(2)
        let _ = [Byte](styled)
    }

    @Test(.timed(iterations: 200, warmup: 20))
    func `render nested elements`() {
        let circle = SVG.Element(tag: "circle") { SVG.Empty() }
        let rect = SVG.Element(tag: "rect") { SVG.Empty() }
        let g = SVG.Element(tag: "g") {
            SVG.Group {
                circle
                rect
            }
        }
        let svg = SVG.Element(tag: "svg") { g }
        let _ = [Byte](svg)
    }
}

extension SVG.Test.Performance {

    @Test(.timed(iterations: 1000, warmup: 100))
    func `context creation default`() {
        let _ = SVG.Context()
    }

    @Test(.timed(iterations: 1000, warmup: 100))
    func `context indentation cycling`() {
        var context = SVG.Context(.pretty)
        for _ in 0..<10 {
            context = context.indented()
        }
        for _ in 0..<10 {
            context = context.outdented()
        }
    }
}

extension SVG.Test.Performance {

    @Test(.timed(iterations: 500, warmup: 50))
    func `chain 5 presentation attributes`() {
        let circle = SVG.Element(tag: "circle") { SVG.Empty() }
        let styled =
            circle
            .fill("red")
            .stroke("black")
            .strokeWidth(2)
            .fillOpacity(0.8)
            .strokeLinecap("round")
        let _ = [Byte](styled)
    }
}

extension SVG.Test.Performance {

    @Test(.timed(iterations: 100, warmup: 10))
    func `group with 10 elements`() {
        let group = SVG.Group {
            for _ in 0..<10 {
                SVG.Element(tag: "circle") { SVG.Empty() }
            }
        }
        let _ = [Byte](group)
    }

    @Test(.timed(iterations: 20, warmup: 5))
    func `group with 100 elements`() {
        let group = SVG.Group {
            for _ in 0..<100 {
                SVG.Element(tag: "rect") { SVG.Empty() }
            }
        }
        let _ = [Byte](group)
    }

    @Test(.timed(iterations: 50, warmup: 5))
    func `String conversion throughput`() {
        let group = SVG.Group {
            for _ in 0..<20 {
                SVG.Element(tag: "circle") { SVG.Empty() }
            }
        }
        let bytes = [Byte](group)
        let _ = String(decoding: bytes, as: UTF8.self)
    }
}

extension SVG.Test.Performance {

    @Test(.timed(iterations: 100, warmup: 10))
    func `pretty print nested document`() {
        let circles = SVG.Group {
            for _ in 0..<10 {
                SVG.Element(tag: "circle") { SVG.Empty() }
            }
        }
        let g = SVG.Element(tag: "g") { circles }
        let svg = SVG.Element(tag: "svg") { g }
        let _ = [Byte](svg, configuration: .pretty)
    }
}
