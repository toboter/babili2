module Vocabulary
  class ConceptsController < ApplicationController
    before_action :set_profile
    layout 'vocabulary'
    
    def index
      @concepts = @profile.concepts.eager_load(:relationships, :states)
    end

    def show
      @concept = @profile.concepts.find(params[:id])
    end

    def new
      @concept = @profile.concepts.new
      @concept.build_label
      @concept.build_note
      @concept.relationships.build
    end

    def edit
      @concept = @profile.concepts.find(params[:id])
    end

    def create
      @concept = @profile.concepts.build(concept_params.merge(
        creator: current_user, 
        current_state: {
          type: concept_params[:current_state], 
          creator: current_user
        })
      )
      respond_to do |format|
        if @concept.save
          format.html { redirect_to [@profile, @concept], notice: "Successfully created concept." }
          format.js
        else
          format.html { render :new, alert: 'Something went wrong. Review your entries.' }
          format.js
        end
      end
    end

    def update
      @concept = @profile.concepts.find(params[:id])
      respond_to do |format|
        if @concept.update(concept_params.merge(
            current_state: {
              type: concept_params[:current_state], 
              creator: current_user
            })
          )
          format.html { redirect_to [@profile, @concept], notice: "Successfully updated concept." }
          format.js
        else
          format.html { render :new, alert: 'Something went wrong. Review your entries.' }
          format.js
        end
      end
    end

    private
    def set_profile
      @profile = Profile.friendly.find(params[:profile_id])
    end

    def concept_params
      params.require(:vocabulary_concept).permit(
        :type,
        :current_state,
        labels_attributes: [
          :type,
          :vernacular,
          :historical,
          :body,
          :lang,
          :abbr
        ],
        relationships_attributes: [
          :id,
          :creator_id,
          :type,
          :foreign_concept,
          :_destroy
        ],
        notes_attributes: [
          :type,
          :body,
          :lang
        ]
      )
    end

  end
end