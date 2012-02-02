module ContentHelper
	def build_post_preview(post)
		output = '<div class="post">'
		if user_signed_in?
			if current_user.voted?(post)
				output += "<table><tr><td class='voted'>"
			else
				output += "<table><tr><td class='vote' id='posts_"+post.id.to_s+"'>"
			end
			output += link_to "&#9650;".html_safe, "#", :onClick => "vote_up("+post.id.to_s+", 'posts')"
		else
			output += "<table><tr><td class='vote'>"
			output += link_to "&#9650;".html_safe, new_user_session_path
		end
		output += "<br /><br /></td><td>"
		output += "<div class='post_title'>"
		(post.link.nil? or post.link.empty?) ? (output += link_to post.title, post) : (output += link_to post.title, post.link)
		output += "<span class='host'>"+link_to("("+URI.parse(post.link).host.gsub("www.","")+")", "http://"+URI.parse(post.link).host)+"</span>" unless post.link.nil? or post.link.empty?
		output += "</div>"
		output += "<div class='infobar'>"+pluralize(post.votes, "point") + " by " + post.user.name + " "+time_ago_in_words(post.created_at) + " ago | " + link_to(pluralize(comment_count(post), "comment"), post)
		output += "</div>"
		output += "</td></tr></table>"
		output += "</div>"
		output.html_safe
	end

	def build_comments(commentable)	
		output = "<div class='comments_box'>"
		commentable.comments.each do |comment|
			output += '<div class="comment">'
			if user_signed_in?
				if current_user.voted?(comment)
					output += "<table><tr><td class='voted' id='comments_"+comment.id.to_s+"'>"
				else
					output += "<table><tr><td class='vote' id='comments_"+comment.id.to_s+"'>"
				end
				output += link_to "&#9650;".html_safe, "#", :onClick => "vote_up("+comment.id.to_s+", 'comments')"
			else
				output += "<table><tr><td class='vote' id='comments_"+comment.id.to_s+"'>"
				output += link_to "&#9650;".html_safe, new_user_session_path
			end
			output += "<br /><br /></td><td>"
			output += simple_format(auto_link(comment.text))
			output += "<div class='infobar'>"+pluralize(comment.votes, "point") + " by " + comment.user.name + " "+time_ago_in_words(comment.created_at) + " ago &nbsp;"
			if can? :update, comment
				output += link_to 'Edit', edit_comment_path(comment)
			end
			output += "</div>"
			output += link_to 'Comment', "#", "onClick" => "$('#comment_form_#{comment.id.to_s}').slideToggle()" if can? :create, Comment
			output += "<br />"
			output += "</td></tr></table>"
			output += "<div id='comment_form_#{comment.id.to_s}' style='display: none'>"
			output += render :partial => 'comments/form', :locals => { :commentable_type => "Comment", :commentable_id => comment.id } 
			output += "</div>"
			output += '</div>'
			output += build_comments(comment) if comment.comments.count > 0
		end
		output += "</div>"
		output
  end
  
  def print_post(post)
		output = '<div class="post">'
		if user_signed_in?
			if current_user.voted?(post)
				output += "<table><tr><td class='voted' id='posts_"+post.id.to_s+"'>"
			else
				output += "<table><tr><td class='vote' id='posts_"+post.id.to_s+"'>"
			end
			output += link_to "&#9650;".html_safe, "#", :onClick => "vote_up("+post.id.to_s+", 'posts')"
		else
			output += "<table><tr><td class='vote'>"
			output += link_to "&#9650;".html_safe, new_user_session_path
		end
		output += "<br /><br /></td><td>"
		(post.link.nil? or post.link.empty?) ? (output += "<strong>"+link_to(post.title, post)+"</strong>") : (output += "<strong>"+link_to(post.title, post.link)+"</strong>")
		output += simple_format(auto_link(post.text))
		output += "<div class='infobar'>"+pluralize(post.votes, "point") + " by " + post.user.name + " "+time_ago_in_words(post.created_at) + " ago &nbsp;"
		if can? :update, post
			output += link_to 'Edit', edit_post_path(post)
		end
		output += "</div>"
		if can? :create, Comment
			output += "<div class='blue button action' style='clear: right;'>"
			output += link_to 'Comment'.html_safe, "#", "onClick" => "$('#comment_form').slideToggle()"
			output += "</div>"
		end
		output += '<div id="comment_form" style="display: none; clear: left">'
		output += render :partial => 'comments/form', :locals => { :commentable_type => "Post", :commentable_id => post.id }
		output += "</div>"
		output += '</td></tr></table></div>'
		output
	end
end


