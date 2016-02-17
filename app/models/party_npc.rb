class PartyNpc < ActiveRecord::Base
	belongs_to :party
	belongs_to :npc
	validates :party_id, presence: true
	validates :npc_id,   presence: true
	# accepts_nested_attributes_for :npc, :reject_if => :all_blank
end
