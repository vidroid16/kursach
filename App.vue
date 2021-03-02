<template>
  <v-app>
    <v-app-bar app color=rgba(144,221,13,1)>
      <!-- <v-toolbar-title> Лаборатаорная работа №3</v-toolbar-title> -->
      <Header/>
    </v-app-bar>
    <v-content>
      <div class="container-m">
           <router-view></router-view>
      </div>
    </v-content>
    
  </v-app>
</template>

<script>
// import Lagrange from './components/Lagrange';
//import Graph from './components/Graph';
//import Bets from './components/Bets';
import Header from './components/Header';
//import Lagrange from './components/Lagrange';

import {EventBus} from '../src/bus.js';
export default {
  name: 'App',

  components: {
    // Lagrange,
    // Graph,
    Header,
    //Bets, 
    //Lagrange
  },
  data: function(){
    return{
      res:this.$store.state.result
    }
  },
  created(){
    EventBus.$on('isRedraw',()=>{
      //this.mydata = this.$store.state.data
      this.res = this.$store.state.result;
    });
  }
}
  
</script>

<style >
  .mycard{
    width: 50%;
    height: 800px;
  }
  .container-m{
    width: 100%;
    display: flex;
    flex-direction: row;
  }
  #result-box{
    margin-bottom: 20px;
    height: 0px;
    
  }
  #options-box{
    height: 800px;
    overflow-y: auto;
    overflow-x: hidden;
  }
  #result-box{
    width: 100%;
  }
</style>