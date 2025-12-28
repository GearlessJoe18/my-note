`<router-link to="路径" >f1</router-link>`

路径为在路由注册的path

`<router-link :to="{name:注册名}" >f1</router-link>`

Vue Router找到 `name: 'UserPage'` 的路由，读取 `path

这个:to是v-bind:to  !!!!!!

**Vue 的指令（如 `v-bind`）会把右侧值当作「JavaScript 表达式」解析，而原生属性仅识别字符串**