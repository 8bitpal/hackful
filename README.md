About
===

This is a fork for the hackful API.

### Here are a couple of specs:

* Format for API is JSON
* Login and authentication token are implemented
* Frontpage, Ask and New resources are avalaible
* Submiting, commenting and upvoting is implemeted
* You can signup via API
* Notfications are avalaible when logged in

### Known issues:

* Login is not encrypted and this should be fixed 


Examples for API: 
===

### Request all posts on frontpage:
```console
GET http://hackful.com/api/v1/posts/frontpage
```

Response:
```json
[{
	"created_at":"2012-02-22T17:34:02Z",
	"down_votes":0,"id":2,
	"link":"",
	"text":"This is a text",
	"title":"This is a title",
	"up_votes":2,
	"updated_at":"2012-02-29T07:16:51Z",
	"user_id":2
}, ...]
```

### Login and recieve a auth_token:
```console
POST http://hackful.com/api/v1/sessions/login
user[email]=david@example.com&user[password]=mypassword
```

Response: 
```json
{	
	"success":true,
	"message":"Successfully logged in",
	"auth_token":"1ZwyJfbv7eiiLE7Gipsv",
	"name":"david",
	"email":"david@example.com"
}
```

### Upvote a post
```console
PUT http://hackful.com/api/v1/post/1/upvote
auth_token=1ZwyJfbv7eiiLE7Gipsv
```

### Submit a new article:
```console
POST http://hackful.com/api/v1/post
auth_token=1ZwyJfbv7eiiLE7Gipsv&post[text]=Text&post[title]=Title&post[link]=http://example.com
```

All implemented methods:
===

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

ToDo's
===

* Write documentation for API
* Encrypt login via API (password is send without encryption to API)

Contribution
===

[Discussion on hackful.com](http://hackful.com/API)

Please post feature requests or bugs as issues.

Testing
---

Cucumber test cases are almost done and on the way.
