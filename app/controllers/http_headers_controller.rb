class HttpHeadersController < ApplicationController

  before_action :find_check, :set_active
  before_action :find_header, only: [:edit, :update, :destroy]

  def index
    @http_headers = @check.http_headers.all
  end

  def new
    @http_header = @check.http_headers.new
  end

  def edit
  end

  def create
    @http_header = @check.http_headers.create(headers_param)
    if @http_header.errors.empty?
      flash[:notice] = 'New header successfully added.'
      redirect_to server_check_http_headers_path(@check.server_id, @check.id)
    else
      render 'edit'
    end
  end

  def update
    @http_header.update_attributes(headers_param)
    if @http_header.errors.empty?
      flash[:notice] = 'Header successfully updated.'
      redirect_to server_check_http_headers_path(@check.server_id, @check.id)
    else
      render 'edit'
    end
  end

  def destroy
    @http_header.destroy
    redirect_to server_check_http_headers_path(@check.server_id, @check.id)
  end

  private

  def headers_param
    params.require(:http_header).permit(:name, :value)
  end

  def find_header
    @http_header = HttpHeader.where(id: params[:id]).first
    render text: 'Not found', status: 404 unless @http_header
  end

  def set_active
    @active = 'servers'
  end

  def find_check
    @check = Check.where(id: params[:check_id]).first
    render text: 'Not found', status: 404 unless @check
    render text: 'Not found', status: 404 unless @check.check_type == 'http_code' or @check.check_type == 'http_keyword'
  end
end
