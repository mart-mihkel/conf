# Development Rules

- Write simple imperative code instead of object oriented solutions.
- Composition over inheritance.
- Use early `return` or `continue` instead of deeply nesting if-statements.
- If a method or function has more than three levels of indentation, consider refactoring it into smaller parts.
- Do not dynamically loop over fields of an object.
- Inline single-line helpers that have only one call site.
- If the user has modified the code after your changes, do not change it back.

## Python Rules

- Use `uv` for project management (`uv run python`, `uv sync`).
- Read `pyproject.toml` and `Makefile` if they are present.
- If the project uses linters, formatters, typecheckers and other tools, use them to verify your changes (`uv run --no-sync ruff format --check`, `uv run --no-sync ruff check`, `uv run --no-sync ty check`).
- Use `uv add` instead of `uv pip install`.
- Always add type annotations to every function.
- Do not use `Any` or `object` as type annotations unless absolutely necessary.
- Do not ignore type or linter erros (`# type: ignore`, `# ty: ignore`, `# noqa`) unless explicitly told to.
- Do not use `getattr`, `setattr` or other metaprogramming shortcuts that hinder typecheckers.
- Use type casting if you know the correct type (`eval_dataset = cast(Dataset, data.get("eval"))`).
- Use exhaustive types, use `NamedTuple` when returning multiple values, write out dictionaries as `TypedDict`.
- Add type aliases for magic structures (`type Vec3 = tuple[float, float, float]`).
- Use the `type` keyword for type aliases (`type Backend = Literal["cu130", "cpu"]`).
- Add non-null assertions where you know a variable is not `None`.

## Typescript Rules

- No `any` unless absolutely necessary.
- No inline imports (`await import()`, `import("pkg").Type`, dynamic type imports).
- Top-level imports only.
- Check node_modules for external API types; don't guess.
- Use only erasable TypeScript syntax (Node strip-only mode); no parameter properties, `enum`, `namespace`/`module`, `import =`, `export =`, or other constructs needing JS emit.
- Use explicit fields with constructor assignments.
