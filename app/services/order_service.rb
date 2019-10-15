# 根据订单创建用户记录
class OrderService

  attr_accessor :order, :days, :allow_download
  delegate :order_items, to: :@order, prefix: false, allow_nil: true

  def initialize(order)
    @order = order
    @days = 0
    @allow_download = false
  end

  def processing
    return unless order.paid?
    products = order_items.map(&:product)
    products.map do |sku| # PrimeryProduct
      if sku.is_virtual?
        process_virtual(sku.becomes(VirtualProduct))
        virtual_product.properties
      else
        proccess_normal(sku.becomes(Variant))
      end
    end
    order.finish!
  end

  def cancel
    products = order_items.map(&:product)
    products.map do |sku| # PrimeryProduct
      if sku.is_virtual?
        cancel_virtual(sku.becomes(VirtualProduct))
        virtual_product.properties
      else
        cancel_normal(sku.becomes(Variant))
      end
    end
  end

  protected

  def process_virtual(virtual_product)
    virtual_product.properties.each do |property|
      allow_download = true if property.allow_download?
      days = property.days if property.days
    end

    paper_ids = virtual_product.actual_products.map do |product|
      variant = product.variants.first
      variant.paper_id
    end
    records = UserPaperRecord.where(user_id: order.user_id, paper_id: paper_ids).index_by do |record|
      "#{record.user_id}-#{record.paper_id}"
    end

    ActiveRecord::Base.transaction do
      begin
        virtual_product.actual_products.each do |product|
          variant = product.variants.first
          record = records["#{order.user_id}-#{variant.paper_id}"]
          if record.present?
            if days > 0
              if record.expired?
                record.reset_expired_at_from_now(days)
              else
                record.stretch(days)
              end
            end
            record.allow_download = allow_download
          else
            record = UserPaperRecord.new(user_id: order.user_id, paper_id: paper.id, expired_at: Time.now.beginning_of_day + days.days, allow_download: allow_download)
          end
          record.save!
        end
      rescue Exception => e
        Rails.logger.error(e)
        raise ActiveRecord::Rollback
      end
    end
  end

  def proccess_normal(variant)
    variant.properties.each do |property|
      allow_download = true if property.allow_download?
      days = property.days if property.days
    end
    begin
      generate_record!(variant.paper, days, allow_download)
    rescue Exception => e
      Rails.logger.error(e)
    end
  end

  def generate_record!(paper, days, allow_download)
    record = UserPaperRecord.where(user_id: order.user_id, paper_id: paper.id).take
    if record.present?
      if days > 0
        if record.expired?
          record.reset_expired_at_from_now(days)
        else
          record.stretch(days)
        end
      end
      record.allow_download = allow_download
    else
      record = UserPaperRecord.new(user_id: order.user_id, paper_id: paper.id, expired_at: Time.now.beginning_of_day + days.days, allow_download: allow_download)
    end
    record.save!
  end

  def cancel_virtual(virtual_product)
    paper_ids = virtual_product.actual_products.map do |product|
      variant = product.variants.first
      variant.paper_id
    end
    destroy_available_records(paper_ids)
  end

  def cancel_normal(variant)
    destroy_available_records([variant.paper_id])
  end

  def destroy_available_records(paper_ids) #只删掉有效的记录
    UserPaperRecord.where(user_id: order.user_id, paper_id: paper_ids).where("expired_at >= ? OR allow_download = ? ", Time.now.beginning_of_day, true).destroy_all
  end

end
