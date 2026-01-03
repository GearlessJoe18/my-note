import Vue from 'vue'
import App from '../App'
import VueRouter from 'vue-router'
  
Vue.use(VueRouter)

const routes = [{

    path: '/',

    component: App,

    children: [{

        path: '',

        component: r => require.ensure([], () => r(require('../page/home')), 'home')

    }, {

        path: '/item',

        component: r => require.ensure([], () => r(require('../page/item')), 'item')

    }, {

        path: '/score',

        component: r => require.ensure([], () => r(require('../page/score')), 'score')

    }]

}]

  

const router = new VueRouter({

    mode: 'history',

    routes

})

export default router