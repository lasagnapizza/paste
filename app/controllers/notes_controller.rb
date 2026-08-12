class NotesController < ApplicationController
  MAX_PREVIEW_BYTES = 1_000_000

  before_action :set_note, only: [:edit, :show, :update]

  def new
    @note = Note.new
  end

  def edit
  end

  def show
    @noindex = true
    Note.increment_counter(:views, @note)
  end

  def preview
    # commonmarker rejects anything that isn't valid UTF-8, including the
    # US-ASCII empty string params gives us when :body is missing
    body = params[:body].to_s.dup.force_encoding(Encoding::UTF_8).scrub.first(MAX_PREVIEW_BYTES)
    render html: helpers.body_to_html(body), layout: false
  end

  def create
    @note = Note.new(note_params)
    @note.password = note_params[:password].presence || Note.random_password

    if @note.save
      redirect_to note_path(@note.slug), flash: {info: "note created, the edit password is #{@note.password}"}
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    unless @note.authenticate(note_params[:password]) # xkcd 2347
      flash.now[:error] = "wrong password"
      render :edit, status: :unprocessable_entity
      return
    end

    @note.password = note_params[:new_password] if note_params[:new_password].present?

    msg = "note updated"
    msg += ", the edit password is #{@note.password}" if @note.password

    if @note.update(note_params.slice(:body, :slug))
      redirect_to note_path(@note.slug), flash: {info: msg}
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def note_params
    params.require(:note).permit(:body, :password, :new_password, :slug)
  end

  def set_note
    @note = Note.find_by!(slug: params[:id])
  end
end
