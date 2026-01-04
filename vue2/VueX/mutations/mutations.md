Vuex 中 `mutations` 里的函数 **固定接收两个参数**，且参数顺序不可调换

一、核心参数：state（第一个参数，必传）
`state` 是 mutation 函数的**第一个参数**，指向当前作用域下的 Vuex 状态对象