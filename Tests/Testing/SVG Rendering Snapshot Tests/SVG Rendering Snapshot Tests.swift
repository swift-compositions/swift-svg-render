import SVG_Rendering_Test_Support
import SVG_Standard
import Testing
import Tests_Inline_Snapshot

@testable import SVG_Rendering

extension SVG {
    #Tests
}

extension SVG.Test.Snapshot {

    @Test
    func `Text escapes special characters`() {
        snapshot(
            as: .svg,
            {
                SVG.Text("<script>alert('xss')</script>")
            },
            matches: {
                """
                &lt;script&gt;alert(&apos;xss&apos;)&lt;/script&gt;
                """
            }
        )
    }

    @Test
    func `Raw does not escape`() {
        snapshot(
            as: .svg,
            {
                SVG.Raw("<circle cx=\"50\" cy=\"50\" r=\"40\"/>")
            },
            matches: {
                """
                <circle cx="50" cy="50" r="40"/>
                """
            }
        )
    }

    @Test
    func `Group composes elements`() {
        snapshot(
            as: .svg,
            {
                SVG.Group {
                    SVG.Text("Hello")
                    SVG.Text(" ")
                    SVG.Text("World")
                }
            },
            matches: {
                """
                Hello World
                """
            }
        )
    }

    @Test
    func `Circle element renders with attributes`() {
        snapshot(
            as: .svg,
            {
                SVG_Standard.Shapes.Circle(cx: 50, cy: 50, r: 40)()
            },
            matches: {
                """
                <circle r="40" cy="50" cx="50"></circle>
                """
            }
        )
    }

    @Test
    func `Rectangle element renders with attributes`() {
        snapshot(
            as: .svg,
            {
                SVG_Standard.Shapes.Rectangle(x: 10, y: 20, width: 100, height: 50)()
            },
            matches: {
                """
                <rect height="50" width="100" y="20" x="10"></rect>
                """
            }
        )
    }

    @Test
    func `SVG element renders with viewBox`() {
        snapshot(
            as: .svg,
            {
                SVG_Standard.Document.SVG(
                    width: .number(200),
                    height: .number(100),
                    viewBox: SVG_Standard.Types.ViewBox(minX: 0, minY: 0, width: 200, height: 100)
                )()
            },
            matches: {
                """
                <svg viewBox="0 0 200 100" height="100" width="200"></svg>
                """
            }
        )
    }

    @Test
    func `Element with method chaining for presentation attributes`() {
        snapshot(
            as: .svg,
            {
                SVG_Standard.Shapes.Circle(cx: 50, cy: 50, r: 40)()
                    .fill("red")
                    .stroke("black")
                    .strokeWidth(2)
            },
            matches: {
                """
                <circle stroke-width="2" stroke="black" fill="red" r="40" cy="50" cx="50"></circle>
                """
            }
        )
    }

    @Test
    func `Nested elements render correctly`() {
        snapshot(
            as: .svg,
            {
                SVG_Standard.Document.SVG(width: .number(100), height: .number(100)) {
                    SVG_Standard.Shapes.Circle(cx: 50, cy: 50, r: 40)()
                        .fill("blue")
                }
            },
            matches: {
                """
                <svg height="100" width="100"><circle fill="blue" r="40" cy="50" cx="50"></circle></svg>
                """
            }
        )
    }
}

extension SVG.Test.Snapshot {

    @Test
    func `Circle math translation renders via svg`() {
        let circle = W3C_SVG2.Circle(cx: 0, cy: 0, r: 25)
        let translated = circle.translated(by: W3C_SVG2.Vector(dx: 50, dy: 50), using: .cartesian)
        snapshot(
            as: .svg,
            { translated.svg },
            matches: {
                """
                <circle r="25" cy="50" cx="50"></circle>
                """
            }
        )
    }

    @Test
    func `Circle math scaling renders larger radius`() {
        let circle = W3C_SVG2.Circle(cx: 0, cy: 0, r: 10)
        let scaled = circle.scaled(by: 2.0)
        snapshot(
            as: .svg,
            { scaled.svg },
            matches: {
                """
                <circle r="20" cy="0" cx="0"></circle>
                """
            }
        )
    }

    @Test
    func `Circle math scale about point`() {
        let circle = W3C_SVG2.Circle(cx: 10, cy: 0, r: 5)
        let scaled = circle.scaled(by: 2.0, about: W3C_SVG2.Point(x: 0, y: 0))
        snapshot(
            as: .svg,
            { scaled.svg },
            matches: {
                """
                <circle r="10" cy="0" cx="20"></circle>
                """
            }
        )
    }

    @Test
    func `Circle svg translated adds transform attribute`() {
        let circle = W3C_SVG2.Circle(cx: 25, cy: 25, r: 20)
        let view = circle.svg.translated(by: W3C_SVG2.Vector(dx: 50, dy: 50))
        snapshot(
            as: .svg,
            { view },
            matches: {
                """
                <circle transform="translate(50, 50)" r="20" cy="25" cx="25"></circle>
                """
            }
        )
    }

    @Test
    func `Circle svg scaled adds scale transform`() {
        let circle = W3C_SVG2.Circle(cx: 25, cy: 25, r: 10)
        let view = circle.svg.scaled(by: 2.0)
        snapshot(
            as: .svg,
            { view },
            matches: {
                """
                <circle transform="scale(2)" r="10" cy="25" cx="25"></circle>
                """
            }
        )
    }

    @Test
    func `Circle svg rotated adds rotate transform`() {
        let circle = W3C_SVG2.Circle(cx: 50, cy: 0, r: 10)
        let view = circle.svg.rotated(by: W3C_SVG2.Degrees(45))
        snapshot(
            as: .svg,
            { view },
            matches: {
                """
                <circle transform="rotate(45)" r="10" cy="0" cx="50"></circle>
                """
            }
        )
    }

