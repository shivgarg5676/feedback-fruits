import Ember from 'ember';

export default Ember.Controller.extend({
  myToken: 'x',
  opponentToken: 'O',
  gameState: [{},{},{},{},{},{},{},{},{}],
  message: null,
  session: Ember.inject.service(),
  cableService: Ember.inject.service('cable'),
  setupSubscription: Ember.on('init', function() {
    let url = "ws://" + window.location.host + "/cable"
    var consumer = this.get('cableService').createConsumer(url);
    var subscription = consumer.subscriptions.create({channel: "GameChannel"} ,{
      received: (data) => {
        if(data.message.type == 'waiting'){
          this.set('showStartNewGame', false)
          this.set('message', "waiting for other player")
        }
        if(data.message.type == "start_play"){
          this.set('message', "your turn")
          this.set('canPlay', true)
          this.set('gameId', data.message.gameId)
          if(data.message.last_move != null){
            Ember.set(this.get('gameState').objectAt(data.message.last_move),'value',this.get('opponentToken'))
          }
        }
        if(data.message.type == "pause_play"){
          this.set('canPlay',false)
          this.set('gameId', data.message.gameId)
          this.set('message', "waiting for other player")
          if(data.message.last_move != null){
            Ember.set(this.get('gameState').objectAt(data.message.last_move),'value',this.get('myToken'))
          }
        }
        if(data.message.type == 'gameEnd'){
          //reset game
          Ember.run.later(()=>{
            this.set('showStartNewGame', true)
            if (data.message.winner == null){
              this.set('canPlay',false)
              this.set('message', "match draw")
            }else{
              if(data.message.winner == this.get('session.currentUser.id')){
                this.set('canPlay',false)
                this.set('message', "you won")
              }
              else {
                this.set('canPlay', false)
                this.set('message', "opponent won")
              }
            }
          },500)

        }
      }
    });
    this.set('subscription', subscription);
  }),

  actions: {
    startNewGame(){
      this.set('gameState',[{},{},{},{},{},{},{},{},{}]);
      this.get('subscription').perform('joinGame')
    },
    playerMoves(index){
      if(this.get('canPlay')){
        if(!this.get('gameState').objectAt(index).value){
          this.get('subscription').perform('move',{move: index,gameId: this.get('gameId')})
        }
      }
    }
  }
});
