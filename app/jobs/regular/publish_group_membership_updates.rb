# frozen_string_literal: true

module Jobs
  class PublishGroupMembershipUpdates < ::Jobs::Base
    def execute(args)
      group = Group.find_by(id: args[:group_id])
      users = User.human_users.where(id: args[:user_ids])

      return if !group
      return if !%w[add remove].include?(args[:type])

      added_members = args[:type] == 'add'
      event_name = added_members ? :user_added_to_group : :user_removed_from_group

      users.each do |user|
        params = [user, group]
        params << { automatic: group.automatic? } if added_members

        DiscourseEvent.trigger(event_name, *params)
      end
    end
  end
end
