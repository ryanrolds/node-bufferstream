path = require 'path'
{ createReadStream, readFileSync } = require 'fs'
BufferStream = require '../'
{ isBuffer } = Buffer

module.exports =

    defaults: (æ) ->
        buffer = new BufferStream size:'flexible'

        æ.equal buffer.encoding, 'utf8'
        æ.equal buffer.length, 0

        results = ["123", "bufferstream", "a", "bc", "def"]

        # only one result expected
        buffer.on 'data', (data) ->
            æ.equal data.toString(), results.join("")

        buffer.on 'end', ->
            æ.equal buffer.toString(), ""
            buf = buffer.getBuffer()
            æ.equal isBuffer(buf), true
            æ.equal buffer.length, 0
            æ.equal buf.length, 0
            æ.done()

        buffer.write result for result in Array::slice(results)
        buffer.end()


    concat: (æ) ->
        concat = BufferStream.fn.concat

        b1 = new Buffer "a"
        b2 = new Buffer "bc"
        b3 = new Buffer "def"

        æ.equal concat(b1, b2, b3).toString(), b1 + "" + b2 + "" + b3
        æ.equal concat(    b2, b3).toString(),           b2 + "" + b3
        æ.equal concat(        b3).toString(),                "" + b3
        æ.done()


    pipe: (æ) ->
        buffer = new BufferStream size:'flexible', split:'\n'
        buffer.on 'data', (data) -> æ.equal data.toString(), readme.shift()
        buffer.on 'end', ->
            æ.equal buffer.length, 0
            æ.equal buffer.toString(), ""
            æ.deepEqual readme, [ "END" ]
            æ.done()

        filename = path.join(__dirname,"..","..","..","README.md")
        readme = "#{readFileSync(filename)}END".split('\n')
        stream = createReadStream filename

        stream.pipe buffer

