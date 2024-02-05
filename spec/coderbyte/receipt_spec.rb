# frozen_string_literal: true
require 'coderbyte/receipt'

RSpec.describe Coderbyte::Receipt do
  let(:shopping_basket_input_1) { [
    "2 book at 12.49",
    "1 music CD at 14.99",
    "1 chocolate bar at 0.85"
  ] }
  let(:receipt) { Coderbyte::Receipt.new(shopping_basket_input_1) }

  describe 'calculate_tax_rate' do
    it 'calculates tax rate correctly for not exempt and not imported' do
      expect(receipt.calculate_tax_rate(false, false)).to eq(Coderbyte::Receipt::TAX_RATE_NOT_EXEMPT)
    end
    it 'calculates tax rate correctly for not exempt and imported' do
      expect(receipt.calculate_tax_rate(false, true)).to eq(Coderbyte::Receipt::TAX_RATE_NOT_EXEMPT + Coderbyte::Receipt::TAX_RATE_IMPORTED)
    end
    it 'calculates tax rate correctly for exempt and imported' do
      expect(receipt.calculate_tax_rate(true, true)).to eq(Coderbyte::Receipt::TAX_RATE_IMPORTED)
    end
  end

  describe 'calculate_sales_tax' do
    it 'calculates sales tax correctly for not exempt and not imported' do
      tax_rate_not_exempt_and_not_imported = receipt.calculate_tax_rate(false, false)
      expect(receipt.calculate_sales_tax(12.49, tax_rate_not_exempt_and_not_imported)).to eq(1.25)
    end
    it 'calculates sales tax correctly for not exempt and imported' do
      tax_rate_not_exempt_and_imported = receipt.calculate_tax_rate(false, true)
      expect(receipt.calculate_sales_tax(14.99, tax_rate_not_exempt_and_imported)).to eq(2.25)
    end
    it 'calculates sales tax correctly for exempt and imported' do
      tax_rate_exempt_and_imported = receipt.calculate_tax_rate(true, true)
      expect(receipt.calculate_sales_tax(27.99, tax_rate_exempt_and_imported)).to eq(1.4)
    end
  end

  describe 'print_receipt' do
    it 'prints the receipt correctly for input 1' do
      expected_output = <<~OUTPUT
        2 book: 24.98
        1 music CD: 16.49
        1 chocolate bar: 0.85
        Sales Taxes: 1.50
        Total: 42.32
      OUTPUT

      expect { receipt.print }.to output(expected_output).to_stdout
    end

    it 'prints the receipt correctly for input 2' do
      shopping_basket_input_2 = [
        "1 imported box of chocolates at 10.00",
        "1 imported bottle of perfume at 47.50"
      ]

      expected_output = <<~OUTPUT
        1 imported box of chocolates: 10.50
        1 imported bottle of perfume: 54.65
        Sales Taxes: 7.65
        Total: 65.15
      OUTPUT

      expect { Coderbyte::Receipt.new(shopping_basket_input_2).print }.to output(expected_output).to_stdout
    end

    it 'prints the receipt correctly for input 3' do
      shopping_basket_input_3 = [
        "1 imported bottle of perfume at 27.99",
        "1 bottle of perfume at 18.99",
        "1 packet of headache pills at 9.75",
        "3 imported boxes of chocolates at 11.25"
      ]

      expected_output = <<~OUTPUT
        1 imported bottle of perfume: 32.19
        1 bottle of perfume: 20.89
        1 packet of headache pills: 9.75
        3 imported boxes of chocolates: 35.55
        Sales Taxes: 7.90
        Total: 98.38
      OUTPUT

      expect { Coderbyte::Receipt.new(shopping_basket_input_3).print }.to output(expected_output).to_stdout
    end
  end

  describe 'parse_input' do
    it 'parses input string correctly' do
      expected_result = [
        ["book", 2, 12.49, true, false],
        ["music CD", 1, 14.99, false, false],
        ["chocolate bar", 1, 0.85, true, false],
      ]
      expect(receipt.parse_input(shopping_basket_input_1)).to eq(expected_result)
    end
  end
end
