class Api::V1::MovesController < ApplicationController
  def show
    render :json => Move.find_by_id(params['id'])
  end
end
