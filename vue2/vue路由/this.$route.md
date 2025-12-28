



```javascript
console.log(this.$route.path) // ✅ /f2（当前路径）
console.log(this.$route.params.id) // ✅ 123（动态参数）
console.log(this.$route.query.name) // ✅ 张三（查询参数）
this.$route.push('/f1') // ❌ 报错（无该方法）
```