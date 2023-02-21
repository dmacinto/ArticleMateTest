require 'net/http'
require 'google/cloud/text_to_speech'

class ApisController < ApplicationController
  before_action :set_api, only: %i[ show edit update destroy ]


  def convert_to_speech
    # PubMed API endpoint URL
    pubmed_api_url = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=#{params[:id]}&rettype=abstract&retmode=text"

    # Make a request to the PubMed API
    uri = URI(pubmed_api_url)
    response = Net::HTTP.get(uri)

    # Initialize Google Cloud Text-to-Speech client
    text_to_speech = Google::Cloud::TextToSpeech.new

    # Convert article title to speech
    input_text = response.match(/Title: (.*)\n/)[1] # assuming that the title is on the first line
    synthesis_input = { text: input_text }
    voice = { language_code: 'en-US', ssml_gender: 'NEUTRAL' }
    audio_config = { audio_encoding: 'MP3' }
    response = text_to_speech.synthesize_speech(synthesis_input, voice, audio_config)

    # Save the speech audio to a file
    File.open("#{params[:id]}.mp3", 'wb') { |file| file.write(response.audio_content) }
  end

end







  # GET /apis or /apis.json
  def index
    @apis = Api.all
  end

  # GET /apis/1 or /apis/1.json
  def show
  end

  # GET /apis/new
  def new
    @api = Api.new
  end

  # GET /apis/1/edit
  def edit
  end

  # POST /apis or /apis.json
  def create
    @api = Api.new(api_params)

    respond_to do |format|
      if @api.save
        format.html { redirect_to api_url(@api), notice: "Api was successfully created." }
        format.json { render :show, status: :created, location: @api }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @api.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apis/1 or /apis/1.json
  def update
    respond_to do |format|
      if @api.update(api_params)
        format.html { redirect_to api_url(@api), notice: "Api was successfully updated." }
        format.json { render :show, status: :ok, location: @api }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @api.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apis/1 or /apis/1.json
  def destroy
    @api.destroy

    respond_to do |format|
      format.html { redirect_to apis_url, notice: "Api was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api
      @api = Api.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def api_params
      params.fetch(:api, {})
    end
end
