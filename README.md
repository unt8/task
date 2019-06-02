### Login with github

* Two OAuth Applications were registered (for
 "development" and "production") 

* Clicking "Login with Github" link navigates user to 
Github OAuth page (https://github.com/login/oauth/authorize) passing parameters: 
    * `scope=user,public_repo`
    * `client_id`
    
* After user grants permission, github redirects to preconfigured "Redirect URL"
 with "Authorization Code" parameter 

* Server exchanges provided code with "access_token" by sending POST
request to "https://api.github.com/user" with params:
    * `code`
    * `client_id`
    * `client_secret`
    
* After obtaining "access_token", server can request user data 
from "https://api.github.com/user" and appending 
 `Authorization: token <access_token>` header
 


### Modifying github repo using "access_token"

Clicking "Add snippets" action which appends code snippets 

* Clone the repo containing "index.html" file
 into local directory `git clone https://unt8:<access_token>@github.com/unt8/plugin.git `

* Insert code snippets into `<head>` and `<body>` sections of index.html file (using "nokogiri" library)

* Commit and push changes 
    

