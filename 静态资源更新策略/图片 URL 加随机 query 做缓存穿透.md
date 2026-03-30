`<img :src="`/static/img/page/login/logo.svg?` + Math.random()" height="68px">`


场景：更新了 `public` 里的 SVG，但线上或本地仍看到旧图；或需要每次进登录页都拉最新资源；

做法：用随机 query 让 URL 唯一。