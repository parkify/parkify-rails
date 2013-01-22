class Api::V2::AcceptancesPresenter < Api::V2::ApplicationPresenter
  
  def as_json(acc, options={})
    {
      :user_id => acc.user_id,
      :resource_offer_id => acc.resource_offer_id,
      :start_time => acc.start_time.to_f,
      :end_time => acc.end_time.to_f,
      :status => acc.status,
      :details => acc.details,
      :id => acc.id,
      :active => (acc.status == "successfully paid" || acc.status == "payment_pending")
    }
  end


end

