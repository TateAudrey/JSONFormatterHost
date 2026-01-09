Here’s a clean, developer-friendly README you can use for this Xcode Source Editor extension.

---

# JSON Formatter Xcode Extension

An Xcode Source Editor extension that formats selected JSON directly inside the editor. It converts raw or minified JSON into a readable, pretty-printed format with consistent indentation and sorted keys.

## Features

* Pretty-prints selected JSON
* Sorts JSON keys alphabetically
* Works on any selected block of text
* Safely replaces only the selected lines
* Leaves the selection unchanged if the JSON is invalid

## How It Works

1. Select one or more lines of JSON in the Xcode editor.
2. Run the extension from the **Editor → Extensions** menu (or via a keyboard shortcut if configured).
3. The extension:

   * Reads the selected lines
   * Parses them as JSON
   * Outputs a formatted version using `JSONSerialization`
   * Replaces the original text with the formatted JSON

If parsing fails, no changes are made.

## Example

### Before

```json
{"name":"Audrey","skills":["Swift","iOS"],"active":true}
```

### After

```json
{
  "active" : true,
  "name" : "Audrey",
  "skills" : [
    "Swift",
    "iOS"
  ]
}
```

## Implementation Details

* Built using `XcodeKit`
* Implements `XCSourceEditorCommand`
* Uses:

  * `JSONSerialization.jsonObject(with:)`
  * `JSONSerialization.data(withJSONObject:options:)`
* Formatting options:

  * `.prettyPrinted`
  * `.sortedKeys`

## Limitations

* Only formats valid JSON
* Does not validate or fix malformed JSON
* Formatting style is determined by Apple’s `JSONSerialization`

## Requirements

* macOS with Xcode
* Xcode Source Editor Extensions enabled

## License

MIT License

* Customize the README for public GitHub release
* Add badges or screenshots
