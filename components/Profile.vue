<template>
    <div class="temp">
        <div>
            <v-card @click="test()" class="p-data"><img id = "profphoto" src="https://themindsetproject.com.au/wp-content/uploads/2017/08/avatar-icon.png" alt="">
            <div> Зубенко Михаил Петрович</div>
            <div>Login: {{login}}</div>
            <div style="height:40px"></div>
            <div><v-btn @click="goAuth()"><img class="icon" src="https://www.pngfind.com/pngs/m/339-3396821_png-file-svg-download-icon-logout-transparent-png.png" alt=""></v-btn></div>
            </v-card>
        </div>
        <div class="hist">
            <h1>История ставок</h1>
            <v-container>
        <table class="matches-table">
            <tr>
                <td>Команда 1</td>
                <td>Коэф. 1</td>
                <td>Название турнира</td>
                <td>Коэф. 2</td>
                <td>Команда 2</td>
                <td>Ставка </td>
            </tr>
            <tr v-for="match in matches" :key="match.id" @click="makebet()">
                <td>
                    <div class="team-name">
                        <img class="logo" :src="match.firstLogo" alt="" >
                        <span>{{ match.firstTeam }}</span>
                    </div>
                </td>
                <td>{{ match.firstCoef }}</td>
                <td>ESL One Germany 2021</td>
                <td>{{ match.secCoef }}</td>
                
                <td>
                    <div class="team-name">
                        <span>{{ match.secTeam }}</span>
                        <img class="logo" :src="match.secLogo" alt="">
                    </div>
                </td>
                <td>{{match.result}}</td>

            </tr>
        </table>
    </v-container>
        </div>
    </div>
</template>

<script>
import axios from "axios";
    export default {
         data: function(){
      return{
        utest:"",
        matches: this.$store.state.hh,
        login: this.$store.state.log
      }
  },
  created(){
     
  },
  mounted(){
    
  },
  methods:{
      test(){
          const instance = axios.create({baseURL: this.$store.state.url})
          instance.post(this.$store.state.url+'makebet',{'login':this.$store.state.log, 'balance':1, 'match_id':3,'p1':true}).then(
            (response)=>{
                this.$store.commit("sethh",response.data);
            });
      },
      goAuth(){
        this.$store.commit("setLog","");
        this.$store.commit("setBalance", 0);

        this.$router.push('/auth');
      }
  }
    }
</script>

<style lang="scss" scoped>

    .hist{
        width: 1000px;
    }
    .p-data{
        width: 300px;
        height: 200%;
        background-color: beige;
    }
    .temp{
        display: flex;
        flex-direction: row;
    }
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
#profphoto{
    width: 240px;
    background-color: beige;
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
.icon{
    width: 20px;
    height: 20px;
}
.tm{
    display: flex;
    flex-direction: row;
    width:300px;
}
.coef{
    padding-left: 20px;
}
.logo {
    max-width: 40px;
    max-height: 40px;
}
.mtour{
    
}
</style>