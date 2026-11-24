// Remove terminal styling, cursor controls, and OSC strings such as hyperlinks.
function plainText(value) {
    return String(value || "")
        .replace(/(?:\x1b\]|\x9d)[\s\S]*?(?:\x07|\x1b\\|\x9c)/g, "")
        .replace(/(?:\x1b\[|\x9b)[0-?]*[ -/]*[@-~]/g, "")
        .trim()
}
