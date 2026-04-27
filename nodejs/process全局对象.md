process

- 在 Node.js 中，process 代表当前 Node.js 进程



**常用 process 环境变量：**

**基础：**

- `process.env.NODE_ENV` → 运行环境（development/production）
- `process.env.PATH` → 系统路径
- `process.env.HOME` / `USERPROFILE` → 用户目录

**平台信息：**

- `process.platform` → 系统平台（darwin/win32/linux）
- `process.arch` → 架构（x64/arm）
- `process.version` → Node.js 版本

**运行时：**

- `process.cwd()` → 当前工作目录
- `process.argv` → 命令行参数数组
- `process.pid` → 进程ID
- `process.memoryUsage()` → 内存使用情况