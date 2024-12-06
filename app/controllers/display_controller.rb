class DisplayController < ApplicationController
  def index
    get_select(params[:q])
    @q = Display.permission(get_permission).ransack(params[:q])
    @displays = @q.result.page(params[:page])
  end

  def paginate
    @q = Display.permission(get_permission).ransack(params[:q])
    @displays = @q.result.page(params[:page])
  end

  def new
    @select = {}
    @display = Display.new()
  end

  def edit
    @select = {}
    @display = Display.permission(get_permission).find_by(id: params[:id])
  end

  def update
    @display = Display.permission(get_permission).find_by(id: params[:id])
    if @display.update(display_params)
      redirect_to master_display_index_path, flash: { success: "保存しました" }
    else
      get_input_select(params[:display])
      @url = master_display_path(@display.id)
      render :form_update, status: :unprocessable_entity
    end
  end

  def create
    prm = display_params
    prm[:user_id] = @current_user.id
    @display = Display.new(prm)
    upload_file = params[:display].[] :upload_file
    if upload_file.blank?
      flash.now[:warning] = '写真を選択して下さい'
      set_error_params(params[:display])
      render :form_update, status: :unprocessable_entity and return
    end
    @display.filename = upload_file.original_filename
    @display.filetype = upload_file.content_type
    if @display.save
      upload_path = Rails.root.join("upload", "display", DisplayType.find_by(prm[:display_type]).name)
      # ディレクトリがなければ作成
      FileUtils.mkdir_p(upload_path) unless FileTest.exist?(upload_path)
      # ファイル保存
      File.binwrite(upload_path.join(@display.filename), upload_file.read)
      redirect_to display_index_path, flash: { success: "作成しました" }
    else
      set_error_params(params[:display])
      render :form_update, status: :unprocessable_entity
    end
  end

  def show
    @display = Display.find_by(id: params[:id])
  end

  def destroy
    target = Display.permission(get_permission).find_by(id: params[:id])
    if target.destroy
      redirect_to display_index_path, flash: { success: "削除しました" }
    else
      redirect_to display_index_path, flash: { success: "削除しました" }
    end
  end

  # 画像表示
  def show_image
    @display = Display.find(params[:id])
    send_file Rails.root.join("upload", "display", @display.display_type.name, @display.filename).to_s, type: @display.filetype, disposition: 'inline'
  end

  def open_modal
    @q = DisplayType.ransack(params[:q])
    @types = @q.result.page(params[:modal_page]).per(8)
    @modal_title = "ディスプレイ選択"
    @content = "/display/type"
    render "/shared/open_modal"
  end

  def set_modal_params
    if params[:value].blank?
      @object = nil
    else
      @object = DisplayType.find_by(id: params[:value])
    end
    @target = "display_type"
  end

  def serch_display
    @q = DisplayType.ransack(params[:q])
    @content_types = @q.result.page(params[:modal_page]).per(8)
  end

  def download
    display = Display.find_by(id: params[:id])
    send_file Rails.root.join("upload", "display", display.display_type.name, display.filename).to_s, type: display.filetype, filename: display.filename
  end

  private

  def display_params
    params.require(:display).permit(:display_type_id, :note, :sort, :time, :option, :limit)
  end

  def get_permission
    permission = ["helper"]
    permission += ["gm"] if is_gm?
    permission += ["admin"] if is_admin?
    permission
  end

  def get_select(prm)
    @select = {}
    if prm
      @select[:display_type] = DisplayType.find_by(id: prm[:display_type_id_eq]).name unless prm[:display_type_id_eq].blank?
    end
  end

  def get_input_select(prm)
    @select = {}
    if prm
      @select[:display_type] = DisplayType.find_by(id: prm[:display_type_id]).name unless prm[:display_type_id].blank?
    end
  end

  def set_error_params(prm)
    @url = display_index_path
    get_input_select(prm)
  end
end
