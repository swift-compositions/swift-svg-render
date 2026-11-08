import Byte

extension StringProtocol {

    public init(
        _ svg: some SVG.View,
        configuration: SVG.Context.Configuration? = nil
    ) {
        let bytes = ContiguousArray<Byte>(svg, configuration: configuration)
        self = Self(decoding: bytes.lazy.map(\.bitPattern), as: UTF8.self)
    }
}

extension StringProtocol {

    @inlinable
    public init<T: SVG.View>(
        _ view: T,
        configuration: SVG.Context.Configuration? = nil
    ) async {
        let bytes = await [Byte](view, configuration: configuration)
        self = Self(decoding: bytes.lazy.map(\.bitPattern), as: UTF8.self)
    }
}
