class SkillsController < ApplicationController
	before_action :set_skill,      only: [:show, :edit, :update, :destroy]
	before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
	before_action :correct_user,	 only: [:edit, :update, :destroy]

	def index
		if params[:npc_id]
			@skills = Npc.find(params[:npc_id]).skills.where(deleted: false)
		else
			@skills = Skill.all_active
		end
	end

	def show
	end

	def new
		@skill = Skill.new
	end

	def create
		@skill = Skill.new(skill_params)
		@skill.user = current_user
		if @skill.save
			current_user.generate_feed(skill: @skill, feed_type: 'insertion')
			flash[:success] = "Operação concluída com sucesso!"
			redirect_to @skill
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @skill.update_attributes(skill_params)
			flash[:success] = "Informações atualizadas"
			current_user.generate_feed(skill: @skill, feed_type: 'updated')
			redirect_to @skill
		else
			render 'edit'
		end
	end

	def destroy
		current_user.generate_feed(skill: @skill, feed_type: 'destroyed')
		@skill.update(deleted: true, deleted_at: Time.zone.now)
		flash[:success] = "Operação concluída com sucesso!"
		redirect_to skills_url
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_skill
			@skill = Skill.find(params[:id])
		end

		def skill_params
			params.require(:skill).permit(:name, :cost, :description)
		end

		# Before filters

		# Confirms a logged-in user.
		def logged_in_user
			unless logged_in?
				store_location
				flash[:danger] = "Acesse o sistema para efetuar esta operação"
				redirect_to login_url
			end
		end

		# Confirms the correct user.
		def correct_user
			@skill = Skill.find(params[:id])
			redirect_to(root_url) unless current_user?(@skill.user) || admin?
		end
end
