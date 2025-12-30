首先要在注册路由时的path里面占位

[{
path:/:id
}]

:表示占位
id是名字

可以被`this.$route.params.id`来访问到

可以运用  `params:{id:300}`  来
**传递 params 动态路径参数**：将 `id: 300` 作为路径参数，注入到路由配置中定义的 `/:id` 占位符位置