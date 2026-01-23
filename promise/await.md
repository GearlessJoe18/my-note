await表达式
1、右边是promise对象，则返回出promise fulfilled 的result

2、不是promise类型 JavaScript 会自动把这个值「包装成一个已成功（resolved）的 Promise」，然后立即返回这个值


3、右边是rejected状态的promise会报错（抛出异常），所以要用try{}catch（err）{}捕获