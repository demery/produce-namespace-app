class Produce::FruitsController < ApplicationController
  # GET /produce/fruits
  # GET /produce/fruits.json
  def index
    @produce_fruits = Produce::Fruit.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @produce_fruits }
    end
  end

  # GET /produce/fruits/1
  # GET /produce/fruits/1.json
  def show
    @produce_fruit = Produce::Fruit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @produce_fruit }
    end
  end

  # GET /produce/fruits/new
  # GET /produce/fruits/new.json
  def new
    @produce_fruit = Produce::Fruit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @produce_fruit }
    end
  end

  # GET /produce/fruits/1/edit
  def edit
    @produce_fruit = Produce::Fruit.find(params[:id])
  end

  # POST /produce/fruits
  # POST /produce/fruits.json
  def create
    @produce_fruit = Produce::Fruit.new(params[:produce_fruit])

    respond_to do |format|
      if @produce_fruit.save
        format.html { redirect_to @produce_fruit, notice: 'Fruit was successfully created.' }
        format.json { render json: @produce_fruit, status: :created, location: @produce_fruit }
      else
        format.html { render action: "new" }
        format.json { render json: @produce_fruit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /produce/fruits/1
  # PUT /produce/fruits/1.json
  def update
    @produce_fruit = Produce::Fruit.find(params[:id])

    respond_to do |format|
      if @produce_fruit.update_attributes(params[:produce_fruit])
        format.html { redirect_to @produce_fruit, notice: 'Fruit was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @produce_fruit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produce/fruits/1
  # DELETE /produce/fruits/1.json
  def destroy
    @produce_fruit = Produce::Fruit.find(params[:id])
    @produce_fruit.destroy

    respond_to do |format|
      format.html { redirect_to produce_fruits_url }
      format.json { head :ok }
    end
  end
end