    @Test
    func `Circle svg rotated around center point`() {
        let circle = W3C_SVG2.Circle(cx: 100, cy: 0, r: 10)
        let view = circle.svg.rotated(
            by: W3C_SVG2.Degrees(90),
            around: W3C_SVG2.Point(x: 0, y: 0)
        )
        snapshot(
            as: .svg,
            { view },
            matches: {
                """
                <circle transform="rotate(90, 0, 0)" r="10" cy="0" cx="100"></circle>
                """
            }
        )
    }

    @Test
    func `Math translation then SVG rotation`() {
        let circle = W3C_SVG2.Circle(cx: 0, cy: 0, r: 15)
        let translated = circle.translated(by: W3C_SVG2.Vector(dx: 50, dy: 50), using: .cartesian)
        let view = translated.svg.rotated(by: W3C_SVG2.Degrees(45))
        snapshot(
            as: .svg,
            { view },
            matches: {
                """
                <circle transform="rotate(45)" r="15" cy="50" cx="50"></circle>
                """
            }
        )
    }

    @Test
    func `Math scaling then SVG translation`() {
        let circle = W3C_SVG2.Circle(cx: 0, cy: 0, r: 10)
        let scaled = circle.scaled(by: 3.0)
        let view = scaled.svg.translated(by: W3C_SVG2.Vector(dx: 100, dy: 100))
        snapshot(
            as: .svg,
            { view },
            matches: {
                """
                <circle transform="translate(100, 100)" r="30" cy="0" cx="0"></circle>
                """
            }
        )
    }

    @Test
    func `Chained math operations then SVG context`() {
        let circle = W3C_SVG2.Circle(cx: 0, cy: 0, r: 5)
        let transformed =
            circle
            .scaled(by: 2.0)
            .translated(by: W3C_SVG2.Vector(dx: 25, dy: 25), using: .cartesian)
        let view = transformed.svg.scaled(by: 1.5)
        snapshot(
            as: .svg,
            { view },
            matches: {
                """
                <circle transform="scale(1.5)" r="10" cy="25" cx="25"></circle>
                """
            }
        )
    }

    @Test
    func `Circle with fill after math and SVG transforms`() {
        let circle = W3C_SVG2.Circle(cx: 0, cy: 0, r: 20)
        let translated = circle.translated(by: W3C_SVG2.Vector(dx: 50, dy: 50), using: .cartesian)
        let view = translated.svg
            .rotated(by: W3C_SVG2.Degrees(30))
            .fill("red")
            .stroke("black")
            .strokeWidth(2)
        snapshot(
            as: .svg,
            { view },
            matches: {
                """
                <circle stroke-width="2" stroke="black" fill="red" transform="rotate(30)" r="20" cy="50" cx="50"></circle>
                """
            }
        )
    }

    @Test
    func `Circle area after math scaling`() {
        let circle = W3C_SVG2.Circle(cx: 0, cy: 0, r: 10)
        let scaled = circle.scaled(by: 2.0)
        let originalArea = circle.area
        let scaledArea = scaled.area
        #expect(scaledArea.rawValue / originalArea.rawValue - 4.0 < 0.001)
        snapshot(
            as: .svg,
            { scaled.svg },
            matches: {
                """
                <circle r="20" cy="0" cx="0"></circle>
                """
            }
        )
    }

    @Test
    func `Bounding box after math translation`() {
        let circle = W3C_SVG2.Circle(cx: 0, cy: 0, r: 10)
        let translated = circle.translated(by: W3C_SVG2.Vector(dx: 50, dy: 50), using: .cartesian)
        let bbox = translated.boundingBox
        #expect(bbox.llx.rawValue - 40.0 < 0.001)
        #expect(bbox.lly.rawValue - 40.0 < 0.001)
        #expect(bbox.urx.rawValue - 60.0 < 0.001)
        #expect(bbox.ury.rawValue - 60.0 < 0.001)
        snapshot(
            as: .svg,
            { translated.svg },
            matches: {
                """
                <circle r="10" cy="50" cx="50"></circle>
                """
            }
        )
    }
}

extension SVG.Test.Snapshot {

    @Test
    func `Complete SVG document with multiple shapes`() {
        snapshot(
            as: .svg,
            {
                SVG_Standard.Document.SVG(
                    width: .number(200),
                    height: .number(200),
                    viewBox: SVG_Standard.Types.ViewBox(minX: 0, minY: 0, width: 200, height: 200)
                ) {
                    SVG_Standard.Shapes.Circle(cx: 100, cy: 100, r: 50)()
                        .fill("blue")
                        .stroke("black")
                        .strokeWidth(2)
                    SVG_Standard.Shapes.Rectangle(x: 25, y: 25, width: 50, height: 50)()
                        .fill("red")
                }
            },
            matches: {
                """
                <svg viewBox="0 0 200 200" height="200" width="200"><circle stroke-width="2" stroke="black" fill="blue" r="50" cy="100" cx="100"></circle><rect fill="red" height="50" width="50" y="25" x="25"></rect></svg>
                """
            }
        )
    }

    @Test
    func `SVG with geometry types directly`() {
        let circle = W3C_SVG2.Circle(cx: 50, cy: 50, r: 30)
        let scaledCircle = circle.scaled(by: 1.5)
        snapshot(
            as: .svg,
            {
                SVG_Standard.Document.SVG(
                    width: .number(200),
                    height: .number(200)
                ) {
                    scaledCircle.svg.fill("green")
                }
            },
            matches: {
                """
                <svg height="200" width="200"><circle fill="green" r="45" cy="50" cx="50"></circle></svg>
                """
            }
        )
    }
}
