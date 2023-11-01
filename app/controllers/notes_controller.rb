class NotesController < ApplicationController
  def new
    @note = Note.new
  end

  def show
    @note = Note.find_by!(slug: params[:id])
  end

  def create
    @note = Note.new(note_params)
    @note.password = note_params[:password].presence || Note.random_password
    password = @note.password

    if @note.save
      redirect_to note_path(@note.slug), flash: { info: "Note created. Your edit password is #{password}" }
    else
      render :new
    end
  end

  private

  def note_params
    params.require(:note).permit(:body, :password, :slug)
  end
end
