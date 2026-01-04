用来触发mutation函数，并给它传参

1. `commit` 接收第一个参数（字符串 / 对象的 `type`）
   这是**mutation 函数的名称**；

2. Vuex 找到 store 中定义的、名为 `XXX` 的 mutation 函数并执行它；

3. 若 `commit` 传了第二个参数（payload），
   Vuex 会把这个参数**作为 mutation 函数的第二个参数**传递过去；

4. mutation 函数的第一个参数是固定的（当前作用域的 `state`），由 Vuex 自动传入，无需手动传。