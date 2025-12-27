`import Vue from 'vue'`
`import App from './App.vue'`
`import router from './router'`
`import store from './store'`

`Vue.config.productionTip = false`

`new Vue({`
  `router,`
  `store,`
  `render: h => h(App)`

`}).$mount('#app')`

  render: h => h(App)
1. `render` 配置的箭头函数，会在 Vue 实例初始化时**被 Vue 自动调用**；
2. Vue 调用这个函数时，会主动把内置的 `createElement` 函数（即 `h`）作为参数传给它；
3. 函数内部调用 `h(App)` 生成 App 根组件的**虚拟 DOM**，Vue 再把这个虚拟 DOM 渲染为真实 DOM，最终挂载到 `$mount('#app')` 指定的 DOM 元素上（而非直接 “创建在挂载元素上”）。
