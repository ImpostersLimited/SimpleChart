# Active Lessons

- Use the dedicated `apply_patch` tool for manual file edits. Do not route patch application through `exec_command`, even if the shell patch succeeds.
- When refactoring wrapper render state, preserve initializer-driven compatibility contracts separately from the internally clamped viewport state; legacy wrappers often promise more than the render helper should enforce.
- When adding stored properties to public `Codable` models, do not rely on synthesis if older payloads may omit the new key; add an explicit compatibility decoder and test it.
