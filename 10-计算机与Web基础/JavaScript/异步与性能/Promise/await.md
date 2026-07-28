await表达式
`await` 操作符用于等待一个 [`Promise`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Promise) 兑现并获取它兑现之后的值。它只能在[异步函数](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Statements/async_function)或者[模块](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Guide/Modules)顶层中使用。

1、右边是promise对象，则返回出promise fulfilled 的result

2、不是promise类型 JavaScript 会自动把这个值「包装成一个已成功（resolved）的 Promise」，然后立即返回这个值


3、右边是rejected状态的promise会报错（抛出异常），所以要用try{}catch（err）{}捕获