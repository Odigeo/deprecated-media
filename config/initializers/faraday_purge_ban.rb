module Faraday
  class Connection

    METHODS << :purge
    METHODS << :ban

    # purge/ban(url, params, headers)
    %w[purge ban].each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(url = nil, params = nil, headers = nil)
          run_request(:#{method}, url, nil, headers) { |request|
            request.params.update(params) if params
            yield request if block_given?
          }
        end
      RUBY
    end

  end
end
