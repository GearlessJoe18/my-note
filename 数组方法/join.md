`// 基本用法`
`const arr = ['apple', 'banana', 'orange']`
`console.log(arr.join())       // 'apple,banana,orange'（默认逗号）`
`console.log(arr.join(''))     // 'applebananaorange'（无间隔）`
`console.log(arr.join(' - '))  // 'apple - banana - orange'`
`console.log(arr.join('+'))    // 'apple+banana+orange'`

`// 常用场景：URL参数拼接`
`const params = ['name=张三', 'age=25', 'city=北京']`
`console.log(params.join('&'))  // 'name=张三&age=25&city=北京'`