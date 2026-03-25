const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9";

// 基本用法
token.includes("JWT");        // true
token.includes("Bearer");     // false

// 第二个参数：起始搜索位置（可选）
token.includes("JWT", 10);    // true（从索引10开始搜索）

// 常用于判断 token 类型
if (accessToken.includes("Bearer")) {
    // 已经带了 Bearer 前缀
} else {
    // 需要添加前缀
    const headerValue = `Bearer ${accessToken}`;
}