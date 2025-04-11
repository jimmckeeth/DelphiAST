# README.md

# DelphiParser

DelphiParser is a project designed to parse Delphi unit files and extract useful information such as the Abstract Syntax Tree (AST), comments, and memory usage statistics. This project provides a user-friendly interface for loading Delphi files and viewing the parsed results.

## Project Structure

- **src/units/uMainForm.pas**: Contains the main form of the application, defining the `TMainForm` class for user interactions and file parsing.
- **src/units/uMainForm.dfm**: The form definition file associated with `uMainForm.pas`, detailing the layout of the visual components.
- **src/units/uParserCore.pas**: Implements the decoupled parser class that encapsulates the parsing logic, including properties for the AST as XML, comments, errors, memory usage, and duration.
- **src/units/uParserTypes.pas**: Defines types and constants used throughout the parser, including type definitions for AST nodes.
- **src/interfaces/uParserInterfaces.pas**: Declares interfaces for the parser components, defining contracts for parsing events and results.
- **src/utils/uParserUtils.pas**: Contains utility functions for file handling and string manipulation to assist with parsing tasks.
- **tests/uParserTests.pas**: Includes unit tests for the parser functionality, ensuring the methods and properties of the parser class work as expected.

## Setup Instructions

1. Clone the repository to your local machine.
2. Open the project in your Delphi IDE.
3. Build the project to restore dependencies.
4. Run the application and use the menu to open Delphi unit files for parsing.

## Usage Examples

- Load a Delphi unit file using the "Open" menu option.
- View the parsed AST in XML format in the output display.
- Check the comments and memory usage statistics in the respective components.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.