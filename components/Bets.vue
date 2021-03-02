<template>
<div id="helpme">
    <v-container id="betlin" :isRedraw="render">
        <table class="matches-table">
            <tr>
                <td>Команда 1</td>
                <td>Коэф. 1</td>
                <td>Название турнира</td>
                <td>Коэф. 2</td>
                <td>Команда 2</td>
            </tr>
            <tr v-for="match in matches" :key="match.id">
                <td>
                    <div @click="makeBet(match.id, 1)" class="team-name">
                        <img :src="match.firstLogo" alt="" >
                        <span>{{ match.firstTeam }}</span>
                    </div>
                </td>
                <td>{{ match.firstCoef }}</td>
                <td>ESL One Germany 2021</td>
                <td>{{ match.secCoef }}</td>
                <td >
                    <div @click="makeBet(match.id,2)" class="team-name">
                        <span>{{ match.secTeam }}</span>
                        <img :src="match.secLogo" alt="">
                    </div>
                </td>
            </tr>
        </table>
        <!-- <v-card class="match"  @click="makebet()">
            <div class="tm">
                <div class="tlogo">
                    <img src="{..\navi2.png}" alt="">
                </div>
                <div class="mteam">
                    
                </div>
                <div class="coef">
                    3.22
                </div>
            </div>
            <div class="mtour">
                ESL One London
            </div>
             <div class="tm" style="flex-direction: row-reverse">
                <div class="tlogo" style="padding-left:20px">
                    <img src="..\navi2.png" alt="">
                </div>
                <div class="mteam">
                    NoTechies
                </div>
                <div class="coef">
                    2.44
                </div>
            </div>
        </v-card> -->
        
    </v-container>
    <v-container id="barb">
        <v-card
      flat
      color="transparent"
    >
      <v-subheader>Cумма Ставки</v-subheader>
  
      <v-card-text>
        <v-row>
          <v-col class="pr-4">
            <v-slider
              v-model="slider"
              class="align-center"
              :max="max"
              :min="min"
              hide-details
            >
              <template v-slot:append>
                <v-text-field
                  v-model="slider"
                  class="mt-0 pt-0"
                  hide-details
                  single-line
                  type="number"
                  style="width: 60px"
                ></v-text-field>
              </template>
            </v-slider>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
    </v-container>
</div>
</template>
<script>
//import {EventBus} from '../bus.js';
//import {Chart} from 'chart.js';
import axios from 'axios';
export default {
  name: 'Bets',
  data: function(){
      return{
        min: 1,
        max: 10000,
        slider: 100,
        matches: this.$store.getters.getMathes,
        p1:true,
        betbal:10.30
      }
  },
  created(){
     
  },
  mounted(){
    
  },
  computed:{
      computedMatches: function(){
          return this.$store.state.matches;
      }
  },
  methods:{
      makeBet(idreq,teamreq){
          if(this.$store.state.balance < this.slider){
              this.slider = this.$store.state.balance
          }else{
              this.name = idreq;
          const instance = axios.create({baseURL: this.$store.state.url});
          if(teamreq == 1){
              this.p1 = true;
          }else{
              this.p1 = false;
          }
          instance.post(this.$store.state.url+'makebet',{'login':this.$store.state.log, 'balance':this.slider, 'match_id':idreq,'p1':this.p1}).then(
            (response)=>{
                this.$store.commit("sethh",response.data);
            });
            instance.post(this.$store.state.url+'getbal',{'login':this.$store.state.log}).then(
            (response)=>{
                this.$store.commit("setBalance",response.data);
            });
            
            instance.post(this.$store.state.url+'line',{'login':this.$store.state.log}).then(
            (response)=>{
                this.$store.commit("setMatches",response.data);
            });
            this.$router.push('/profile');
            this.$router.push('/bets');
            this.$router.push('/profile');
            this.$router.push('/bets');
            this.$router.push('/profile');

          }
          
      }
  }
}
</script>

<style scoped>
.matches-table {
    width: 100%;
    font-size: 1.4rem;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
    border-collapse:separate; 
    border-spacing: 0 1em;
}

.matches-table td {
    text-align: center;
}

.matches-table tr {
    border: solid 2px;
    height: 50px;
    box-shadow: 0px 0px 10px -1px rgba(0,0,0,0.75);
    margin-bottom: 20px;
    border-radius: 10px;
}

.team-name {
    display: flex;
    justify-content: center;
    align-items: center;
}

.team-name > *:first-child {
    margin-right: 20px;
}

.match{
    flex-flow: row nowrap;
    align-items: center;
    align-content: space-between;
    justify-content: space-between;
    height: 50px;
    font-size: 30px;
    display: flex;
    flex-direction: row;
}
.mteam{
    padding-left: 20px;
}
.tlogo{
    margin: 0px;
}
.tm{
    display: flex;
    flex-direction: row;
    width:300px;
}
.coef{
    padding-left: 20px;
}
#helpme{
    display: flex;
    flex-direction: row;
    
}
#betlin{
    width: 1000px;
}
#barb{
    width: 30%;
}
img {
    max-width: 40px;
    max-height: 40px;
}
.mtour{
    
}
</style>
