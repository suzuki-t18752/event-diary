class ArticlesController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:destroy]


  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.search(params[:search]).page(params[:page]).per(10)
    
    if params[:tag_name]
      @articles = @articles.tagged_with("#{params[:tag_name]}")
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @comments = Comment.where(article_id: @article) 
    
    @tweet_url = URI.encode(
      "http://twitter.com/intent/tweet?original_referer=" +
      request.url +
      "&url=" +
      request.url +
      "&text=" +
      "記事『" + @article.name + "』を閲覧しています。 #event-diary" 
    )
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = current_user.articles.build(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:name, :content, :image, :tag_list)
    end
    
    def correct_user
    @article = current_user.articles.find_by(id: params[:id])
    unless @article
      redirect_to articles_path
    end
    end
end
