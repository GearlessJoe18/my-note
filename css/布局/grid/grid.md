**核心**：二维布局（同时控制行 + 列）

- 容器（父元素）：`display: grid`
- 网格线 / 网格单元格：行列分割出的最小单元

- `grid-template-columns`：列宽（`1fr 2fr`/`repeat(3, 100px)`）
- `grid-template-rows`：行高（同上）
- `gap`：行列间距（`gap: 10px` 等价 `row-gap + column-gap`）
- `place-items`：单元格内对齐（center 一键居中）
#### 核心属性（项目）
- `grid-column`：跨列（`1 / 3` 占第 1-2 列）
- `grid-row`：跨行（同上）