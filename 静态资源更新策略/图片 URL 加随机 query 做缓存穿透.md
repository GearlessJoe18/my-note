`<img :src="`/static/img/page/login/logo.svg?` + Math.random()" height="68px">`


场景：更新了 `public` 里的 SVG，但线上或本地仍看到旧图；或需要每次进登录页都拉最新资源；

做法：用随机 query 让 URL 唯一。

 注意：每次渲染若 `Math.random()` 都会变，可能导致同页重复请求同一张图；更稳的做法往往是固定版本号。随机数适合「临时验证」或「接受多请求」的场景。