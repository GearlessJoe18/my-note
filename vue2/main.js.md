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
1. render 配置的箭头函数，会在 Vue 实例初始化时**被 Vue 自动调用**；
2. Vue 调用这个函数时，会主动把内置的 createElement 函数（即 h）作为参数传给它；
3. 函数内部调用 h(App) 生成 App 根组件的**虚拟 DOM**，Vue 再把这个虚拟 DOM 渲染为真实 DOM，最终挂载到 $mount('#app') 指定的 DOM 元素上（而非直接 “创建在挂载元素上”）。
4. 
`createElement` 是 Vue 内置造虚拟 DOM 的函数，Vue 不全局暴露它，而是通过给 `render` 函数传参的方式，让你在箭头函数里调用它生成虚拟 DOM。

箭头函数前后空格隔开，文档最后留空行
