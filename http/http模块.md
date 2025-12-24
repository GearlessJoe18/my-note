`const http = require('http')`

`const server = http.createServer((req,res)=>{`
    `res.end('hello world')`
`})`
 `//回调在服务器接受到http请求时执行`
 
`server.listen(3000,()=>{`
    `console.log('启动成功');`
`})`
`//回调在服务器启动成功时执行`