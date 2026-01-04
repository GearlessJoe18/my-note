当 `mapState` 传**字符串数组**时，它会生成一个对象：

- 对象的**属性名** = 数组中的 state 属性名（如 `itemNum`）；
- 对象的**属性值** = 一个函数（该函数返回 `this.$store.state.对应属性名`，即自动帮你写好访问 state 的计算属性函数）。





`mapState` **必须放在计算属性（`computed`）中**

1. **响应式匹配**：Vuex 的 `state` 是响应式数据，而 `computed` 是 Vue 中专门处理「响应式派生值」的选项 —— 把 `mapState` 映射的结果放在 `computed` 中，才能保证：
    - 当 Vuex 的 `state` 变化时，组件中映射后的属性会**自动更新**；
    - 具备计算属性的「缓存特性」，避免重复访问 `$store.state.xxx` 导致的性能损耗。
2. **用法逻辑匹配**：`mapState` 的本质是「把 Vuex 的全局 state 映射为组件的 “本地属性”」，而 `computed` 正是组件用来定义 “本地派生属性” 的地方（而非 `methods`，`methods` 是执行动作的）。


`mapState` 会返回一个**对象**（键是组件内的属性名，值是对应 Vuex state 的取值函数），因此需要把这个对象合并到 `computed` 中，有 2 种常见写法：