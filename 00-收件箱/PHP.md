


Controller 主要有五类职责：

| 职责             | 常见代码                                       |
| -------------- | ------------------------------------------ |
| 接收 URL 参数和请求数据 | `Request $request`、`string $id`            |
| 校验输入           | `StoreUserRequest $request`                |
| 调用业务能力         | `$userService->createUser(...)`            |
| 调用简单数据查询       | `User::findOrFail($id)`                    |
| 返回 HTTP 响应     | `view()`、`response()->json()`、`redirect()` |

以后你读到 Controller，先固定按这四个问题看：

```
1. 哪条 Route 调用它？
2. 请求参数如何进入方法？
3. 它调用了哪个 Service / Model？
4. 最终返回 View、JSON，还是 Redirect？
```


