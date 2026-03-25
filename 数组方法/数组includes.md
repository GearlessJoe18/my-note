const allowedRoles = ["admin", "manager", "editor"];

// 判断用户是否有权限
const userRole = "admin";
if (allowedRoles.includes(userRole)) {
    console.log("有权限访问");
}

// 常用于白名单校验
const publicPaths = ["/login", "/register", "/forgot-password"];
if (publicPaths.includes(currentPath)) {
    // 不需要 token 的页面
}