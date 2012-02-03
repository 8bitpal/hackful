module ContentHelper
	def build_post_preview(post)
		output = '<div class="post">'
		if user_signed_in?
			if current_user.voted?(post)
				output += "<div class='voted arrow' id='posts_"+post.id.to_s+"'>"
			else
				output += "<div class='vote arrow' id='posts_"+post.id.to_s+"'>"
			end
			output += link_to "&#9650;".html_safe, "#", :onClick => "vote_up("+post.id.to_s+", 'posts'); return false"
		else
			output += "<div class='vote arrow'>"
			output += link_to "&#9650;".html_safe, new_user_session_path
		end
		output += "</div><div class='post_preview_body'>"
		output += "<div class='post_title'>"
		(post.link.nil? or post.link.empty?) ? (output += link_to post.title, post) : (output += link_to post.title, post.link)
		output += "<span class='host'>"+link_to("("+URI.parse(post.link).host.gsub("www.","")+")", "http://"+URI.parse(post.link).host)+"</span>" unless post.link.nil? or post.link.empty?
		output += "</div>"
		output += "<div class='infobar'>"+pluralize(post.votes, "point") + " by " + post.user.name + " "+time_ago_in_words(post.created_at) + " ago | " + link_to(pluralize(comment_count(post), "comment"), post)
		output += "</div>"
		output += "</div>"
		output += "</div>"
		output.html_safe
	end

	def build_comments(commentable)	
		output = "<div class='comments_box'>"
		commentable.comments.each do |comment|
			output += '<div class="comment">'
			if user_signed_in?
				if current_user.voted?(comment)
					output += "<div class='voted arrow' id='comments_"+comment.id.to_s+"'>"
				else
					output += "<div class='vote arrow' id='comments_"+comment.id.to_s+"'>"
				end
				output += link_to "&#9650;".html_safe, "#", :onClick => "vote_up("+comment.id.to_s+", 'comments'); return false"
			else
				output += "<div class='vote arrow'>"
				output += link_to "&#9650;".html_safe, new_user_session_path
			end
			output += "</div><div class='text_body'>"
			output += simple_format(auto_link(comment.text))
			output += "<div class='infobar'>"+pluralize(comment.votes, "point") + " by " + comment.user.name + " "+time_ago_in_words(comment.created_at) + " ago &nbsp;"
			if can? :update, comment
				output += link_to 'Edit', edit_comment_path(comment)
			end
			output += "</div>"
			output += link_to('reply', "#", "onClick" => "$('#comment_form_#{comment.id.to_s}').slideToggle(); return false", class: "comment_reply") if can? :create, Comment
			output += "<br />"
			output += "</div>"
			output += "<div id='comment_form_#{comment.id.to_s}' class='comment_form' style='display: none'>"
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
				output += "<div class='voted arrow' id='posts_"+post.id.to_s+"'>"
			else
				output += "<div class='vote arrow' id='posts_"+post.id.to_s+"'>"
			end
			output += link_to "&#9650;".html_safe, "#", :onClick => "vote_up("+post.id.to_s+", 'posts'); return false"
		else
			output += "<div class='vote arrow'>"
			output += link_to "&#9650;".html_safe, new_user_session_path
		end
		output += "</div><div class='text_body'>"
		(post.link.nil? or post.link.empty?) ? (output += "<strong>"+link_to(post.title, post)+"</strong>") : (output += "<strong>"+link_to(post.title, post.link)+"</strong>")
		output += "<span class='host'>"+link_to("("+URI.parse(post.link).host.gsub("www.","")+")", "http://"+URI.parse(post.link).host)+"</span>" unless post.link.nil? or post.link.empty?
		output += simple_format(auto_link(post.text))
		output += "<div class='infobar'>"+pluralize(post.votes, "point") + " by " + post.user.name + " "+time_ago_in_words(post.created_at) + " ago &nbsp;"
		if can? :update, post
			output += link_to 'Edit', edit_post_path(post)
		end
		output += "</div>"
		if can? :create, Comment
			output += '<div id="comment_form" class="comment_form" style="clear: left; margin-left: 0px;">'
			output += render :partial => 'comments/form', :locals => { :commentable_type => "Post", :commentable_id => post.id }
			output += "</div>"
		end
		output += '</div></div>'
		output
	end
end


