class Api::V3::AcceptancesPresenter < Api::V3::ApplicationPresenter
  
  def as_json(acc, options={})
    toRtn = {
      :user_id => acc.user_id,
      :resource_offer_id => acc.resource_offer_id,
      :start_time => acc.start_time.to_f,
      :end_time => acc.end_time.to_f,
      :status => acc.status,
      :details => acc.details,
      :id => acc.id,
      :active => (acc.status == "successfully paid" || acc.status == "payment pending" || acc.status == "delayed payment pending")
    }
    if(acc.needs_payment && acc.pay_by) 
        toRtn[:needs_payment] = acc.needs_payment
        toRtn[:pay_by] = acc.pay_by
    end
    return toRtn
  end


end

