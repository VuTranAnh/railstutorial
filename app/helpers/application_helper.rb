module ApplicationHelper
  def full_title page_title = ""
    base_title = t "sample_app"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def follow_button user
    if current_user.following? user
      render "shared/unfollow",
        relation: current_user.active_relationships
          .find_by(followed_id: @user.id)
    else
      render "shared/follow", relation: current_user.active_relationships.build
    end
  end
end
