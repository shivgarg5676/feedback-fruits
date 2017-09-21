import Ember from "ember"
import getLoggedInUser from "frontend/mixins/get_logged_in_user";
import constants from "frontend/utils/constants";
import ajax from "frontend/helpers/ajax";

let controller = Ember.Controller.extend(getLoggedInUser,{
  actions:{
    login:function(){
      let self = this;
      this.set('errorMessage', null)
      let hash= {
        data: {
          user:{
            email: this.get('email'),
            password: this.get('password')
          }
        },
        success:function(data){
          if(data.message == "sign_in success"){
            self.getLoggedInUser().done(function(){
              self.transitionToRoute('/')
            });
          }
          else{
            self.set('password',"")
            self.set('errorMessage', data.message)
          }
        }
      }
      ajax(constants.SIGN_IN_URL,'POST', hash, this)
      return false;
    },
    gotoCreateUser:function(){
      let user = this.store.createRecord('user')
      this.set('newUser', user)
      this.set('errorMessage',"")
      this.set('showLogin',false)
    },
    gotoLogin: function(){
      this.set('errorMessage',"")
      this.set('showLogin',true)

    },
    signUp:function(){
      this.get('newUser').save().then((data)=>{
        this.set('errorMessage', "New user successfully created")
      }).catch((adapterError)=>{
        let str =""
        this.get('newUser.errors').toArray().forEach((item)=>{
          if(item.attribute){
            str = str + " "+ item.attribute.replace(/([A-Z])/g,' $1').replace(/^./, (str)=>{str.toUpperCase()}) + " "+ item.message + "</br>"
          }});
          this.set('errorMessage', str);
        });
    }
  }
})
export default controller;
