collection @products
attributes :id, :name, :permalink, :count_on_hand, :on_demand, :group_buy

node :show_variants do
  true
end

node do |product|
  {
    notes: strip_tags(product.notes),
    description: strip_tags(product.description),
    price: product.master.price_with_fees(current_distributor, current_order_cycle) 
  }
end

child :supplier => :supplier do
  attributes :id, :name, :description
end

child :master => :master do
  attributes :id, :is_master, :count_on_hand, :options_text, :count_on_hand, :on_demand
  child :images => :images do
    attributes :id, :alt
    node do |img|
      {:small_url => img.attachment.url(:small, false)}
    end
  end
end

node :variants do |product|
  product.variants_for(current_order_cycle, current_distributor).in_stock.map do |v|
    {id: v.id,
     is_master: v.is_master,
     count_on_hand: v.count_on_hand,
     options_text: v.options_text,
     on_demand: v.on_demand,
     price: v.price_with_fees(current_distributor, current_order_cycle),
     images: v.images.map { |i| {id: i.id, alt: i.alt, small_url: i.attachment.url(:small, false)} }
    }
  end
end

child :taxons => :taxons do |taxon|
  attributes :name 
end

child :properties => :properties do |property|
  attributes :name, :presentation 
end
