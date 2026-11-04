# swift-svg-render

Use this package when you write SVG markup from Swift with a result builder and render it to bytes or a string. Start from `SVG.View`: build elements with `SVG.Element`, text with `SVG.Text`, and set attributes with modifiers. Render into any byte collection, or into a string with an optional `SVG.Context.Configuration`. If you want lowercase element builders named after SVG tags and one import for the W3C SVG model, use swift-svg. If you only need the SVG element and value types, use swift-svg-standard.

## Laws

- Output is compact by default, with no newlines or indentation. `SVG.Context.Configuration.pretty` puts each nested element on its own line and indents it by two spaces per level.
- Every element is written with an opening and a closing tag, even when it has no content. Elements are never self-closing.
- Attribute values and `SVG.Text` escape the quotation mark, apostrophe, ampersand and both angle brackets as entities. Every other character, non-ASCII included, is written as UTF-8 unchanged. A `String` renders as `SVG.Text`.
- `SVG.Raw` writes its content verbatim, with no escaping.
- An attribute modifier given nil leaves the attribute out. `SVG.View.attribute(_:_:)` with no value writes the bare attribute name.
- Numeric attribute values are formatted without a trailing fraction, so a width of 2 is written as `2`.
- A modifier applies to the elements it wraps. On a group it applies to each top-level element in the group. It never passes into an element's children.
- `SVG.Empty`, a nil `Optional`, an empty `Array` and an empty group render nothing. Groups add no element of their own.
