# 根据订单创建用户记录

class OrderService

  delegate :order_items, to: :@order, prefix: false, allow_nil: true

  def initialize(order)
    @order = order
  end

  def exec
    products = order_items.map(&:product)
    products.map do |sku|
      sku.paper
      sku.properties # 拿的是PrimeryProduct，没有paper properties，按照抽象order item不应该获得这些信息
    end
  end


# { paper: expired: , user: }

end
