extension SVG {
    public struct Group<Content: SVG.View>: SVG.View {
        let content: Content

        public init(@SVG.Builder _ content: () -> Content) {
            self.content = content()
        }
    }
}

extension SVG.Group {
    public var body: some SVG.View {
        content
    }
}
