# HTTP 401 验证知识点

## 1. 401 是什么

`401 Unauthorized` 是 HTTP 状态码，表示客户端当前没有通过身份认证。

它不是 HTTPS 证书错误，而是 HTTP 或应用层认证错误。

简单理解：

```text
证书校验：先确认“我是不是连到了正确的服务器”
401 验证：再确认“你这个用户有没有权限访问”
```

## 2. 401 出现在哪一步

401 出现在 TLS 连接建立完成之后。

完整顺序通常是：

```text
1. 浏览器发起 HTTPS 连接
2. TLS 握手
3. 服务器发送证书
4. 浏览器验证证书
5. 双方协商出加密会话密钥
6. TLS 加密通道建立成功
7. 浏览器在加密通道里发送 HTTP 请求
8. 服务器应用层处理请求
9. 如果没有认证通过，服务器返回 HTTP 401
```

所以证书问题和 401 不是同一层的问题。

证书问题发生在：

```text
HTTPS / TLS 层
```

401 发生在：

```text
HTTP / 应用认证层
```

如果证书校验没通过，浏览器通常会先拦截连接，还没到正常处理 HTTP 401 的阶段。

## 3. 浏览器为什么会弹出用户名和密码输入框

浏览器弹出原生“用户名 / 密码”输入框，不是因为服务器只返回了 401，而是因为服务器返回了 401，并且响应头里带了 `WWW-Authenticate`。

典型响应如下：

```http
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Basic realm="登录"
```

浏览器看到：

```text
401 Unauthorized
WWW-Authenticate: Basic ...
```

就知道服务器要求使用 HTTP Basic Auth，于是自动弹出用户名和密码输入框。

## 4. Basic Auth 的完整流程

HTTP Basic Auth 的典型流程是：

```text
1. 用户访问页面
2. 服务端返回 401
3. 响应头包含 WWW-Authenticate: Basic realm="xxx"
4. 浏览器弹出用户名 / 密码窗口
5. 用户输入用户名和密码
6. 浏览器重新请求
7. 请求头携带 Authorization
8. 服务端校验账号密码
9. 校验通过则返回正常页面，校验失败则继续返回 401
```

第二次请求时，浏览器会带上类似这样的请求头：

```http
Authorization: Basic dXNlcjpwYXNz
```

其中 `dXNlcjpwYXNz` 是：

```text
base64(username:password)
```

例如：

```text
user:pass
```

Base64 后可能变成：

```text
dXNlcjpwYXNz
```

注意：Base64 不是加密，只是编码。因此 Basic Auth 必须配合 HTTPS 使用。

## 5. 为什么只返回 401 不一定弹窗

浏览器是否弹出账密输入框，关键看是否有 `WWW-Authenticate` 响应头。

只返回下面这样，通常不会弹出浏览器原生账密框：

```http
HTTP/1.1 401 Unauthorized
```

需要返回：

```http
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Basic realm="Internal Site"
```

其中 `realm` 是认证区域名称，浏览器可能会把它显示在弹窗里，用于告诉用户当前在登录哪个受保护区域。

## 6. 和普通登录页的区别

HTTP Basic Auth 是浏览器内置认证机制。

普通网页登录页是应用自己写的 HTML 页面。

两者区别如下：

| 项目 | HTTP Basic Auth | 普通登录页 |
| --- | --- | --- |
| 登录框来源 | 浏览器原生弹窗 | 网页 HTML 表单 |
| 触发方式 | 401 + WWW-Authenticate | 返回登录页面 |
| 凭据传递 | Authorization 请求头 | 表单、Cookie、Token 等 |
| 页面可定制性 | 很弱 | 很强 |
| 常见用途 | 内网、临时保护、管理后台 | 正式业务系统 |

## 7. 常见服务器配置示例

Nginx 中可以这样启用 Basic Auth：

```nginx
location / {
    auth_basic "Internal Site";
    auth_basic_user_file /etc/nginx/.htpasswd;
}
```

效果是：未认证用户访问该路径时，Nginx 返回：

```http
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Basic realm="Internal Site"
```

浏览器随后弹出用户名和密码输入框。

## 8. 截图中的现象怎么理解

如果页面地址类似：

```text
https://172.16.110.228:60001
```

浏览器弹出原生用户名和密码框，说明服务端大概率返回了：

```http
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Basic realm="登录"
```

如果地址栏同时显示“不安全”，说明 HTTPS 证书仍然存在问题。

这代表当前同时存在两层现象：

```text
证书问题：浏览器不完全信任这个 HTTPS 连接
401 弹窗：服务器要求 HTTP Basic/Digest 认证
```

两者不是一回事。

证书问题属于 TLS 层。

401 弹窗属于 HTTP 认证层。

## 9. 常见注意点

- 只返回 401，但没有 `WWW-Authenticate`，浏览器不会弹原生账密框。
- 返回登录页 HTML，而不是返回 401，浏览器不会弹原生账密框。
- Bearer Token、Cookie Session、JWT 等认证方式通常不会触发浏览器原生账密框。
- 前端 Ajax 请求收到 401 时，通常由前端代码处理，不一定弹出全局浏览器登录框。
- 用户输入错误时，服务端可以继续返回带 `WWW-Authenticate` 的 401，浏览器会再次要求输入。
- Basic Auth 的用户名密码只是 Base64 编码，必须依赖 HTTPS 保护传输安全。

## 10. 一句话总结

401 是 HTTPS 连接建立成功后，服务器在 HTTP 层返回的认证失败结果。

浏览器原生用户名和密码弹窗的关键条件是：服务器返回 `401 Unauthorized`，并且响应头包含 `WWW-Authenticate: Basic realm="..."`。
