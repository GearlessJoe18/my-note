await表达式
1、右边是promise对象，则返回出promise fulfilled 的result
2、不是promise类型就直接返回
3、右边是rejected状态的peomise会报错，所以要用try{}catch（err）{}捕获