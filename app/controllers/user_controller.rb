class UserController < ApplicationController

  include HTTParty
  debug_output $stderr

  def index
    # render html: 'Hello'
    #
    # response = HTTParty.get('http://api.stackexchange.com/2.2/questions?site=stackoverflow')

    # render html: response
  end

  def callback
    code = params['code'] || ''
    if not code.empty?
      resp = HTTParty.post('https://github.com/login/oauth/access_token',
                           :body => { :code => code,
                                      :client_id => 'f5ed8373d801d99bd95b',
                                      :client_secret => '6681b80366dbd320771cfe2325471148ddf20220',
                                      :status => 'Open',
                           },
                           :headers => { 'Accept' => 'application/json' })
      #
      #

      token = resp['access_token']

      render html: resp
      #
      # resp = HTTParty.get('https://api.github.com/user', {
      #     headers: {
      #         'Authorization: token' => "#{token}",
      #         'user-agent' => 'Httparty'
      #     },
      #     # debug_output: STDOUT
      # })
      #
      # render html: resp
    else
      render html: 'empty'
    end
  end


  def test_token
    resp = HTTParty.get('https://api.github.com/user', {
        headers: {
            'Authorization' => "token a708fee11b6ae72e55be7095f73ce7675cd798fb",
            # 'Authorization' => "token ca64ddcc44761a082127cefc6ac20d4fcdfecac6",
            'User-Agent' => 'HTTPie/1.0.2'
        },
        debug_output: $stdout
    })

    render html: resp
  end

end
