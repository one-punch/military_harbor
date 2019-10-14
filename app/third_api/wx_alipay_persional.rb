class WxAlipayPersional

  class << self

    def new(*args)
      Client.new *args
    end

  end

  class Client

    def initialize(host=YAML_CONFIG[:wx_alipay][:host], secretkey=YAML_CONFIG[:wx_alipay][:secretkey])
      @host = host
      @secretkey = secretkey
    end

    def create_order(order_id: , order_type: , order_price: , order_name: , redirect_url: , extension: )
      sign = lambda do
        md5(md5("#{order_id}#{order_price}") + @secretkey)
      end
      do_request(:post, "/api/order") do |params|
        params.merge!(order_id: order_id, order_type: order_type, order_price: order_price, order_name: order_name, redirect_url: redirect_url, extension: extension, sign: sign.call)
      end
    end


    private


    def md5(str)
      Digest::MD5.hexdigest str
    end

    def do_request(method, url)
        params = {}
        yield(params) if block_given?
        params.symbolize_keys!
        if method.to_sym.upcase == :GET
          response = client.get "#{url}?#{params_to_url(params)}"
        elsif method.to_sym.upcase == :POST
          response = client.post url, params.to_json
        elsif  method.to_sym.upcase == :PUT
          response = client.put url, params.to_json
        end
        @response = Response.new response
    end

    def client
      @client ||= Faraday.new(url: "#{@host}") do |faraday|
                    faraday.request :retry, max: 2, interval: 0.5,
                       interval_randomness: 0.5, backoff_factor: 2,
                       exceptions: Faraday::ConnectionFailed
                    faraday.headers['Content-Type'] = 'application/json;charset=UTF-8'
                    faraday.headers['Authorization'] = 'Basic ZHJlYW1lcjoxMjM0NTY=' unless Rails.env.production?
                    faraday.response :logger, Rails.logger, bodies: true
                    faraday.adapter  Faraday.default_adapter
                  end
    end

  end

  class Response

    # fail {"code":-1,"data":"","msg":"系统火爆，请过1-3分钟后下单!"}
    # success {"created_at":"2019-10-14 14:49:41","updated_at":"2019-10-14 14:49:41","pay_status":"未支付","id":4,"order_id":"00002","order_type":"wechat","order_price":"1.98","order_name":"for test","extension":"test","redirect_url":"http://127.0.0.1:3001/?ok=1","qr_url":"wxp://f2f1YmzY6OIGkAvFTRNfzkJEBDAjrK59lSOY","qr_price":"1.98"}
    delegate :[], to: :@response, allow_nil:  true
    attr_accessor :result

    def initialize(res)
      @origin_res = res
      @response =  JSON.parse(res.body, symbolize_names: true)
      @result = Hashie::Mash.new(@response)
    end

    def success?
      !@response[:code].present?
    end

    def error_message
      @response[:msg] if @response[:msg].present?
    end

    def status
      @origin_res.status
    end

  end

end