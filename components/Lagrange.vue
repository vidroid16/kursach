<template>
<v-container>
    <v-form>
      <!-- {{this.$store.state.result}} -->
      <v-radio-group id="method" v-model="f">
        <v-radio
          :key="1"
          :label="`y'=x^2+3*y`"
          :value="`x^2+3*y`"
        ></v-radio>
        <v-radio
          :key="2"
          :label="`y'=cos(x)+y`"
          :value="`cos(x)+y`"
        ></v-radio>
        <v-radio
          :key="3"
          :label="`Свое выражение`"
          :value="'?'"
        ></v-radio>
      </v-radio-group>
        <div id="f">
          <v-text-field v-model="f" label="Введите функцию y' = " class="textfield">
          </v-text-field>
        </div>
        <div id="inter_points">
        <div style="display:none" id="points">
          <v-text-field v-model="pointsStr" label="Введите узлы интерполяции через запятую " class="textfield">
          </v-text-field>
        </div>    
        </div>
        <div id = "interval">
          <v-text-field v-model="a" label="Левая граница x0 = " class="textfield inter">
          </v-text-field>
          <v-text-field v-model="b" label="Правая граница xn = " class="textfield inter">
          </v-text-field>
        </div>
        <div id = "interval2">
          <v-text-field v-model="y0" label="y0 = " class="textfield inter">
          </v-text-field>
          <v-text-field v-model="eps" label="epsilon = " class="textfield inter">
          </v-text-field>
        </div>
        <v-btn @click="go" id="btn">Расчитать L(x)</v-btn>
        <!-- <div style="height:70px"></div> -->
        <v-text-field v-model="x" label="Введите точку в которой хотите найти значение = " id="findxlabel" class="textfield">
        </v-text-field>
        <v-btn @click="find" id="findx">Найти значение в точке</v-btn>
        <v-card>
          <div>Точка x: {{this.x}}</div>
        </v-card>
        <v-card>
          <div>L(x) = {{this.findL}}</div>
        </v-card>
    </v-form>
</v-container>
</template>

<script>
import axios from "axios";
import {EventBus} from '../bus.js';
export default {
  name: 'Options',
  props: {
    msg: String
  },
  data:function(){
      return{
        f:"",
        eps:0.1,
        y0:0.0,
        points:[],
        pointsDraw:[],
        pointsStr:"",
        a: -2.5,
        b: 2.5, 
        n: 1,
        Lg:"",
        resultLoc:{},
        x:"",
        findf:"",
        findL:""
      }
  },
  methods:{
      go: async function(){
          //this.points = this.pointsStr.split(",");
          const instance = axios.create({baseURL: this.$store.state.url});
          instance.defaults.timeout = 5000;
          // instance.post(this.$store.state.url+'getL',{'f':this.f, 'points':this.points}).then(
          //   (response)=>{
          //     if(response.data=="e404"){
          //       this.$store.commit("setRes","Результат не найден.");
          //     } else if(response.data=="e405"){
          //       this.$store.commit("setRes","Функция на краях отрезка должна быть разных знаков!");
          //     } else if(response.data=="e406"){
          //       this.$store.commit("setRes","Ф-я на интервале должна быть монотонной и не иметь точек экстремума. Иначе я ничего не гарантирую");
          //     } else{
          //       this.Lg = response.data;
          //       this.$store.commit("clearData");
          //       this.$store.commit("setRes",this.Lg);
          //       this.$store.commit("seta", this.a);
          //       this.$store.commit("setb", this.b);
          //       this.$store.commit("addData", {"fn":response.data, 'sampler': 'builtIn','graphType': 'polyline'});
          //       this.$store.commit("addData", {"fn":this.f, 'sampler': 'builtIn','graphType': 'polyline'});
          //     }
          //   });
          await instance.post(this.$store.state.url+'goAdams',{'f':this.f, 'x0':this.a,'y0':this.y0,'xn':this.b,'eps':this.eps}).then(
            (response)=>{
              this.$store.commit("clearData");
              this.$store.commit("seta", this.a);
              this.$store.commit("setb", this.b);
              this.$store.commit("setRes",response.data);
              this.$store.commit('clearPoints');
              //this.$store.commit("addData", {"fn":response.data, 'sampler': 'builtIn','graphType': 'polyline'});
              this.$store.commit("addData", {
                points: response.data,
                fnType: 'points',
                graphType: 'scatter'
              }
              );
              //this.$store.commit("setRes",response.data);
            }
          );
          console.log(this.$store.state.result);
          instance.post(this.$store.state.url+'getGraph',{ 'points':this.$store.state.result}).then(
            (response)=>{
              this.Lg = response.data;
              this.$store.commit("addData", {"fn":response.data, 'sampler': 'builtIn','graphType': 'polyline'});
              
            }
          );
          this.graphTry();
          console.log(this.$store.state.result);
          EventBus.$emit('isRedraw');
          console.log(this.$store.state.result);
      },
      find: function(){
        const instance = axios.create({baseURL: this.$store.state.url})
        instance.post(this.$store.state.url+'findx',{'f':"x", 'l':this.Lg, 'x':this.x}).then(
            (response)=>{
              //let res = JSON.parse(response.data);
              //this.findf = response.data[0];
              this.findL = response.data[0];
            }
          );
      }
    }
}
      
</script>

<style>
.textfield{
    display: block;
    margin: auto;
    padding: 50px;
}
#f{
    display: flex;
}
#method{
  /* display: flex;
  flex-direction: row;
  margin: auto; */
}
#btn{
    display: block;
    margin: auto;
    background-color: rgba(235, 95, 223, 0.63)
}
#findx{
  display: block;
    margin: auto;
    background-color: rgba(235, 95, 223, 0.63)
}
#interval{
    display: flex;
}
#interval2{
    display: flex;
}
.custom{
  display: block;
  width: 50px;
}
#findxlabel{
  
}
.inter{
    /* display: block;
    width: 100%;
    background-color: red; */
}
.scroll{
  overflow-y: auto;
  height: 1000px;
}
</style>
