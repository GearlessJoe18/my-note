 `main.js` 里写的 `new Vue({ router })`，就是「注入路由器」
 
 Vue 会把这个 `router` 实例挂载到**所有组件的 `this` 上**，所以任何组件里都能通过 `this` 访问路由相关 API

