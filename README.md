# Dart CLI Task Manager

A robust Command Line Interface (CLI) application built with Dart, demonstrating Object-Oriented Programming (OOP) principles, generic repositories, inheritance, and automated testing.

## Features
- **Task Management**: Add, list, complete, and delete tasks.
- **Urgent Tasks**: Specialized `UrgentTask` subclass with urgency notes.
- **Persistence**: Automated saving and loading via JSON.
- **Sorting**: Filter tasks by priority (Urgent > High > Medium > Low) or by Due Date.
- **CI/CD**: Automatic test execution via GitHub Actions.

## Requirements
- Dart SDK (>= 3.0.0)

## Getting Started

1. **Install dependencies**:
   ```bash
   dart pub get
   ```

2. **Run the application**:
   ```bash
   # Add a normal task
   dart bin/main.dart add --title "Buy groceries" --priority high --date 2026-07-10

   # Add an urgent task
   dart bin/main.dart add --title "Server down!" --priority urgent --note "Production issue"

   # List tasks
   dart bin/main.dart list

   # List tasks sorted by priority
   dart bin/main.dart list --sort

   # Mark a task as completed
   dart bin/main.dart complete --id 1688800000000

   # Delete a task
   dart bin/main.dart delete --id 1688800000000
   ```

## Running Tests
To execute the unit test suite:
```bash
dart test
```

## Project Structure
- `lib/models/`: Entity and Task classes (Abstract classes, Inheritance).
- `lib/services/`: Generic Repository and TaskManager implementation.
- `lib/exceptions/`: Custom Exception classes.
- `bin/`: CLI entry point with argument parsing.
- `test/`: Unit tests.
- `.github/workflows/`: CI configuration.
