用export default导出时，导出对象的名字是由import决定的

命名导出
在定义变量 / 函数 / 对象时，直接加 `export` 关键字：
```javascript
export const PI = 3.14159;
```

```javascript
function add(a, b) {
  return a + b;
}
const user = { name: '张三', age: 20 };

// 统一导出（必须写定义好的名称）
export { add, user };
```

```javascript
export { PI as CirclePI };
```

导入时用 `{ 名称 }` 包裹，名称必须和导出的完全一致：
```javascript
import { PI, add, user } from './util.js';

// 使用导入的值
console.log(PI); // 3.14159
console.log(add(1, 2)); // 3
console.log(user.name); // 张三
```

