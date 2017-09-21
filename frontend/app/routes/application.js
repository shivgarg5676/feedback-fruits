import Ember from 'ember';
import getLoggedInUser from "frontend/mixins/get_logged_in_user";
import constants from "frontend/utils/constants";
import ajax from "frontend/helpers/ajax";

export default Ember.Route.extend(getLoggedInUser,{
  beforeModel:function(){
    this.getLoggedInUser();
  },
  actions:{
    signOut(){
      let hash = {}
      ajax(constants.SIGN_OUT_URL,'get', hash, this).then(()=>{
        window.location.reload()
      })
    },
    index(){
      this.transitionTo('index')
    }

  }

});
