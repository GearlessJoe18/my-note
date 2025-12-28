 `main.js` 里写的 `new Vue({ router })`，就是「注入路由器」
 
 Vue 会把这个 `router` 实例挂载到**所有组件的 `this` 上**，所以任何组件里都能通过 `this` 访问路由相关 API


```javascript
// 跳转到/about页面（所有组件里都能这么写）
this.$router.push('/about')
// 返回上一页
this.$router.go(-1)
// 替换当前路径（不留下历史记录）
this.$router.replace('/home')
```