require 'nokogiri'

class UserController < ApplicationController

  include HTTParty
  debug_output $stderr

  CLIENT_ID = 'f5ed8373d801d99bd95b'
  CLIENT_SECRET = '6681b80366dbd320771cfe2325471148ddf20220'
  REPO_PATH = "#{Rails.root}/public/plugin"

  def index
    @client_id = CLIENT_ID

    @users = User.all
  end


  def callback
    code = params['code'] || ''

    if code.empty?
      render json: {error: 'Code not provided'}, status: :internal_server_error and return
    end

    resp = HTTParty.post('https://github.com/login/oauth/access_token',
                         :body => { :code => code,
                                    :client_id => CLIENT_ID,
                                    :client_secret => CLIENT_SECRET
                         },
                         :headers => { 'Accept' => 'application/json' })

    access_token = resp['access_token']

    if access_token.nil? or access_token.empty?
      render json: {error: 'Access token not provided'}, status: :internal_server_error and return
    end

    resp = HTTParty.get('https://api.github.com/user', {
        headers: {
            'Authorization' => "token #{access_token}",
            'User-Agent' => 'HTTPie/1.0.2'
        }
    })


    # save user data
    user = User.new
    user.login = resp['login']
    user.github_id = resp['id']
    user.avatar_url = resp['avatar_url']
    user.access_token = access_token
    user.save

    redirect_to :action => :index
  end




  def add_snippets
    out = ''

    out += clone_repo
    insert_snippets
    out += commit_and_push
    remove_repo

    flash.notice = out

    redirect_to :action => :index
  end


  protected
  def clone_repo
    cmd = "cd #{REPO_PATH}; "

    if not File.directory?(REPO_PATH)
      cmd += "git clone https://unt8:79f087be18e5eff590c17f2d5fdf83707091281c@github.com/unt8/plugin.git #{REPO_PATH} 2>&1; "
    end

    out = `#{cmd}`

    return out
  end


  def insert_snippets
    file = "#{REPO_PATH}/index.html"

    doc = Nokogiri::HTML(File.read(file))

    doc.at("/html/head").add_child("<script src='https://www.powr.io/powr.js'></script>")
    doc.at("/html/body").add_child("<div class='powr-form-builder' id='b642b8d0_1559372136'></div>")

    File.write(file, doc.to_xml)
  end



  def commit_and_push
    cmd = "cd #{REPO_PATH}; "

    cmd += "git add index.html 2>&1; "
    cmd += "git commit -m 'Add snippet to index.html' 2>&1; "
    cmd += "git push origin master 2>&1; "

    out = `#{cmd}`

    return out
  end


  def remove_repo
    FileUtils.rm_rf(REPO_PATH)
  end

end
