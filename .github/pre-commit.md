## ❌ Pre-commit Hooks Failed

Some pre-commit hooks have failed. Please address the following issues before proceeding with your commit:
```bash
check yaml...............................................................Passed
fix end of files.........................................................Failed
- hook id: end-of-file-fixer
- exit code: 1
- files were modified by this hook

Fixing README.md

trim trailing whitespace.................................................Passed
Dart Format..............................................................Passed
Dart Analyze.............................................................Passed
Import Sorter............................................................Passed
Check valid changelog current version....................................Passed
```
Run the following command to fix issues automatically (if available) and reproduce the output shown above, run:

```bash
pre-commit run --all-files
```
Make sure pre-commit is installed and configured in your Git hooks to maintain code consistency. For more information, refer to the [CONTRIBUTING.md](https://github.com/izzalDev/inno_build/blob/main/CONTRIBUTE.md) file.
