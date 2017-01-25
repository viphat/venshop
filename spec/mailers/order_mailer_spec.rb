require 'rails_helper'

RSpec.describe OrderMailer, type: :mailer do
  include OrderHelper

  describe 'New Order Mail' do
    include_context 'create_a_valid_order'
    let(:user) { order.user }
    let(:mail) { described_class.new_order(order).deliver_now }

    before(:each) do
      order_item.valid? and order.valid?
    end

    it 'renders the subject' do
      expect(mail.subject).to eq "[VENSHOP] - Order #{order.id} - Confirmation"
    end

    it 'renders the receiver email' do
     expect(mail.to).to eq([user.email])
   end

   it 'renders the sender email' do
     expect(mail.from).to eq(['noreply@zigexn.vn'])
   end

   it 'should include user.name in mail body' do
     expect(mail.body.encoded).to match(user.name)
   end

   it 'should include order.id in mail body' do
     expect(mail.body.encoded)
       .to match(order.id.to_s)
   end

  end

end
