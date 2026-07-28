const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9";

// 基本用法
token.includes("JWT");        // true
token.includes("Bearer");     // false

// 第二个参数：起始搜索位置（可选）
token.includes("JWT", 10);    // true（从索引10开始搜索）

