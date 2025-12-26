`$emit` 是 Vue 实例上的一个内置方法
```javascript
this.$emit(eventName, ...args)
```

子组件调用`this.$emit('自定义事件名', 数据)`时，Vue 会在子组件实例的 “事件队列” 中，找到这个自定义事件对应的**父组件绑定的处理函数**