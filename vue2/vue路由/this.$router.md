 `main.js` 里写的 `new Vue({ router })`，就是「注入路由器」
 
 Vue 会把这个 `router` 实例挂载到**所有组件的 `this` 上**，所以任何组件里都能通过 `this` 访问路由相关 API

- `this.$router`：只做「动作」（改变路由），比如点击按钮跳转到其他页面、返回上一页，核心是 “操作路由”；


```javascript
// 跳转到/about页面（所有组件里都能这么写）
this.$router.push('/about')
// 返回上一页
this.$router.go(-1)
// 替换当前路径（不留下历史记录）
this.$router.replace('/home')
```