class PicturesController < ApplicationController
  before_action :set_picture, only: %i[ show edit update destroy ]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @pictures = Picture.all
  end

  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end

  def edit
  end
  
  def create
    @picture = Picture.new(picture_params)
    @picture.user_id = current_user.id
    
    respond_to do |format|
      if @picture.save
        ContactMailer.contact_mail(@picture).deliver_now
        format.html { redirect_to pictures_url, notice: "Picture was successfully created." }
        format.json { render :show, status: :created, location: @picture }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to picture_url(@picture), notice: "Picture was successfully updated." }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @picture.destroy
    
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: "Picture was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def new
    if params[:back]
      @picture = Picture.new
    else
      @picture = Picture.new
    end
  end
  
  def confirm
    @picture = current_user.pictures.build(picture_params)
    render :new if @picture.invalid?
  end

  private
    def set_picture
      @picture = Picture.find(params[:id])
    end

    def picture_params
      params.require(:picture).permit(:content, :image, :image_cache)
    end

    def ensure_correct_user
      @picture = Picture.find_by(id: params[:id])
      if @current_user.id != @picture.user_id
        flash[:notice] = "権限がありません"
        redirect_to pictures_path
      end
    end
end
