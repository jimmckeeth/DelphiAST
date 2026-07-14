# Cross-Compiler Headless Tests and CI Design

## Objective

Replace the interactive-only test path with an exhaustive headless test suite that
runs the same test logic under Delphi and Free Pascal Compiler (FPC), while
preserving the existing GUI test application. Add GitHub Actions coverage for the
FPC suite and repair the non-rendering code-statistics badges in the README.

## Directory Layout

The current GUI application will move from `Test` to `Test/GUI`. Its project and
form files will be adjusted for their new relative paths but its behavior will
remain unchanged.

The headless suite will live in `Test/UnitTests`. It will contain two thin project
entry points:

- A Delphi project (`DelphiASTTests.dpr` and `DelphiASTTests.dproj`).
- An FPC project (`DelphiASTTests.lpr`).

The project entry points will contain only compiler-specific startup declarations
and calls into the shared runner. All test registration, runner behavior,
assertions, fixtures, include handling, and test cases will be implemented in
common Pascal units compiled unchanged by both projects.

## Test Framework

The suite will use a small dependency-free framework because no established test
framework supplies one identical dependency and console runner for both Delphi
and FPC. FPCUnit and DUnit are only roughly source-compatible and require distinct
runners; DUnitX does not support FPC. Pulling in a much larger cross-compiler
framework solely for its test facilities would add unnecessary project weight.

The shared framework will provide:

- Named test registration and deterministic execution order.
- Per-test isolation and cleanup.
- Equality, truth, nil/non-nil, and expected-exception assertions needed by this
  suite.
- Clear console reporting with passed, failed, and total counts.
- Failure details that identify the test and assertion or unexpected exception.
- Process exit code zero on success and nonzero on any failure.

Compiler conditionals may adapt small RTL differences, but test meaning and
results must remain the same under Delphi and FPC.

## Test Coverage

Every Pascal snippet currently under `Test/Snippets` will remain test data and
will become an automatically enumerated parse-success test. The suite will accept
an optional test-data path and otherwise locate the snippets relative to the
repository or executable, so IDE, command-line, and CI runs behave consistently.
Include-file lookup will be headless and deterministic.

Focused shared tests will expand coverage beyond "parsing did not raise". They
will verify representative AST structure and values for:

- Units, interfaces, implementations, uses clauses, and declarations.
- Procedures, functions, parameters, return types, calling conventions, and
  anonymous methods.
- Classes, interfaces, records, helpers, visibility, properties, generics,
  constraints, attributes, and directives.
- Statements, assignments, calls, control flow, exception handling, and common
  expression/operator forms.
- Numeric and string literals, Unicode input, comments, conditional directives,
  include files, and source positions.
- Recently repaired parser cases represented by the existing regression snippets.
- Invalid or incomplete syntax where a specific parser failure is expected.
- Writer output and serialization round trips where the public APIs support stable
  assertions.

Tests will assert semantic AST facts rather than entire unstable object dumps
unless an output format is explicitly intended to be stable. Temporary objects
and files will be cleaned up even after failures. Optional compiler-specific leak
diagnostics may supplement the run but must not alter shared test semantics.

## GitHub Actions

A workflow under `.github/workflows` will run on pushes and pull requests. On an
Ubuntu runner it will:

1. Check out the repository.
2. Install a supported stable FPC toolchain.
3. Compile the FPC headless project with warnings visible and explicit source-unit
   paths.
4. Execute the compiled suite against the repository's test data.

Compilation errors, missing test data, failed assertions, and unexpected
exceptions will fail the job. Generated compiler artifacts will be directed to a
build directory or otherwise kept out of source directories.

## README and Tokei Badges

The README will document how to build and run each headless project with FPC and
Delphi. It will describe the GUI application as an optional interactive parser
exercise rather than the automated suite.

The three broken `tokei.rs` badges were intended to report:

- `lines`: total physical lines in counted source files.
- `code`: code lines after excluding comments and blank lines.
- `files`: the number of counted source files.

They will be changed to the corresponding endpoints of an operating Tokei badge
service while retaining those meanings and links back to repository statistics.

## Verification and Acceptance

The implementation is accepted when:

- The GUI project builds from `Test/GUI` with its paths corrected.
- The Delphi and FPC console projects contain distinct entry points but compile
  the same shared framework and tests.
- The FPC executable runs every existing snippet plus the focused tests and exits
  successfully locally.
- A deliberately failing test is confirmed to produce useful output and a nonzero
  exit code, then removed.
- The workflow syntax is valid and mirrors the successful local FPC commands.
- README badge image endpoints return SVG images representing lines, code, and
  files.
- No unrelated user files or working-tree changes are modified.
