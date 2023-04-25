class PurchaseSerializer
  attr_reader :purchase, :user

  def initialize(purchase, user)
    @purchase = purchase
    @user = user
  end

  def call
    Jbuilder.new do |json|
      json.points(user.points)
      json.purchase_points(purchase.points)
    end.attributes!
  end
end