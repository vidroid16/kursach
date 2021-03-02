<template>
    <div>
  <div :style="[isDisplayed ? 'display:none':'display:block']" class="login-form">
    <div> Логин:<input v-model="login" type="text"/></div>
    <div>Пароль:<input v-model="password" type="password" /></div>
    <div>Повторите пароль:<input v-model="passwordConfirmed" type="password" /></div>
    <input @click="validateForm" type="button" value="Войти"/>
    <div v-if="isError" id="errorMessege">
      {{messageError}}
    </div>
  </div>
</div>
</template>

<script>
import axios from "axios";
export default {
  name: 'reg-form',
  components: {},
  props: [],
  data () {
    return {
      login:"",
      password:"",
      passwordConfirmed:"",
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
      if(this.password!==this.passwordConfirmed){
        this.messageError = "Пароль не совпадает";
        this.isError = true;
        return;
      }
      this.messageError="";
      //window.location.replace('home.html');
      const instance = axios.create({baseURL: this.$store.state.url})
      instance.post('/reg',{'login':this.login, 'password':this.password}).then(
        (response)=>{
          if(response.data===200){
            this.$store.commit('setL', this.login);
            localStorage.setItem('name',this.login);
            this.$router.push('/main');
            // document.globlog = "";
            // //window.location.replace('home.html');
          }else{
            this.messageError = "Данный логин уже занят";
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
    display: block;
    background-color: rgba(86, 214, 186, 0.534);
    border-radius: 10px;
    width: 220px;
    height: 200px;
    //position:fixed;
    top: 30%;
    left: calc(50% - 110px);
    margin-top: 20px;
    //margin-left: 30vw;
    //width: 50%;
  margin: 0 auto;
    
}
#errorMessege{
    background-color: rgba(247, 81, 81, 0.795);
    margin-top: 20px;;
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
    #errorMessege{
        //margin-top: 700px;;
    }
    .login-form {
        font-size: 1.2rem;
        width: 300px;
        height: 250px;
        left: calc(50% - 150px);
    }
    input{
        width: 80%;
        height: 30px;
        margin-top: 10px;
    }input[type="button"]{
        width: 80%;
        height: 25px;
    }
}
</style>