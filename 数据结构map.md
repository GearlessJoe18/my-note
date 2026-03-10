`const map =new Map();`
`map.set('name', '张三')`
`map.set({id: 1}, '对象作为键')`
`// 常用方法`
`map.get('name')      // 获取 → '张三'`
`map.has('name')      // 检查 → true`
`map.delete('name')   // 删除`
`map.size             // 大小`
`map.clear()          // 清空`
`// 遍历`
`map.forEach((value, key) => {})`
`for (const [key, value] of map) {}`