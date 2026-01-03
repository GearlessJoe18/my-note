`import Vue from 'vue'`
`import VueRouter from 'vue-router'`

`// 引入视口组件`
`import AboutView from '../views/AboutView.vue'`

`Vue.use(VueRouter)`

`const routes = [{`
    `path: '/',`
    `component: AboutView,`
`}]`

const routes = [
  {
    path: '/f1',
    name: 'f1',
    props: true,
    component: () => import('../views/AboutView.vue')
  }
]


`const router = new VueRouter({`
    `mode: 'history',`
    `routes`
`})`

`export default router`









路由就是一组映射关系 key-value

key：路径
value：组件/页面

1. “页面路由中可以注册组件” → 更精准：**路由配置（router/index.js）是 “关联路径与页面组件”，而非 “注册组件”**（注册是 `Vue.component`/ 父组件 `components` 选项的行为）；
2. “app 根组件可以直接运用路由标签” → 更精准：**App 根组件通过 `<router-link>`（导航）和 `<router-view>`（渲染）调用路由能力，这两个标签是 vue-router 注册的全局组件**；
3. 核心链路：`components（子组件）→ views（页面组件）→ router（路由配置）→ main.js（挂载路由）→ App根组件（使用路由标签）`。


