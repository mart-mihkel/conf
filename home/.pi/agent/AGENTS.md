## Guidelines

- **NEVER** run git commands.
- Ask for permission when you need to ignore linter or typechecker diagnostics.
- Use type casts or assertions if needed instead of loosening a type.
- Always add precise and exhaustive type annotations to everything.
- Use exhaustive types over bare containers. Always us precise generics or designated typing classes instead of bare containers (`NamedTuple` or `TypedDict` instead of `tuple` or `dict`). When runtime validation is needed use pydantic models.
- All significant changes must be tested. Add or update focused tests for semantic changes when existing coverage does not already establish the intended behavior.
- Look to see if your tests could go in an existing file before adding a new file for your tests.
- Get your tests to pass. If you didn't run the tests, your code does not work.
- Follow existing code style. Check neighboring files for patterns.
- Before writing significant amounts of new code, look for existing utilities or mechanisms that could solve the problem. Avoid expanding the task to unrelated issues, but do not confuse keeping the task focused with minimizing the size of the implementation. Prefer addressing the underlying architectural problem over adding a localized workaround, even when doing so requires a substantial refactor or rearchitecture. Ask the user for guidance if in doubt about whether to attempt a larger refactor or not.
- Try hard to avoid patterns that require `getattr` or `setattr`. Instead, try to encode those constraints in the type system. Don't be afraid to write code that's more verbose or requires largeish refactors if it enables you to avoid these unsafe calls.
- Don't use comments to narrate code, but do use them to explain invariants and why something unusual was done a particular way
- Make sure that a comment will make sense to somebody who's reading the code for the first time. Prefer plain language, avoid jargon, and don't be afraid to be more verbose if it's necessary to explain something well.
- Avoid writing walls of rich markdown text when documenting code objects, preferably write just one sentence high level overview with natural language and no markdown syntax. Use a docstring format when documenting arguments.
- Leave some visual space in your code, add newlines at the end of code blocks, indented statements and logical blocks.

## Examples

**Visual space**:

```python
# incorrect
page = [
    ...,
]
if len(page) < page_size:
    return
offset += page_size

# correct
page = [
    ...,
]

if len(page) < page_size:
    return

offset += page_size
```

**Vertical code**:

```python
# incorrect
def do(
    param_1: int, param_2: int, param_3: int
) -> int:
    ...

# correct
def do(
    param_1: int,
    param_2: int,
    param_3: int,
) -> int:
    ...
```

**Exhaustive types**:

```python
# incorrect
def do(things: Mapping[str, Any]) -> None:
    ...

# correct
class Things(TypedDict):
    ...

def do(things: Things) -> None:
    ...
```
