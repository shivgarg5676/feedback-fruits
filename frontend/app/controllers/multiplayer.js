import Ember from 'ember';

export default Ember.Controller.extend({
  myToken: 'x',
  opponentToken: 'O',
  gameState: [{},{},{},{},{},{},{},{},{}],
  message: null,
  session: Ember.inject.service(),
  cableService: Ember.inject.service('cable'),
  setupSubscription: Ember.on('init', function() {
    var consumer = this.get('cableService').createConsumer('ws://localhost:4200/cable');
    var subscription = consumer.subscriptions.create({channel: "GameChannel"} ,{
      received: (data) => {
        if(data.message.type == 'waiting'){
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
        if(data.message.type == 'gameEnd'){
          //reset game
        }
      }
    });
    this.set('subscription', subscription);
  }),

  actions: {
    playerMoves(index){
      if(this.get('canPlay')){
        if(!this.get('gameState').objectAt(index).value){
          Ember.set(this.get('gameState').objectAt(index),'value',this.get('myToken'))
          this.set('canPlay',false)
          this.get('subscription').perform('move',{move: index,gameId: this.get('gameId')})
          this.set('message', "waiting for other player")
        }
      }
    }
  }
});
