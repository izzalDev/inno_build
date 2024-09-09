## ❌ Pre-commit Hooks Failed

Some pre-commit hooks have failed. Please fix the following issues before committing:

```bash
${{ steps.pre-commit.outputs.pre_commit_output }}
```

Run the following command to fix issues automatically (if available) and reproduce output shown above, run:

```bash
pre-commit run --all-files
```

Ensure that pre-commit is installed and configured in your Git hooks to maintain code consistency. For additional help, please refer to the [CONTRIBUTING.md](https://github.com/izzalDev/inno_build/blob/main/CONTRIBUTE.md) file.
