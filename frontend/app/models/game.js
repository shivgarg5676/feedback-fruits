import DS from 'ember-data';

export default DS.Model.extend({
  player1: DS.belongsTo('user'),
  player2: DS.belongsTo('user'),
  winner: DS.belongsTo('user'),
  workflow_state: DS.attr(),
  moves: DS.hasMany('moves'),
});
