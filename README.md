# Nekomancy

Starts a neko module and reloads it when the module changes. Useful for testing and reloading servers or other tools. If the process is still running when the neko module is updated the old process will be killed.

## Usage

```bash
nekomancy [-v] module.n
```

The `-v` tag will output more information about the process start/restart including anything in stdout.
