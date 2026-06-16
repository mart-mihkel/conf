# Global Agents Config

- Prefer simple imperative solutions to complex object oriented solutions

## Python Project Rules

- Use `uv` for project management (`uv run python`, `uv sync`)
- Read `pyproject.toml` and `Makefile` if they are present
- If the project uses linters, formatters, typecheckers and such, use them to verify your changes (`uv run --no-sync ruff format --check`, `uv run --no-sync ruff check`, `uv run --no-sync ty check`)
- Prefer dependencies with fixed specifiers (`torch==2.12.0`, `requires-python = "==3.14.5"`)
- Prefer `uv add` to `uv pip install`
- **Always** add type annotations to **everything**
- Use type casting if you know the correct type (`eval_dataset = cast(Dataset, data.get("eval"))`)
- Add non-null assertions where you know a variable is not `None`
- Use exhaustive types, write out dictionaries as `TypedDict` when possible
- Add type aliases for magic structures (`type Vec3 = tuple[float, float, float]`)
- Prefer:
  - `ty` to `mypy`
  - `polars` to `pandas`
  - `marimo` to `jupyter`
  - `plotnine` to `matplotlib`
