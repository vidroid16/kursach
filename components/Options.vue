<template>
<v-container>
    <v-form>
      <!-- {{fs}} -->
        <div id="f" v-if="radioGroup==3">
          <v-text-field @click="clear" v-model="n" label="Введите кол-во аргументов n = " class=".custom">
          </v-text-field>
        </div>
        <div id="f" v-if="radioGroup!=3">
          <v-text-field v-model="f" label="Введите функцию f(x) = " class="textfield">
          </v-text-field>
        </div>
        <div id="f" v-for="i in n*1" v-bind:key="i" v-else >
          <v-text-field  v-model="fs[i-1]" label="Введите функцию a...z = " class="textfield">
          </v-text-field>
        </div>
        <div id = "interval">
          <v-text-field v-model="a" label="Левая граница a = " class="textfield inter">
          </v-text-field>
          <v-text-field v-model="b" label="Правая граница b = " class="textfield inter">
          </v-text-field>
          <v-text-field v-model="eps" label="Точность = " class="textfield inter">
          </v-text-field>
        </div>
        <div>
          <v-radio-group id="method" v-model="radioGroup">
        <v-radio
          :key="1"
          :label="`Метод бисекции`"
          :value="1"
        ></v-radio>
        <v-radio
          :key="2"
          :label="`Метод касательных`"
          :value="2"
        ></v-radio>
        <v-radio
          :key="3"
          :label="`Метод простых итераций`"
          :value="3"
        ></v-radio>
      </v-radio-group>
        </div>
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
        radioGroup:1,
        f:"",
        fs:[],
        a: -2.5,
        b: 2.5, 
        n: 1,
        eps: 0.001,
      }
  },
  methods:{
      clear(){
        this.fs = [];
      },
      go: function(){
        this.$store.commit("clearData");
        EventBus.$emit('isRedraw');
        if(this.radioGroup==3){
          const instance = axios.create({baseURL: this.$store.state.url})
          instance.post(this.$store.state.url+'goIter',{'fs':this.fs, 'a':this.a, 'b':this.b, "eps":this.eps}).then(
            (response)=>{
              if(response.data=="e404"){
                this.$store.commit("setRes","Результат не найден.");
              } else if(response.data=="e405"){
                this.$store.commit("setRes","Функция на краях отрезка должна быть разных знаков!");
              } else if(response.data=="e406"){
                this.$store.commit("setRes","Ф-я на интервале должна быть монотонной и не иметь точек экстремума. Иначе я ничего не гарантирую");
              } else{
                this.$store.commit("clearData");
                this.$store.commit("setRes",response.data);
                this.$store.commit("addData", {points: [
                    [this.$store.state.result[0],0]
                ],
                fnType: 'points',
                graphType: 'scatter'
                });
                this.$store.commit("seta", this.a);
                this.$store.commit("setb", this.b);
                instance.post(this.$store.state.url+'getFs',{'fs':this.fs, 'a':this.a, 'b':this.b, "eps":this.eps}).then(
                  (response)=>{
                    response.data.forEach(element => {
                      this.$store.commit("addData", {"fn":element});
                    });
                  }
                )
                EventBus.$emit('isRedraw');
              }
            }
          );
        }
        else{
          const instance = axios.create({baseURL: this.$store.state.url})
          instance.post(this.$store.state.url+'go',{'m':this.radioGroup, 'f':this.f, 'a':this.a, 'b':this.b, "eps":this.eps}).then(
            (response)=>{
              if(response.data=="e404"){
                this.$store.commit("setRes","Результат не найден.");
              } else if(response.data=="e405"){
                this.$store.commit("setRes","Функция на краях отрезка должна быть разных знаков!");
              } else if(response.data=="e406"){
                this.$store.commit("setRes","Ф-я на интервале должна быть монотонной и не иметь точек экстремума. Иначе я ничего не гарантирую");
              } else{
                this.$store.commit("clearData");
                this.$store.commit("setRes",response.data);
                this.$store.commit("addData", {points: [
                    [this.$store.state.result,0]
                ],
                fnType: 'points',
                graphType: 'scatter'
                });
                this.$store.commit("seta", this.a);
                this.$store.commit("setb", this.b);
                this.$store.commit("addData", {"fn":this.f});
                EventBus.$emit('isRedraw');
              }
            }
          );
        }
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
#interval{
    display: flex;
}
.custom{
  display: block;
  width: 50px;
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
