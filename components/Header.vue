<template>
    <v-container class="header">
        <label class="betsName" @click="gotoBets()">MafiaBets</label>
        <v-dialog
        v-model="dialog"
        persistent
        max-width="900px"
      >
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            
            id="balance"
            v-bind="attrs"
            v-on="on"
          >
          <div>{{computedBalance}} RUB</div>
          </v-btn>
        </template>
        <v-card class="hide">
          <v-card-title>
            <span class="headline">Пополнить баланс</span>
          </v-card-title>
          <v-card-text>
            <v-container>
                <v-text-field
                    class="inputf"
                    label="Пополнить баланс на"
                    :rules="[numberRule]"
                    v-model="dep"
                ></v-text-field>
            </v-container>
            
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn
              color="blue darken-1"
              text
              @click="dialog = false"
            >
              Закрыть
            </v-btn>
            <v-btn
              color="blue darken-1"
              text
              @click="makeDep()"
            >
              Пополнить
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
        <v-btn flat @click="gotoProfile()">
          Профиль
        </v-btn>

    </v-container>
</template>

<script>
import axios from 'axios';
import {EventBus} from '../bus.js';
export default {
  name: 'Header',
  data: function(){
      return{
        mydata: this.$store.state.data,
        balance:this.$store.getters.getBalance,
        dialog : false,
        log: this.$store.state.log,
        isLog:this.computedLog==""?true:false,
        isDep:false,
        dep:0.00,
        numberRule: v  => {
            if (!v.trim()) {
              this.isDep = true;
              return true;
            }
            if (!isNaN(parseFloat(v)) && v >= 1 && v <= 10000) 
            {
              this.isDep = true; 
              return true;
            }
            this.isDep = false;
            return 'Можно пополнит только от 1 до 10000 рублей';
        }
      }
  },
  computed: {
    computedLog: function() {
      return this.$store.state.log;
    },
    computedBalance: function() {
      return this.$store.state.balance;
    },
    computedisLog: function() {
      if(this.$store.state.log!=""){
        return true;
      }else{
        return false;
      }
    },
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
      makeDep(){
        if(this.isDep == true){
          //depositing
          this.$store.commit("makeDep", this.dep);
          this.isDep = false;
          this.dep = 0;
          this.balance = this.$store.getters.getBalance;
          const instance = axios.create({baseURL: this.$store.state.url})
          instance.post(this.$store.state.url+'balance',{'login':this.$store.state.log, 'balance':this.$store.getters.getBalance}).then(
            (response)=>{
              response.data;
            });
          this.dialog = false;
        }
        this.dialog = false;
      },
      gotoProfile(){
        this.$router.push('/profile');
      
      },
      gotoBets(){
        if(this.$store.getters.getLog != ""){
          
          this.$router.push('/bets');
        }
      },
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
.header{
    display: flex;
    flex-direction: row;
}
.betsName{
    font-size: 50px;
    font-family: 'Lucida Sans', 'Lucida Sans Regular', 'Lucida Grande', 'Lucida Sans Unicode', Geneva, Verdana, sans-serif;
    color: darkslategrey;

}
#balance{
    margin-left: 50%;
}
.inputf{
    width: 400px;
}
.hide{
    overflow: hidden;
}
.hbtn{
    /* color:aqua;
    background-color: deepskyblue; */
}
</style>
