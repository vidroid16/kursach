<template>
  <div id="auth">
    <div id="logButtons" @islog="displayLogin($event)">
        <v-btn class="bttn" @click="undisplayLogin()" id="registerButton">Регистрация</v-btn>
        <v-btn class="bttn" @click="displayLogin()" id="loginButton">Вход</v-btn>
    </div>
    <component :is="currentForm"></component>
    <h3>{{isLog?"Вход":"Регистрация"}}</h3>
    <LoginForm v-if="!isLog" :isDisplayed="isLog"/>
    <RegForm v-else/>
  </div>
</template>

<script>
import LoginForm from './RegForm';
import RegForm from './LoginForm';
export default {
  name: 'auth',
  components: {
    LoginForm, 
    RegForm,
  },
  props: [],
  data () {
    return {
      isLog:true
    }
  },
  computed: {
  },
  mounted () {
  },
  methods: {
    displayLogin: function(){
      this.$emit('islog',true);
      this.isLog = true;
    },
    undisplayLogin: function(){
      this.$emit('islog',false);
      this.isLog = false; 
    }
  }
}
</script>

<style>
.bttn{
    display: none;
}
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  text-align: center;
  margin: 0px;
  padding: 0px;
}
#auth{
    margin-top: 10%;
    background-color: rgba(86, 214, 186, 1.134);
    margin-left: 40%;
}
h1{
  margin-bottom: px;
}
</style>