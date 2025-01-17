class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  
  # Add your routes here
  get "/" do
    { message: "Good luck with your project!" }.to_json
  end

  get "/posts" do
    #This should return all posts
    posts = Post.all.order("date ASC") 
    posts.to_json(include: :author)
  end



  get "/posts/:id" do 
    #This should acquire a single specific post via id
    post = Post.find(params[:id])
    post.to_json(include: :author)
  end

  delete "/posts/:id" do 
    #Acquire the specific post by id and then delete it.
    post = Post.find(params[:id])
    post.destroy 
    post.to_json
  end

  post "/posts" do
    #Create a new post entry from submitted data/object
    newpost = Post.create(
    title: params[:title],
    content: params[:content],
    author_id: params[:author_id],
    date: DateTime.now
    )
    newpost.to_json
  end



  patch "/posts/:id" do 
    #Acquire specific post by ID and then update the title/content. Unsure if we should allow editing of the Author?
    post = Post.find(params[:id])
    post.update(
      title: params[:title],
      content: params[:content],
      date: DateTime.now
    )
    post.to_json(include: :author)
  end

  get "/authors" do 
    #Return all Authors, including their posts
    authors = Author.all 
    authors.to_json(include: :posts)
  end


  post "/authors" do 
    #Create a new Author
    newauthor = Author.find_or_create_by(
      author_name: params[:author_name],
      email: params[:email]
    )
    newauthor.to_json
  end

  # get "/authors/:id" do 
  #   #Return a specific Author, including their posts
  #   author = Author.find_by(id: params[:id])
  #   author.to_json(include: :posts)
  # end

    get "/authors/:id" do 
    #Return a specific Author, including their posts
    author = Author.find_by(id: params[:id])
    posts = Post.where(author_id: author.id).order("date DESC")
    posts.to_json
  end

end
