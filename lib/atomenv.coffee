fs = require('fs')

{CompositeDisposable} = require 'atom'

module.exports =
  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add(atom.commands.add 'atom-workspace', 'atomenv:load': => @load())

  deactivate: ->
    @subscriptions.dispose()
    @subscriptions = null

  load: ->
    filepath = atom.project.getPaths()[0] + "/.atomenv.json"

    projectPath = atom.project.getPaths()[0]

    env = process.env
    env["ATOM_PROJECT_PATH"] = projectPath

    if !fs.existsSync(filepath)
      console.log('Not found ' + filepath)
      return

    conf = require(filepath)
    if conf.hasOwnProperty("env")
      for k,v of conf.env
        matches = v.match(/(\$[a-zA-Z0-9\._-]+)/g)
        for i, mv of matches
            envkey = mv.replace(/\$|\{|\}/g, "")

            v = v.replace(mv, env[envkey])

        process.env[k] = v

    console.log('Loaded atomenv')
