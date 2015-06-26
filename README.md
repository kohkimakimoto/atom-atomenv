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
