# General Rules

- Use simple imperative solutions instead complex object oriented solutions (functions are better than classes)
- Use early `return` or `continue` instead of deeply nesting if-statements
- If a method or function has more than three levels of indentation, consider refactoring it into smaller parts
- Do not dynamically loop over fields of an object

## Python Project Rules

- Use `uv` for project management (`uv run python`, `uv sync`)
- Read `pyproject.toml` and `Makefile` if they are present
- If the project uses linters, formatters, typecheckers and such, use them to verify your changes (`uv run --no-sync ruff format --check`, `uv run --no-sync ruff check`, `uv run --no-sync ty check`)
- Use `uv add` instead of `uv pip install`
- Use dependencies with fixed specifiers (`torch==2.12.0`, `requires-python = "==3.14.5"`) fallback to compatible if needed (`torch~=2.12.0`)
- **ALWAYS** add type annotations to everything
- **DO NOT** use `Any` or `object` as type hints
- **DO NOT** use `# type: ignore`
- **DO NOT** use `getattr`, `setattr` or other metaprogramming shortcuts that hinder typecheckers
- Use type casting if you know the correct type (`eval_dataset = cast(Dataset, data.get("eval"))`)
- Use exhaustive types, use `NamedTuple` when returning multiple values, write out dictionaries as `TypedDict`
- Add type aliases for magic structures (`type Vec3 = tuple[float, float, float]`)
- Use the `type` keyword for type aliases (`type Backend = Literal["cu130", "cpu"]`)
- Add non-null assertions where you know a variable is not `None`
- Use a logger instead of print statements
- Use `polars` instead of `pandas` and `plotnine` instead of `matplotlib`
