About
===

Hackful is a platform developed to power http://hackful.com, a place 
for European entrepreneurs to share demos, stories or ask questions.

Developed by  [@8bitpal](https://twitter.com/8bitpal)
 
Idea by [@rayhanrafiq](https://twitter.com/rayhanrafiq) and [@mattslight](https://twitter.com/mattslight)

Hosting donated by [incite ict](http://www.incite-ict.com/)

Setup
===
Hackful runs on mysql.

Quick fix for getting the configuration to work in OSX as well as in ubuntu
`sudo ln -s /tmp/mysql.sock /var/run/mysqld/mysqld.sock`

API
---

### Quick Facts

* Format for API is JSON
* You can Login with your credential or with a authentication token
* Frontpage, Ask and New resources are avalaible as JSON
* Posts JSON includes voting status, e.g. did you already vote the entry or not
* Submiting, commenting and upvoting can be easily done with API
* You can signup via API
* Notfications are avalaible as JSON if you are logged in

[Discussion on hackful.com](http://hackful.com/posts/572)

### Known issues:

* Login is not encrypted and this should be fixed

### Examples for API: 

##### Request all posts on frontpage:
```console
GET http://hackful.com/api/v1/posts/frontpage
```

##### Response:

	[{
		"created_at":"2012-03-24T10:11:14Z",
		"down_votes":0,
		"id":49,
		"link":"http://www.balkanventureforum.org/",
		"text":"Balkan Venture Forum April 2012",
		"title":"Balkan Venture Forum April 2012",
		"up_votes":4,
		"updated_at":"2012-03-26T18:48:19Z",
		"comment_count":6,
		"path":"/posts/49",
		"voted":false,
		"user":{
			"id":1,
			"name":"Oemera"
		}
	}, ...]

##### Request all comments for a post:
```console
GET http://hackful.com/api/v1/posts/frontpage
```

##### Response:

	[{
		"commentable_id":49,
		"created_at":"2012-03-24T10:12:21Z",
		"id":34,
		"text":"asdasdasd",
		"up_votes":1,
		"updated_at":"2012-03-24T10:12:21Z",
		"voted":false,
		"user":{
			"id":9,
			"name":"AwesomeGuy"
		},
		"children":[
			{
				"commentable_id":34,
				"created_at":"2012-03-24T10:12:26Z",
				"id":35,
				"text":"asdasdasd",
				"up_votes":1,
				"updated_at":"2012-03-24T10:12:26Z",
				"voted":false,
				"user":{
					"id":9,
					"name":"AwesomeGuy"
				},
				"children":[]
			}, ... ]
	}, ...]

##### Login and recieve a auth_token:
```console
POST http://hackful.com/api/v1/sessions/login
user[email]=david@example.com&user[password]=mypassword
```

##### Response:

	{
		"success":true,
		"message":"Successfully logged in",
		"auth_token":"xHpdsVa5QqahMRxqc4zc",
		"user":{
			"id":8,
			"name":"RandomGuy",
			"email":"random@example.com"
		}
	}

##### Upvote a post
```console
PUT http://hackful.com/api/v1/post/1/upvote
auth_token=1ZwyJfbv7eiiLE7Gipsv
```

##### Submit a new article:
```console
POST http://hackful.com/api/v1/post
auth_token=1ZwyJfbv7eiiLE7Gipsv&post[text]=Text&post[title]=Title&post[link]=http://example.com
```

### All implemented API methods:

	POST 	/api/v1/signup

	GET 	/api/v1/user/:id
	GET 	/api/v1/user/notifications
	PUT 	/api/v1/user

	GET 	/api/v1/posts/frontpage(/:page)
	GET 	/api/v1/posts/new(/:page)
	GET 	/api/v1/posts/ask(/:page)
	GET 	/api/v1/posts/user/:id(/:page)

	GET 	/api/v1/post/:id
	POST 	/api/v1/post
	PUT 	/api/v1/post/:id
	DELETE 	/api/v1/post/:id
	PUT 	/api/v1/post/:id/upvote
	PUT 	/api/v1/post/:id/downvote

	GET 	/api/v1/comments/user/:id
	GET 	/api/v1/comments/post/:id
	GET 	/api/v1/comment/:id
	POST 	/api/v1/comment
	PUT 	/api/v1/comment/:id
	DELETE 	/api/v1/comment/:id
	PUT 	/api/v1/comment/:id/upvote
	PUT 	/api/v1/comment/:id/downvote

Contribution
---

Please post feature requests or bugs as issues.

Testing
---

Cucumber test cases are almost done and on the way.

ToDo's
----

* Write wiki article for hackful API
* Encrypt API login (password is send without encryption to API)
