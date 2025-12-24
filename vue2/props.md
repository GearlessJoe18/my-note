父组件中
`<div id='app'>`
	`<child  name='msg' ></child>`
`</div>`

`new Vue({`
	`el:{`
	`#app`
	`}`
	`data:{`
		`msg='xxx'`
	`}`
`})`

子组件中
```vue
<script>
export default {
  // 数组里写要接收的props名称（字符串）
  props: ['name', 'age', 'isShow']
}
</script>
```

父组件中子组件的html标签中传入props名=什么值

