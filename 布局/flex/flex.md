- 容器（父元素）：`display: flex`
- 项目（子元素）：容器内的直接子元素




- `justify-content`：属性定义了项目在主轴上的对齐方式。

flex-start | flex-end | center | space-between | space-around;

- `align-items`：属性定义项目在交叉轴上如何对齐

- `flex-wrap`：是否换行（wrap 解决溢出）

`.box{`
  `flex-wrap: nowrap | wrap | wrap-reverse;`
`}`






- `flex: 1`：占满剩余空间（均分列 / 行神器）
- `align-self`：单独调整某项目的交叉轴对齐