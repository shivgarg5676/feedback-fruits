import Ember from 'ember';
import getLoggedInUser from "frontend/mixins/get_logged_in_user";
import constants from "frontend/utils/constants";
export default Ember.Route.extend(getLoggedInUser,{
  beforeModel:function(){
    this.getLoggedInUser();
  },
  actions:{
    signOut(){
      debugger;
    },
    playMultiplayer(){
      this.transitionTo('multiplayer')
    }

  }

});
