# frozen_string_literal: true

module Coderbyte
  class Receipt

    TAX_RATE_IMPORTED = 5
    TAX_RATE_NOT_EXEMPT = 10

    def initialize(shopping_basket)
      @parsed_items = parse_input(shopping_basket)
    end

    def print
      total_cost = 0
      total_sales_tax = 0

      @parsed_items.each do |item|
        name, quantity, price, is_exempt, is_imported = item

        tax_rate = calculate_tax_rate(is_exempt, is_imported)
        sales_tax = calculate_sales_tax(price, tax_rate)
        price_with_tax = (price + sales_tax) * quantity

        total_cost += price_with_tax
        total_sales_tax += sales_tax * quantity

        puts "#{quantity} #{name}: #{'%.2f' % price_with_tax}"
      end

      puts "Sales Taxes: #{'%.2f' % total_sales_tax}"
      puts "Total: #{'%.2f' % total_cost}"
    end

    # I leave these method as public, just to make it easy to test and not use .send to bypass
    # protected

    # @param [Array(string)] shopping_basket
    def parse_input(shopping_basket)
      items = []
      shopping_basket.each do |line|
        match = line.match(/(\d+) (.+) at (\d+\.\d+)/)
        unless match
          raise ArgumentError, "Invalid input format: #{line.chomp}"
        end

        quantity, name, price = match[1..3]
        is_exempt = !!(name =~ /book|chocolate|fruit|food|medical|medicine|pill|drugs/i)
        is_imported = !!(name =~ /imported/i)
        items << [name, quantity.to_i, price.to_f, is_exempt, is_imported]
      end
      items
    end

    # @param [decimal] price
    # @param [decimal] tax_rate
    def calculate_sales_tax(price, tax_rate)
      tax = price * tax_rate / 100.0
      rounded_tax = (tax / 0.05).ceil * 0.05
      rounded_tax.round(2)
    end

    # @param [boolean] is_exempt
    # @param [boolean] is_imported
    def calculate_tax_rate(is_exempt, is_imported)
      tax_rate = 0
      tax_rate += TAX_RATE_NOT_EXEMPT unless is_exempt
      tax_rate += TAX_RATE_IMPORTED if is_imported
      tax_rate
    end
  end

  if __FILE__ == $0
    shopping_basket = if ARGV.any?
                        ARGV
                      else
                        raise ArgumentError, "No purchases were submitted"
                      end

    receipt = Receipt.new shopping_basket
    receipt.print
  end
end
