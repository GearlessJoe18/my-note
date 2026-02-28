`// 基本用法（默认按字符串Unicode顺序）`
`const fruits = ['banana', 'apple', 'orange']`
`fruits.sort()`
`console.log(fruits)  // ['apple', 'banana', 'orange']`

`// 数字排序（需要传比较函数）`
`const numbers = [10, 5, 40, 25, 1000]`
`numbers.sort()`
`console.log(numbers)  // [10, 1000, 25, 40, 5]（错误！按字符串排的）`

`// 正确的数字排序`
`numbers.sort((a, b) => a - b)   // 升序 [5, 10, 25, 40, 1000]`
`numbers.sort((a, b) => b - a)   // 降序 [1000, 40, 25, 10, 5]`