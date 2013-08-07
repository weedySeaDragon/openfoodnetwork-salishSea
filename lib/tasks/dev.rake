
namespace :openfoodweb do

  namespace :dev do

    desc 'load sample data'
    task :load_sample_data => :environment do
      require File.expand_path('../../../spec/factories', __FILE__)
      require File.expand_path('../../../spec/support/spree/init', __FILE__)
      task_name = "openfoodweb:dev:load_sample_data"

      # -- Shipping / payment information
      unless Spree::Zone.find_by_name 'Australia'
        puts "[#{task_name}] Seeding shipping / payment information"
        zone = FactoryGirl.create(:zone, :name => 'Australia', :zone_members => [])
        country = Spree::Country.find_by_name('Australia')
        Spree::ZoneMember.create(:zone => zone, :zoneable => country)
        FactoryGirl.create(:shipping_method, :zone => zone)
        FactoryGirl.create(:payment_method, :environment => 'development')
      end


      # -- Taxonomies
      unless Spree::Taxonomy.find_by_name 'Products'
        puts "[#{task_name}] Seeding taxonomies"
        taxonomy = Spree::Taxonomy.find_by_name('Products') || FactoryGirl.create(:taxonomy, :name => 'Products')
        taxonomy_root = taxonomy.root

        ['Vegetables', 'Fruit', 'Oils', 'Preserves and Sauces', 'Dairy', 'Meat and Fish'].each do |taxon_name|
          FactoryGirl.create(:taxon, :name => taxon_name, :parent_id => taxonomy_root.id)
        end
      end

      # -- Addresses
      unless Spree::Address.find_by_zipcode "3160"
        puts "[#{task_name}] Seeding addresses"
        Spree::Address.delete_all

        FactoryGirl.create(:address, :address1 => "25 Myrtle Street", :zipcode => "3153", :city => "Bayswater")
        FactoryGirl.create(:address, :address1 => "6 Rollings Road", :zipcode => "3156", :city => "Upper Ferntree Gully")
        FactoryGirl.create(:address, :address1 => "72 Lake Road", :zipcode => "3130", :city => "Blackburn")
        FactoryGirl.create(:address, :address1 => "7 Verbena Street", :zipcode => "3195", :city => "Mordialloc")
        FactoryGirl.create(:address, :address1 => "20 Galvin Street", :zipcode => "3018", :city => "Altona")
        FactoryGirl.create(:address, :address1 => "59 Websters Road", :zipcode => "3106", :city => "Templestowe")
        FactoryGirl.create(:address, :address1 => "17 Torresdale Drive", :zipcode => "3155", :city => "Boronia")
        FactoryGirl.create(:address, :address1 => "21 Robina CRT", :zipcode => "3764", :city => "Kilmore")
        FactoryGirl.create(:address, :address1 => "25 Kendall Street", :zipcode => "3134", :city => "Ringwood")
        FactoryGirl.create(:address, :address1 => "2 Mines Road", :zipcode => "3135", :city => "Ringwood East")
        FactoryGirl.create(:address, :address1 => "183 Millers Road", :zipcode => "3025", :city => "Altona North")
        FactoryGirl.create(:address, :address1 => "310 Pascoe Vale Road", :zipcode => "3040", :city => "Essendon")
        FactoryGirl.create(:address, :address1 => "6 Martin Street", :zipcode => "3160", :city => "Belgrave")
      end

      # -- Enterprises
      unless Enterprise.count > 0
        puts "[#{task_name}] Seeding enterprises"
        Enterprise.delete_all

        3.times { FactoryGirl.create(:supplier_enterprise, :address => Spree::Address.find_by_zipcode("3160")) }

        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3153"))
        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3156"))
        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3130"))
        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3195"))
        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3018"))
        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3106"))
        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3155"))
        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3764"))
        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3134"))
        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3135"))
        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3025"))
        FactoryGirl.create(:distributor_enterprise, :address => Spree::Address.find_by_zipcode("3040"))
      end

      unless Spree::ShippingMethod.all.any? { |sm| sm.calculator.is_a? OpenFoodWeb::Calculator::Itemwise }
        FactoryGirl.create(:itemwise_shipping_method)
      end

      # -- Products
      unless Spree::Product.count > 0
        puts "[#{task_name}] Seeding products"

        prod1 = FactoryGirl.create(:product,
                           :name => 'Garlic', :price => 20.00,
                           :supplier => Enterprise.is_primary_producer[0],
                           :taxons => [Spree::Taxon.find_by_name('Vegetables')])

        ProductDistribution.create(:product => prod1,
                                   :distributor => Enterprise.is_distributor[0],
                                   :shipping_method => Spree::ShippingMethod.first)


        prod2 = FactoryGirl.create(:product,
                           :name => 'Fuji Apple', :price => 5.00,
                           :supplier => Enterprise.is_primary_producer[1],
                           :taxons => [Spree::Taxon.find_by_name('Fruit')])

        ProductDistribution.create(:product => prod2,
                                   :distributor => Enterprise.is_distributor[1],
                                   :shipping_method => Spree::ShippingMethod.first)

        prod3 = FactoryGirl.create(:product,
                           :name => 'Beef - 5kg Trays', :price => 50.00,
                           :supplier => Enterprise.is_primary_producer[2],
                           :taxons => [Spree::Taxon.find_by_name('Meat and Fish')])

        ProductDistribution.create(:product => prod3,
                                   :distributor => Enterprise.is_distributor[2],
                                   :shipping_method => Spree::ShippingMethod.first)
      end
    end
  end
end