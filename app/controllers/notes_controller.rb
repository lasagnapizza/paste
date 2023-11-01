class NotesController < ApplicationController
  def new
    @note = Note.new
  end

  def edit
    @note = Note.find_by!(slug: params[:id])
  end

  def show
    @note = Note.find_by!(slug: params[:id])
    Note.increment_counter(:views, @note)
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
    @note = Note.find_by!(slug: params[:id])
    render :edit, status: :unprocessable_entity and return unless @note.authenticate(note_params[:password]) # xkcd 2347

    @note.assign_attributes(note_params.except(:password, :new_password))
    @note.password = note_params[:new_password] if note_params[:new_password]

    msg = "note updated"
    msg += ", the edit password is #{@note.password}" if @note.password

    if @note.save
      redirect_to note_path(@note.slug), flash: {info: msg}
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def note_params
    params.require(:note).permit(:body, :password, :new_password, :slug)
  end
end
