import DS from 'ember-data';

export default DS.Model.extend({
  state: DS.attr(),
  player: DS.belongsTo('user'),
  game: DS.belongsTo('game'),
  previousMove: DS.belongsTo('move')
});
