fs = require('fs')

AtomenvView = require './atomenv-view'
{CompositeDisposable} = require 'atom'

module.exports = Atomenv =
  atomenvView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'atomenv:reload': => @reload()
    @subscriptions.add(atom.packages.onDidActivateInitialPackages => @start())

  deactivate: ->
    @subscriptions.dispose()
    @subscriptions = null

  serialize: ->
    atomenvViewState: @atomenvView.serialize()

  start: ->
    @reload()

  reload: ->
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
            console.log(envkey + " " + mv)

            v = v.replace(mv, env[envkey])

        process.env[k] = v

    console.log('Loaded atomenv')
