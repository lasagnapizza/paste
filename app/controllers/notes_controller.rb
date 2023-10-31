class NotesController < ApplicationController
  def new
    @note = Note.new
  end

  def show
    @note = Note.find_by!(slug: params[:slug])
  end

  def create
    @note = Note.new(note_params)
    password = note_params[:password].presence || ('a'..'z').to_a.shuffle[0,8].join
    @note.password = password

    if @note.save
      redirect_to note_path(slug: @note.slug), flash: { info: "Note created. Your edit password is #{password}" }
    else
      render :new
    end
  end

  private

  def note_params
    params.require(:note).permit(:body, :password, :slug)
  end
end
