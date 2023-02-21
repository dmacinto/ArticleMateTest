class ApisController < ApplicationController
  before_action :set_api, only: %i[ show edit update destroy ]

  require 'net/http'
  require 'google/cloud/text_to_speech'
  require 'pdf-reader'
  require 'json'

  def convert_to_speech
    text = params[:text]
    output_file = Rails.root.join('app/audio_outputs', 'output.mp3')

    # Replace with your Google Cloud project ID and API key

    google_credentials = {
      "type": "service_account",
      "project_id": "#{ENV.fetch("TEXT_TO_SPEECH_PROJECT_ID")}",
      "private_key_id": "#{ENV.fetch("TEXT_TO_SPEECH_KEY_ID")}",
      "private_key": "-----BEGIN PRIVATE KEY-----#{ENV.fetch("TEXT_TO_SPEECH_PRIVATE_KEY")}-----END PRIVATE KEY-----\n",
      "client_email": "#{ENV.fetch("TEXT_TO_SPEECH_CLIENT_EMAIL")}",
      "client_id": "#{ENV.fetch("TEXT_TO_SPEECH_CLIENT_ID")}",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "#{ENV.fetch("TEXT_TO_SPEECH_CLIENT_URL")}"
    }
    
    #google_json = JSON.generate(google_credentials)

    # Initialize the Text-to-Speech client with your API key
    client = Google::Cloud::TextToSpeech.text_to_speech do |config|
      config.credentials = google_credentials
    end

    #client = Google::Cloud::TextToSpeech.text_to_speech #project: project_id, credentials: api_key

    # Generate the audio file using the Text-to-Speech client
    synthesis_input = { text: text }
    voice = { language_code: 'en-US', ssml_gender: 'FEMALE' }
    audio_config = { audio_encoding: 'MP3' }
    response = client.synthesize_speech input: synthesis_input, voice: voice, audio_config: audio_config

    # Write the audio file to disk
    File.write(output_file, response.audio_content, mode: 'wb')

    # Render a JSON response with the path to the audio file
    render json: { audio_path: 'app/audio_outputs/output.mp3' }








    # PubMed API endpoint URL
    #pubmed_api_url = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=#{pubmedId}&rettype=abstract&retmode=text"

    # Make a request to the PubMed API
    #uri = URI(pubmed_api_url)
    #response = Net::HTTP.get(uri)

    # Extract the article content
    #article_content = response.match(/Abstract(.|\n)*/)[0].strip

    #input_text = response.match(/Title: (.*)\n/)[1] # assuming that the title is on the first line


    # Initialize Google Cloud Text-to-Speech client
    #text_to_speech = Google::Cloud::TextToSpeech.new

    # Convert article content to speech
    #synthesis_input = { text: input_text }
    #voice = { language_code: 'en-US', ssml_gender: 'NEUTRAL' }
    #audio_config = { audio_encoding: 'MP3' }
    #response = text_to_speech.synthesize_speech(synthesis_input, voice, audio_config)

    # Save the speech audio to a file
    #File.open("#{params[:pubId]}.mp3", 'wb') { |file| file.write(response.audio_content) }
  end




  def convert
    pdf_file = params[:file]
    if pdf_file.content_type == 'application/pdf'
      reader = PDF::Reader.new(pdf_file.path)
      text = reader.pages.map(&:text).join("\n")
      File.open('converted_text.txt', 'w') { |file| file.write(text) }
      send_file('converted_text.txt')
    else
      flash[:alert] = 'Invalid file type. Please upload a PDF file.'
      redirect_to root_path
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
