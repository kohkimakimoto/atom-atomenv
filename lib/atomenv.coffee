fs = require 'fs'
CSON = require 'cson'
_ = require 'lodash'

{CompositeDisposable} = require 'atom'

module.exports =
  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add(atom.commands.add 'atom-workspace', 'atomenv:load': => @load())

  deactivate: ->
    @subscriptions.dispose()
    @subscriptions = null

  load: ->
    filepathJSON = atom.project.getPaths()[0] + "/.atomenv.json"
    filepathCSON = atom.project.getPaths()[0] + "/.atomenv.cson"

    projectPath = atom.project.getPaths()[0]
    env = _.clone(process.env)
    env["ATOM_PROJECT_PATH"] = projectPath

    conf = {}
    if fs.existsSync(filepathJSON)
      _.merge(conf, CSON.parseFile(filepathJSON))
    if fs.existsSync(filepathCSON)
      _.merge(conf, CSON.parseFile(filepathCSON))

    # console.log(conf)

    if conf.hasOwnProperty("env")
      for k,v of conf.env
        matches = v.match(/(\$[a-zA-Z0-9\._-]+)/g)
        for i, mv of matches
            envkey = mv.replace(/\$|\{|\}/g, "")

            v = v.replace(mv, env[envkey])

        process.env[k] = v

    console.log('Loaded atomenv')
