首先要在注册路由时的path里面占位

[{
path:/:id
}]

:表示占位
id是名字

可以被this.$route.
你可以运用params:{id:300}来定义