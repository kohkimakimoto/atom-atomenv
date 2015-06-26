# atomenv package

Loads environment variables from .atomenv.json

## Usage

You should create `.atomenv.json` in the directory that is an atom project.

```json
{
    "env": {
        "GOPATH": "$ATOM_PROJECT_PATH/_vendor:$HOME",
        "FOO": "foooobaaaaa"
    }
}
```

Runs `atomenv:load` command.

Note: `$ATOM_PROJECT_PATH` is applied automatically by this package. And you can refer to other environment variables by usign `$` prefix. ex) `$HOME`.

## Automatically loading

If you want to load when window opens, You can use atom [auto-run](https://atom.io/packages/auto-run) packages with this.

## License

MIT License.
