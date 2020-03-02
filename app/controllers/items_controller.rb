class ItemsController < ApplicationController
  
  def index

    @items =Item.order("id desc").limit(4)
    @item_images = ItemImage.all
    @parents =Category.where(ancestry: nil).limit(13)
  end

  def new
    @item = Item.new
    @item.item_images.new
    @item.build_shipping
    @item.build_category
    @categories = Category.where(ancestry: nil).limit(13)
  end
  
  def create

    @item = Item.create(items_params)
    @categories = Category.where(ancestry: nil).limit(13)
    if @item.save
      redirect_to root_path
    else
      @item.item_images.new
      render :new
    end

  end

  def show
    @item = Item.find(params[:id])
    @item_images = @item.item_images.limit(8)
    @parent = @item.category
    @shipping = @item.shipping  
  end

  def edit
    @item = Item.find(params[:id])
    @item_images = @item.item_images.limit(8)
    @parent = @item.category
    @categories = Category.where(ancestry: nil).limit(13)
    render "items/item_edit"
  end

  def destroy
    @item = Item.find(params[:id])
    @item.saler_id == current_user.id && user_signed_in?
    if @item.destroy
      redirect_to root_path
    else
      redirect_to item_path(@item)
      flash[:alert] ='削除に失敗しました'
  end
end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_update_params)
        redirect_to item_path(@item)
    else
      redirect_to user_path(current_user)
      flash[:alert] ='編集に失敗しました'
    end

  end


  private
  def items_params
    params.require(:item).permit(:name, :condition_id,:text, :price, :trading_status, :buyer, :saler, :completed_at, shipping_attributes: [:delivery_fee_id, :delivery_handlingtime_id, :prefecture_code], category_attributes: [:name], item_images_attributes: %i[image_url]).merge(saler_id: current_user.id)
  end

  def item_update_params
    params.require(:item).permit(:name,:condition_id,:text, :price, :trading_status, :buyer, :saler, :completed_at,[shipping_attributes:[:delivery_fee_id, :delivery_handlingtime_id, :prefecture_code]],[item_images_attributes:[:image_url,:_destroy,:id]],[category_attributes: [:name]])
  end

end
