<template>

    <v-container :isRedraw="this.render()">
      <!-- {{this.$store.state.data}} -->
        <v-btn @click="render" style="display:none"></v-btn>
        <div id="root"></div>
    </v-container>
</template>

<script>
import {EventBus} from '../bus.js';
export default {
  name: 'TestComponent',
  data: function(){
      return{
        mydata: this.$store.state.data
      }
  },
  created(){
    EventBus.$on('isRedraw',()=>{
      //this.mydata = this.$store.state.data
      this.render();
    });
  },
  mounted(){
    
  },
  methods:{
      render:function(){
        this.$store.commit('setResultData');
        let a = this.$store.state.a;
        let b = this.$store.state.b;
        // let tmp = 0;
        // if(b<a){
        //     tmp = a;
        //     a = b;
        //     b = tmp;
        // }
        window.d3 = require('d3');
        const functionPlot = require('function-plot');
        const root = document.querySelector("#root");
        functionPlot({
        target: root,
        yAxis: { domain: [-5, 5] },
        xAxis: { domain: [a, b] },
        tip: {
            renderer: function() {}
        },
        grid: true,
        data: this.$store.state.resultData,
        });
       
        
      }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
