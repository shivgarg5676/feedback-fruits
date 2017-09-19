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
            self.set('inputPassword',"")
            this.set('errorMessage', data.message)
          }
        }
      }
      ajax(constants.SIGN_IN_URL,'POST', hash, this)
      return false;
    }
  }
})
export default controller;
