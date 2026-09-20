

controller
|职责|常见代码|
|---|---|
|接收 URL 参数和请求数据|`Request $request`、`string $id`|
|校验输入|`StoreUserRequest $request`|
|调用业务能力|`$userService->createUser(...)`|
|调用简单数据查询|`User::findOrFail($id)`|
|返回 HTTP 响应|`view()`、`response()->json()`、`redirect()`|
