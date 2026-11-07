extension String: SVG.View {
    public var body: some SVG.View {
        SVG.Text(self)
    }
}
