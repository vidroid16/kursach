<template>
    <div>
        <div :style="[isDisplayed ? 'display:none':'display:block']" class="login-form">
        <div> Логин:   <input v-model="login" type="text"/></div>
        <div>Пароль:<input v-model="password" type="password" /></div>
        <input type="button" value="Войти" @click="validateForm"/>
        <div v-if="isError" id="errorMessege">
        {{messageError}}
  </div>
</div>
    </div>
</template>

<script>
    import axios from "axios";
export default {
  name: 'login-form',
  components: {},
  props: [],
  data () {
    return {
      login:"",
      password:"",
      isError:false,
      messageError:""
    }
  },
  computed: {

  },
  mounted () {

  },
  methods: {
    validateForm: function(){
      if(!/^(?=.*[A-Za-z0-9]$)[A-Za-z][A-Za-z\d.-]{0,19}$/.test(this.login)){
        this.messageError = "Введите нормальный логин";
        this.isError = true;
        return;
      }
      this.messageError="";
      //window.location.replace('home.html');
      const instance = axios.create({baseURL: this.$store.state.url})
      instance.post(this.$store.state.url+'log',{'login':this.login, 'password':this.password}).then(
        (response)=>{
          if(response.data!="404"){
            this.$store.commit("setLog", response.data.login);
            this.$router.push('/bets');
            this.$store.commit("setBalance", parseFloat(response.data.balance));
            instance.post(this.$store.state.url+'line',{'login':this.$store.state.log}).then(
            (response)=>{
                this.$store.commit("setMatches",response.data);
            });
          }else{
            this.messageError = "Такого пользователя не существует";
            this.isError = true;
          }
        },
        ()=>{
          this.messageError = "Повторите попытку потом";
          this.isError = true;
        }
      )
    },
  }
}
</script>

<style lang="scss" scoped>
    .login-form {
    background-color: rgba(86, 214, 186, 0.534);
    border-radius: 10px;
    width: 220px;
    height: 151px;
    //position:fixed;
    top: 30%;
    left: calc(50% - 110px);
    margin-top: 20px;
    margin: 0 auto;
    
}
input[type="button"]{
    width: 85%;
    margin-top: 10px;
    background-color: rgba(198, 199, 212, 0.979);
}
@media only screen and (max-width: 228px){  
    .login-form {
        width: 100%;
        height: 151px;
        position:relative;
        margin-top: 50px;
        top: 0%;
        left: 0%;
    }
}
@media only screen and (max-width: 1075px)and (min-width: 818px){  
    .login-form {
        font-size: 2.9rem;
        width: 300px;
        height: 350px;
        left: calc(50% - 150px);
    }
    input{
        width: 80%;
        height: 30px;
    }input[type="button"]{
        width: 80%;
        height: 45px;
    }
}
</style>