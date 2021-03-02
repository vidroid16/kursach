import Vue from 'vue'
import App from './App.vue'
import VueResource from "vue-resource"
import VueRouter from "vue-router";
import axios from "axios"
import Vuex from "vuex"
import vuetify from './plugins/vuetify.js';
import 'vuetify/dist/vuetify'
import Meta from "vue-meta";
import Bets from './components/Bets.vue';
import Auth from './components/Auth.vue';
import Profile from './components/Profile.vue';

//import Lagrange from './components/Lagrange.vue';


Vue.use(Meta);
Vue.use(VueResource);
Vue.use(axios);
Vue.use(Vuex);
Vue.use(VueRouter);
Vue.use(vuetify);
const instance = axios.create({baseURL: 'http://localhost:8080/'})

const store = new Vuex.Store({
  actions: {

  },
  state: {
    url:'http://localhost:8080/',
    hh:[],
    mathes: [
      {
          id:32324,
          firstTeam:"NAVI",
          firstLogo:"https://upload.wikimedia.org/wikipedia/ru/2/2c/NAVI_logo.png",
          firstCoef:"1.32",
          tournament:"ESL One London",
          secTeam:"OG",
          secLogo:"https://upload.wikimedia.org/wikipedia/ru/0/02/OGBlueLogo.png",
          secCoef:"3.32",
          betFirst:true,
          betResul:21    },
      {
        id:32325,
        firstTeam:"NAVI",
        firstLogo:"https://upload.wikimedia.org/wikipedia/ru/2/2c/NAVI_logo.png",
        firstCoef:"1.32",
        tournament:"ESL One London",
        secTeam:"OG",
        secLogo:"https://upload.wikimedia.org/wikipedia/ru/0/02/OGBlueLogo.png",
        secCoef:"3.32"
    }
  ],
    result:0,
    data:[],
    points:[],
    resultData:[],
    a: -2.5,
    b: 2.5,
    isLog: false,
    balance: 0.00,
    log:""
  },
  getters: {
    gethh(state){
      return state.historyMatches;
    },
    getLog(state){
      return state.log;
    },
    getMathes(state) {
      return state.mathes;
    },
    getisLog(state){
      return state.isLog;
    },
    getBalance(state){
      return state.balance;
    }
  },
  mutations: {
    makeDep(state, val){
      state.balance += val*1;
    },
    setLog(state, val){
      state.log = val;
    },
    setMatches(state,val){
      state.mathes = val;
    },
    sethh(state,val){
      state.hh = val;
    },
    addData(state, val){
      state.data.push(val);
    },
    setBalance(state, val){
      state.balance = val;
    },
    clearData(state){
      state.data = [];
    },
    clearPoints(state){
      state.points = [];
    },
    seta(state, val){
      state.a = val;
    },
    setb(state, val){
      state.b = val;
    },
    setRes(state, val){
      state.result = val;
    },
    setResultData(state){
      state.resultData = state.data.concat(state.points);
    },
    addPoint(state, val){
      state.points.push(val);
    },
    setisLog(state, val){
      state.isLog = val;
    }
  }
})

Vue.config.productionTip = false

var router = new VueRouter({
  routes:[
    {path: '/bets', component:Bets},
    {path: '/', component:Bets},
    {path: '/auth', component:Auth},
    {path: '/profile', component:Profile}
  ]
})
new Vue({
  store,
  instance,
  router,
  vuetify,
  Meta,
  render: h => h(App)
}).$mount('#app')
