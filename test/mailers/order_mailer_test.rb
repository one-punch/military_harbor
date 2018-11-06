require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "thank_buy" do
    mail = OrderMailer.thank_buy
    assert_equal "Thank buy", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "sent" do
    mail = OrderMailer.sent
    assert_equal "Sent", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
