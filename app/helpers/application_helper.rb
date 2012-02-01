module ApplicationHelper
	def comment_count(object)
		count = object.comments.count
		object.comments.each do |comment|
			count += comment_count(comment)
		end
		count
	end
end
