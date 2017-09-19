import DS from 'ember-data';

export default DS.Model.extend({
  state: DS.attr(),
  player: DS.belonsTo('user'),
  game: DS.belonsTo('game'),
  previousMove: DS.belonsTo('move')
});
