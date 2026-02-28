`const obj = {`
  `name: '张三',`
  `age: 25`
`}`
`console.log(obj.hasOwnProperty('name'))  // true（自身属性）`
`console.log(obj.hasOwnProperty('toString')) // false（原型链上的属性）`

